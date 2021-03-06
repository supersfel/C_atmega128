/*
 * spi_3.c
 *
 * Created: 2021-10-09 오후 6:00:58
 * Author: 정민규
 */

#include <mega128.h>
#include <delay.h>
#include <math.h>
#include "spi.h"


#define SS 0
#define SCK 1
#define MOSI 2
#define MISO 3
#define pi 3.1415

bit flag =0;

unsigned char DAC_MSB;
unsigned char DAC_LSB;

unsigned char c_cnt;
void Init_Timer2(void) //타이머 설정
{ 

    TCCR2 = 0x00;
    TCCR2 |= (1<<WGM21);
    OCR2=100;
    TIMSK = (1<<OCIE2);
    TCCR2|= 1<<CS21;    

}



interrupt [TIM2_COMP] void timer2_out_comp(void){
    c_cnt++;}     // 타이머 설정


void MCP4921_SPI_Write(unsigned int DAC_Data)
{
    DAC_MSB = (0b00110000)|(DAC_Data >> 8);
    DAC_LSB = DAC_Data;
    
    SPI_CS2 = 0;
    SPI_Master_Send(DAC_MSB);
    SPI_Master_Send(DAC_LSB);
    SPI_CS2 = 1;      //MCP4921을 이용한 설정
}


void Init_MCP4921(void)
{
    MCP4921_SPI_Write(0x0000);
    delay_ms(1);
}

void sin_pulse(double SIN[])
{
    int i;
    for (i=0; i<100;i++)
    {
        SIN[i] = (sin((2* pi * i)/100)+1) * 100;
    }
}


void main(void)
{

    unsigned int DAC_Data = 0;
    unsigned int i;
    unsigned char key=0;  
    double sin[100];
    DDRE = 0xff;
    DDRD = 0x00;
    Init_SPI_Master(); //초기설정
    Init_MCP4921();
    Init_Timer2();
    SREG |= 0x80;
    
    sin_pulse(sin);
    

while (1)
    {
    
       key = (PIND&0xff);
        switch(key)
        {  
               
            case 0xFB: //100Hz
                if (c_cnt >= 100) DAC_Data=0, c_cnt =0;
                DAC_Data = sin[c_cnt];
                MCP4921_SPI_Write(DAC_Data); 
                
                break;
            case 0xFD: //1kHz
                if (c_cnt >= 10) flag = ~flag, c_cnt =0;
                if (flag) DAC_Data = 500;
                else DAC_Data = 0;
                MCP4921_SPI_Write(DAC_Data);
                
                break;
            case 0xFE: //100Hz
                if (c_cnt >= 100) DAC_Data=0, c_cnt =0;
                DAC_Data = DAC_Data + 8;               
                MCP4921_SPI_Write(DAC_Data);
                
                
                break;      
            default:
                break;
        }   
    
    
    
    }
}
