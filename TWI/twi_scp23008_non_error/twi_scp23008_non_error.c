/*
 * twi_scp23008.c
 *
 * Created: 2021-10-29 ¿ÀÀü 10:29:42
 * Author: Á¤¹Î±Ô
 */

#include <mega128.h>
#include <delay.h>
#include "TWI.h"


#define MCP23008ADDR (unsigned char) 0x40
#define GPIO (unsigned char) 0x09
#define IODIR (unsigned char) 0x00  


/* 
enum MCP23008_REG_ADDRESS
     {
        IODIR =  0x00,
        IPOL =   0x01, 
        GPINTEN = 0x02,
        DEFVAL = 0x03,   
        INTCON = 0x04,    
        IOCON =  0x05,     
        GPPU = 0x06,        
        INTF = 0x07,         
        INTCAP = 0x08,        
        GPIO =  0x09,
        OLAT = 0x0A,
     }  
     
*/ 
unsigned char MCP23008_I2C_Read(char devAddr, char regAddr)
{
    unsigned char data;
    unsigned char rec_data;
    TWI_Start();
    TWI_Write_SLAW(devAddr);
    TWI_Write_Data(regAddr);
    TWI_Restart();
    TWI_Write_SLAW(devAddr);
    data = TWI_Read_Data_NACK();    
    TWI_Stop();
    
    return data;
    
   
}

 

unsigned char MCP23008_I2C_Write(char devAddr,char regAddr, char data)
{
    TWI_Start();
    TWI_Write_SLAW(devAddr);
   
    TWI_Write_Data(regAddr);
    
    TWI_Write_Data(data);
    
    TWI_Stop();
    
    
}

void MCP23008_Init(void)
{
    MCP23008_I2C_Write(MCP23008ADDR,IODIR,0x0F);
    delay_ms(10);
}


void main(void)
{
    unsigned char keyInput;
    unsigned char keyOutput;
    unsigned char fnd;
    unsigned char ret_err = 0;
    
    Init_TWI();
    MCP23008_Init();
    
while (1)
    {
        
        keyInput = MCP23008_I2C_Read(MCP23008ADDR, GPIO);
        
        fnd = keyInput;
        keyOutput = (0x0F)|(fnd << 4);
        delay_ms(1);
        MCP23008_I2C_Write(MCP23008ADDR, GPIO, 0b00010000);
        delay_ms(100);
        
        

    }
}
