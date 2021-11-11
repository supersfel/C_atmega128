#include <mega128.h>
#include "spi.h"
#include "usart.h"

#define SPI_CS PORTB.0

void main(void)
{
    unsigned char data;
    Init_USART1(0);
    Init_SPI_Master();
    
    while(1)
    {
        data = getch_USART1();
        PORTB.7 = ~PORTB.7;
        SPI_Master_Send(data);
    }

}