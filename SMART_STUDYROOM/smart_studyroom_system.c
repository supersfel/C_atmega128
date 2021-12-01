#include <mega128.h>
#include <delay.h>
#include <stdio.h>
#include "lcd.h"
#include "twi.h"
#include "srf02.h"
#include "Keypad.h"

#define NONE 0
#define START 1
#define INPUT_PHONE 2
#define INPUT_PHONE_INIT 3
#define CHECK_PNUM 4
#define CHECK_PNUM_INIT 5
#define EXIT_CHOOSE 6
#define PHONE_NUM_CHECK 7

unsigned char ti_Cnt_1ms;
unsigned char LCD_DelCnt_1ms;

void Timer0_Init()  //Ÿ�̸� ���ͷ�Ʈ
{
    TCCR0 = (1<<WGM01)|(1<<CS00)|(1<<CS01)|(1<<CS02);
    TCNT0 = 0x00;
    OCR0 = 100;
    TIMSK = (1<<OCIE0);
}

interrupt[TIM0_COMP] void timer0_comp(void)    //���� ī��Ʈ ����
{
    ti_Cnt_1ms++;
    LCD_DelCnt_1ms++;
}



int SRF_Run(char Sonar_Addr){    //SRF �ּҷ� ���� �޾ƿ�
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
    int t=0; //Ű�е�� ���� ���� 
    int count =0; //count ���� 
    int finalnum=0; //FND�� ������� �־��� ���� 
    int fnd[12]={0,};
    signed int angle=0; // ������� ������ ���� ���� 
    char STATE = START;                
    char user_state[3] = {'X','X','X'}; 
    int i = 0;  
    char user_pnumber[3][11];
    char user_name;
    
    DDRD |= 0x03;    
    LCD_Init();
    Timer0_Init(); 
    FND_PORT_Init(); // ��Ʈ�� ����� �ʱ� ���� 
    Init_TWI(); 
    Init_Timer1();
    delay_ms(1000);
    SREG |= 0x80;  
    
    OCR1A = 4710;
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
            
             
            /*
            LCD_Clear();
            sprintf(Message, "%03dcm", Sonar_range_1);
            LCD_Pos(0,0);
            LCD_Str(Message);
                
            sprintf(Message, "%03dcm", Sonar_range_2);
            LCD_Pos(1,0);
            LCD_Str(Message); 
            
            sprintf(Message, "%03dcm", Sonar_range_3);
            LCD_Pos(1,5);
            LCD_Str(Message); */
                
            LCD_DelCnt_1ms = 0;             
            ti_Cnt_1ms = 0;
        } 
        t= Changenum(KeyScan()); 
        if(t<11 & t>0 ) //���ڰ� ������ ���ο� ���� �����ϵ��� count�� ���� 
            {
                count++; 
                delay_ms(50);
            }
        else if(t==0 & zero_flag) //zero_flag�� ����� ��쿡�� 0���� �Է� 
            {
                count++;
                zero_flag =0; //��� 0���� �Էµ� ���°� �ȵǰ� zero_flag�� �ٽ� 0����
                delay_ms(50);
            }    
        else if(t==13) // FND ��¼��� ���¹�ư ��� 
            { 
                fnd[0]=0,fnd[1]=0,fnd[2]=0,fnd[3]=0;               
            }
        else if (t ==14)  
            {
               STATE = START;
            } 
            
        if((count%2) ==0){ //count�� ¦���϶� ���� t���� �����ϰ�
                            //�ٽ� count�� Ȧ���� ���� 
            for(i=11;i>0;i--) {       
                fnd[i] = fnd[i-1];
                delay_us(10);
            }
            fnd[0] = t;
            count++;
            delay_ms(50);
        }
        finalnum = 1000*fnd[3] + 100*fnd[2] + 10*fnd[1] + fnd[0];
        OUTFND(finalnum); //FND ���
        buzzer_play_function(t); //���ڿ� �´� �� ���
     
        switch (STATE) {
        
            case NONE: //�⺻ ����
                if (fnd[1] <=3 && fnd[1] >0 && fnd[0] == 10) {
                    user_name = fnd[1]-1;
                    STATE=INPUT_PHONE_INIT ;
                }
                if (fnd[1]==4 && fnd[0] == 10) { //Ż�� ���
                    LCD_Clear();
                    LCD_Pos(0,0);
                    LCD_Str("Choose Seat");
                    LCD_Pos(1,0);
                    if (user_state[0] == 'X') LCD_Str("1  ");
                    if (user_state[1] == 'X') LCD_Str("2  ");
                    if (user_state[2] == 'X') LCD_Str("3  ");
                    STATE=EXIT_CHOOSE ;
                }
                break;

            case START: //���ε�
                LCD_Pos(0,0);
                LCD_Str("StudyRoom  4:OUT");
                sprintf(Message, "1:%c 2:%c 3:%c", user_state[0],user_state[1],user_state[2]);
                LCD_Pos(1,0);
                LCD_Str(Message); 
                STATE = NONE;
                break;
                
            case INPUT_PHONE:
                
                if (fnd[0] == 10){
                    sprintf(user_pnumber[user_name], "%d%d%d%d%d%d%d%d%d%d%d", fnd[11],fnd[10],fnd[9],fnd[8],fnd[7],fnd[6],fnd[5],fnd[4],fnd[3],fnd[2],fnd[1]);
                    user_state[user_name] ='X';
                    STATE = CHECK_PNUM_INIT;                     
                } 
                delay_ms(10);                 
                break;         
                
            case INPUT_PHONE_INIT:
                fnd[0]=0;
                LCD_Clear();
                LCD_Pos(0,0);
                LCD_Str("Input PhoneNum") ;
                STATE = INPUT_PHONE;
                
                if (user_state[user_name] == 'O'){
                    LCD_Clear();
                    LCD_Pos(0,0);
                    LCD_Str("Someone Used");
                    delay_ms(1000);
                    STATE = START;
                }

                break; 
            case CHECK_PNUM:
                
                if (fnd[1] == 1 && fnd[0] == 10){
                    user_state[user_name] = 'O';
                    OCR1A = 3000;    
                    delay_ms(5000);
                    OCR1A = 4710;
                    STATE = START;
                    fnd[0]=0;
                }
                else if (fnd[1] == 2 && fnd[0] == 10) STATE = INPUT_PHONE_INIT;
            break;
            case CHECK_PNUM_INIT:
                LCD_Clear();
                LCD_Pos(0,0);
                LCD_Str(user_pnumber[user_name]); 
                LCD_Pos(1,0);
                LCD_Str("1:Yes  2:No");
                fnd[1] = 0;
                STATE = CHECK_PNUM;
            break;
            
            case EXIT_CHOOSE:  
            
                user_name = fnd[1]-1;
                if (fnd[1] <=3 && fnd[1] >0 && fnd[0] == 10){
                    user_name = fnd[1]-1;
                    fnd[0]=0;
                    LCD_Clear();
                    LCD_Pos(0,0);
                    LCD_Str("Input PhoneNum") ;
                    STATE = PHONE_NUM_CHECK;
                }

            break;
            case PHONE_NUM_CHECK:
            break;
        }
     
    } 
}
