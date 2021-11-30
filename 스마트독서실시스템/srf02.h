#define SRF02_Return_inch           80
#define SRF02_Return_Cm             81
#define SRF02_Return_microSecond    82

#define COM_REG                     0
                   
#define SRF02_1st_Seg_change        160
#define SRF02_2nd_Seg_change        170
#define SRF02_3rd_Seg_change        165


unsigned char SRF02_I2C_Write(char address, char reg, char data)
{
    unsigned char ret_err=0;
    ret_err = TWI_Start();
    ret_err = TWI_Write_SLAW(address);
    if(ret_err != 0)return ret_err;
    ret_err = TWI_Write_Data(reg);
    if(ret_err != 0)return ret_err;
    ret_err = TWI_Write_Data(data);
    if(ret_err != 0)return ret_err;
    TWI_Stop();
    return 0;
}

unsigned char SRF02_I2C_Read(char address, char reg, unsigned char* Data)
{
    char read_data = 0;
    unsigned char ret_err=0;
    ret_err = TWI_Start();
    
    ret_err = TWI_Write_SLAW(address);
    if(ret_err != 0)return ret_err;
    ret_err = TWI_Write_Data(reg);
    if(ret_err != 0)return ret_err;
    
    ret_err = TWI_Restart();
    PORTB |= 0x08;
    if(ret_err != 0)return ret_err; 
    
    ret_err = TWI_Write_SLAR(address);
    PORTB |= 0x10;
    if(ret_err != 0)return ret_err;
    
    ret_err = TWI_Read_Data_NACK(&read_data);
    PORTB |= 0x20;
    if(ret_err != 0)return ret_err;
    TWI_Stop();
    *Data = read_data;
    return 0;
}

unsigned char startRanging(char addr)
{
    return SRF02_I2C_Write(addr,COM_REG,SRF02_Return_Cm);
}   

unsigned int getRange(char addr, unsigned int *pDistance)
{
    unsigned char temp;
    unsigned char res = 0;
    res = SRF02_I2C_Read(addr,2,&temp);
    if(res) return res;
    *pDistance = temp<<8;
    res = SRF02_I2C_Read(addr,3,&temp);
    if(res) return res;
    *pDistance |= temp;
    
    return res;
}

unsigned char change_Sonar_Addr(unsigned char ori, unsigned char des)
{
    unsigned char res = 0;
    
    switch(des)
    {
        case 0xE0:
        case 0xE2:
        case 0xE4:
        case 0xE6:
        case 0xE8:
        case 0xEA:
        case 0xEC:
        case 0xEE:
        case 0xF0:
        case 0xF2:
        case 0xF4:
        case 0xF6:
        case 0xF8:
        case 0xFA:
        case 0xFC:
        case 0xFE:
        
        res = SRF02_I2C_Write(ori, COM_REG, SRF02_1st_Seg_change);
        if(res) return res;
        res = SRF02_I2C_Write(ori, COM_REG, SRF02_2nd_Seg_change);
        if(res) return res;
        res = SRF02_I2C_Write(ori, COM_REG, SRF02_3rd_Seg_change);
        if(res) return res;
        
        res = SRF02_I2C_Write(ori, COM_REG, des);
        if(res) return res;
        break; 
        
    default:
        return -1;
    }
    return 0;
}


