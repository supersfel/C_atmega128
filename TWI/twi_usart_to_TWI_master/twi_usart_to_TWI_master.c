/*
 * twi_usart_to_TWI_master.c
 *
 * Created: 2021-10-15 ???? 12:41:03
 * Author: ???α?
 */
#define _USE_SAFTY_TWI_


#include <mega128.h>
#include <delay.h>
#include "twi.h"
#include "lcd.h"
#include "usart.h"

unsigned char SLAVE_ADDR = 0x02;

void main(void)
{
    unsigned char key =0,data;
    int i=0;
    
    LCD_Init();
    LCD_Str("I2C Master Init");
    LCD_Pos(1,0);
    LCD_Str("Send -> ");
    
    DDRB = 0x00;
    
    Init_TWI();
    Init_USART1(0);


while (1)
    {
        delay_ms(200);
        data = getch_USART1();
        
        if( TWI_Master_Transmit(data,SLAVE_ADDR) == 0)
        {               
                    
        } 

    }
}
