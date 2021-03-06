/*
 * usart_1_1.c
 *
 * Created: 2021-09-18 오후 4:27:39
 * Author: 정민규
 */

#include <mega128.h>
#include "lcd.h"
#include "usart.h"
#include <delay.h>

#define ENTER '\r'
#define MAXLEN 17

unsigned char first_flag = 0, error_flag =0; //초기상태와 에러상태를 정의
unsigned char key, ch, pos;
unsigned char str[MAXLEN], str2[MAXLEN];
unsigned char start_str[] = "Press char&Enter";
unsigned char error_message[] = "Max length error"; 


interrupt [USART1_RXC] void usart1_receive(void)
{
    unsigned char i;
    
    if(first_flag == 0) ch = 0;  //초기상태일시 문자열 입력이 안되게 함
    str[ch] = UDR1;          //인터럽트 발생 시 수신된 문자를 str[ch]에 저장
   

     if(str[ch] == ENTER){
        for(i=0;i<MAXLEN;i++) str2[i] = 0;
        for(i=0;i<MAXLEN;i++) str2[i] = str[i];
        
        str[ch-1] = 0x00;   
        ch = 0;             //문자열 초기화
        key = 1;            //메인문에서 동작수행하게 하는 키
        LCD_Pos(~pos,0);         //위치 변경
        }
        else ch++;
        delay_ms(10);
        
   
    if(first_flag > 0) {
    LCD_Str(str); }        //LCD가 계속 표시되는걸 막게하기 위해 예제와 위치 변경   
    
    if ( ch >= MAXLEN) error_flag = 1;    //최대 글자 이상일때 에러모드

}




void main(void)
{
   
    unsigned char i;
    LCD_Init();
    Init_USART1_IntCon(0,RX_Int);
    SREG |= 0x80;
    pos = 1;
    ch = 0;
    key = 0;
    
    LCD_Str(start_str);
    
    
while (1)
    {   
           
    
          if(key == 1) {   //엔터키가 눌렸을때 동작
            
                    
            LCD_Pos(0,0);
            LCD_Str("                ");
            LCD_Pos(0,0);              
            LCD_Str(str2); 
            LCD_Pos(1,0);
            LCD_Str("                ");
            LCD_Pos(0,0);          
            //LCD초기화 후 이전 문자를 위LCD에 표시 
            
            for(i=0;i<MAXLEN;i++) str[i] = 0;
            key = 0;
            first_flag ++;
            delay_ms(100);
            
            }
          else{            
            
            if(first_flag > 1) LCD_Pos(1,0) ;
            else LCD_Pos(0,0);
            
            }
            
          
            
          if( error_flag ){ //에러모드 동작
            for(i=0;i<MAXLEN;i++) str[i] = 0;              
            LCD_Pos(0,0);
            LCD_Str("                "); 
            LCD_Pos(1,0);
            LCD_Str("                ");
            LCD_Pos(0,0);         
            LCD_Str(error_message);
            first_flag = 0;
            error_flag = 0;
            
             }   

    }
}
