/*
 * spi_2_slave.c
 *
 * Created: 2021-10-06 ¿ÀÈÄ 1:05:09
 * Author: Á¤¹Î±Ô
 */

#include <mega128.h>
#include "lcd.h"
#include "spi.h"
#include "usart.h"

unsigned char count, SPI_flag;
unsigned char Str;

interrupt [SPI_STC] void spi_isr(void)
{
   
    
    
    
    if(SPDR == 0x0D)
    {
        SPI_flag = 2;
        Str = SPDR;
        count = 0;
    
    }
    else if(SPDR != 0)
    {
        SPI_flag = 1;
        Str = SPDR;
    }  
}

void main(void)
{
    bit pos = 0;

    unsigned char line = 1;
    unsigned char i = 0;
    count = 0;
    SPI_flag = 0;
    
    Init_SPI_Slave_IntContr();
    LCD_Init();
while (1)
    {
       
        switch(SPI_flag)
        {
            case 1:
               LCD_Char(Str);
               SPI_flag =0;
               
               count++; 
               break;
            case 2: 
                       
               pos = ~pos;
               LCD_Pos(pos,0);
               LCD_Str("               ");
               LCD_Pos(pos,0);
               SPI_flag = 0;
               
               break;
            
            default :
                break;
        }
        
        
        
        
        
        if(count == 16)
        {
            LCD_Pos(0,0);
            count =0;
        }

    }
}


