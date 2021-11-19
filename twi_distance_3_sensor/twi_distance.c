
#include <mega128.h>
#include <delay.h>
#include <stdio.h>
#include "lcd.h"
#include "twi.h"
#include "srf02.h"

unsigned char ti_Cnt_1ms;
unsigned char LCD_DelCnt_1ms;

void Timer0_Init()
{
    TCCR0 = (1<<WGM01)|(1<<CS00)|(1<<CS01)|(1<<CS02);
    TCNT0 = 0x00;
    OCR0 = 100;
    TIMSK = (1<<OCIE0);
}

interrupt[TIM0_COMP] void timer0_comp(void)
{
    ti_Cnt_1ms++;
    LCD_DelCnt_1ms++;
}

int SRF_Run(char Sonar_Addr){
    unsigned char res;    
    unsigned int Sonar_range;  
    
    res = getRange(Sonar_Addr, &Sonar_range);
        if(res)
        {         
            return 0;
        }
        else if(LCD_DelCnt_1ms > 100)
        {
            
            LCD_DelCnt_1ms = 0;            
            return Sonar_range;
        }  

}

void main(void)
{
    unsigned char res;
    char Sonar_Addr = 0xE0;
    unsigned int Sonar_range_1,Sonar_range_2,Sonar_range_3;   
    char Message[40];
    int readCnt = 0; 
    DDRD |= 0x03;
    
    LCD_Init();
    Timer0_Init();
    Init_TWI();
    delay_ms(1000);
    SREG |= 0x80;
    
    startRanging(Sonar_Addr);
    ti_Cnt_1ms = 0;
    Sonar_range_1 = 0; 
    Sonar_range_2 = 0;  
    Sonar_range_3 = 0;
    
    LCD_DelCnt_1ms = 0; 
    
    while(1)
    {   
           
        if(ti_Cnt_1ms > 100)
        {     
            
            
                         
            if (Sonar_Addr == 0xE0){
                Sonar_Addr = 0xEC;
                startRanging(Sonar_Addr);
                Sonar_range_1 = SRF_Run(Sonar_Addr);
            } 
            else if (Sonar_Addr == 0xEC) {
                Sonar_Addr = 0xE2;
                startRanging(Sonar_Addr);
                Sonar_range_2 = SRF_Run(Sonar_Addr);
            }
            else{
                Sonar_Addr = 0xE0;
                startRanging(Sonar_Addr);
                Sonar_range_3 = SRF_Run(Sonar_Addr);
            }
            
             
            
            LCD_Clear();
            sprintf(Message, "%03dcm", Sonar_range_1);
            LCD_Pos(0,0);
            LCD_Str(Message);
                
            sprintf(Message, "%03dcm", Sonar_range_2);
            LCD_Pos(1,0);
            LCD_Str(Message); 
            
            sprintf(Message, "%03dcm", Sonar_range_3);
            LCD_Pos(1,5);
            LCD_Str(Message); 
                
            LCD_DelCnt_1ms = 0;             
            ti_Cnt_1ms = 0;
        } 
        
        
        
        
        
        
    }
}
