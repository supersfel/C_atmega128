/*
 * twi_usart_to_TWI_slave.c
 *
 * Created: 2021-10-13 ???? 12:56:12
 * Author: ???α?
 */
 
#define _USE_SAFTY_TWI_
#define ENTER '\r'
#define MAXLEN 15

#include <mega128.h>
#include <delay.h>
#include "twi.h"
#include "lcd.h"

unsigned char SLAVE_ADDR = 0x02;

void main(void)
{
    unsigned char ch = 0;
    unsigned char str[MAXLEN];
    char pos_row = 0, count =0,i;
    bit pos_col =0;
    
    
    
    LCD_Init();
     
    
    
    
    Init_TWI();
    Init_TWI_Slaveaddr(SLAVE_ADDR);
while (1)
    {
    // Please write your application code here  
        
        if(TWI_Slave_Receive(&ch) ==0)
        { 
            delay_ms(100);
            str[count] = ch;
            count++;
            
            
            
            //LCD_Pos(pos_col,pos_row);
            LCD_Char(ch);
              
            
            if(ch == ENTER){
                str[count-1] = 0x00;
                LCD_Clear();
                LCD_Pos(0,0);
                LCD_Str(str);
                LCD_Pos(1,0);
                count = 0;
                
                for (i=0;i<MAXLEN;i++)
                {
                    str[i]=0;
                }
                
            }
            
        }
        
        
        

    }
}
