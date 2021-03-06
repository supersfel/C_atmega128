#include <mega128.h>
#include <delay.h>
#include <stdio.h>
#include "lcd.h"
#include "twi.h"
#include "srf02.h"
#include "Keypad.h"
#include "usart.h"

/*상태 정의*/
#define NONE 0
#define START 1
#define INPUT_PHONE 2
#define INPUT_PHONE_INIT 3
#define CHECK_PNUM 4
#define CHECK_PNUM_INIT 5
#define EXIT_CHOOSE 6
#define CHECK_PNUM_OUT 7
#define CHECK_PNUM_OUT_INIT 8
#define INPUT_PHONE_OUT 9
#define INPUT_PHONE_OUT_INIT 10

/*usart 정의*/
#define ENTER '\r'
#define MAXLEN 17
unsigned char str[MAXLEN], str2[MAXLEN];
unsigned char master_password[] = "1mingyu";
unsigned char open_password[] = "1opendo";
char num[3][11];

unsigned char ti_Cnt_1ms;  //초음파 센서구동을위한 cnt 
unsigned char LCD_DelCnt_1ms;
unsigned char Distance_cnt_1ms; // 시간지나면 자리비움처리를 위한 cnt
unsigned char ch=0;

interrupt [USART1_RXC] void usart1_receive(void)
{
    unsigned char i;
    
    str[ch] = UDR1;          //인터럽트 발생 시 수신된 문자를 str[ch]에 저장
   

     if(str[ch] == ENTER){
        char access_cnt = 0;
        for(i=0;i<MAXLEN;i++) str2[i] = 'a';
        for(i=0;i<MAXLEN;i++) str2[i] = str[i];
        
        str[ch-1] = 0x00;   
        ch = 0;             //문자열 초기화 
         
        for (i=1;i<7;i++) {
            if (master_password[i] == str2[i]) access_cnt ++; 
        }
        if (access_cnt == 6) {
            puts_USART1("\n first seat : \n");
            for(i=0;i<11;i++)  putch_USART1(num[0][i]);
            puts_USART1("\n Second seat : \n");
            for(i=0;i<11;i++)  putch_USART1(num[1][i]);
            puts_USART1("\n Third seat : \n");
            for(i=0;i<11;i++)  putch_USART1(num[2][i]); 
        }
        
        access_cnt = 0;
         for (i=1;i<7;i++) {
            if (master_password[i] == str2[i]) access_cnt ++; 
        }
        if (access_cnt == 6) {
            OCR1A = 3000;
            LCD_Clear();
            LCD_Pos(0,0);
            LCD_Str("Door Open") ;    
            delay_ms(5000);
            OCR1A = 4710;
            STATE = START;
            fnd[0]=0; 
        }
        
        
               
        for(i=0;i<MAXLEN;i++) str2[i] = 0;
     }
     else ch++;
     delay_ms(10);
        
       
    
    if ( ch >= MAXLEN) ch = 0;    //최대 글자 이상일때 에러모드

}


void Timer0_Init()  //초음파 센서구동 타이머 인터럽트
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
    unsigned int Sonar_range[3]={0,};   
    char Message[40];
    int readCnt = 0;  
    int t=0; //키패드로 받은 숫자 
    int count =0; //count 변수 
    int finalnum=0; //FND에 출력으로 넣어줄 변수 
    int fnd[12]={0,};
    signed int angle=0; // 서브모터 각도로 넣을 변수 
    char STATE = START;                
    char user_state[3] = {'X','X','X'}; 
    int i = 0;  
    char user_pnumber[3][11]; //유저 비밀번호 저장 
    char check_pnumber[11]; //비밀번호 일치확인을위한 공간
    char user_name; //1~3번중 어느좌석 유저를 가르키는지 저장
    
    char empty_cnt[3]={0,};
    
    DDRD |= 0x03;
      
    LCD_Init();
    Timer0_Init(); 
    FND_PORT_Init(); // 포트들 입출력 초기 설정 
    Init_TWI(); 
    Init_Timer1();
    delay_ms(1000);
    SREG |= 0x80;  
    
    OCR1A =4710;
    startRanging(Sonar_Addr);
    ti_Cnt_1ms = 0; 
    LCD_DelCnt_1ms = 0; 
     
    Init_USART1_IntCon(0,RX_Int); 
    DDRD.7 =1;
    
    
    
    while(1)
    {     
        if(ti_Cnt_1ms > 100)  //2초에 한번정도 한센서씩 갱신
        {               
            if (Sonar_Addr == 0xE0){
                Sonar_Addr = 0xEC;
                startRanging(Sonar_Addr);
                Sonar_range[0] = SRF_Run(Sonar_Addr);
                
                
            } 
            else if (Sonar_Addr == 0xEC) {
                Sonar_Addr = 0xE2;
                startRanging(Sonar_Addr);
                Sonar_range[1] = SRF_Run(Sonar_Addr);
                
            }
            else{
                Sonar_Addr = 0xE0;
                startRanging(Sonar_Addr);
                Sonar_range[2] = SRF_Run(Sonar_Addr);
                
            }
            
             
            /*   초음파 확 인 *//*
            LCD_Clear();
            sprintf(Message, "%03dcm", Sonar_range[0]);
            LCD_Pos(0,0);
            LCD_Str(Message);
                
            sprintf(Message, "%03dcm", Sonar_range[1]);
            LCD_Pos(1,0);
            LCD_Str(Message); 
            
            sprintf(Message, "%03dcm", Sonar_range[2]);
            LCD_Pos(1,5);
            LCD_Str(Message); */ 
            
            /* 자리비움 처리 */
            for (i=0;i<3;i++){
                if ( (Sonar_range[i] > 30)&&(user_state[i] == 'O') ){
                   empty_cnt[i] ++;
                    /*sprintf(Message, "%03dcm", empty_cnt[i]); 
                    LCD_Clear();
                    LCD_Pos(0,0);
                    LCD_Str(Message);  */ //cnt확인용 
                }
                else empty_cnt[i] =0;
            
                if (empty_cnt[i] > 15 ) {
                 user_state[i] ='E';
                 if (STATE == NONE ) STATE = START;
                }
            }
            
            
                
            LCD_DelCnt_1ms = 0;             
            ti_Cnt_1ms = 0;
        }
        
        
        /*
        if(PIND.7 == 1){ 
           LCD_Clear();
              LCD_Pos(0,0); // 문자열 위치 0행 1열 지정
              LCD_Str("Warning....."); // 문자열 str을 LCD 첫번째 라인에 출력
              delay_us(10);
              LCD_Pos(1,0); // 문자열 위치 1행 1열 지정
               LCD_Str("Fire!!!    "); // 문자열 str을 LCD 두번째 라인에 출력 
             LCD_Pos(1,0);
              delay_us(10); 
                
            while(1)
            {
                    
                 for(i=0;i<20;i++){    //사이렌 소리
                  Buzzer_play(Sol/2);
                  delay_ms(10);
                }  
                delay_ms(10);
                for(i=0;i<20;i++){
                    Buzzer_play(Re/2); 
                    delay_ms(10);
                }  
            } 
            
        }
            else{
               
        }*/
        
        
        
         
        t= Changenum(KeyScan()); 
        if(t<11 & t>0 ) //숫자가 눌리면 새로운 값을 저장하도록 count값 설정 
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
        else if (t ==14)  
            {
               STATE = START;
            } 
            
        if((count%2) ==0){ //count가 짝수일때 들어온 t값을 저장하고
                            //다시 count를 홀수로 만듬 
            for(i=11;i>0;i--) {       
                fnd[i] = fnd[i-1];
                delay_us(10);
            }
            fnd[0] = t;
            count++;
            delay_ms(50);
        }
        finalnum = 1000*fnd[3] + 100*fnd[2] + 10*fnd[1] + fnd[0];
        OUTFND(finalnum); //FND 출력
        buzzer_play_function(t); //숫자에 맞는 음 출력
        
        
        
       
        
        
        switch (STATE) {  //LCD처
        
            case NONE: //기본 상태
                if (fnd[1] <=3 && fnd[1] >0 && fnd[0] == 10) {
                    user_name = fnd[1]-1;
                    STATE=INPUT_PHONE_INIT ;
                }
                if (fnd[1]==4 && fnd[0] == 10) { //탈출 모드
                    LCD_Clear();
                    LCD_Pos(0,0);
                    LCD_Str("Choose Seat");
                    LCD_Pos(1,0);
                    if (user_state[0] == 'O') LCD_Str("1  ");
                    if (user_state[1] == 'O') LCD_Str("2  ");
                    if (user_state[2] == 'O') LCD_Str("3  ");
                    STATE=EXIT_CHOOSE ;
                }
                break;

            case START: //업로드
                LCD_Pos(0,0);
                LCD_Str("StudyRoom  4:OUT");
                sprintf(Message, "1:%c 2:%c 3:%c", user_state[0],user_state[1],user_state[2]);
                LCD_Pos(1,0);
                LCD_Str(Message); 
                STATE = NONE;
                break;
                
            case INPUT_PHONE: //입장 : 폰번호 입력
                
                if (fnd[0] == 10){
                    sprintf(user_pnumber[user_name], "%d%d%d%d%d%d%d%d%d%d%d", fnd[11],fnd[10],fnd[9],fnd[8],fnd[7],fnd[6],fnd[5],fnd[4],fnd[3],fnd[2],fnd[1]);
                    user_state[user_name] ='X';
                    for(i=0;i<11;i++){
                        num[user_name][i] = user_pnumber[user_name][i];
                    }
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
                    LCD_Clear();
                    LCD_Pos(0,0);
                    LCD_Str("Door Open") ;    
                    delay_ms(5000);
                    OCR1A = 4710;
                    STATE = START;
                    fnd[0]=0;     
                    user_name = 4;
                }
                else if (fnd[1] == 2 && fnd[0] == 10) STATE = INPUT_PHONE_INIT;
            break;
            case CHECK_PNUM_INIT:
                fnd[0]=0;
                LCD_Clear();
                LCD_Pos(0,0);
                LCD_Str(user_pnumber[user_name]); 
                LCD_Pos(1,0);
                LCD_Str("1:Yes  2:No");
                fnd[1] = 0;
                STATE = CHECK_PNUM;
            break;
            
            case EXIT_CHOOSE:  //퇴장 번호 선  
            
                user_name = fnd[1]-1;
                if (fnd[1] <=3 && fnd[1] >0 && fnd[0] == 10){
                    
                    STATE = INPUT_PHONE_OUT_INIT;
                    
                    if (user_state[user_name] != 'O'){
                        LCD_Clear();
                        LCD_Pos(0,0);
                        LCD_Str("Empty Seat");
                        delay_ms(1000);
                        fnd[0]=0;
                        STATE = START;
                    }
                }
                
                

            break;
             case CHECK_PNUM_OUT_INIT: 
                 fnd[0]=0;
                 fnd[1] = 0;
                 LCD_Clear();
                 LCD_Pos(0,0);
                 LCD_Str(check_pnumber); 
                 LCD_Pos(1,0);
                 
                 LCD_Str("1:Yes  2:No");
                 STATE = CHECK_PNUM_OUT;
               
                
            break;
            case CHECK_PNUM_OUT:   //비밀번호 일치시 탈출
            
                 if (fnd[1] == 1 && fnd[0] == 10){
                   int cnt=0;
                   for(i=0;i<11;i++){
                      if(num[user_name][i] == check_pnumber[i] ) cnt ++;  } 
                   
                    if (cnt == 11 ){  //비밀번호 일치
                       LCD_Clear();
                       LCD_Pos(0,0);
                       LCD_Str("User Check") ; 
                       LCD_Pos(1,0);
                       LCD_Str("Good Bye") ;
                       OCR1A = 3000;
                        delay_ms(5000);
                        OCR1A = 4710;    
                      user_state[user_name] ='X';
                      STATE = START;
                      fnd[0] = 0;
                    }
                    else{ //비밀번호 불일치
                      LCD_Clear();
                      LCD_Pos(0,0);
                      LCD_Str("Wrong Password") ; 
                      delay_ms(2000);
                      fnd[0] = 0;
                      STATE = START;
                    } 
                }
                else if (fnd[1] == 2 && fnd[0] == 10) STATE = INPUT_PHONE_OUT_INIT;
                
                
            break;
            case INPUT_PHONE_OUT: //퇴장 : 폰번호 입력
                
                if (fnd[0] == 10){
                    sprintf(check_pnumber, "%d%d%d%d%d%d%d%d%d%d%d", fnd[11],fnd[10],fnd[9],fnd[8],fnd[7],fnd[6],fnd[5],fnd[4],fnd[3],fnd[2],fnd[1]); 
                    
                    STATE = CHECK_PNUM_OUT_INIT;                     
                } 
                delay_ms(10);                 
                break;  
             
             case INPUT_PHONE_OUT_INIT: //퇴장 : 폰번호 입력
                
                
                fnd[0]=0;
                LCD_Clear();
                LCD_Pos(0,0);
                LCD_Str("Input PhoneNum") ;
                STATE = INPUT_PHONE_OUT;            
                break;         
                
           
        }
     
    } 
}