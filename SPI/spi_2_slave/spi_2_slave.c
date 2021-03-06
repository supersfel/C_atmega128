/*
 * spi_2_slave.c
 *
 * Created: 2021-10-06 ???? 1:05:09
 * Author: ???α?
 */

#include <mega128.h>
#include "lcd.h"
#include "spi.h"
#include "usart.h"

unsigned char SPI_Str[16];
unsigned char count, SPI_flag;
unsigned char Str;

interrupt [SPI_STC] void spi_isr(void)
{
   
    if(count > 15) count = 0;
    if(SPDR == 0x0D)
    {
        SPI_flag = 1;
        SPI_Str[count] = 0;
        count = 0;
    
    }            
    else if (SPDR == 0x0A)
    {
        #asm("NOP");
    }
    else
    {
        SPI_Str[count] = SPDR;
        count ++;
    }
    
    
    
}

void main(void)
{

    unsigned char line = 1;
    unsigned char i = 0;
    count = 0;
    SPI_flag = 0;
    
    Init_SPI_Slave_IntContr();
    LCD_Init();
while (1)
    {
    // Please write your application code here  
    
        if(SPI_flag)
        {
            if(line == 1) { line = 0; LCD_Clear();}
            else line = 1;
            LCD_Pos(line,0);
            LCD_Str(SPI_Str);
            for(i=0;i<30;i++) SPI_Str[i] = 0;
            SPI_flag = 0;
        }       
        
        
        

    }
}
