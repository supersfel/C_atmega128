// max length 초과시 오류 발생 
// 오류 메세지 출력하고 enter key가 입력되도록 wait 하도록 수정 요함 
#include <mega128.h>  
#include <delay.h>
#include "lcd.h"                    // LCD 사용을 위해 lcd 헤더 파일을 포함
#include "usart.h"

#define MAXLEN  17                  // LCD 16 문자 + \r
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
unsigned char Current_str[MAXLEN]={0,}; // 현재 수신된 문자를 저장하기 위한 공간, 0으로 문자열 초기화 
unsigned char Mem_str[MAXLEN]={0,};     // 이전에 수신된 문자열을 저장하기 위한 공간, 0으로 문자열 초기화 

unsigned int Status = STATUS0_WAIT_KEY_INPUT;  // 동작 STATUS 를 나타내는 변수 

// 인터럽트 루틴에서의 데이터 수신
interrupt [USART1_RXC] void usart1_receive(void)
{       
    Current_str[buffer_count] = UDR1;       
    PORTB ^= 1<<0;
    // 특수문자이면 문자를 처리하지 않고,     
    if(Current_str[buffer_count] == ENTER){
        Status = STATUS3_KEY_INPUT_END;
        PORTB ^= 1<<1;
    }
    else  
    // max length(16문자)를 초과하면 error flag 설정 
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
         
    LCD_Init();                     // LCD 초기화  
    Init_USART1_IntCon(0, RX_Int);    // 9600bps, RX INT    
    SREG |= 0x80;                   // glabal int. 허가 
 
    LCD_Pos(0,0);               // 1라인에 USART Intro Message 출력   
    LCD_Str(Intro_msg); 

    while(1){
        switch(Status)
        {             
        case STATUS10_ERROR:    // 에러상태(글자수 초과) 인 경우 화면에 에러 메시지 출력후 현재 수진 문자열 초기화   
            LCD_Pos(0, 0);
            LCD_Str(Error_msg); 
            for(i=0;i<=MAXLEN;i++) 
                Current_str[i] = NULL;  
                
            Status = STATUS0_WAIT_KEY_INPUT;
            Line_Shift = 0;        // 이전 라인을 시프트하여 표시하지 않음?? 
            buffer_count = 0;       
            Current_str[buffer_count] = NULL;
            break;     
            
        case STATUS0_WAIT_KEY_INPUT: // 입력 대기상태로 아무 동작을 수행하지 않음
            break;       
            
        case STATUS1_FIRST_KEY_INPUT: // 처음에 키를 입력받았을때 화면을 초기화 하는 부분   
            LCD_Clear();   
            Status = STATUS2_KEY_INPUT;
            break;       
            
        case STATUS3_KEY_INPUT_END:     // 키보드에서 엔터키 정보를 입력받아 기존의 문자열을 저장하는 상태   
            // LCD에 표시하기 위하여 LCD 출력 버퍼에 저장   
            buffer_count = 0;
            for(i=0; i<MAXLEN; i++) 
            {
                if(Current_str[i] <= 0x20) 
                    Current_str[i] = NULL;     // LCD 표시 문자열에서 CR, LF 제거
                Mem_str[i] = Current_str[i]; 
                Current_str[i] = NULL;                 // Current_str 초기화 
            }                         
            Line_Shift = 1;
            Status = STATUS4_LCD_DISPLAY;  
            break; 
                       
        case STATUS2_KEY_INPUT:         // 키보드의 입력이 있을 경우 문자를 포시하며
        case STATUS4_LCD_DISPLAY:       // 엔터입력을 받은경우(Line_Shift == 1) 기존의 문자열 또한 출력 하도록 함 
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