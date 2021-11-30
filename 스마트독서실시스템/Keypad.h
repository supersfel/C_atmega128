#include <mega128.h>
#include <delay.h>

#define Do 1908 // 262Hz (3817us) 1908us
#define Re 1700 // 294Hz (3401us) 1701us
#define Mi 1515 // 330Hz (3030us) 1515us
#define Fa 1432 // 349Hz (2865us) 1433us
#define Sol 1275 // 370Hz (2703us) 1351us
#define La 1136 // 440Hz (2273us) 1136us
#define Si 1012 // 494Hz (2024us) 1012us

char zero_flag=0; // 0�� ���������� FND�� �ٲ�� �����ִ� flag

unsigned char Port_char[] ={0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xd8,
0x80,0x90 ,0x88,0x83,0xc4, 0xa1,0x84,0x8e};
unsigned int Port_fnd[] ={0x1f,0x2f,0x4f,0x8f}; //FND �� ����

void FND_PORT_Init(void) 
{
    DDRE|=0xF0; //FND ����� ���� ����
    DDRF|=0xFF; //FND ����� ���� ����
    DDRC|=0x0F; //Ű�е带 ���� ���� 
    DDRG|=0x10; //���� ����� ���� ���� 
    DDRB|=0x20; //������� ����� ���� ���� 
    PORTC|=0xFF;
}

void Init_Timer1(void)
{ 

    TCCR1A = (1<<COM1A1) | (1<<WGM11); 
    TCCR1B = (1<<WGM13) | (1<<WGM12) | (1<<CS11); 
    TCNT1 = 0x00;
    ICR1 = 36864-1; // TOP �� : 36864-> 20ms(0.542us X 36864), 0~36863 
    OCR1A =2765 ; // �ʱ� ���� ��ġ 0��
    TIMSK |= (1<<OCIE1A); // Output Compare Match Interrupt �㰡
}

interrupt [TIM1_COMPA] void compare(void)
{
    #asm("nop"); //����ġ ���ͷ�Ʈ ���� 
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
    PORTG |= 1<<4; //buzzer off, PORTG�� 4�� �� on(out 1)
    myDelay_us(delay);
    PORTG &= ~(1<<4); //buzzer on, PORTG�� 4�� �� off(out 0)
    myDelay_us(delay);
    }
}

unsigned char KeyScan(void) //Ű�е带 �޴� �Լ� 
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
unsigned char Changenum(unsigned char num) //Ű�е�� �޾Ƶ��� ���ڸ� Ű�е�      //��Ȳ�� �°� ��ȯ 
{

    unsigned char return_num=0;
    if(num ==0){
        return_num =0;
    }
    else if (num%4 ==0){         // 1 2 3 13
    return_num = 12 + num/4;   // 4 5 6 14
                                 // 7 8 9 15
    }                             // 10 0 12 16
    else if( num/4 ==0){ // ��ó�� �νĵǰ� ��ȯ 
        return_num = (4*(num/4) +num%4) ;
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
        zero_flag =1; // �ƹ��͵� ������ �������� 0�� ����Ǳ⿡ 
     // 0�� ������ zero_flag���۵ǰ� ����



    } 
    return return_num;



}



void OUTFND( unsigned int t)
{
    unsigned char FND0, FND1, FND2, FND3; 
    // ���� t�� �޾Ƽ� FND�� ����ϴ� �Լ� 
    FND3 = t/1000;
    FND2 = (t%1000)/100;
    FND1 = (t%100)/10;
    FND0 = t%10;
    PORTE = Port_fnd[0];
    PORTF = Port_char[FND0]; //1���ڸ�
    delay_ms(10);
    PORTE = Port_fnd[1];
    PORTF = Port_char[FND1]; //10���ڸ� 
    delay_ms(10);
    PORTE = Port_fnd[2];
    PORTF = Port_char[FND2]; //100�� �ڸ� 
    delay_ms(10);
    PORTE = Port_fnd[3]; //1000�� �ڸ� 
    PORTF = Port_char[FND3]; 
    delay_ms(10); 
}


void buzzer_play_function(int t)
{
    switch(t) //�� Ű�е帶�� ������ �� ����
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
