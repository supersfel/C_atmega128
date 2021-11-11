
/*
 * spi_1.c
 *
 * Created: 2021-10-06 ���� 11:57:57
 * Author: ���α�
 */

#include <mega128.h>
#include <delay.h>
#include <stdio.h>
#include "lcd.h"
#include "spi.h"



    
interrupt [SPI_STC] void spi_master_isr(void)
{
    
    LCD_Pos(1,0);        
    delay_ms(300);
    
    // ���ͷ�Ʈ ��ƾ        
        
}


void main(void)
{

    unsigned char key =0;
    unsigned char key_flag = 0;
    unsigned char send_data = 0;
    unsigned char str[] = "Master Send :";
    unsigned char *mes = "@Mingyu";   // @�� ������ ù�ٷ� ���� �����صξ���.
    int i=0;                          
    DDRD = 0x00;
    Init_SPI_Master();
    LCD_Init();
    LCD_Pos(0,0);
    LCD_Str(str);
    SREG |= 0x80;
    
while (1)
    {
        key = (PIND&0xff); // PIND�� �Է��� ����
        switch(key)
        {
             case 0xF7:    // PD2��ư 
                
                key_flag = 1;
                delay_ms(10);
                
                 
                ClearToSend=1;
                SPI_CS = 0;
                SPI_Master_Send_IntContr(mes); //������ �޽��� ����
                LCD_Char('T');  
                SPI_CS = 1;
                
                
                delay_ms(300);
             
                 
                
                
                break;
            case 0xFB:  // PD1��ư 
               
                key_flag = 1;
                delay_ms(10);
                        
                for (i=0;i<7;i++)
                {
                    send_data = mes[i];
                    SPI_CS = 0;
                    SPI_Master_Send(send_data);
                    SPI_CS = 1;  
                    
                    delay_ms(300);
                }
                
                
                break;
            case 0xFD:   // PD0��ư 
                
                key_flag = 1;
                delay_ms(10);  
                
                SPI_CS = 0;
                    SPI_Master_Send('@');
                    SPI_CS = 1;
                    delay_ms(300);
                
                for (i=0; i<26;i++) 
                {
                    send_data = 65+i;
                    LCD_Pos(0,14);
                    LCD_Char(send_data);
                    
                    SPI_CS = 0;
                    SPI_Master_Send(send_data);
                    SPI_CS = 1;
                    
                    delay_ms(300);
                    
                }
                
                
                break;
            case 0xFE:
                send_data = 'A';
                key_flag = 1;
                delay_ms(10); 
                
                SPI_CS = 0;
                SPI_Master_Send(send_data);
                SPI_CS = 1;  
                
                
                break;      
            default:
                break;
        }
       
        
        if(send_data =='A') //A�� ���� �ð����� ����
        {
            delay_ms(300); 
            SPI_CS = 0;
            SPI_Master_Send(send_data);
            SPI_CS = 1;   
        }              

    }
}

