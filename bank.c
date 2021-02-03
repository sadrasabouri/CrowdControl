#include <io.h>
#include <delay.h>
#include <stdio.h>
#include <string.h>


char GetKey();
//=================================================================================================
// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
char k;
delay_ms(200);
k = GetKey();
if(k != 0xFF) PORTB = SevenSegment[k];
else PORTB = 0x00;
// clear INTF0
GICR |= (1 << INTF0);
}
//*************************************************************************************************
void main(void)
{
DDRB = 0x7F;
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
// Global enable interrupts
#asm("sei")
int totalcount1_5 = 0, nobat1_5 = 0;
int totalcount6 = 0, nobat6 = 0;
int totalcount7 = 0, nobat7 = 0;
int TotalCount = 0;
int badje1 = 0, badje2 = 0, badje3 = 0, badje4 = 0, badje5 = 0, badje6 = 0, badje7 = 0; 
int namayesh = 0; 
//tanzimat saat
int saat_yekonim = 0; 


while (1)
    {
    if(!reset){
		if(k != 0xFF) // dokme feshorde shod 
		
	  {
		if (saat < 1.5){
			saat_yekonim = 1;
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
					LCD_namayesh_go_to_badje(nobat1_5, 1)
					namayesh = 0;
				
				}
				else if (badje2 == 0){
					badje2 = 1;
					nobat1_5 += 1;
					namayesh = 1;
					LCD_namayesh_go_to_badje(nobat1_5, 2)
					namayesh = 0;
				}
				else if (badje3 == 0){
					badje3 = 1;
					nobat1_5 += 1;
					namayesh = 1;
					LCD_namayesh_go_to_badje(nobat1_5, 3)
					namayesh = 0;
				}
				else if (badje4 == 0){
					badje4 = 1;
					nobat1_5 += 1;
					namayesh = 1;
					LCD_namayesh_go_to_badje(nobat1_5, 4)
					namayesh = 0;
				}
				else if (badje5 == 0){
					badje5 = 1;
					nobat1_5 += 1;
					namayesh = 1;
					LCD_namayesh_go_to_badje(nobat1_5, 5)
					namayesh = 0;
				}
				else {
					namayesh = 1;
					int entezar = totalcount1_5 - nobat1_5; 
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
					LCD_namayesh_go_to_badje(nobat6, 6)
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
					LCD_namayesh_go_to_badje(nobat7, 7)
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
				int d1 = nobat1_5 + 1;
				LCD_namayesh_go_to_badje(d1, 1)
				badje1 = 1;
				nobat1_5 += 1;
				namayesh = 0;
			}
			break;
		case 8 : //badje2
			badje2 = 0;
			if (totalcount1_5 > nobat1_5){
				namayesh = 1;
				int d2 = nobat1_5 + 1;
				LCD_namayesh_go_to_badje(d1, 2)
				badje1 = 1;
				nobat1_5 += 1;
				namayesh = 0;
			}
			break;
		case 7 : //badje3
			badje3 = 0;
			if (totalcount1_5 > nobat1_5){
				namayesh = 1;
				int d3 = nobat1_5 + 1;
				LCD_namayesh_go_to_badje(d3, 3)
				badje1 = 1;
				nobat1_5 += 1;
				namayesh = 0;
			}
			break;
		case 6 : //badje4
			badje4 = 0;
			if (totalcount1_5 > nobat1_5){
				namayesh = 1;
				int d4 = nobat1_5 + 1;
				LCD_namayesh_go_to_badje(d4, 4)
				badje1 = 1;
				nobat1_5 += 1;
				namayesh = 0;
			}
			break;
		case 5 : //badje5
			badje5 = 0;
			if (totalcount1_5 > nobat1_5){
				namayesh = 1;
				int d5 = nobat1_5 + 1;
				LCD_namayesh_go_to_badje(d5, 5)
				badje1 = 1;
				nobat1_5 += 1;
				namayesh = 0;
			}
			break;
		case 4 : //badje6
			badje6 = 0;
			if (totalcount6 > nobat6){
				namayesh = 1;
				int d6 = nobat6 + 1;
				LCD_namayesh_go_to_badje(d6, 6)
				badje1 = 1;
				nobat1_5 += 1;
				namayesh = 0;
			}
			break;
		case 0 : //badje7
			badje7 = 0;
			if (totalcount7 > nobat7){
				namayesh = 1;
				int d7 = nobat7 + 1;
				LCD_namayesh_go_to_badje(d7, 7)
				badje1 = 1;
				nobat1_5 += 1;
				namayesh = 0;
			}
			break;
		
		}
	  }
		
		}
		else{
			int totalcount1_5 = 0, nobat1_5 = 0;
			int totalcount6 = 0, nobat6 = 0;
			int totalcount7 = 0, nobat7 = 0;
			int TotalCount = 0;
			int badje1 = 0, badje2 = 0, badje3 = 0, badje4 = 0, badje5 = 0, badje6 = 0, badje7 = 0; 
			int namayesh = 0; 
			//tanzimat saat
		}
	}
}
//*************************************************************************************************
void LCD_namayesh_go_to_badje (int a, int b){
    char go_to[] = " go to badje ";
    char str1[10];
    sprintf(str1, "%d", a);
    char str2[10];
    sprintf(str2, "%d", b);
    strcat(str1, go_to);
    strcat(str1, str2);
    printf("%s", str1);
}

void LCD_namayesh_entezar (int a){
    char go_to[] = " nafar joloye shoma hastand";
    char str1[10];
    sprintf(str1, "%d", a);
    strcat(str1, go_to);
    printf("%s", str1);
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