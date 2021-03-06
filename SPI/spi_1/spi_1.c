
/*
 * spi_1.c
 *
 * Created: 2021-10-06 ???? 11:57:57
 * Author: ???α?
 */

#include <mega128.h>
#include <delay.h>
#include <stdio.h>
#include "lcd.h"
#include "spi.h"




void main(void)
{

    unsigned char key =0;
    unsigned char key_flag = 0;
    unsigned char send_data = 0;
    unsigned char str[] = "Master Send :";
    DDRD = 0x00;
    Init_SPI_Master();
    LCD_Init();
    LCD_Pos(0,0);
    LCD_Str(str);
    
while (1)
    {
        key = (PIND&0xff);
        switch(key)
        {
            case 0x7F:
                send_data = 'H';
                key_flag = 1;
                delay_ms(10);
                break; 
            case 0xBF:
                send_data = 'G';
                key_flag = 1;
                delay_ms(10);
                break;            
            case 0xDF:
                send_data = 'F';
                key_flag = 1;
                delay_ms(10);
                break;
            case 0xEF:
                send_data = 'E';
                key_flag = 1;
                delay_ms(10);
                break;
            case 0xF7:
                send_data = 'D';
                key_flag = 1;
                delay_ms(10);
                break;
            case 0xFB:
                send_data = 'C';
                key_flag = 1;
                delay_ms(10);
                break;
            case 0xFD:
                send_data = 'B';
                key_flag = 1;
                delay_ms(10);
                break;
            case 0xFE:
                send_data = 'A';
                key_flag = 1;
                delay_ms(10);
                break;      
            default:
                break;
        }
        if(key_flag == 1)
        {
            SPI_CS = 0;
            SPI_Master_Send(send_data);
            SPI_CS = 1;
            LCD_Pos(0,14);
            LCD_Char(send_data);
            key_flag =0;
            }
            delay_ms(100);
                      

    }
}
