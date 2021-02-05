#include <io.h>
#include <delay.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <alcd.h>
#include <mega32.h>

#define ONE_SEC 1000
#define SHOW_DELAY 3000
int second = 0;
int minute = 30;
int hour = 7;
char is_AM = 1;

//   fo Counter    1, 2, 3, 4, 5, 6, 7
char is_full[7] = {0, 0, 0, 0, 0, 0, 0};
//   fo Counter 1-5, 6, 7
int in_que[3] = {0 , 0, 0};
int client_index = 1;
int is_timeContinue = 1;

void time_after(int, int*, int*, int*, char*);
int give_first_empty(char*, int);
void LCD_Goto_Counter (int, int);
void LCD_Show_Waiting (int);
void LCD_Out_Of_Time();
char GetKey();

// Timer Interrupt - NOT WORKING
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
    // Reinitialize Timer1 Value
    TCNT1H = 0x85EE >> 8;
    TCNT1L = 0x85EE & 0xff;
}

// External Interrupt 0
interrupt [EXT_INT0] void ext_int0_isr(void)
{
    char key;
    int empt_counter_idx;
    key = GetKey();
    GICR |= (1 << INTF0);   //  Enalbe Interrupt Flag
    if(key != 0xFF) // dokme feshorde shod 
    {
        if (!is_AM)
            if (hour > 1 || (hour == 1 && minute >= 30 ))
                is_timeContinue = 0;

        switch(key)
        {
            case 1:
                if (is_timeContinue)
                {
                    empt_counter_idx = give_first_empty(is_full, 5);
                    if (empt_counter_idx != -1)
                    {
                        is_full[empt_counter_idx] = 1;
                        LCD_Goto_Counter(client_index, empt_counter_idx + 1);
                    }
                    else // All Counters are full
                    {
                        LCD_Show_Waiting(in_que[0]);
                        in_que[0]++;
                    }
                }
                else    //  Running out of time
                    LCD_Out_Of_Time();
                break;
                
            // case 2:
            //     if(is_timeContinue)
            //     {
            //         TotalCount += 1;
            //         totalcount6 += 1;
            //         if(!Counter6)
            //         {
            //             Counter6 = 1;
            //             turn6 += 1;
            //             LCD_Goto_Counter(turn6, 6);
            //         }
            //         else
            //         {
            //             int entezar6 = totalcount6 - turn6; 
            //             LCD_Show_Waiting(entezar6);
            //         }
            //     }
            //     else
            //         LCD_Out_Of_Time();
            //     break;

            // case 3: 
            //     if(is_timeContinue)
            //     {
            //         TotalCount += 1;
            //         totalcount7 += 1;
            //         if(Counter7 == 0){
            //             Counter7 = 1;
            //             turn7 += 1;
            //             LCD_Goto_Counter(turn7, 7);
            //         }
            //         else
            //         {      
            //             int entezar7 = totalcount7 - turn7; 
            //             LCD_Show_Waiting(entezar7);
            //         }
            //     }
            //     else
            //         LCD_Out_Of_Time();
            //     break;

            case 9: // Counter1
                is_full[0] = 0;
                if (in_que[0] > 0)
                {
                    in_que[0]--;
                    LCD_Goto_Counter(0, 1);
                    is_full[0] = 1;
                }
                break;

            // case 8: // Counter2
            //     Counter2 = 0;
            //     if (totalcount1_5 > turn1_5)
            //     {
            //         d2 = turn1_5 + 1;
            //         LCD_Goto_Counter(d2, 2);
            //         Counter2 = 1;
            //         turn1_5 += 1;
            //     }
            //     break;

            // case 7: // Counter3
            //     Counter3 = 0;
            //     if (totalcount1_5 > turn1_5)
            //     {
            //         d3 = turn1_5 + 1;
            //         LCD_Goto_Counter(d3, 3);
            //         Counter3 = 1;
            //         turn1_5 += 1;
            //     }
            //     break;
            // case 6: // Counter4
            //     Counter4 = 0;
            //     if (totalcount1_5 > turn1_5)
            //     {
            //         d4 = turn1_5 + 1;
            //         LCD_Goto_Counter(d4, 4) ;
            //         Counter4 = 1;
            //         turn1_5 += 1;
            //     }
            //     break;
            // case 5: // Counter5
            //     Counter5 = 0;
            //     if (totalcount1_5 > turn1_5)
            //     {
            //         d5 = turn1_5 + 1;
            //         LCD_Goto_Counter(d5, 5);
            //         Counter5 = 1;
            //         turn1_5 += 1;
            //     }
            //     break;
            // case 4: // Counter6
            //     Counter6 = 0;
            //     if (totalcount6 > turn6)
            //     {
            //         d6 = turn6 + 1;
            //         LCD_Goto_Counter(d6, 6);
            //         Counter6 = 1;
            //         turn6 += 1;
            //     }
            //     break;
            // case 0: // Counter7
            //     Counter7 = 0;
            //     if (totalcount7 > turn7)
            //     {
            //         d7 = turn7 + 1;
            //         LCD_Goto_Counter(d7, 7);
            //         Counter7 = 1;
            //         turn7 += 1;
            //     }
            //     break;
        }
    }
}


void main(void)
{
    char* lcd_buffer = "";

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
    
    is_full[0] = 0;
    is_full[1] = 0;
    is_full[2] = 0;
    is_full[3] = 0;
    is_full[4] = 0;
    is_full[5] = 0;
    is_full[6] = 0;

    in_que[0] = 0;
    in_que[0] = 0;
    in_que[0] = 0;
    lcd_init(16);

    while (1)
    {
        if (!is_AM)
            sprintf(lcd_buffer,"   %02d:%02d:%02d  PM", hour, minute, second);
        else
            sprintf(lcd_buffer,"   %02d:%02d:%02d  AM", is_full[0], in_que[0], second);
        lcd_gotoxy(0,0);
        lcd_puts(lcd_buffer);
        delay_ms(ONE_SEC);
        //time_after(ONE_SEC, &hour, &minute, &second, &is_AM);
        lcd_clear();
    }
}

void time_after(int n, int* pthour, int* ptminute, int* ptsecond, char* ptis_AM)
{
    unsigned char second = *ptsecond;
    unsigned char minute = *ptminute;
    unsigned char hour = *pthour;

    n = n / ONE_SEC;
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
    {
        hour = hour % 12;
        *ptis_AM = *ptis_AM ? 0 : 1;    //  is_AM = ~is_AM
    }

    *ptsecond = second;
    *ptminute = minute;
    *pthour = hour;
}

int give_first_empty(char* is_full, int to)
{
    int i = 0;
    for (i = 0; i < to; ++i)
    {
        if (!is_full[i])
            return i;   
    }
    return -1;
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

    delay_ms(SHOW_DELAY);
    time_after(SHOW_DELAY, &hour, &minute, &second, &is_AM);
    lcd_clear();
}

void LCD_Show_Waiting(int togo_number)
{
    char* tmp_buffer = "";

    lcd_clear();

    sprintf(tmp_buffer," %3d Client(s) ", togo_number);
    lcd_gotoxy(0, 0);
    lcd_puts(tmp_buffer);
 
    sprintf(tmp_buffer,"   Before You   ", togo_number);
    lcd_gotoxy(0, 1);
    lcd_puts(tmp_buffer);

    delay_ms(SHOW_DELAY);
    time_after(SHOW_DELAY, &hour, &minute, &second, &is_AM);
    lcd_clear();
}

void LCD_Out_Of_Time()
{
    char* tmp_buffer = "";

    lcd_clear();

    sprintf(tmp_buffer,"    Sorry :(    ");
    lcd_gotoxy(0, 0);
    lcd_puts(tmp_buffer);
 
    sprintf(tmp_buffer,"  Time's Over!  ");
    lcd_gotoxy(0, 1);
    lcd_puts(tmp_buffer);

    delay_ms(SHOW_DELAY);
    time_after(SHOW_DELAY, &hour, &minute, &second, &is_AM);
    lcd_clear();
}

char GetKey()
{
    unsigned char key_code = 0xFF;
    unsigned char columns;

    PORTC = 0xFF;

    // First Row
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
    
    // Second Row
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

    // Third Row
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
    
    // Fourth Row
    PORTC.7 = 0;
    if(!PINC.1) key_code = 0;
    PORTC.7 = 1;

    PORTC = 0x0F;
    return key_code;
}
