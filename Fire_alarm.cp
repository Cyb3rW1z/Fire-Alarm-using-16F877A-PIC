#line 1 "C:/Users/User/Desktop/Fire_alarm.c"
unsigned int i;
unsigned int j;
unsigned bal=0;
unsigned char temp_val[6];
unsigned char location;
unsigned char flag = 0;
char pump;
unsigned char temp;


void ADC_init(void){
 ADCON1=0xCE;
 ADCON0= 0x41;
 TRISA=0x01;

}
unsigned int read_temp(void){
 unsigned int read;
 ADCON0 = ADCON0 | 0x04;
 while( ADCON0 & 0x04);
 read=(ADRESH<<8)| ADRESL;
 return (read*500)/1023;
}









void LCD_command(unsigned char);
void LCD_initialize();
void LCD_String_xy (unsigned char ,unsigned char ,unsigned char *);
void LCD_String (unsigned char *);
void LCD_Char (unsigned char );
void LCD_Clear();



void UART_Init(int baudRate);
char UART_RxChar();



void MSdelay(unsigned int val);

void interrupt(){
 flag = 1;
 INTCON = INTCON & 0XFD;

}

void main()
{
 UART_Init(9600);
 delay_ms(100);
 LCD_Initialize();
 INTCON = 0X90;
 LCD_Initialize();
 ADC_init();
 LCD_String_xy(1,0,"LOADING SYS...");
 MSdelay(1000);
 pump = "k";

while(1)
 {
 if(flag == 1){
 LCD_Clear();
 LCD_String_xy(1,0,"WARNING!");
 MSdelay(500);
 PORTC = PORTC | 0X0E;
 MSdelay(5000);
 PORTC = PORTC & 0XF1;
 flag = 0;
 }
 temp = read_temp();
 temp = temp + 1;
 WordToStr(temp,temp_val);
 MSdelay(1000);
 LCD_Clear();
 LCD_String_xy(1,0,"Temp:");
 LCD_String_xy(1,5,temp_val);
 MSdelay(1500);

 if (temp >= 31){
 LCD_Clear();
 LCD_String_xy(1,0,"HIGH TEMP!");
 MSdelay(500);
 PORTC = PORTC | 0X07;
 MSdelay(5000);
 PORTC = PORTC & 0XF8;
 }
 pump = UART_RxChar();
 if(pump == 'a')
 {
 LCD_Clear();
 MSdelay(500);
 LCD_String_xy(1,5,"FAN ON");

 MSdelay(1000);
 PORTC = PORTC | 0x07;
 pump = 'k';
 }
 if(pump == 'b')
 {
 LCD_Clear();
 MSdelay(500);
 LCD_String_xy(1,5,"FAN OFF");

 MSdelay(1000);
 PORTC = PORTC & 0xF8;
 pump = 'k';
 }
 if(pump == 'c')
 {
 LCD_Clear();
 MSdelay(500);
 LCD_String_xy(1,5,"PUMP ON");

 MSdelay(1000);
 PORTC = PORTC | 0X0E;
 pump = 'k';
 }

 if(pump == 'd')
 {
 LCD_Clear();
 MSdelay(500);
 LCD_String_xy(1,5,"PUMP OFF");

 MSdelay(1000);
 PORTC = PORTC & 0XF1;
 pump = 'k';
 }
 if(flag == 1)
 {
 LCD_Clear();
 LCD_String_xy(1,0,"WARNING!");
 MSdelay(1000);
 PORTC = PORTC | 0X0E;
 MSdelay(5000);
 PORTC = PORTC & 0XF1;
 flag = 0;
 }

 if(pump == 'k')
 {
 LCD_Clear();
 MSdelay(250);
 }
 }


}




void LCD_Initialize ()
{
  TRISD  = 0x00;
 delay_ms(20);
 LCD_Command(0x02);
 LCD_Command(0x28);
 LCD_Command(0x01);
 LCD_Command(0x0c);
 LCD_Command(0x06);
}

void LCD_command(unsigned char cmnd)
{
  PORTD  = ( PORTD  & 0x0f) |(0xF0 & cmnd);
  RD0_bit  = 0;
  RD1_bit  = 1;
 asm NOP;
  RD1_bit  = 0;
 MSdelay(1);
  PORTD  = ( PORTD  & 0x0f) | (cmnd<<4);
  RD1_bit  = 1;
 asm NOP;
  RD1_bit  = 0;
 MSdelay(3);
}

void LCD_String_xy (unsigned char row,unsigned char pos,unsigned char *str)
{
location=0;
if(row<=1)
 {
 location=(0x80) | ((pos) & 0x0f);
 LCD_Command(location);
 }
else
 {
 location=(0xC0) | ((pos) & 0x0f);
 LCD_Command(location);
 }

LCD_String(str);

}

void LCD_String (unsigned char *str)
{
 while((*str)!=0)
 {
 LCD_Char(*str);
 str++;
 }
}

void LCD_Char (unsigned char chardata)
{
  PORTD  = ( PORTD  & 0x0f) | (0xF0 & chardata);
  RD0_bit  = 1;
  RD1_bit  = 1;
 asm NOP;
  RD1_bit  = 0;
 MSdelay(1);
  PORTD  = ( PORTD  & 0x0f) | (chardata<<4);
  RD1_bit  = 1;
 asm NOP;
  RD1_bit  = 0;
 MSdelay(3);
}


void LCD_Clear()
{
 LCD_Command(0x01);
 MSdelay(3);
}



void MSdelay(unsigned int val)
{
 for(i=0;i<val;i++)
 for(j=0;j<165;j++);
}

void UART_Init(int baudRate)
{
 TRISC=0xC0;
 TXSTA=(1<<5);
 RCSTA=(1<<7) | (1<<4);
 SPBRG = (8000000UL/(long)(64UL*baudRate))-1;
}
char UART_RxChar()
{
 while(!(PIR1 & 0xDF));
 PIR1 = PIR1 & 0xDF;
 return(RCREG);
}
