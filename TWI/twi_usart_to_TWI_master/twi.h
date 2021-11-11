#ifndef _INCLUDE_TWI_H__
#define _INCDLUE_TWI_H__

// TimeOut 등을 고려한 TWI 동작에 있어 Error 처리를 하는 함수를 사용할 경우, 
// 아래와 같이 _USE_SAFTY_TWI_ 를 정의하여 사용하고, 
// Error 처리를 하지 않고 간단히 사용할 경우에는 일반적인 함수를 사용하도록 header 파일을 수정 

//#define _USE_SAFTY_TWI_

#define ExtDev_ERR_MAX_CNT 2000

// TWI Master Transmitter/Receiver Mode에서의 상태 코드     
#define TWI_START   0x08 
#define TWI_RESTART 0x10
#define MT_SLA_ACK 0x18  
#define MT_DATA_ACK 0x28 
#define MR_SLA_ACK 0x40
#define MR_DATA_ACK 0x50
#define MR_DATA_NACK 0x58

// TWI Slave Receiver Mode에서의 상태 코드  
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
    TWBR = 0x0A;        	//SCL 약 400kHz
    TWCR = (1<<TWEN);   	//TWI Enable
    TWSR = 0x00;        	//100kHz
}

#if defined(_USE_SAFTY_TWI_)
/***************************************************/
/*   마스터 송신기 모드에서의 송신 관련 함수    */
/***************************************************/

// 신호 전송 완료 검사 및 Status 확인 + Timeout Check 
// error code 0 : no error, 1 : timeout error 2 : TWI Status error

unsigned char TWI_TransCheck_ACK(unsigned char Stat)
{ 
    unsigned int ExtDev_ErrCnt = 0;
    while (!(TWCR & (1<<TWINT)))         // 패킷 전송 완료될 때 까지 wait
    { 
        if(ExtDev_ErrCnt++ > ExtDev_ERR_MAX_CNT){ return 1; }
    }      

    if ((TWSR & 0xf8) != Stat)return 2;  // 전송 검사(ACK) : error시 2 반환
    else return 0;       
}

// START 전송 
unsigned char TWI_Start()
{
    TWCR = ((1<<TWINT) | (1<<TWSTA) | (1<<TWEN));   // START 신호 보내기
    // while (TWCR & (1<<TWINT)) == 0x00);  // START 신호 전송 완료될 때 까지 wait
    return TWI_TransCheck_ACK(TWI_START);     
} 
        
// SLA+W 패킷 전송
unsigned char TWI_Write_SLAW(unsigned char Addr)
{
    TWDR = Addr;                        // SLA + W 패킷(슬레이브 주소+Write bit(Low))
    TWCR = (1<<TWINT) | (1<<TWEN);      // SLA + W 패킷 보내기       
    return TWI_TransCheck_ACK(MT_SLA_ACK); 
} 

// 데이터 패킷 전송
unsigned char TWI_Write_Data(unsigned char Data)
{
    TWDR = Data;                        // 데이터 
    TWCR = (1<<TWINT) | (1<< TWEN);     // 데이터 패킷 송신  
    return TWI_TransCheck_ACK(MT_DATA_ACK);   
} 

// STOP 전송 
void TWI_Stop()
{
    TWCR = ((1<<TWINT) | (1<<TWSTO) | (1<<TWEN));   // STOP 신호 보내기
} 

// RESTART 전송 
unsigned char TWI_Restart()
{
//    unsigned char ret_err=0;
    TWCR = ((1<<TWINT) | (1<<TWSTA) | (1<<TWEN));   // Restart 신호 보내기 
    return TWI_TransCheck_ACK(TWI_RESTART);                 
} 
                      
// Write Packet function for Master 
unsigned char TWI_Master_Transmit(unsigned char Data, unsigned char Addr)  
{
    unsigned char ret_err=0;
    ret_err = TWI_Start();      // START 신호 송신 
    if(ret_err != 0) return ret_err;  // error시 종료 
    ret_err = TWI_Write_SLAW(Addr);    // 슬레이브 주소 송신  
    if(ret_err != 0) return ret_err;    
    ret_err = TWI_Write_Data(Data);    // 데이터 송신 
    if(ret_err != 0) return ret_err;
    TWI_Stop();                 	// STOP 신호 송신
    return ret_err;		// error 코드 반환
}

/***************************************************/
/*   마스터 수신기 모드에서의 송신 관련 함수   */
/**************************************************/            
// SLA+R 패킷 전송
unsigned char TWI_Write_SLAR(unsigned char Addr)
{
//    unsigned char ret_err=0;
    TWDR = Addr|0x01;               // SLA + R 패킷(슬레이브 주소+Read bit(High))
    TWCR = (1<<TWINT) | (1<<TWEN);  // SLA + R 패킷 보내기  
    return TWI_TransCheck_ACK(MR_SLA_ACK);     
}                                

// 데이터 패킷 수신
unsigned char TWI_Read_Data(unsigned char* Data)
{   
    unsigned char ret_err=0;
    TWCR = (1<<TWINT)|(1<< TWEN);   
    ret_err = TWI_TransCheck_ACK(MR_DATA_ACK); 
    if(ret_err != 0) 
        return ret_err;     // if error, return error code         
    *Data = TWDR;           // no error, return 수신 데이터(포인터로)
    return 0;               // 정상 종료 
} 

unsigned char TWI_Read_Data_NACK(unsigned char* Data)
{   
    unsigned char ret_err=0;
    TWCR = (1<<TWINT)|(1<< TWEN);   // SLA + W 패킷 보내기  
    ret_err = TWI_TransCheck_ACK(MR_DATA_NACK); 
    *Data = TWDR;           // no error, return 수신 데이터(포인터로)
    return 0;               // 정상 종료 
} 

// Read Packet function for Master 
unsigned char TWI_Master_Receive(unsigned char Addr, unsigned char* Data)  
{
    unsigned char rec_data;
    unsigned char ret_err=0;
    ret_err = TWI_Start();            // START 신호 송신    
    if(ret_err != 0) return ret_err;  // error시 종료     
    ret_err = TWI_Write_SLAR(Addr);   // 슬레이브 주소 송신  
    if(ret_err != 0) return ret_err;  // error시 종료 
    ret_err = TWI_Read_Data(&rec_data); // 데이터수신 
    if(ret_err != 0) return ret_err;  // error시 종료 
    TWI_Stop();             // STOP 신호 송신                          
    *Data = rec_data;
    return 0;               // 전상 종
}

/*****************************************************/
/*   슬레이브 수신기 모드에서의 수신 관련 함수    */
/*****************************************************/
         
// Slave 주소 설정 함수 
void Init_TWI_Slaveaddr(unsigned char Slave_Addr)
{ 
    TWAR = Slave_Addr;
}
 
// SLA 패킷에 대한 ACK 생성 함수
unsigned char TWI_Slave_Match_ACK()
{
//    unsigned char ret_err=0; 
    TWCR = ((1<<TWINT)|(1<<TWEA) |(1<<TWEN));
    // ACK 생성 모드 활성화       
    return TWI_TransCheck_ACK(SR_SLA_ACK);  
    // 패킷 수신 완료 대기 및 SLA + W 패킷에 대한 ACK 확인  
} 

// STOP 조건 수신 및 ACK 생성 함수
unsigned char TWI_Slave_Stop_ACK()
{ 
//    unsigned char ret_err=0;
    TWCR = ((1<<TWINT)|(1<<TWEA) |(1<<TWEN));
    // ACK 생성 모드 활성화 
    return TWI_TransCheck_ACK(SR_STOP); 
    // STOP 신호 수신 대기           
} 

// 데이터 수신 함수 
unsigned char TWI_Slave_Read_Data(unsigned char* Data)      
// unsigned char* Data : 주소 값 입력 
{ 
    unsigned char ret_err=0;
    TWCR = ((1<<TWINT)|(1<<TWEA) |(1<<TWEN));
    // ACK 생성 모드 활성화        
    ret_err = TWI_TransCheck_ACK(SR_DATA_ACK);   
    if(ret_err != 0) 
        return ret_err;     // if error, return error code         
    *Data = TWDR;           // no error, return 수신 데이터  
    return 0;               // 정상 종료 
} 

// Read Packet function for Slave 
unsigned char TWI_Slave_Receive(unsigned char* Data)
{
    unsigned char ret_err=0;
    unsigned char rec_data;
    ret_err = TWI_Slave_Match_ACK();   
    if(ret_err != 0) return ret_err;  // error시 종료
    ret_err = TWI_Slave_Read_Data(&rec_data); 
    if(ret_err != 0) return ret_err;  // error시 종료    
    ret_err = TWI_Slave_Stop_ACK(); 
    if(ret_err != 0) return ret_err;  // error시 종료     
    *Data = rec_data;           // 수신 데이터 반환 
    return 0;	                // 정상 종료
}

/*****************************************************************/
/*   Master TX/RX Mixed function like EEPROM, Sonar etc    */
/*****************************************************************/       

unsigned char TWI_Master_Receive_ExDevice(unsigned char devAddr,unsigned char regAddr, unsigned char* Data)  
{
    unsigned char rec_data; 
    unsigned char ret_err=0;
    ret_err = TWI_Start();      // START 신호 송신    
    if(ret_err != 0) return ret_err;  // error시 종료 
    ret_err = TWI_Write_SLAW(devAddr);    // 슬레이브 주소 송신
    if(ret_err != 0) return ret_err;  // error시 종료 
    ret_err = TWI_Write_Data(regAddr);    // 레지스터주소 송신  
    if(ret_err != 0) return ret_err;  // error시 종료             
    ret_err = TWI_Restart();              // Restart 송신 
    if(ret_err != 0) return ret_err;  // error시 종료     
    ret_err = TWI_Write_SLAR(devAddr);    // 슬레이브 레지스터 주소 송신 
    if(ret_err != 0) return ret_err;  // error시 종료        

    ret_err = TWI_Read_Data_NACK(&rec_data); // 레지스터 데이터 수신(주소 전달)      
    if(ret_err != 0) return ret_err;  // error시 종료      
    TWI_Stop();                 // STOP 신호 송신
    *Data = rec_data; 
    return 0;
}

#else 		// Not _USE_SAFTY_TWI_

/**************************************************************/
/*    마스터 송신기 모드에서의 송신 관련 함수(SIMPLY)     */
/**************************************************************/

// 신호 전송 완료 검사 및 Status 확인 + Timeout Check 
unsigned char TWI_TransCheck_ACK(unsigned char Stat)
{ 
    unsigned int ExtDev_ErrCnt = 0;
    while (!(TWCR & (1<<TWINT)));         // 패킷 전송 완료될 때 까지 wait
    { 
        if(ExtDev_ErrCnt++>ExtDev_ERR_MAX_CNT){ return 1; }
    }      
    if ((TWSR & 0xf8) != Stat) return 1;  // 전송 검사(ACK) : error시 1 반환  
    else return 0;       
}

// START 전송 
void TWI_Start()
{
    TWCR = ((1<<TWINT) | (1<<TWSTA) | (1<<TWEN));   // START 신호 보내기
    // while (TWCR & (1<<TWINT)) == 0x00);  // START 신호 전송 완료될 때 까지 wait
    TWI_TransCheck_ACK(TWI_START); 
} 
        
// SLA+W 패킷 전송
void TWI_Write_SLAW(unsigned char Addr)
{
    TWDR = Addr;                        // SLA + W 패킷(슬레이브 주소+Write bit(Low))
    TWCR = (1<<TWINT) | (1<<TWEN);      // SLA + W 패킷 보내기       
    TWI_TransCheck_ACK(MT_SLA_ACK);
} 

// 데이터 패킷 전송
void TWI_Write_Data(unsigned char Data)
{
    TWDR = Data;                        // 데이터 
    TWCR = (1<<TWINT) | (1<< TWEN);     // 데이터 패킷 송신  
    TWI_TransCheck_ACK(MT_DATA_ACK);           
} 

// STOP 전송 
void TWI_Stop()
{
    TWCR = ((1<<TWINT) | (1<<TWSTO) | (1<<TWEN));   // STOP 신호 보내기
} 

// RESTART 전송 
void TWI_Restart()
{
    TWCR = ((1<<TWINT) | (1<<TWSTA) | (1<<TWEN));   // Restart 신호 보내기 
    TWI_TransCheck_ACK(TWI_RESTART);          
} 
                      
// Write Packet function for Master 
void TWI_Master_Transmit(unsigned char Data, unsigned char Addr)  
{
    TWI_Start();      // START 신호 송신
    TWI_Write_SLAW(Addr);    // 슬레이브 주소 송신
    TWI_Write_Data(Data);    // 데이터 송신
    TWI_Stop();     // STOP 신호 송신
}

/****************************************************************/
/*     마스터 수신기 모드에서의 송신 관련 함수(SIMPLY)      */
/****************************************************************/            
// SLA+R 패킷 전송
void TWI_Write_SLAR(unsigned char Addr)
{
    TWDR = Addr|0x01;               // SLA + R 패킷(슬레이브 주소+Read bit(High))
    TWCR = (1<<TWINT) | (1<<TWEN);  // SLA + R 패킷 보내기  
    TWI_TransCheck_ACK(MR_SLA_ACK);
}                                

// 데이터 패킷 수신
unsigned char TWI_Read_Data()
{   
    TWCR = (1<<TWINT)|(1<< TWEN);   // SLA + W 패킷 보내기  
//    while (!(TWCR & (1<<TWINT)));   // 패킷 전송 완료될 때 까지 wait
    TWI_TransCheck_ACK(MR_DATA_ACK);       
    return TWDR;     
} 

// 데이터 패킷 수신 with Nack
unsigned char TWI_Read_Data_NACK()
{   
    TWCR = (1<<TWINT)|(1<< TWEN);   // SLA + W 패킷 보내기  
//   while (!(TWCR & (1<<TWINT)));   // 패킷 전송 완료될 때 까지 wait
    TWI_TransCheck_ACK(MR_DATA_NACK);       
    return TWDR;     
} 

// Read Packet function for Master 
unsigned char TWI_Master_Receive(unsigned char Addr)  
{
    unsigned char rec_data;
    TWI_Start();            // START 신호 송신
    TWI_Write_SLAR(Addr);   // 슬레이브 주소 송신
    rec_data = TWI_Read_Data(); // 데이터수신
    TWI_Stop();             // STOP 신호 송신
    return rec_data;
}

/**************************************************************/
/*   슬레이브 수신기 모드에서의 수신 관련 함수(SIMPLY)   */
/**************************************************************/
         
void Init_TWI_Slaveaddr(unsigned char Slave_Addr)
{ 
     TWAR = Slave_Addr;
} 

// SLA 패킷에 대한 ACK 생성 함수
void TWI_Slave_Match_ACK()
{ 
     TWCR = ((1<<TWINT)|(1<<TWEA) |(1<<TWEN));
     // ACK 생성 모드 활성화
     TWI_TransCheck_ACK(SR_SLA_ACK);  
} 
// STOP 조건 수신 및 ACK 생성 함수
void TWI_Slave_Stop_ACK()
{ 
    TWCR = ((1<<TWINT)|(1<<TWEA) |(1<<TWEN));
     // ACK 생성 모드 활성화
    TWI_TransCheck_ACK(SR_STOP); 
} 
// 데이터 수신 함수 
 unsigned char TWI_Slave_Read_Data()
{ 
    unsigned char Data; 
    TWCR = ((1<<TWINT)|(1<<TWEA) |(1<<TWEN));
     // ACK 생성 모드 활성화
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
    return Data;    // 읽은 데이터 반환
}

#endif
#endif