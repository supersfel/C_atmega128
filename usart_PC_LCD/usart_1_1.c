/*
 * usart_1_1.c
 *
 * Created: 2021-09-18 ���� 4:27:39
 * Author: ���α�
 */

#include <mega128.h>
#include "lcd.h"
#include "usart.h"
#include <delay.h>

#define ENTER '\r'
#define MAXLEN 17

unsigned char first_flag = 0, error_flag =0; //�ʱ���¿� �������¸� ����
unsigned char key, ch, pos;
unsigned char str[MAXLEN], str2[MAXLEN];
unsigned char start_str[] = "Press char&Enter";
unsigned char error_message[] = "Max length error"; 


interrupt [USART1_RXC] void usart1_receive(void)
{
    unsigned char i;
    
    if(first_flag == 0) ch = 0;  //�ʱ�����Ͻ� ���ڿ� �Է��� �ȵǰ� ��
    str[ch] = UDR1;          //���ͷ�Ʈ �߻� �� ���ŵ� ���ڸ� str[ch]�� ����
   

     if(str[ch] == ENTER){
        for(i=0;i<MAXLEN;i++) str2[i] = 0;
        for(i=0;i<MAXLEN;i++) str2[i] = str[i];
        
        str[ch-1] = 0x00;   
        ch = 0;             //���ڿ� �ʱ�ȭ
        key = 1;            //���ι����� ���ۼ����ϰ� �ϴ� Ű
        LCD_Pos(~pos,0);         //��ġ ����
        }
        else ch++;
        delay_ms(10);
        
   
    if(first_flag > 0) {
    LCD_Str(str); }        //LCD�� ��� ǥ�õǴ°� �����ϱ� ���� ������ ��ġ ����   
    
    if ( ch >= MAXLEN) error_flag = 1;    //�ִ� ���� �̻��϶� �������

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
           
    
          if(key == 1) {   //����Ű�� �������� ����
            
                    
            LCD_Pos(0,0);
            LCD_Str("                ");
            LCD_Pos(0,0);              
            LCD_Str(str2); 
            LCD_Pos(1,0);
            LCD_Str("                ");
            LCD_Pos(0,0);          
            //LCD�ʱ�ȭ �� ���� ���ڸ� ��LCD�� ǥ�� 
            
            for(i=0;i<MAXLEN;i++) str[i] = 0;
            key = 0;
            first_flag ++;
            delay_ms(100);
            
            }
          else{            
            
            if(first_flag > 1) LCD_Pos(1,0) ;
            else LCD_Pos(0,0);
            
            }
            
          
            
          if( error_flag ){ //������� ����
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