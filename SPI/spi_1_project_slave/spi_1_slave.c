/*
 * spi_1_slave.c
 *
 * Created: 2021-10-06 오후 12:38:36
 * Author: 정민규
 */

#include <mega128.h>
#include <delay.h>
#include <stdio.h>
#include "lcd.h"
#include "spi.h"

unsigned char SPI_Rec_Char;
unsigned char count=0;
unsigned char flag =0,clear_flag =0;
interrupt [SPI_STC] void spi_isr(void)
{
    SPI_Rec_Char = SPDR;
    flag = 1;
    if (SPI_Rec_Char == '@') clear_flag =1;  
     
    delay_ms(10);
}




void main(void)
{
    unsigned char str[] = "Slave Rec. : ";
    Init_SPI_Slave_IntContr();
    LCD_Init();
    LCD_Pos(0,0);
    LCD_Str(str);
    LCD_Pos(1,0);
while (1)
    {
    // Please write your application code here  
       
        if (clear_flag){   //새로운 버튼이 눌러지면 LCD를 초기화
            LCD_Clear();
            LCD_Pos(0,0);
            LCD_Str(str);
            LCD_Pos(1,0);
            count =0;
            clear_flag =0;
            delay_ms(300);
        }
        else if (flag) 
        {
                  
            LCD_Char(SPI_Rec_Char);
            delay_ms(100);                 
            if(count <15)  count++;
            else count =0, LCD_Pos(1,0);       
                
            flag =0;
        }
    }
}
