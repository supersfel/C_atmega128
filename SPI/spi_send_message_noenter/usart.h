#ifndef _INCLUDE_UART_H__
#define _INCDLUE_UART_H__

#define RX_Int   0		// 수신 인터럽트 설정 인자
#define TX_Int   1		// 송신 인터럽트 설정 인자
#define RXTX_Int 2		// 송수신 인터럽트 설정 인자

// UART 초기화 함수
// baud = 0 : 9600bps, baud = 1 : 115200bps,   
void Init_USART1(unsigned char baud)
{
    UCSR1A = 0x00;               		// 1배속 전송 모드
    UCSR1B = (1<<RXEN1) | (1<<TXEN1);	// 수신, 송신 허가 
    //UCSR1B |= (1<<RXCIE1) | (1<<UDRIE1); // 송수신 인터럽트 허가 
    UCSR1C = (1<<UCSZ11) | (1<<UCSZ10);	// 8비트 데이터 전송
 
    switch(baud)
    {
         case 0: 
             // fClk = 14.7456MHz, Baudrate = 9600
             UBRR1H = 0;
             UBRR1L = 95;
             break; 
         case 1: 
             // fClk = 14.7456MHz, Baudrate = 115200
             UBRR1H = 0x00;
             UBRR1L = 0x07;
             break; 
         default : break; 
    } 
}

void Init_USART1_IntCon(unsigned char baud, unsigned char Int_type)
{
    UCSR1A = 0x00;                 // 1배속 전송 모드
    UCSR1B = (1<<RXCIE1) | (1<<RXEN1) | (1<<TXEN1);

    switch(baud)
    {
         case 0:                                                         
         
             // fClk = 14.7456MHz, Baudrate = 9600
             UBRR1H = 0;
             UBRR1L = 95;
             break; 
         case 1: 
             // fClk = 14.7456MHz, Baudrate = 115200
             UBRR1H = 0x00;
             UBRR1L = 0x07;                        
             
             break; 
         default : break; 
    }
  
    switch(Int_type)               // Int_type에 따라 RX, TX 인터럽트 허가  
    {
        case RX_Int :
            UCSR1B = (1<<RXCIE1) | (1<<RXEN1) | (1<<TXEN1);               // 송수신 및 RX 인터럽트 허가 
            break;
        case TX_Int :
            UCSR1B = (1<<UDRIE1) | (1<<RXEN1) | (1<<TXEN1);               // 송수신 및 TX 인터럽트 허가 
            break;
        case RXTX_Int :
            UCSR1B = (1<<RXCIE1) | (1<<UDRIE1) | (1<<RXEN1) | (1<<TXEN1); // 송수신 및 RX. TX 인터럽트 허가
            break;   
    }      
        UCSR1C = (1<<UCSZ11) | (1<<UCSZ10);  	
    // 비동기 통신, 짝수 패리티, 1 stop bit 전송 모드 설정 
    
    //  SREG |= 0x80;	// 인터럽트 허가는 메인 함수에서 반드시 설정하기 바람.  
}

void putch_USART1(char data){
     while(!(UCSR1A&(1<<UDRE1)));
     UDR1 = data;
}

void puts_USART1(char *str){
     while(*str !=0){
         putch_USART1(*str);
         str++;
    }
}

char getch_USART1(void){
     while(!(UCSR1A & (1<<RXC1)));
     return UDR1;
}

#endif