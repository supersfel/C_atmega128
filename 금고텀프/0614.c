#include <mega128.h>
#include <delay.h>
#include <lcd.h>

#define Do  1908 // 262Hz (3817us) 1908us
#define Re  1700 // 294Hz (3401us) 1701us
#define Mi  1515 // 330Hz (3030us) 1515us
#define Fa  1432 // 349Hz (2865us) 1433us
#define Sol 1275 // 370Hz (2703us) 1351us
#define La  1136 // 440Hz (2273us) 1136us
#define Si  1012 // 494Hz (2024us) 1012us
#define MAXLEN 17 // LCD 16 문자 + \n
#define ENTER '\n'

unsigned char buffer_count=0;
unsigned char str[MAXLEN]={0,};          // 임시로 수신된 문자를 저장하기 위한 공간
char zero_flag=0;                        // 0을 눌렀을때만 FND가 바뀌도록 도와주는 flag
char interrupt_flag=0;                   // 인터럽트 버튼을 눌렀을때 새비밀번호를 저장하거나 세팅하거나 판별하게하는 flag
bit master_flag=0;                       // 마스터모드에서 비밀번호 일치시 사이렌에서 탈출하게하는 flag
int fnd[14]={0,};                        // 키패드에서 눌린값을 저장하는 배열
int password[14] = {0,9,8,7,6,5,4,3,2,1,0,0,0,0}; //초기 비밀번호 
char* master_password = "2017142037";    // 마스터모드 비밀번호(학번)
 
unsigned char Port_char[] ={0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xd8,
                            0x80,0x90 ,0x88,0x83,0xc4, 0xa1,0x84,0x8e};
unsigned int Port_fnd[] ={0x1f,0x2f,0x4f,0x8f};  //FND 값 설정

interrupt [USART1_RXC] void usart1_receive(void)   // usart인터럽트
{
    if(master_flag)    //마스터모드에서만 동작하게 설정
            { 
                str[buffer_count] = UDR1;
                if(buffer_count >= MAXLEN)
                buffer_count = 0;
                else
                buffer_count++;
    
    
                LCD_Clear();
                LCD_Pos(0,0); 
                LCD_Str("MASTER MODE    "); 
                delay_us(1);
                LCD_Pos(1,0); 
                LCD_Str("**************"); 
                LCD_Pos(1,0);
                delay_us(1);           
                LCD_Str(str);
            
            }
}

void Init_USART1_IntCon(void)
{
// RXCIE1=1(수신 인터럽트 허가), RXEN0=1(수신 허가), TXEN0 = 1(송신 허가)
UCSR1B = (1<<RXCIE1)| (1<<RXEN1) | (1 <<TXEN1);
UBRR1L = 0x07; // 115200bps 보오 레이트 설정
SREG |= 0x80; // 전체 인터럽트 허가
}


void PORT_Init(void) 
{
    DDRE=0xF0;     //FND 출력을 위한 설정
    DDRF=0xFF;     //FND 출력을 위한 설정
    DDRC=0x0F;     //키패드를 위한 설정 
    DDRG=0x10;     //부저 출력을 위한 설정 
    DDRB=0x20;     //서브모터 출력을 위한 설정 
    
    EIMSK = 0x01;    // 외부인터럽트를 0~4까지 선택
    EICRA = 0xaf;    //INT0,1은 상승에지 INT2,3 하강에지로 선택
    SREG |= 0x80;    //전체인터럽트 허가
    DDRD |= 0x00;    //D를 입력으로 받음(스위치) 
    
  
    
    PORTC=0xFF;
}



char Num_to_Str(int num)   //숫자를 문자열로 바꿔주는 함수
{
    char str;
    switch(num)
    {
        case 0 :
            str = '0';
        break;
        case 1 :
            str = '1';
        break;
         case 2 :
            str = '2';
        break;
         case 3 :
            str = '3';
        break;
         case 4 :
            str = '4';
        break;
         case 5 :
            str = '5';
        break;
         case 6 :
            str = '6';
        break;
         case 7 :
            str = '7';
        break;
         case 8 :
            str = '8';
        break;
         case 9 :
            str = '9'; 
        break; 
         dafault:
        break;
    }
        return str;

}

void Init_Timer1(void)
{ 

    TCCR1A = (1<<COM1A1) | (1<<WGM11); 
    TCCR1B = (1<<WGM13) | (1<<WGM12) | (1<<CS11); 
    TCNT1 = 0x00;
    ICR1 = 36864-1; // TOP 값 : 36864-> 20ms(0.542us X 36864), 0~36863 
    OCR1A =2765 ; // 초기 시작 위치 0도
    TIMSK |= (1<<OCIE1A); // Output Compare Match Interrupt 허가
}

interrupt [TIM1_COMPA] void compare(void)
{
    #asm("nop");          //비교일치 인터럽트 구문 
}

void myDelay_us(unsigned int delay)

{
    unsigned int loop; 
    for(loop=0; loop<delay; loop++)
        delay_us(1);
}


void Buzzer_play(unsigned int delay)
{
    unsigned int loop;                            
    unsigned char Play_Tim=0;
    Play_Tim = 10000/delay;
    for(loop=0; loop<Play_Tim; loop++)
    {
        PORTG |= 1<<4;      //buzzer off, PORTG의 4번 핀 on(out 1)
        myDelay_us(delay);
        PORTG &= ~(1<<4);   //buzzer on, PORTG의 4번 핀 off(out 0)
        myDelay_us(delay);
    }
}
 
unsigned char KeyScan(void)  //키패드를 받는 함수 
{   
    unsigned int key_scan_line = 0xFE;
    unsigned char key_scan_loop =0, getPinData =0;
    unsigned int key_num =0;
    
    for(key_scan_loop =0; key_scan_loop <4;key_scan_loop++)
    {
        PORTC = key_scan_line;
        delay_us(1);
        
        getPinData = PINC & 0xF0;
        
        if(getPinData != 0x00)
        {
            switch(getPinData)
            {
                case 0x10:
                        key_num = key_scan_loop * 4 +1 ;
                break;
                case 0x20:
                        key_num = key_scan_loop * 4 +2 ;
                break;
                case 0x40:
                        key_num = key_scan_loop * 4 +3 ;
                break;
                case 0x80:
                        key_num = key_scan_loop * 4 +4 ;
                break;
            
            }
           
            return key_num;
            
            
        }
    key_scan_line = (key_scan_line <<1);    
    }

}         
 unsigned char Changenum(unsigned char num)  //키패드로 받아들어온 숫자를 키패드
                                             //상황에 맞게 변환 
{

     unsigned char return_num=0;
     if(num ==0){
      return_num =0;
     }
     else if (num%4 ==0){                      // 1 2 3   13
      return_num = 12 + num/4;                 // 4 5 6   14
                                               // 7 8 9   15
     }                                         // 10 0 12 16
     else if( num/4 ==0){                      // 위처럼 인식되게 변환  
      return_num = (4*(num/4) +num%4)  ;
      
     }
     else if( num/4 ==1){
      return_num = (4*(num/4) +num%4) -1 ;
      
     }
     else if( num/4 ==2){
      return_num = (4*(num/4) +num%4) -2 ;
      
     }
     else if( num/4 ==3){
      return_num = (4*(num/4) +num%4) -3 ;
      
     }
     
     if (return_num ==11){
     return_num =0;
     
     zero_flag =1;   // 아무것도 누르지 않을때도 0이 저장되기에 
                     // 0을 누를때 zero_flag동작되게 설정



    }    
     return return_num;
}








void OUTFND( int FND[] ) //fnd를 출력하는 함수
{
    int i=0;
    for(i=0;i<4;i++ )
    {
   
   
          PORTE = Port_fnd[i];
          PORTF = Port_char[FND[i]];         
          delay_ms(10);
          
          
          
     }
}



interrupt [EXT_INT0] void ext_int0_isr(void)    //인터럽트 내용
{
    int i=0;
    delay_ms(50);
     if(interrupt_flag ==0)  //flag가0일시 비밀번호 set상태
     {      
         delay_ms(10);
         LCD_Comm(0x0f); // 모든 기능을 ON 한다. 
         LCD_delay(2);// 1.64㎳ 이상을 기다림

                
         LCD_Pos(0,0); // 문자열 위치 0행 1열 지정
         LCD_Str("PASSWORD SET"); // 문자열 str을 LCD 첫번째 라인에 출력
         delay_us(10);
         LCD_Pos(1,0); // 문자열 위치 1행 1열 지정
         LCD_Str("--------------"); // 문자열 str을 LCD 두번째 라인에 출력 
         LCD_Pos(1,0);
         delay_us(10);
        
         
         
     
         for(i=0;i<14;i++) {
             fnd[i] = 0; }
         
         interrupt_flag =1;
     
     }    
     else    //들어온 비밀번호를 저장
     {
          
         
         LCD_Pos(0,0); // 문자열 위치 0행 1열 지정
         LCD_Str("PASSWORD SET"); // 문자열 str을 LCD 첫번째 라인에 출력
         delay_us(10);
         LCD_Pos(1,0); // 문자열 위치 1행 1열 지정
         LCD_Str(" -SUCCESS-    "); // 문자열 str을 LCD 두번째 라인에 출력 
         LCD_Pos(1,0);
         delay_us(10);
         
         delay_ms(500);
         LCD_Clear();
     
         
         Buzzer_play(Do);
         delay_ms(500);
         Buzzer_play(Re);
         delay_ms(500);
         Buzzer_play(Mi);
         
          
                     
         for(i=0;i<14;i++)
        {  
          password[i] = fnd[i];    //새 비밀번호를 저장
        }
        
        interrupt_flag = 0;   
      
     }   
    
}
void putch_USART(char data)   //pc에 문자를 출력
{
    while(!(UCSR1A & (1<<UDRE1)));     
    UDR1 = data;
}

void puts_USART(char *str)  //pc에 문자열을 출력
{
    while(*str!= 0)
    {
        putch_USART(*str);
        str++;
    }
}




void main (void)
{
   int key_num=0;        //키패드로 받은 숫자 
   char count =0;        //count 변수_fnd에서 숫자받을때 사용  
   char p_count=0;       //password 일치확인할때 사용
   char Rock_count =0;   //3번이상 틀릴때 rock되게 사용
   char master_count=1;  //위험감지시 사이렌모드로 동작하게 사용
   int star_count=0;     //*이 3초이상 눌리는지 감지할때 사용
   int mastermode_count=0; //mastermode에 들어갔는지 감지에 사용
   int i=0;   //for문을 돌리기 위한 변수
        
    unsigned char  loop_count=0; 
    unsigned char  str_password[] = "PASSWORD        "; 
    unsigned char  str_star[] = "************** ";
     
         
   Init_USART1_IntCon();      
   Init_Timer1();  // 타이머 초기설정 
   PORT_Init();    // 포트들 입출력 초기 설정               
   LCD_PORT_Init; // LCD 출력 포트 설정
   LCD_Init(); // LCD 초기화
   OCR1A = 4710; //모터 초기설정(잠김)   
   
   
   
   while(1) 
   {
               
   
             key_num= Changenum(KeyScan());  //keyscan으로 받은 값을 변환하여 저장 
          
             if(key_num<10 & key_num>0 )   //숫자가 눌리면 새로운 값을 저장하도록 count값 설정       
          {
            count++;      
            delay_ms(50);
            
          }
          else if(key_num==0 & zero_flag)   //zero_flag가 실행된 경우에만 0으로 입력 
          {
            count++;
            delay_ms(50);
          } 
           else if(key_num == 10 )
           {
                for(i=0;i<14;i++)   //비밀번호 일치하는지 확인
                {
                    if(fnd[i] == password[i])
                    {  
                        p_count ++;
                    }
                    else
                    {
                       p_count =0;  
                    }               
                                
                }   
                
                if(p_count == 14)  //비밀번호 일치시
                {
                    LCD_Pos(0,0); // 문자열 위치 0행 1열 지정
                    LCD_Str("DOOR OPEN    "); // 문자열 str을 LCD 첫번째 라인에 출력
                    delay_us(10);
                    LCD_Pos(1,0); // 문자열 위치 1행 1열 지정
                    LCD_Str("              "); // 문자열 str을 LCD 두번째 라인에 출력 
                    LCD_Pos(1,0); 
                   
                     Buzzer_play(Do);
                     delay_ms(500);
                     Buzzer_play(Mi);
                      delay_ms(500);
                     Buzzer_play(Sol);
                      delay_ms(500);
                     Buzzer_play(Do/2);
                     delay_ms(500);
                     LCD_Clear();
                    
                     OCR1A = 3000;    //모터 해제 
                     for(i=0;i<14;i++) {
                       fnd[i] = 0; }  //받은 fnd값 초기화
                     
                    p_count=0;
                } 
                else  //비밀번호 오류시
                 {
                    LCD_Pos(0,0); // 문자열 위치 0행 1열 지정
                    LCD_Str(str_password); // 문자열 str을 LCD 첫번째 라인에 출력
                    delay_us(10);
                    LCD_Pos(1,0); // 문자열 위치 1행 1열 지정
                    LCD_Str(" error.......   "); // 문자열 str을 LCD 두번째 라인에 출력 
                    LCD_Pos(1,0);
                    
                   
                    
                     Buzzer_play(La);
                     delay_ms(500);
                     Buzzer_play(La);
                     delay_ms(500);
                     Buzzer_play(La);
                     delay_ms(500);
                    LCD_Clear();
                     
                     
                     for(i=0;i<14;i++) {
                       fnd[i] = 0; }
                      
                    p_count=0;
                    Rock_count ++;    //오류시 Rock_count가 증가함
                                         
                }
                
                
                 
                 
                 
            }
            
            
           else if(key_num==12)   //#버튼에 해당
            {
                LCD_Comm(0x0f); // 모든 기능을 ON 한다. 
                LCD_delay(2);// 1.64㎳ 이상을 기다림

            
                LCD_Pos(0,0); // 문자열 위치 0행 1열 지정
                LCD_Str(str_password); // 문자열 str을 LCD 첫번째 라인에 출력
                delay_us(10);
                LCD_Pos(1,0); // 문자열 위치 1행 1열 지정
                LCD_Str(str_star); // 문자열 str을 LCD 두번째 라인에 출력 
                LCD_Pos(1,0);
                delay_us(10); 
                
                for(i=0;i<14;i++)  //fnd값 초기화
                {
                fnd[i] =0;                
                }
                
                for(i=0;i<17;i++)
                {
                    str[i] = '*';  //마스터모드에서 잘못 입력하였을때 사용
                }
                buffer_count=0;
                master_flag=0;           
                
           }
           else if(key_num==13) // FND 출력숫자 리셋버튼 기능 
          { 
            for(i=0;i<14;i++)
                fnd[i] =0;
          }
          
            if((key_num)| zero_flag)
            {
                 if((count%2) ==1){   //count가 홀수일때 들어온 t값을 저장하고
                                      //다시 count를 짝수로 만듬 
                       
                        for(i=13;i>0;i--) //키패드로 입력되는 수들을 fnd배열에 저장
                        {
                            fnd[i] = fnd[i-1];
                            delay_ms(20);
                        }                     
                         
                         fnd[0] = key_num;
                       
                          
                        count++;
                        delay_ms(50); 
                            
                        LCD_Char ( Num_to_Str(key_num));//입력되면 lcd에 출력 
                           
                      } 
                       
                     
                if(zero_flag) //0이 발생시 zeroflag를 다시 0으로만들어 0을 다시 받을수 있게함
                {
                    zero_flag = 0;
                }
              }
            
            
                 
             
                if(PINC.4 && PINC.6)   
                {
                    while(PINC.4 && PINC.6){  // *과 #을 동시에 누른 상태
                         delay_ms(10);
                         mastermode_count++;  //초 카운트
                        
                         if(mastermode_count >  300)  //3초 카운트
                             {
                                LCD_Pos(0,0); // 문자열 위치 0행 1열 지정
                                LCD_Str("MASTER MODE    "); // 문자열 str을 LCD 첫번째 라인에 출력
                                delay_us(10);
                                LCD_Pos(1,0); // 문자열 위치 1행 1열 지정
                                LCD_Str(str_star); // 문자열 str을 LCD 두번째 라인에 출력 
                                LCD_Pos(1,0);
                                delay_us(10);
                                  
                                 mastermode_count =0;
                                 master_flag=1;  //마스터 모드 들어감
                              }
                             
                    }
                }
                else
                {                    
            
                    while(PINC.4){    // *만 꾹 누르고 있는 상태
                             delay_ms(10);
                             star_count++;
                             if(star_count > 300)
                                 {
                                    Buzzer_play(Sol);
                                     delay_ms(500);
                                     Buzzer_play(Fa);
                                      delay_ms(500);
                                     Buzzer_play(Mi);
                                      delay_ms(500);
                                     Buzzer_play(Re);
                                     
                                      OCR1A = 4710;  // 금고 잠금
                                      
                                     star_count =0;
                                 }
                    } 
                }  
                                
            /*  
            if(PINB.7 == 1)  //진동센서 감지시
            {
                LCD_Pos(0,0); // 문자열 위치 0행 1열 지정
                LCD_Str("Warning....."); // 문자열 str을 LCD 첫번째 라인에 출력
                delay_us(10);
                LCD_Pos(1,0); // 문자열 위치 1행 1열 지정
                LCD_Str(" stealing!!!    "); // 문자열 str을 LCD 두번째 라인에 출력 
                LCD_Pos(1,0);
                delay_us(10);
                master_count = 1;
                
                
                while(master_count) // 마스터모드에서 해제하지 않으면 무한 반복
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
                    
                    
                    while(PINC.4 && PINC.6){ //사이렌모드에서 마스터모드로 접근
                         delay_ms(10);
                         
                         mastermode_count++;
                         if(mastermode_count >  300)
                             {
                                LCD_Pos(0,0); // 문자열 위치 0행 1열 지정
                                LCD_Str("MASTER MODE    "); // 문자열 str을 LCD 첫번째 라인에 출력
                                delay_us(10);
                                LCD_Pos(1,0); // 문자열 위치 1행 1열 지정
                                LCD_Str(str_star); // 문자열 str을 LCD 두번째 라인에 출력 
                                LCD_Pos(1,0);
                                delay_us(10);
                                
                                puts_USART("Enter Password  \n");
                                puts_USART("-->  \n");
                                  
                                buffer_count=0;
                                 mastermode_count =0;
                                 master_flag=1;
                                 
                             }
                         } 
                    for(i=0;i<10;i++)
                    {
                        if(str[i] == master_password[i]) //pc에서 받은 str과 학번을 비교
                        {  
                            p_count ++;
                        }
                        else
                        {
                           p_count =0;  
                        }               
                                    
                    }   
                
                    if(p_count == 10)  // 비밀번호 일치시
                    {
                        master_count =0; //사이렌 탈출
                        master_flag=0;   //마스터모드 해제
                        p_count =0;      //비밀번호 카운트 초기화
                        delay_ms(500);
                        LCD_Clear();
                    } 
                }
                  
            }
            */
            
             
            if(Rock_count >= 3) //에러 3번이상 발생시
            {                       
                LCD_Pos(0,0); // 문자열 위치 0행 1열 지정
                LCD_Str("Warning....."); // 문자열 str을 LCD 첫번째 라인에 출력
                delay_us(10);
                LCD_Pos(1,0); // 문자열 위치 1행 1열 지정
                LCD_Str(" if.theft         "); // 문자열 str을 LCD 두번째 라인에 출력 
                LCD_Pos(1,0);
                delay_us(10);   
                master_count = 1;
                 
                while(master_count)   //이하 내용은 진동센서와 동일
                {                     // 단 Rock_count초기화 하는기능이 마지막에 추가
                        for(i=0;i<20;i++){
                          Buzzer_play(Sol/2);
                          delay_ms(10);
                        }  
                        delay_ms(10);
                        for(i=0;i<20;i++){
                            Buzzer_play(Re/2); 
                            delay_ms(10);
                        }
                         
                    while(PINC.4 && PINC.6){ 
                         delay_ms(10);
                         
                         
                         mastermode_count++;
                        
                         if(mastermode_count >  300)
                             {
                                LCD_Pos(0,0); // 문자열 위치 0행 1열 지정
                                LCD_Str("MASTER MODE    "); // 문자열 str을 LCD 첫번째 라인에 출력
                                delay_us(10);
                                LCD_Pos(1,0); // 문자열 위치 1행 1열 지정
                                LCD_Str(str_star); // 문자열 str을 LCD 두번째 라인에 출력 
                                LCD_Pos(1,0);
                                delay_us(10);
                                
                                puts_USART("Enter Password  \n");
                                puts_USART("-->  \n");
                                
                                 buffer_count=0;  
                                 mastermode_count =0;
                                 master_flag=1;
                             }
                         } 
                    for(i=0;i<10;i++)
                    {
                        if(str[i] == master_password[i])
                        {  
                            p_count ++;
                        }
                        else
                        {
                           p_count =0;  
                        }           
                    }   
                
                    if(p_count == 10) 
                    {
                        master_count =0;
                        Rock_count =0;
                        master_flag=0;
                        p_count =0;
                        
                        delay_ms(500);
                        LCD_Clear();                              
                    }
                } 
                
            
            }   
               
         OUTFND(fnd);  //fnd출력
         
          
          switch(key_num)     //각 키패드마다 나오는 음 설정
          {
            case 1:
              Buzzer_play(Do);
              break;
            case 2:
              Buzzer_play(Re);
              break;
            case 3:
              Buzzer_play(Mi);
              break;
            case 4:
              Buzzer_play(Fa);
              break;
            case 5:
              Buzzer_play(Sol);
              break;
            case 6:
              Buzzer_play(La);
              break;
            case 7:
              Buzzer_play(Si);
              break;
            case 8:
              Buzzer_play(Do/2);
              break;
            case 9:
              Buzzer_play(Re/2);
              break;
              
            default:
                break;
          }
      } 
}


