/*
 * twi_scp23008.c
 *
 * Created: 2021-10-29 ???? 10:29:42
 * Author: ???α?
 */
#define _USE_SAFTY_TWI_
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
unsigned char MCP23008_I2C_Read(char devAddr, char regAddr, unsigned char* data)
{
    unsigned char rec_data;
    unsigned char ret_err = 0;
    ret_err = TWI_Start();
    if(ret_err!=0) return ret_err; 
    ret_err = TWI_Write_SLAW(devAddr);
    if(ret_err!=0) return ret_err;
    ret_err = TWI_Write_Data(regAddr);
    if(ret_err!=0) return ret_err;
    ret_err = TWI_Restart();
    if(ret_err!=0) return ret_err;
    ret_err = TWI_Write_SLAW(devAddr);
    if(ret_err!=0) return ret_err;
    ret_err = TWI_Read_Data_NACK(&rec_data);
    if(ret_err!=0) return ret_err;
    TWI_Stop();
    *data = rec_data;
    return ret_err;
}

 

unsigned char MCP23008_I2C_Write(char devAddr,char regAddr, char data)
{
    unsigned char ret_err = 0;
    ret_err = TWI_Start();
    if(ret_err!=0) return ret_err;  
    ret_err = TWI_Write_SLAW(devAddr);
    if(ret_err!=0) return ret_err;
    ret_err = TWI_Write_Data(regAddr);
    if(ret_err!=0) return ret_err;
    ret_err = TWI_Write_Data(data);
    if(ret_err!=0) return ret_err;
    TWI_Stop();
    return ret_err;
    
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
        
        ret_err = TWI_Master_Receive_ExDevice(MCP23008ADDR, GPIO, &keyInput);
        if(ret_err == 0)
        {
            fnd = keyInput;
            keyOutput = (0x0F)|(fnd << 4);
            
            delay_ms(1);
            ret_err = MCP23008_I2C_Write(MCP23008ADDR, GPIO, keyOutput);
            delay_ms(100);
        }
        

    }
}
