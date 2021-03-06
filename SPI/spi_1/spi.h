#ifndef _INCLUDE_SPI_H__
#define _INCDLUE_SPI_H__

#define SPI_CS PORTB.0
#define SPI_CS2 PORTE.6

#define SS   0
#define SCK  1
#define MOSI 2
#define MISO 3

char *PtrToStrChar; 	// Pointer to certain Character in String
char ClearToSend = 1;

void Init_SPI_Master()
{
    // I/O를 master로 동작으로 설정, (MOSI, SS, SCK 출력, MISO 입력)
    DDRB |= (1<<MOSI) | (1<<SS) | (1<<SCK);    
    DDRB &= ~(1<<MISO);
    SPCR = (1 << SPE) | (1 << MSTR) | (1 << CPHA) | (3 << SPR0);
    // 동작모드 1, 클럭 : SCK = fosc/128
    SPSR = 0x00;
    SPI_CS = 1;	        // SS 신호선을 대기상태(high)로 설정 복귀
}

void Init_SPI_Master_IntContr(void)
{
    SREG &= ~0x80;
    // I/O를 master로 동작으로 설정 , (MOSI, SS, SCK 출력, MISO 입력) 
    DDRB |= (1<<MOSI) | (1<<SS) | (1<<SCK);    
    DDRB &= ~(1<<MISO);  
    // 클럭 : SCK = fosc/128, 동작 모드 1
    SPCR = (1<<SPIE) | (1<<SPE) | (1<<MSTR) | (1<<CPHA) | (3<<SPR0);
    SPSR = 0x00;
    SREG |= 0x80;		// Enable Global Interrupt 
}

void Init_SPI_Slave_IntContr(void) //for Slave interrupt SPI 
{
    DDRB |= (1 << MISO);
    // I/O를 slave로 동작으로 설정(MISO 출력)
    SPCR = (1<<SPIE) | (1<<SPE) | (1<<CPHA) | (3<<SPR0); 
    // SPCR을 슬레이브 INT 동작으로 초기화, 클럭 : SCK = fosc/128
    SPSR = 0x00;
    SREG |= 0x80;       // Enable Global Interrupt
}

unsigned char SPI_Master_Send(unsigned char data)//polling
{
    SPI_CS = 0;     // SS 선택 과정이 메인 함수에서 전체적으로 수행될 경우 생략 가능 
//    delay_us(10);   // Slave가 원만한 인식을 위한 지연 시간   
    
    SPDR = data;
    while (!(SPSR & (1 << SPIF)));

     SPI_CS = 1;
    return SPDR; 
    // SPSR레지스터의 SPIF 비트를 초기화 하기 위해 수신 데이터가 쓰레기 값이더라도 해야함.
}

unsigned char SPI_Master_Receive(void)
{
    while(!(SPSR & (1<<SPIF)));    
    return SPDR;
}

unsigned char SPI_Slave_Receive(void)
{
    while(!(SPSR & (1<<SPIF)));    
    return SPDR;
}

void SPI_Master_Send_IntContr(unsigned char *TextString)
{
    if (ClearToSend == 1) 
    { 	// if no transmission is in progress
	PtrToStrChar = TextString;	// Set Pointer to beginning of String
	// initiate new transmission by 
	SPDR = *PtrToStrChar; 	// sending first Char of new String
	ClearToSend = 0; 		// block initiation of new transmissions
    }
}
#endif 