#include <io.h>
#include <delay.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <alcd.h>
#include <mega32.h>

int second;
int minute = 30;
int hour = 7;

int totalcount1_5, nobat1_5;
int totalcount6, nobat6;
int totalcount7, nobat7;
int TotalCount;

int Counter1, Counter2, Counter3, Counter4, Counter5, Counter6, Counter7; 
int Show = 0; 

void time_after(int, int*, int*, int*);
void LCD_Goto_Counter (int, int);
char GetKey();

int d1,d2,d3 ,d4,d5,d6 ,d7;
int entezar;
void LCD_Goto_Counter (int, int);
void LCD_Show_entezar (int);

int reset = 0;
int saat_yekonim;
int Show;
char lcd_buffer[17];

// Timer Interrupt
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
    // Reinitialize Timer1 value
    TCNT1H = 0x85EE >> 8;
    TCNT1L = 0x85EE & 0xff;
    
    if(second==59){
        second=0;
        if(minute==59){
            minute=0;
            if(hour==23)
                hour=0;
            else
                hour++;
        }
        else
            minute++;
    }
    else
        second++;
}

// External Interrupt 0
interrupt [EXT_INT0] void ext_int0_isr(void)
{
char k;
k = GetKey();
GICR |= (1 << INTF0);
if(!reset){ 
        if(k != 0xFF) // dokme feshorde shod 
      {
        if (hour < 13 || (hour ==13 && minute<=30 )){
            saat_yekonim = 1;
        }else{
            saat_yekonim = 0 ; 
        }  
      switch(k)
        {
        case 1 :
            if (saat_yekonim) {
                TotalCount += 1;
                totalcount1_5 += 1;
                if(Counter1 == 0){
                    Counter1 = 1;
                    nobat1_5 += 1;
                    Show = 1;
                    LCD_Goto_Counter(nobat1_5, 1);
                    Show = 0;
                
                }
                else if (Counter2 == 0){
                    Counter2 = 1;
                    nobat1_5 += 1;
                    Show = 1;
                    LCD_Goto_Counter(nobat1_5, 2);
                    Show = 0;
                }
                else if (Counter3 == 0){
                    Counter3 = 1;
                    nobat1_5 += 1;
                    Show = 1;
                    LCD_Goto_Counter(nobat1_5, 3);
                    Show = 0;
                }
                else if (Counter4 == 0){
                    Counter4 = 1;
                    nobat1_5 += 1;
                    Show = 1;
                    LCD_Goto_Counter(nobat1_5, 4) ;
                    Show = 0;
                }
                else if (Counter5 == 0){
                    Counter5 = 1;
                    nobat1_5 += 1;
                    Show = 1;
                    LCD_Goto_Counter(nobat1_5, 5);
                    Show = 0;
                }
                else {
                    Show = 1;
                    entezar = totalcount1_5 - nobat1_5; 
                    LCD_Show_entezar(entezar);
                    Show = 0;
                }
            }    
            break;
        case 2 :
            if(saat_yekonim){
                TotalCount += 1;
                totalcount6 += 1;
                if(Counter6 == 0){
                    Counter6 = 1;
                    nobat6 += 1;
                    Show = 1;
                    LCD_Goto_Counter(nobat6, 6);
                    Show = 0;
                }
                else {
                    int entezar6 = totalcount6 - nobat6; 
                    LCD_Show_entezar(entezar6);
                }
            }
            break;
        case 3 : 
            if(saat_yekonim){
                TotalCount += 1;
                totalcount7 += 1;
                if(Counter7 == 0){
                    Counter7 = 1;
                    nobat7 += 1;
                    Show = 1;
                    LCD_Goto_Counter(nobat7, 7) ;
                    Show = 0;
                }
                else {
                    
                    int entezar7 = totalcount7 - nobat7; 
                    LCD_Show_entezar(entezar7);
                }
            }
            break;
        case 9 : //Counter1
            Counter1 = 0;
            if (totalcount1_5 > nobat1_5){
                Show = 1;
                d1 = nobat1_5 + 1;
                LCD_Goto_Counter(d1, 1);
                Counter1 = 1;
                nobat1_5 += 1;
                Show = 0;
            }
            break;
        case 8 : //Counter2
            Counter2 = 0;
            if (totalcount1_5 > nobat1_5){
                Show = 1;
                d2 = nobat1_5 + 1;
                LCD_Goto_Counter(d2, 2);
                Counter2 = 1;
                nobat1_5 += 1;
                Show = 0;
            }
            break;
        case 7 : //Counter3
            Counter3 = 0;
            if (totalcount1_5 > nobat1_5){
                Show = 1;
                d3 = nobat1_5 + 1;
                LCD_Goto_Counter(d3, 3);
                Counter3 = 1;
                nobat1_5 += 1;
                Show = 0;
            }
            break;
        case 6 : //Counter4
            Counter4 = 0;
            if (totalcount1_5 > nobat1_5){
                Show = 1;
                d4 = nobat1_5 + 1;
                LCD_Goto_Counter(d4, 4) ;
                Counter4 = 1;
                nobat1_5 += 1;
                Show = 0;
            }
            break;
        case 5 : //Counter5
            Counter5 = 0;
            if (totalcount1_5 > nobat1_5){
                Show = 1;
                d5 = nobat1_5 + 1;
                LCD_Goto_Counter(d5, 5);
                Counter5 = 1;
                nobat1_5 += 1;
                Show = 0;
            }
            break;
        case 4 : //Counter6
            Counter6 = 0;
            if (totalcount6 > nobat6){
                Show = 1;
                d6 = nobat6 + 1;
                LCD_Goto_Counter(d6, 6);
                Counter6 = 1;
                nobat6 += 1;
                Show = 0;
            }
            break;
        case 0 : //Counter7
            Counter7 = 0;
            if (totalcount7 > nobat7){
                Show = 1;
                d7 = nobat7 + 1;
                LCD_Goto_Counter(d7, 7);
                Counter7 = 1;
                nobat7 += 1;
                Show = 0;
            }
            break;
        
        }
      }
        
        }
        else{
            totalcount1_5 = 0, nobat1_5 = 0;
            totalcount6 = 0, nobat6 = 0;
            totalcount7 = 0, nobat7 = 0;
            TotalCount = 0;
            Counter1 = 0, Counter2 = 0, Counter3 = 0, Counter4 = 0, Counter5 = 0, Counter6 = 0, Counter7 = 0; 
            Show = 0; 
            //tanzimat saat
        }
    }

void main(void)
{
    DDRB = 0xFF;    //  Port B as output - To LCD
    PORTB = 0x00;   //  Initialize it by 0000_0000
    DDRC = 0xF0;    //  Port C as half input half output - From Keypad
    PORTC = 0x0F;   //  Initialize it by 0000_1111

    // External Interrupt(s) initialization
    // INT0: On
    // INT0 Mode: Falling Edge
    // INT1: Off
    // INT2: Off
    GICR |= (0<<INT1) | (1<<INT0) | (0<<INT2);
    MCUCR = (0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
    MCUCSR = (0<<ISC2);
    GIFR = (0<<INTF1) | (1<<INTF0) | (0<<INTF2);
    
    // Timer/Counter 1 initialization
    // Clock source: System Clock
    // Clock value: 31/250 kHz
    // Mode: Normal top=0xFFFF
    // OC1A output: Disconnected
    // OC1B output: Disconnected
    // Noise Canceler: Off
    // Input Capture on Falling Edge
    // Timer Period: 1 s
    // Timer1 Overflow Interrupt: On
    // Input Capture Interrupt: Off
    // Compare A Match Interrupt: Off
    // Compare B Match Interrupt: Off
    TCCR1A = (0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
    TCCR1B = (0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
    TCNT1H = 0x85;
    TCNT1L = 0xEE;
    ICR1H = 0x00;
    ICR1L = 0x00;
    OCR1AH = 0x00;
    OCR1AL = 0x00;
    OCR1BH = 0x00;
    OCR1BL = 0x00;

    // Global Enable Interrupts
    #asm("sei")
    
    totalcount1_5 = 0, nobat1_5 = 0;
    totalcount6 = 0, nobat6 = 0;
    totalcount7 = 0, nobat7 = 0;
    TotalCount = 0;
    Counter1 = 0, Counter2 = 0, Counter3 = 0, Counter4 = 0, Counter5 = 0, Counter6 = 0, Counter7 = 0; 
    Show = 0; 
    saat_yekonim = 0;
    lcd_init(16);
    second = 0 ; 
    
    while (1)
        {
            if (hour == 1 || hour == 12)
                sprintf(lcd_buffer,"   %02d:%02d:%02d  PM", hour, minute, second);
            else
                sprintf(lcd_buffer,"   %02d:%02d:%02d  AM", hour, minute, second);
            lcd_gotoxy(0,0);
            lcd_puts(lcd_buffer);
            delay_ms(1000);
            time_after(1000, &hour, &minute, &second);
            lcd_clear();
    }
}

void time_after(int n, int* pthour, int* ptminute, int* ptsecond)
{
    unsigned char second = *ptsecond;
    unsigned char minute = *ptminute;
    unsigned char hour = *pthour;

    n = n / 1000;
    second += n;
    if (second > 59)
    {
        minute += 1;
        second = second % 60;
    }
    if (minute > 59)
    {
        hour += 1;
        minute = minute % 60;
    }
    if (hour > 12)
        hour = hour % 12;

    *ptsecond = second;
    *ptminute = minute;
    *pthour = hour;
}

void LCD_Goto_Counter(int clinet_number, int counter_number)
{
    char* tmp_buffer = "";

    lcd_clear();
    
    sprintf(tmp_buffer,"   Client #%03d   ", clinet_number);
    lcd_gotoxy(0, 0);
    lcd_puts(tmp_buffer);

    sprintf(tmp_buffer,"Go To Counter#%02d!", counter_number);
    lcd_gotoxy(0, 1);
    lcd_puts(tmp_buffer);

    delay_ms(3000);
    time_after(3000, &hour, &minute, &second);
    lcd_clear();
}

void LCD_Show_entezar(int togo_number)
{
    char* tmp_buffer = "";

    lcd_clear();

    sprintf(tmp_buffer," %3d Client(s) ", togo_number);
    lcd_gotoxy(0, 0);
    lcd_puts(tmp_buffer);
 
    sprintf(tmp_buffer,"   Before You   ", togo_number);
    lcd_gotoxy(0, 1);
    lcd_puts(tmp_buffer);

    delay_ms(3000);
    time_after(3000, &hour, &minute, &second);
    lcd_clear();  
}

char GetKey()
{
unsigned char key_code = 0xFF;
unsigned char columns;

PORTC = 0xFF; 
// first row
PORTC.4 = 0;
columns = PINC & 0x07;
if(columns != 0x07)
  {
  switch(columns)
    {
    case 0b110 : key_code = 1; break;
    case 0b101 : key_code = 2; break;
    case 0b011 : key_code = 3; break;
    }
  }  
PORTC.4 = 1;
// second row
PORTC.5 = 0;
columns = PINC & 0x07;
if(columns != 0x07)
  {
  switch(columns)
    {
    case 0b110 : key_code = 4; break;
    case 0b101 : key_code = 5; break;
    case 0b011 : key_code = 6; break;
    }
  }  
PORTC.5 = 1;
// third row
PORTC.6 = 0;
columns = PINC & 0x07;
if(columns != 0x07)
  {
  switch(columns)
    {
    case 0b110 : key_code = 7; break;
    case 0b101 : key_code = 8; break;
    case 0b011 : key_code = 9; break;
    }
  }  
PORTC.6 = 1;
// fourth row
PORTC.7 = 0;
if(!PINC.1) key_code = 0;
PORTC.7 = 1;

PORTC = 0x0F;
return key_code;
}