# include<reg51.h>
#include<stdio.h>
 sbit CLK = P3^7;
 sbit OE = P3^6;
 sbit EOC = P3^5;
 sbit SC = P2^0;
 sbit ALE = P3^3;
 sbit ADC = P3^2;
 sbit ADB = P3^1;
 sbit ADA = P3^0;
 sbit E = P2^3;
 sbit RW = P2^2;
 sbit RS = P2^1;
 sbit A1 = P2^7;
 sbit A2 = P2^6;
 sbit A3 = P2^5;
 sbit A4 = P2^4;
 #define input_port P1 //ADC
 #define lcdport P0 //lcdport
 int result[3],number;
 
 void timer0() interrupt 0
 {
    CLK = ~CLK;
 }
 void delay(unsigned int count)
 {
    int i,j; 
    for(i=0;i<count;i++)
       for(j=0;j<100;j++);
  }
  
 void datawrt(char dat)
  {
     RS=1;
     lcdport = dat;
     RW=0;
     E=1;
     delay(1);
     E=0;
     delay(1);
   }
   void cmdwrt(unsigned int dat)
   {
      RS=0;
      lcdport = dat;
      RW = 0;
      E=1;
      delay(1);
      E=0;
      delay(1);
    }
    void lcd_ini(int ch)
    {
       if(ch==1);
       {
	  cmdwrt(0x38);
	  cmdwrt(0x0E);
	  cmdwrt(0x01);
	  cmdwrt(0x0C);
	  cmdwrt(0x80);
	}
	if(ch==2);
	{
	  cmdwrt(0x38);
	  cmdwrt(0x0E);
	  cmdwrt(0x01);
	  cmdwrt(0x0C);
	  cmdwrt(0xC0);
	 }
     }
    void lcdprint(unsigned char *str)
    {
       while(*str)
       {
	  datawrt(*str);
	  str++;
	}
     }
    
   
   void main()
   {
      TMOD = 0x02;
       IE = 0x82;
       TH0 = 0xFD;
       TR0=1;
       lcd_ini(1);
       lcdprint("LDR1 LDR2 LDR3");
       
    }