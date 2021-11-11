// max length �ʰ��� ���� �߻� 
// ���� �޼��� ����ϰ� enter key�� �Էµǵ��� wait �ϵ��� ���� ���� 
#include <mega128.h>  
#include <delay.h>
#include "lcd.h"                    // LCD ����� ���� lcd ��� ������ ����
#include "usart.h"

#define MAXLEN  17                  // LCD 16 ���� + \r
#define ENTER   '\r'
#define NULL    '\0'          

#define STATUS0_WAIT_KEY_INPUT    0
#define STATUS1_FIRST_KEY_INPUT   1
#define STATUS2_KEY_INPUT         2
#define STATUS3_KEY_INPUT_END     3
#define STATUS4_LCD_DISPLAY       4

#define STATUS10_ERROR       10

unsigned char Intro_msg[] = "Press char&Enter";
unsigned char Error_msg[] = "Max length error";

unsigned char buffer_count=0;
unsigned char Current_str[MAXLEN]={0,}; // ���� ���ŵ� ���ڸ� �����ϱ� ���� ����, 0���� ���ڿ� �ʱ�ȭ 
unsigned char Mem_str[MAXLEN]={0,};     // ������ ���ŵ� ���ڿ��� �����ϱ� ���� ����, 0���� ���ڿ� �ʱ�ȭ 

unsigned int Status = STATUS0_WAIT_KEY_INPUT;  // ���� STATUS �� ��Ÿ���� ���� 

// ���ͷ�Ʈ ��ƾ������ ������ ����
interrupt [USART1_RXC] void usart1_receive(void)
{       
    Current_str[buffer_count] = UDR1;       
    PORTB ^= 1<<0;
    // Ư�������̸� ���ڸ� ó������ �ʰ�,     
    if(Current_str[buffer_count] == ENTER){
        Status = STATUS3_KEY_INPUT_END;
        PORTB ^= 1<<1;
    }
    else  
    // max length(16����)�� �ʰ��ϸ� error flag ���� 
    {
        if(buffer_count == MAXLEN)
        {                    
            Status = STATUS10_ERROR;
        }
        else 
        {         
            if(buffer_count == 0)   Status = STATUS1_FIRST_KEY_INPUT;
            else                    Status = STATUS2_KEY_INPUT;
            buffer_count++;     
        }
    } 
}

void main(void)
{         
    int i = 0;     
    unsigned char Line_Shift = 0;                   
    DDRB = 0xFF;
         
    LCD_Init();                     // LCD �ʱ�ȭ  
    Init_USART1_IntCon(0, RX_Int);    // 9600bps, RX INT    
    SREG |= 0x80;                   // glabal int. �㰡 
 
    LCD_Pos(0,0);               // 1���ο� USART Intro Message ���   
    LCD_Str(Intro_msg); 

    while(1){
        switch(Status)
        {             
        case STATUS10_ERROR:    // ��������(���ڼ� �ʰ�) �� ��� ȭ�鿡 ���� �޽��� ����� ���� ���� ���ڿ� �ʱ�ȭ   
            LCD_Pos(0, 0);
            LCD_Str(Error_msg); 
            for(i=0;i<=MAXLEN;i++) 
                Current_str[i] = NULL;  
                
            Status = STATUS0_WAIT_KEY_INPUT;
            Line_Shift = 0;        // ���� ������ ����Ʈ�Ͽ� ǥ������ ����?? 
            buffer_count = 0;       
            Current_str[buffer_count] = NULL;
            break;     
            
        case STATUS0_WAIT_KEY_INPUT: // �Է� �����·� �ƹ� ������ �������� ����
            break;       
            
        case STATUS1_FIRST_KEY_INPUT: // ó���� Ű�� �Է¹޾����� ȭ���� �ʱ�ȭ �ϴ� �κ�   
            LCD_Clear();   
            Status = STATUS2_KEY_INPUT;
            break;       
            
        case STATUS3_KEY_INPUT_END:     // Ű���忡�� ����Ű ������ �Է¹޾� ������ ���ڿ��� �����ϴ� ����   
            // LCD�� ǥ���ϱ� ���Ͽ� LCD ��� ���ۿ� ����   
            buffer_count = 0;
            for(i=0; i<MAXLEN; i++) 
            {
                if(Current_str[i] <= 0x20) 
                    Current_str[i] = NULL;     // LCD ǥ�� ���ڿ����� CR, LF ����
                Mem_str[i] = Current_str[i]; 
                Current_str[i] = NULL;                 // Current_str �ʱ�ȭ 
            }                         
            Line_Shift = 1;
            Status = STATUS4_LCD_DISPLAY;  
            break; 
                       
        case STATUS2_KEY_INPUT:         // Ű������ �Է��� ���� ��� ���ڸ� �����ϸ�
        case STATUS4_LCD_DISPLAY:       // �����Է��� �������(Line_Shift == 1) ������ ���ڿ� ���� ��� �ϵ��� �� 
            PORTB ^= 1<<2;    
            if(Line_Shift == 0)
            {     
                LCD_Clear();   
                LCD_Pos(0, 0);  
                LCD_Str(Current_str);   
            } 
            else
            {    
                LCD_Clear();   
                LCD_Pos(0, 0);
                LCD_Str(Mem_str);      
                LCD_Pos(1, 0);  
                LCD_Str(Current_str);           
            }                
            Status = STATUS0_WAIT_KEY_INPUT;       
            break;
        
        }
    }
}