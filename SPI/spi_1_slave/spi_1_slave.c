/*
 * spi_1_slave.c
 *
 * Created: 2021-10-06 ���� 12:38:36
 * Author: ���α�
 */

#include <mega128.h>
#include <delay.h>
#include <stdio.h>
#include "lcd.h"
#include "spi.h"

unsigned char SPI_Rec_Char;

interrupt [SPI_STC] void spi_isr(void)
{
   SPI_Rec_Char = SPDR;
}


void main(void)
{
    unsigned char str[] = "Slave Rec. : ";
    Init_SPI_Slave_IntContr();
    LCD_Init();
    LCD_Pos(0,0);
    LCD_Str(str);

while (1)
    {
    // Please write your application code here  
        LCD_Pos(0,13);
        LCD_Char(SPI_Rec_Char);
        delay_ms(100);

    }
}
