#include <mega128.h>
#include <delay.h>
#include <stdio.h>
#include "lcd.h"
#include "twi.h"
#include "srf02.h"
#include "Keypad.h"

unsigned char ti_Cnt_1ms;
unsigned char LCD_DelCnt_1ms;

void Timer0_Init()  //타이머 인터럽트
{
    TCCR0 = (1<<WGM01)|(1<<CS00)|(1<<CS01)|(1<<CS02);
    TCNT0 = 0x00;
    OCR0 = 100;
    TIMSK = (1<<OCIE0);
}

interrupt[TIM0_COMP] void timer0_comp(void)    //실제 카운트 증가
{
    ti_Cnt_1ms++;
    LCD_DelCnt_1ms++;
}



int SRF_Run(char Sonar_Addr){    //SRF 주소로 값을 받아옴
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
    unsigned int Sonar_range_1 = 0,Sonar_range_2 = 0,Sonar_range_3 = 0;   
    char Message[40];
    int readCnt = 0;  
    int t=0; //키패드로 받은 숫자 
    int count =0; //count 변수 
    int finalnum=0; //FND에 출력으로 넣어줄 변수 
    int fnd[4]={0,0,0,0};
    signed int angle=0; // 서브모터 각도로 넣을 변수 
    
    DDRD |= 0x03;    
    LCD_Init();
    Timer0_Init(); 
    FND_PORT_Init(); // 포트들 입출력 초기 설정 
    Init_TWI();
    delay_ms(1000);
    SREG |= 0x80;  
    
    
    startRanging(Sonar_Addr);
    ti_Cnt_1ms = 0; 
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
         
       
        
        t= Changenum(KeyScan()); 
        if(t<10 & t>0 ) //숫자가 눌리면 새로운 값을 저장하도록 count값 설정 
            {
                count++; 
                delay_ms(50);
            }
        else if(t==0 & zero_flag) //zero_flag가 실행된 경우에만 0으로 입력 
            {
                count++;
                zero_flag =0; //계속 0으로 입력된 상태가 안되게 zero_flag를 다시 0으로
                delay_ms(50);
            }    
        else if(t==13) // FND 출력숫자 리셋버튼 기능 
            { 
                fnd[0]=0,fnd[1]=0,fnd[2]=0,fnd[3]=0;               
            }
        else if (t ==14) //현재 FND의 숫자각도만큼 모터각도 변경 
            {
                    angle = finalnum%360;
                if(angle >= 180){ //예제 모터는 90도까지만되나 180도 이상은
                    angle -= 360; //-각도로 생각 
                }
                OCR1A = 2765 + 10.249*angle; //1도단위까지도 입력 가능 
            } 
            
        if((count%2) ==0){ //count가 짝수일때 들어온 t값을 저장하고
                            //다시 count를 홀수로 만듬 
            fnd[3] = fnd[2];
            delay_ms(50);
            fnd[2] = fnd[1];
            delay_ms(50);
            fnd[1] = fnd[0];
            delay_ms(50);
            fnd[0] = t;
            count++;
            delay_ms(50);
        }
        finalnum = 1000*fnd[3] + 100*fnd[2] + 10*fnd[1] + fnd[0];
        
        OUTFND(finalnum); //FND 출력
        buzzer_play_function(t); //숫자에 맞는 음 출력
        
     
     
     
     
    } 
}
