#ifndef _INCLUDE_TWI_H__
#define _INCDLUE_TWI_H__

// TimeOut ���� ����� TWI ���ۿ� �־� Error ó���� �ϴ� �Լ��� ����� ���, 
// �Ʒ��� ���� _USE_SAFTY_TWI_ �� �����Ͽ� ����ϰ�, 
// Error ó���� ���� �ʰ� ������ ����� ��쿡�� �Ϲ����� �Լ��� ����ϵ��� header ������ ���� 

//#define _USE_SAFTY_TWI_

#define ExtDev_ERR_MAX_CNT 2000

// TWI Master Transmitter/Receiver Mode������ ���� �ڵ�     
#define TWI_START   0x08 
#define TWI_RESTART 0x10
#define MT_SLA_ACK 0x18  
#define MT_DATA_ACK 0x28 
#define MR_SLA_ACK 0x40
#define MR_DATA_ACK 0x50
#define MR_DATA_NACK 0x58

// TWI Slave Receiver Mode������ ���� �ڵ�  
#define SR_SLA_ACK 0x60 
#define SR_STOP 0xA0    
#define SR_DATA_ACK 0x80  
#define SR_DATA_NACK 0x58         

// TWI Init.
void Init_TWI()
{
    TWBR = 0x32;        //SCL = 100kHz
    TWCR = (1<<TWEN);   //TWI Enable
    TWSR = 0x00;        //100kHz
}

void Init_TWI_400K()
{
    // Fsck = 14.7456MHz         
    // SCL = (Fsck)/(16 + (2*10)) = 409,600
    TWBR = 0x0A;        	//SCL �� 400kHz
    TWCR = (1<<TWEN);   	//TWI Enable
    TWSR = 0x00;        	//100kHz
}

#if defined(_USE_SAFTY_TWI_)
/***************************************************/
/*   ������ �۽ű� ��忡���� �۽� ���� �Լ�    */
/***************************************************/

// ��ȣ ���� �Ϸ� �˻� �� Status Ȯ�� + Timeout Check 
// error code 0 : no error, 1 : timeout error 2 : TWI Status error

unsigned char TWI_TransCheck_ACK(unsigned char Stat)
{ 
    unsigned int ExtDev_ErrCnt = 0;
    while (!(TWCR & (1<<TWINT)))         // ��Ŷ ���� �Ϸ�� �� ���� wait
    { 
        if(ExtDev_ErrCnt++ > ExtDev_ERR_MAX_CNT){ return 1; }
    }      

    if ((TWSR & 0xf8) != Stat)return 2;  // ���� �˻�(ACK) : error�� 2 ��ȯ
    else return 0;       
}

// START ���� 
unsigned char TWI_Start()
{
    TWCR = ((1<<TWINT) | (1<<TWSTA) | (1<<TWEN));   // START ��ȣ ������
    // while (TWCR & (1<<TWINT)) == 0x00);  // START ��ȣ ���� �Ϸ�� �� ���� wait
    return TWI_TransCheck_ACK(TWI_START);     
} 
        
// SLA+W ��Ŷ ����
unsigned char TWI_Write_SLAW(unsigned char Addr)
{
    TWDR = Addr;                        // SLA + W ��Ŷ(�����̺� �ּ�+Write bit(Low))
    TWCR = (1<<TWINT) | (1<<TWEN);      // SLA + W ��Ŷ ������       
    return TWI_TransCheck_ACK(MT_SLA_ACK); 
} 

// ������ ��Ŷ ����
unsigned char TWI_Write_Data(unsigned char Data)
{
    TWDR = Data;                        // ������ 
    TWCR = (1<<TWINT) | (1<< TWEN);     // ������ ��Ŷ �۽�  
    return TWI_TransCheck_ACK(MT_DATA_ACK);   
} 

// STOP ���� 
void TWI_Stop()
{
    TWCR = ((1<<TWINT) | (1<<TWSTO) | (1<<TWEN));   // STOP ��ȣ ������
} 

// RESTART ���� 
unsigned char TWI_Restart()
{
//    unsigned char ret_err=0;
    TWCR = ((1<<TWINT) | (1<<TWSTA) | (1<<TWEN));   // Restart ��ȣ ������ 
    return TWI_TransCheck_ACK(TWI_RESTART);                 
} 
                      
// Write Packet function for Master 
unsigned char TWI_Master_Transmit(unsigned char Data, unsigned char Addr)  
{
    unsigned char ret_err=0;
    ret_err = TWI_Start();      // START ��ȣ �۽� 
    if(ret_err != 0) return ret_err;  // error�� ���� 
    ret_err = TWI_Write_SLAW(Addr);    // �����̺� �ּ� �۽�  
    if(ret_err != 0) return ret_err;    
    ret_err = TWI_Write_Data(Data);    // ������ �۽� 
    if(ret_err != 0) return ret_err;
    TWI_Stop();                 	// STOP ��ȣ �۽�
    return ret_err;		// error �ڵ� ��ȯ
}

/***************************************************/
/*   ������ ���ű� ��忡���� �۽� ���� �Լ�   */
/**************************************************/            
// SLA+R ��Ŷ ����
unsigned char TWI_Write_SLAR(unsigned char Addr)
{
//    unsigned char ret_err=0;
    TWDR = Addr|0x01;               // SLA + R ��Ŷ(�����̺� �ּ�+Read bit(High))
    TWCR = (1<<TWINT) | (1<<TWEN);  // SLA + R ��Ŷ ������  
    return TWI_TransCheck_ACK(MR_SLA_ACK);     
}                                

// ������ ��Ŷ ����
unsigned char TWI_Read_Data(unsigned char* Data)
{   
    unsigned char ret_err=0;
    TWCR = (1<<TWINT)|(1<< TWEN);   
    ret_err = TWI_TransCheck_ACK(MR_DATA_ACK); 
    if(ret_err != 0) 
        return ret_err;     // if error, return error code         
    *Data = TWDR;           // no error, return ���� ������(�����ͷ�)
    return 0;               // ���� ���� 
} 

unsigned char TWI_Read_Data_NACK(unsigned char* Data)
{   
    unsigned char ret_err=0;
    TWCR = (1<<TWINT)|(1<< TWEN);   // SLA + W ��Ŷ ������  
    ret_err = TWI_TransCheck_ACK(MR_DATA_NACK); 
    *Data = TWDR;           // no error, return ���� ������(�����ͷ�)
    return 0;               // ���� ���� 
} 

// Read Packet function for Master 
unsigned char TWI_Master_Receive(unsigned char Addr, unsigned char* Data)  
{
    unsigned char rec_data;
    unsigned char ret_err=0;
    ret_err = TWI_Start();            // START ��ȣ �۽�    
    if(ret_err != 0) return ret_err;  // error�� ����     
    ret_err = TWI_Write_SLAR(Addr);   // �����̺� �ּ� �۽�  
    if(ret_err != 0) return ret_err;  // error�� ���� 
    ret_err = TWI_Read_Data(&rec_data); // �����ͼ��� 
    if(ret_err != 0) return ret_err;  // error�� ���� 
    TWI_Stop();             // STOP ��ȣ �۽�                          
    *Data = rec_data;
    return 0;               // ���� ��
}

/*****************************************************/
/*   �����̺� ���ű� ��忡���� ���� ���� �Լ�    */
/*****************************************************/
         
// Slave �ּ� ���� �Լ� 
void Init_TWI_Slaveaddr(unsigned char Slave_Addr)
{ 
    TWAR = Slave_Addr;
}
 
// SLA ��Ŷ�� ���� ACK ���� �Լ�
unsigned char TWI_Slave_Match_ACK()
{
//    unsigned char ret_err=0; 
    TWCR = ((1<<TWINT)|(1<<TWEA) |(1<<TWEN));
    // ACK ���� ��� Ȱ��ȭ       
    return TWI_TransCheck_ACK(SR_SLA_ACK);  
    // ��Ŷ ���� �Ϸ� ��� �� SLA + W ��Ŷ�� ���� ACK Ȯ��  
} 

// STOP ���� ���� �� ACK ���� �Լ�
unsigned char TWI_Slave_Stop_ACK()
{ 
//    unsigned char ret_err=0;
    TWCR = ((1<<TWINT)|(1<<TWEA) |(1<<TWEN));
    // ACK ���� ��� Ȱ��ȭ 
    return TWI_TransCheck_ACK(SR_STOP); 
    // STOP ��ȣ ���� ���           
} 

// ������ ���� �Լ� 
unsigned char TWI_Slave_Read_Data(unsigned char* Data)      
// unsigned char* Data : �ּ� �� �Է� 
{ 
    unsigned char ret_err=0;
    TWCR = ((1<<TWINT)|(1<<TWEA) |(1<<TWEN));
    // ACK ���� ��� Ȱ��ȭ        
    ret_err = TWI_TransCheck_ACK(SR_DATA_ACK);   
    if(ret_err != 0) 
        return ret_err;     // if error, return error code         
    *Data = TWDR;           // no error, return ���� ������  
    return 0;               // ���� ���� 
} 

// Read Packet function for Slave 
unsigned char TWI_Slave_Receive(unsigned char* Data)
{
    unsigned char ret_err=0;
    unsigned char rec_data;
    ret_err = TWI_Slave_Match_ACK();   
    if(ret_err != 0) return ret_err;  // error�� ����
    ret_err = TWI_Slave_Read_Data(&rec_data); 
    if(ret_err != 0) return ret_err;  // error�� ����    
    ret_err = TWI_Slave_Stop_ACK(); 
    if(ret_err != 0) return ret_err;  // error�� ����     
    *Data = rec_data;           // ���� ������ ��ȯ 
    return 0;	                // ���� ����
}

/*****************************************************************/
/*   Master TX/RX Mixed function like EEPROM, Sonar etc    */
/*****************************************************************/       

unsigned char TWI_Master_Receive_ExDevice(unsigned char devAddr,unsigned char regAddr, unsigned char* Data)  
{
    unsigned char rec_data; 
    unsigned char ret_err=0;
    ret_err = TWI_Start();      // START ��ȣ �۽�    
    if(ret_err != 0) return ret_err;  // error�� ���� 
    ret_err = TWI_Write_SLAW(devAddr);    // �����̺� �ּ� �۽�
    if(ret_err != 0) return ret_err;  // error�� ���� 
    ret_err = TWI_Write_Data(regAddr);    // ���������ּ� �۽�  
    if(ret_err != 0) return ret_err;  // error�� ����             
    ret_err = TWI_Restart();              // Restart �۽� 
    if(ret_err != 0) return ret_err;  // error�� ����     
    ret_err = TWI_Write_SLAR(devAddr);    // �����̺� �������� �ּ� �۽� 
    if(ret_err != 0) return ret_err;  // error�� ����        

    ret_err = TWI_Read_Data_NACK(&rec_data); // �������� ������ ����(�ּ� ����)      
    if(ret_err != 0) return ret_err;  // error�� ����      
    TWI_Stop();                 // STOP ��ȣ �۽�
    *Data = rec_data; 
    return 0;
}

#else 		// Not _USE_SAFTY_TWI_

/**************************************************************/
/*    ������ �۽ű� ��忡���� �۽� ���� �Լ�(SIMPLY)     */
/**************************************************************/

// ��ȣ ���� �Ϸ� �˻� �� Status Ȯ�� + Timeout Check 
unsigned char TWI_TransCheck_ACK(unsigned char Stat)
{ 
    unsigned int ExtDev_ErrCnt = 0;
    while (!(TWCR & (1<<TWINT)));         // ��Ŷ ���� �Ϸ�� �� ���� wait
    { 
        if(ExtDev_ErrCnt++>ExtDev_ERR_MAX_CNT){ return 1; }
    }      
    if ((TWSR & 0xf8) != Stat) return 1;  // ���� �˻�(ACK) : error�� 1 ��ȯ  
    else return 0;       
}

// START ���� 
void TWI_Start()
{
    TWCR = ((1<<TWINT) | (1<<TWSTA) | (1<<TWEN));   // START ��ȣ ������
    // while (TWCR & (1<<TWINT)) == 0x00);  // START ��ȣ ���� �Ϸ�� �� ���� wait
    TWI_TransCheck_ACK(TWI_START); 
} 
        
// SLA+W ��Ŷ ����
void TWI_Write_SLAW(unsigned char Addr)
{
    TWDR = Addr;                        // SLA + W ��Ŷ(�����̺� �ּ�+Write bit(Low))
    TWCR = (1<<TWINT) | (1<<TWEN);      // SLA + W ��Ŷ ������       
    TWI_TransCheck_ACK(MT_SLA_ACK);
} 

// ������ ��Ŷ ����
void TWI_Write_Data(unsigned char Data)
{
    TWDR = Data;                        // ������ 
    TWCR = (1<<TWINT) | (1<< TWEN);     // ������ ��Ŷ �۽�  
    TWI_TransCheck_ACK(MT_DATA_ACK);           
} 

// STOP ���� 
void TWI_Stop()
{
    TWCR = ((1<<TWINT) | (1<<TWSTO) | (1<<TWEN));   // STOP ��ȣ ������
} 

// RESTART ���� 
void TWI_Restart()
{
    TWCR = ((1<<TWINT) | (1<<TWSTA) | (1<<TWEN));   // Restart ��ȣ ������ 
    TWI_TransCheck_ACK(TWI_RESTART);          
} 
                      
// Write Packet function for Master 
void TWI_Master_Transmit(unsigned char Data, unsigned char Addr)  
{
    TWI_Start();      // START ��ȣ �۽�
    TWI_Write_SLAW(Addr);    // �����̺� �ּ� �۽�
    TWI_Write_Data(Data);    // ������ �۽�
    TWI_Stop();     // STOP ��ȣ �۽�
}

/****************************************************************/
/*     ������ ���ű� ��忡���� �۽� ���� �Լ�(SIMPLY)      */
/****************************************************************/            
// SLA+R ��Ŷ ����
void TWI_Write_SLAR(unsigned char Addr)
{
    TWDR = Addr|0x01;               // SLA + R ��Ŷ(�����̺� �ּ�+Read bit(High))
    TWCR = (1<<TWINT) | (1<<TWEN);  // SLA + R ��Ŷ ������  
    TWI_TransCheck_ACK(MR_SLA_ACK);
}                                

// ������ ��Ŷ ����
unsigned char TWI_Read_Data()
{   
    TWCR = (1<<TWINT)|(1<< TWEN);   // SLA + W ��Ŷ ������  
//    while (!(TWCR & (1<<TWINT)));   // ��Ŷ ���� �Ϸ�� �� ���� wait
    TWI_TransCheck_ACK(MR_DATA_ACK);       
    return TWDR;     
} 

// ������ ��Ŷ ���� with Nack
unsigned char TWI_Read_Data_NACK()
{   
    TWCR = (1<<TWINT)|(1<< TWEN);   // SLA + W ��Ŷ ������  
//   while (!(TWCR & (1<<TWINT)));   // ��Ŷ ���� �Ϸ�� �� ���� wait
    TWI_TransCheck_ACK(MR_DATA_NACK);       
    return TWDR;     
} 

// Read Packet function for Master 
unsigned char TWI_Master_Receive(unsigned char Addr)  
{
    unsigned char rec_data;
    TWI_Start();            // START ��ȣ �۽�
    TWI_Write_SLAR(Addr);   // �����̺� �ּ� �۽�
    rec_data = TWI_Read_Data(); // �����ͼ���
    TWI_Stop();             // STOP ��ȣ �۽�
    return rec_data;
}

/**************************************************************/
/*   �����̺� ���ű� ��忡���� ���� ���� �Լ�(SIMPLY)   */
/**************************************************************/
         
void Init_TWI_Slaveaddr(unsigned char Slave_Addr)
{ 
     TWAR = Slave_Addr;
} 

// SLA ��Ŷ�� ���� ACK ���� �Լ�
void TWI_Slave_Match_ACK()
{ 
     TWCR = ((1<<TWINT)|(1<<TWEA) |(1<<TWEN));
     // ACK ���� ��� Ȱ��ȭ
     TWI_TransCheck_ACK(SR_SLA_ACK);  
} 
// STOP ���� ���� �� ACK ���� �Լ�
void TWI_Slave_Stop_ACK()
{ 
    TWCR = ((1<<TWINT)|(1<<TWEA) |(1<<TWEN));
     // ACK ���� ��� Ȱ��ȭ
    TWI_TransCheck_ACK(SR_STOP); 
} 
// ������ ���� �Լ� 
 unsigned char TWI_Slave_Read_Data()
{ 
    unsigned char Data; 
    TWCR = ((1<<TWINT)|(1<<TWEA) |(1<<TWEN));
     // ACK ���� ��� Ȱ��ȭ
    TWI_TransCheck_ACK(SR_DATA_ACK);  
    Data = TWDR; 
    return Data;
} 

unsigned char TWI_Slave_Receive()
{
    unsigned char Data;   
    TWI_Slave_Match_ACK();
    Data = TWI_Slave_Read_Data(); 
    TWI_Slave_Stop_ACK(); 
    return Data;    // ���� ������ ��ȯ
}

#endif
#endif