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

int badje1, badje2, badje3, badje4, badje5, badje6, badje7; 
int namayesh = 0; 

void LCD_namayesh_go_to_badje (int a, int b);
char GetKey();

int d1,d2,d3 ,d4,d5,d6 ,d7;
int entezar;
void LCD_namayesh_go_to_badje (int a, int b);
void LCD_namayesh_entezar (int a);

char str2[10];
char str3[17];
int reset = 0;
int saat_yekonim;
char str1[10];
int namayesh;
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
                if(badje1 == 0){
                    badje1 = 1;
                    nobat1_5 += 1;
                    namayesh = 1;
                    LCD_namayesh_go_to_badje(nobat1_5, 1);
                    namayesh = 0;
                
                }
                else if (badje2 == 0){
                    badje2 = 1;
                    nobat1_5 += 1;
                    namayesh = 1;
                    LCD_namayesh_go_to_badje(nobat1_5, 2);
                    namayesh = 0;
                }
                else if (badje3 == 0){
                    badje3 = 1;
                    nobat1_5 += 1;
                    namayesh = 1;
                    LCD_namayesh_go_to_badje(nobat1_5, 3);
                    namayesh = 0;
                }
                else if (badje4 == 0){
                    badje4 = 1;
                    nobat1_5 += 1;
                    namayesh = 1;
                    LCD_namayesh_go_to_badje(nobat1_5, 4) ;
                    namayesh = 0;
                }
                else if (badje5 == 0){
                    badje5 = 1;
                    nobat1_5 += 1;
                    namayesh = 1;
                    LCD_namayesh_go_to_badje(nobat1_5, 5);
                    namayesh = 0;
                }
                else {
                    namayesh = 1;
                    entezar = totalcount1_5 - nobat1_5; 
                    LCD_namayesh_entezar(entezar);
                    namayesh = 0;
                }
            }    
            break;
        case 2 :
            if(saat_yekonim){
                TotalCount += 1;
                totalcount6 += 1;
                if(badje6 == 0){
                    badje6 = 1;
                    nobat6 += 1;
                    namayesh = 1;
                    LCD_namayesh_go_to_badje(nobat6, 6);
                    namayesh = 0;
                }
                else {
                    int entezar6 = totalcount6 - nobat6; 
                    LCD_namayesh_entezar(entezar6);
                }
            }
            break;
        case 3 : 
            if(saat_yekonim){
                TotalCount += 1;
                totalcount7 += 1;
                if(badje7 == 0){
                    badje7 = 1;
                    nobat7 += 1;
                    namayesh = 1;
                    LCD_namayesh_go_to_badje(nobat7, 7) ;
                    namayesh = 0;
                }
                else {
                    
                    int entezar7 = totalcount7 - nobat7; 
                    LCD_namayesh_entezar(entezar7);
                }
            }
            break;
        case 9 : //badje1
            badje1 = 0;
            if (totalcount1_5 > nobat1_5){
                namayesh = 1;
                d1 = nobat1_5 + 1;
                LCD_namayesh_go_to_badje(d1, 1);
                badje1 = 1;
                nobat1_5 += 1;
                namayesh = 0;
            }
            break;
        case 8 : //badje2
            badje2 = 0;
            if (totalcount1_5 > nobat1_5){
                namayesh = 1;
                d2 = nobat1_5 + 1;
                LCD_namayesh_go_to_badje(d2, 2);
                badje2 = 1;
                nobat1_5 += 1;
                namayesh = 0;
            }
            break;
        case 7 : //badje3
            badje3 = 0;
            if (totalcount1_5 > nobat1_5){
                namayesh = 1;
                d3 = nobat1_5 + 1;
                LCD_namayesh_go_to_badje(d3, 3);
                badje3 = 1;
                nobat1_5 += 1;
                namayesh = 0;
            }
            break;
        case 6 : //badje4
            badje4 = 0;
            if (totalcount1_5 > nobat1_5){
                namayesh = 1;
                d4 = nobat1_5 + 1;
                LCD_namayesh_go_to_badje(d4, 4) ;
                badje4 = 1;
                nobat1_5 += 1;
                namayesh = 0;
            }
            break;
        case 5 : //badje5
            badje5 = 0;
            if (totalcount1_5 > nobat1_5){
                namayesh = 1;
                d5 = nobat1_5 + 1;
                LCD_namayesh_go_to_badje(d5, 5);
                badje5 = 1;
                nobat1_5 += 1;
                namayesh = 0;
            }
            break;
        case 4 : //badje6
            badje6 = 0;
            if (totalcount6 > nobat6){
                namayesh = 1;
                d6 = nobat6 + 1;
                LCD_namayesh_go_to_badje(d6, 6);
                badje6 = 1;
                nobat6 += 1;
                namayesh = 0;
            }
            break;
        case 0 : //badje7
            badje7 = 0;
            if (totalcount7 > nobat7){
                namayesh = 1;
                d7 = nobat7 + 1;
                LCD_namayesh_go_to_badje(d7, 7);
                badje7 = 1;
                nobat7 += 1;
                namayesh = 0;
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
            badje1 = 0, badje2 = 0, badje3 = 0, badje4 = 0, badje5 = 0, badje6 = 0, badje7 = 0; 
            namayesh = 0; 
            //tanzimat saat
        }
    }


//*************************************************************************************************
void main(void)
{
DDRB = 0xFF;
PORTB = 0x00;
DDRC = 0xF0;
PORTC = 0x0F;
// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: Off
// INT2: Off
GICR|=(0<<INT1) | (1<<INT0) | (0<<INT2);
MCUCR=(0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);
GIFR=(0<<INTF1) | (1<<INTF0) | (0<<INTF2);
////==============================================timer initiallize
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
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x85;
TCNT1L=0xEE;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
// Global enable interrupts
#asm("sei")
//============================================================
totalcount1_5 = 0, nobat1_5 = 0;
totalcount6 = 0, nobat6 = 0;
totalcount7 = 0, nobat7 = 0;
TotalCount = 0;
badje1 = 0, badje2 = 0, badje3 = 0, badje4 = 0, badje5 = 0, badje6 = 0, badje7 = 0; 
namayesh = 0; 
saat_yekonim = 0;
lcd_init(16);
second = 0 ; 
//======================================================================================
while (1)
    {
        if (hour == 1 || hour == 12)
            sprintf(lcd_buffer,"   %02d:%02d:%02d  PM", hour, minute,second);
        else
            sprintf(lcd_buffer,"   %02d:%02d:%02d  AM", hour, minute,second);
        lcd_gotoxy(0,0);
        lcd_puts(lcd_buffer);
        delay_ms(1000);
        lcd_clear();      
}
}
//========================================================================================
void LCD_namayesh_go_to_badje (int a, int b){
    lcd_clear(); 
    str1[10]; 
    itoa(a, str1);
    lcd_gotoxy(0, 0);
    lcd_puts(str1);
    lcd_gotoxy(5, 0);
    lcd_putsf("go to badje : ");
    itoa(b, str2);
    lcd_gotoxy(15, 0);
    lcd_puts(str2);
    delay_ms(1000);
    lcd_clear(); 
}
//==========================================================================================
void LCD_namayesh_entezar (int a){
    lcd_clear();
    str3[17];
    itoa(a, str3);
    lcd_gotoxy(0, 0);
    lcd_puts(str1);
    lcd_gotoxy(4, 0);
    lcd_putsf(" nafar joloye shoma hastand"); 
    delay_ms(500);
    lcd_clear();  
}
//=========================================================================================


//=========================================================================================
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