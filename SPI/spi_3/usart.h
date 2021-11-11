#ifndef _INCLUDE_UART_H__
#define _INCDLUE_UART_H__

#define RX_Int   0		// ���� ���ͷ�Ʈ ���� ����
#define TX_Int   1		// �۽� ���ͷ�Ʈ ���� ����
#define RXTX_Int 2		// �ۼ��� ���ͷ�Ʈ ���� ����

// UART �ʱ�ȭ �Լ�
// baud = 0 : 9600bps, baud = 1 : 115200bps,   
void Init_USART1(unsigned char baud)
{
    UCSR1A = 0x00;               		// 1��� ���� ���
    UCSR1B = (1<<RXEN1) | (1<<TXEN1);	// ����, �۽� �㰡 
    //UCSR1B |= (1<<RXCIE1) | (1<<UDRIE1); // �ۼ��� ���ͷ�Ʈ �㰡 
    UCSR1C = (1<<UCSZ11) | (1<<UCSZ10);	// 8��Ʈ ������ ����
 
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
    UCSR1A = 0x00;                 // 1��� ���� ���
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
  
    switch(Int_type)               // Int_type�� ���� RX, TX ���ͷ�Ʈ �㰡  
    {
        case RX_Int :
            UCSR1B = (1<<RXCIE1) | (1<<RXEN1) | (1<<TXEN1);               // �ۼ��� �� RX ���ͷ�Ʈ �㰡 
            break;
        case TX_Int :
            UCSR1B = (1<<UDRIE1) | (1<<RXEN1) | (1<<TXEN1);               // �ۼ��� �� TX ���ͷ�Ʈ �㰡 
            break;
        case RXTX_Int :
            UCSR1B = (1<<RXCIE1) | (1<<UDRIE1) | (1<<RXEN1) | (1<<TXEN1); // �ۼ��� �� RX. TX ���ͷ�Ʈ �㰡
            break;   
    }      
        UCSR1C = (1<<UCSZ11) | (1<<UCSZ10);  	
    // �񵿱� ���, ¦�� �и�Ƽ, 1 stop bit ���� ��� ���� 
    
    //  SREG |= 0x80;	// ���ͷ�Ʈ �㰡�� ���� �Լ����� �ݵ�� �����ϱ� �ٶ�.  
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