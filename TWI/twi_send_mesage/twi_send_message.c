/*
 * twi_send_message.c
 *
 * Created: 2021-10-13 오후 12:47:59
 * Author: 정민규
 */
#define _USE_SAFTY_TWI_

#include <mega128.h>
#include <delay.h>
#include "twi.h"
#include "lcd.h"

unsigned char SLAVE_ADDR = 0x02;
unsigned char *mes = "mingyu";




void main(void)
{

    unsigned char idx = 0; 
    unsigned char key =0;
    int i=0;
    
    LCD_Init();
    LCD_Str("I2C Master Init");
    LCD_Pos(1,0);
    LCD_Str("Send -> ");
    
    DDRB = 0x00;
    Init_TWI();
while (1)
    {   
    
        
        
        
        key = (PINB&0xff);
        switch(key)
        {
             case 0xF7://스위치3
               
                
                
                
                break;
            case 0xFB: //스위치2
                delay_ms(500);
                LCD_Pos(1,9);
                
                
                for(i=0;i<6;i++)
                {
                    delay_ms(500);
                    LCD_Char(mes[i]);
                    if( TWI_Master_Transmit(mes[i],SLAVE_ADDR) == 0)
                    {                   
                    
                    } 
                        
                }
                
                 
                
                
                break;
            case 0xFD: //스위치1
                delay_ms(500);
                LCD_Pos(1,9);
                LCD_Char('A'+idx);
                
                if( TWI_Master_Transmit('A' +(idx++),SLAVE_ADDR) == 0)
                {
                    if(('A'+idx)>'Z') idx = 0;
                    
                } 
                
                
                
                
                break;
            case 0xFE: //스위치0
                delay_ms(500);
                LCD_Pos(1,9);
                LCD_Char('A');
                
                if( TWI_Master_Transmit('A' ,SLAVE_ADDR) == 0)
                
                
            
                
                
                
                break;      
            default:
                break;
        }
        
        
        
    
        
    // Please write your application code here

    }
}
