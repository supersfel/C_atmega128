/*
 * spi_control_mcp.c
 *
 * Created: 2021-10-10 ???? 1:53:40
 * Author: ???α?
 */


#include <mega128.h>
#include <delay.h>
#include "spi.h"

#define SPI_CS PORTB.0
#define MCP23S08ADDR 0x40



enum MCP23S08_REG_ADDRESS{
    IODIR = 0x00,
    IPOL = 0x01,
    GPINTEN = 0x02,
    DEFVAL = 0x03,
    INTCON = 0x04,
    IOCON = 0x05,
    GPPU = 0x06,
    INTF = 0x07,
    INTCAP = 0x08,
    GPIO = 0x09,
    OLAT = 0x0A,
};


void MCP23S08_SPI_Write (char Dev_Addr, char Reg_Addr, unsigned char Data)
{
    SPI_CS = 0;
    SPI_Master_Send(Dev_Addr);
    SPI_Master_Send(Reg_Addr);
    SPI_Master_Send(Data);
    SPI_CS=1;
}

unsigned char MCP23S08_SPI_Read(char DevAddr, char Reg_Addr, unsigned char Data)
{
    unsigned char data, addr;
    SPI_CS =0;
    addr = DevAddr|0x01;
    SPI_Master_Send(addr);
    SPI_Master_Send(Reg_Addr);
    SPI_Master_Send(Data);
    SPI_CS =1;
    return data;
}

void Init_MCP23S08(void)
{
    MCP23S08_SPI_Write(MCP23S08ADDR, IODIR, 0xf0);
    MCP23S08_SPI_Write(MCP23S08ADDR, IPOL, 0x00);
    MCP23S08_SPI_Write(MCP23S08ADDR,GPIO,0x00);
    
    
}

void main(void)
{
                             
    unsigned char Data = 0xff;
    
    Init_SPI_Master();
    Init_MCP23S08();

    
    
    
while (1)
    {
     // Please write your application code here
        int i=0;
       
                     
        
        MCP23S08_SPI_Write(MCP23S08ADDR,GPIO,0xff); 
        
        
        delay_ms(10); 
    }
}
 
 


