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
    // I/O�� master�� �������� ����, (MOSI, SS, SCK ���, MISO �Է�)
    DDRB |= (1<<MOSI) | (1<<SS) | (1<<SCK);    
    DDRB &= ~(1<<MISO);
    SPCR = (1 << SPE) | (1 << MSTR) | (1 << CPHA) | (3 << SPR0);
    // ���۸�� 1, Ŭ�� : SCK = fosc/128
    SPSR = 0x00;
    SPI_CS = 1;	        // SS ��ȣ���� ������(high)�� ���� ����
}

void Init_SPI_Master_IntContr(void)
{
    SREG &= ~0x80;
    // I/O�� master�� �������� ���� , (MOSI, SS, SCK ���, MISO �Է�) 
    DDRB |= (1<<MOSI) | (1<<SS) | (1<<SCK);    
    DDRB &= ~(1<<MISO);  
    // Ŭ�� : SCK = fosc/128, ���� ��� 1
    SPCR = (1<<SPIE) | (1<<SPE) | (1<<MSTR) | (1<<CPHA) | (3<<SPR0);
    SPSR = 0x00;
    SREG |= 0x80;		// Enable Global Interrupt 
}

void Init_SPI_Slave_IntContr(void) //for Slave interrupt SPI 
{
    DDRB |= (1 << MISO);
    // I/O�� slave�� �������� ����(MISO ���)
    SPCR = (1<<SPIE) | (1<<SPE) | (1<<CPHA) | (3<<SPR0); 
    // SPCR�� �����̺� INT �������� �ʱ�ȭ, Ŭ�� : SCK = fosc/128
    SPSR = 0x00;
    SREG |= 0x80;       // Enable Global Interrupt
}

unsigned char SPI_Master_Send(unsigned char data)//polling
{
    SPI_CS = 0;     // SS ���� ������ ���� �Լ����� ��ü������ ����� ��� ���� ���� 
    //delay_us(10);   // Slave�� ������ �ν��� ���� ���� �ð�   
    
    SPDR = data;
    while (!(SPSR & (1 << SPIF)));

     SPI_CS = 1;
    return SPDR; 
    // SPSR���������� SPIF ��Ʈ�� �ʱ�ȭ �ϱ� ���� ���� �����Ͱ� ������ ���̴��� �ؾ���.
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