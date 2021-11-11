/*
 * usart_Queue_Buffer.c
 *
 * Created: 2021-09-18 ���� 8:25:47
 * Author: user
 */

#include <mega128.h>
#include "lcd.h"
#include "usart.h"
#include <delay.h>
#define ENTER '\r'
#define MAXLEN 17

const int QueBuffSize = 20;  //���ø� ������� 20���� ����
unsigned char QueData[QueBuffSize];
int QueFront=0;
int QueRear = 0;

unsigned char first_flag = 0, error_flag =0; //�ʱ���¿� �������¸� ����
unsigned char key, ch, pos;
unsigned char str[MAXLEN], str2[MAXLEN];

int enQue(char data)    //������ ����
{
    if((QueRear-QueFront)>=QueBuffSize)
        return -1;
        
    if((QueRear - QueFront) <= -QueBuffSize)
        return -1;
    
    QueData[QueRear] = data;
    QueRear++;
    
    if(QueRear >= QueBuffSize)
        QueRear = 0;
    return(QueRear-QueFront);
}

int deQue(char *pData)  //������ ����
{
    if((QueRear - QueFront) == 0) {
        *pData = 0;
        return -1;
    }
    
    *pData = QueData[QueFront];
    QueFront++;
    
    if(QueFront >= QueBuffSize)
        QueFront = 0;
        
    return (QueRear-QueFront);
}

interrupt [USART1_RXC] void usart1_receive(void)
{
    int i;
    unsigned char recByte = 0;      
    recByte = UDR1;
    enQue(recByte);
    
    
    if(QueRear > QueFront) //��ü ����ũ�⸦ �ʰ��ߴ��� �ƴ��� Ȯ��
    {
       
         if( (QueRear-QueFront) > 16){
         deQue(QueData);
        }
        for(i=0; i < 16 ; i++){
             
                LCD_Char(QueData[QueFront+i]);
        }          
    }
    else if( QueFront > QueRear)
    {
        deQue(QueData);
        
        for(i=0; i < 16 ; i++){
             
            if (QueFront+i < QueBuffSize) LCD_Char(QueData[QueFront+i]);
            else LCD_Char(QueData[QueFront+i-QueBuffSize]);         
        }    
    
    }
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
while (1)
    { CD_Pos(0,0); }
}
