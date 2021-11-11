/*
 * twi_send_message_slave.c
 *
 * Created: 2021-10-13 오후 12:56:12
 * Author: 정민규
 */
 
#define _USE_SAFTY_TWI_

#include <mega128.h>
#include <delay.h>
#include "twi.h"
#include "lcd.h"

unsigned char SLAVE_ADDR = 0x02;

void main(void)
{
    unsigned char ch = 0;
    int pos_count = 10; 
    
    
    LCD_Init();
    LCD_Str("I2C Slave Init");
    LCD_Pos(1,0);
    LCD_Str("Received-> ");  
    
    
    
    Init_TWI();
    Init_TWI_Slaveaddr(SLAVE_ADDR);
while (1)
    {
    // Please write your application code here  
        
        if(TWI_Slave_Receive(&ch) ==0)
        {
            LCD_Pos(1,pos_count);
            LCD_Char(ch);
            pos_count++;
        }
        
        if (pos_count > 15) pos_count =10;

    }
}
