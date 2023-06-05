
_ADC_init:

;Fire_alarm.c,11 :: 		void ADC_init(void){
;Fire_alarm.c,12 :: 		ADCON1=0xCE;//Right Justify, Fosc/16, AN0 other PORTA and PORTE are digital
	MOVLW      206
	MOVWF      ADCON1+0
;Fire_alarm.c,13 :: 		ADCON0= 0x41;// ADC ON, Channel 0, Fosc/16
	MOVLW      65
	MOVWF      ADCON0+0
;Fire_alarm.c,14 :: 		TRISA=0x01;
	MOVLW      1
	MOVWF      TRISA+0
;Fire_alarm.c,16 :: 		}
L_end_ADC_init:
	RETURN
; end of _ADC_init

_read_temp:

;Fire_alarm.c,17 :: 		unsigned int read_temp(void){
;Fire_alarm.c,19 :: 		ADCON0 = ADCON0 | 0x04;// GO
	BSF        ADCON0+0, 2
;Fire_alarm.c,20 :: 		while( ADCON0 & 0x04);
L_read_temp0:
	BTFSS      ADCON0+0, 2
	GOTO       L_read_temp1
	GOTO       L_read_temp0
L_read_temp1:
;Fire_alarm.c,21 :: 		read=(ADRESH<<8)| ADRESL;
	MOVF       ADRESH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;Fire_alarm.c,22 :: 		return (read*500)/1023;
	MOVLW      244
	MOVWF      R4+0
	MOVLW      1
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      255
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
;Fire_alarm.c,23 :: 		}
L_end_read_temp:
	RETURN
; end of _read_temp

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Fire_alarm.c,49 :: 		void interrupt(){
;Fire_alarm.c,50 :: 		flag = 1;
	MOVLW      1
	MOVWF      _flag+0
;Fire_alarm.c,51 :: 		INTCON = INTCON & 0XFD;
	MOVLW      253
	ANDWF      INTCON+0, 1
;Fire_alarm.c,53 :: 		}
L_end_interrupt:
L__interrupt29:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Fire_alarm.c,55 :: 		void main()
;Fire_alarm.c,57 :: 		UART_Init(9600);
	MOVLW      128
	MOVWF      FARG_UART_Init_baudRate+0
	MOVLW      37
	MOVWF      FARG_UART_Init_baudRate+1
	CALL       _UART_Init+0
;Fire_alarm.c,58 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main2:
	DECFSZ     R13+0, 1
	GOTO       L_main2
	DECFSZ     R12+0, 1
	GOTO       L_main2
	DECFSZ     R11+0, 1
	GOTO       L_main2
	NOP
;Fire_alarm.c,59 :: 		LCD_Initialize();
	CALL       _LCD_initialize+0
;Fire_alarm.c,60 :: 		INTCON = 0X90;
	MOVLW      144
	MOVWF      INTCON+0
;Fire_alarm.c,61 :: 		LCD_Initialize();
	CALL       _LCD_initialize+0
;Fire_alarm.c,62 :: 		ADC_init();
	CALL       _ADC_init+0
;Fire_alarm.c,63 :: 		LCD_String_xy(1,0,"LOADING SYS...");
	MOVLW      1
	MOVWF      FARG_LCD_String_xy+0
	CLRF       FARG_LCD_String_xy+0
	MOVLW      ?lstr1_Fire_alarm+0
	MOVWF      FARG_LCD_String_xy+0
	CALL       _LCD_String_xy+0
;Fire_alarm.c,64 :: 		MSdelay(1000);
	MOVLW      232
	MOVWF      FARG_MSdelay_val+0
	MOVLW      3
	MOVWF      FARG_MSdelay_val+1
	CALL       _MSdelay+0
;Fire_alarm.c,65 :: 		pump = "k";
	MOVLW      ?lstr_2_Fire_alarm+0
	MOVWF      _pump+0
;Fire_alarm.c,67 :: 		while(1)
L_main3:
;Fire_alarm.c,69 :: 		if(flag == 1){
	MOVF       _flag+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main5
;Fire_alarm.c,70 :: 		LCD_Clear();
	CALL       _LCD_Clear+0
;Fire_alarm.c,71 :: 		LCD_String_xy(1,0,"WARNING!");
	MOVLW      1
	MOVWF      FARG_LCD_String_xy+0
	CLRF       FARG_LCD_String_xy+0
	MOVLW      ?lstr3_Fire_alarm+0
	MOVWF      FARG_LCD_String_xy+0
	CALL       _LCD_String_xy+0
;Fire_alarm.c,72 :: 		MSdelay(500);
	MOVLW      244
	MOVWF      FARG_MSdelay_val+0
	MOVLW      1
	MOVWF      FARG_MSdelay_val+1
	CALL       _MSdelay+0
;Fire_alarm.c,73 :: 		PORTC = PORTC | 0X0E;
	MOVLW      14
	IORWF      PORTC+0, 1
;Fire_alarm.c,74 :: 		MSdelay(5000);
	MOVLW      136
	MOVWF      FARG_MSdelay_val+0
	MOVLW      19
	MOVWF      FARG_MSdelay_val+1
	CALL       _MSdelay+0
;Fire_alarm.c,75 :: 		PORTC = PORTC & 0XF1;
	MOVLW      241
	ANDWF      PORTC+0, 1
;Fire_alarm.c,76 :: 		flag = 0;
	CLRF       _flag+0
;Fire_alarm.c,77 :: 		}
L_main5:
;Fire_alarm.c,78 :: 		temp = read_temp();
	CALL       _read_temp+0
	MOVF       R0+0, 0
	MOVWF      _temp+0
;Fire_alarm.c,79 :: 		temp = temp + 1;
	INCF       R0+0, 1
	MOVF       R0+0, 0
	MOVWF      _temp+0
;Fire_alarm.c,80 :: 		WordToStr(temp,temp_val);
	MOVF       R0+0, 0
	MOVWF      FARG_WordToStr_input+0
	CLRF       FARG_WordToStr_input+1
	MOVLW      _temp_val+0
	MOVWF      FARG_WordToStr_output+0
	CALL       _WordToStr+0
;Fire_alarm.c,81 :: 		MSdelay(1000);
	MOVLW      232
	MOVWF      FARG_MSdelay_val+0
	MOVLW      3
	MOVWF      FARG_MSdelay_val+1
	CALL       _MSdelay+0
;Fire_alarm.c,82 :: 		LCD_Clear();
	CALL       _LCD_Clear+0
;Fire_alarm.c,83 :: 		LCD_String_xy(1,0,"Temp:");
	MOVLW      1
	MOVWF      FARG_LCD_String_xy+0
	CLRF       FARG_LCD_String_xy+0
	MOVLW      ?lstr4_Fire_alarm+0
	MOVWF      FARG_LCD_String_xy+0
	CALL       _LCD_String_xy+0
;Fire_alarm.c,84 :: 		LCD_String_xy(1,5,temp_val);
	MOVLW      1
	MOVWF      FARG_LCD_String_xy+0
	MOVLW      5
	MOVWF      FARG_LCD_String_xy+0
	MOVLW      _temp_val+0
	MOVWF      FARG_LCD_String_xy+0
	CALL       _LCD_String_xy+0
;Fire_alarm.c,85 :: 		MSdelay(1500);
	MOVLW      220
	MOVWF      FARG_MSdelay_val+0
	MOVLW      5
	MOVWF      FARG_MSdelay_val+1
	CALL       _MSdelay+0
;Fire_alarm.c,87 :: 		if (temp >= 31){
	MOVLW      31
	SUBWF      _temp+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main6
;Fire_alarm.c,88 :: 		LCD_Clear();
	CALL       _LCD_Clear+0
;Fire_alarm.c,89 :: 		LCD_String_xy(1,0,"HIGH TEMP!");
	MOVLW      1
	MOVWF      FARG_LCD_String_xy+0
	CLRF       FARG_LCD_String_xy+0
	MOVLW      ?lstr5_Fire_alarm+0
	MOVWF      FARG_LCD_String_xy+0
	CALL       _LCD_String_xy+0
;Fire_alarm.c,90 :: 		MSdelay(500);
	MOVLW      244
	MOVWF      FARG_MSdelay_val+0
	MOVLW      1
	MOVWF      FARG_MSdelay_val+1
	CALL       _MSdelay+0
;Fire_alarm.c,91 :: 		PORTC = PORTC | 0X07;
	MOVLW      7
	IORWF      PORTC+0, 1
;Fire_alarm.c,92 :: 		MSdelay(5000);
	MOVLW      136
	MOVWF      FARG_MSdelay_val+0
	MOVLW      19
	MOVWF      FARG_MSdelay_val+1
	CALL       _MSdelay+0
;Fire_alarm.c,93 :: 		PORTC = PORTC & 0XF8;
	MOVLW      248
	ANDWF      PORTC+0, 1
;Fire_alarm.c,94 :: 		}
L_main6:
;Fire_alarm.c,95 :: 		pump = UART_RxChar();
	CALL       _UART_RxChar+0
	MOVF       R0+0, 0
	MOVWF      _pump+0
;Fire_alarm.c,96 :: 		if(pump == 'a')
	MOVF       R0+0, 0
	XORLW      97
	BTFSS      STATUS+0, 2
	GOTO       L_main7
;Fire_alarm.c,98 :: 		LCD_Clear();
	CALL       _LCD_Clear+0
;Fire_alarm.c,99 :: 		MSdelay(500);         // PORTB3 ON
	MOVLW      244
	MOVWF      FARG_MSdelay_val+0
	MOVLW      1
	MOVWF      FARG_MSdelay_val+1
	CALL       _MSdelay+0
;Fire_alarm.c,100 :: 		LCD_String_xy(1,5,"FAN ON");
	MOVLW      1
	MOVWF      FARG_LCD_String_xy+0
	MOVLW      5
	MOVWF      FARG_LCD_String_xy+0
	MOVLW      ?lstr6_Fire_alarm+0
	MOVWF      FARG_LCD_String_xy+0
	CALL       _LCD_String_xy+0
;Fire_alarm.c,102 :: 		MSdelay(1000);
	MOVLW      232
	MOVWF      FARG_MSdelay_val+0
	MOVLW      3
	MOVWF      FARG_MSdelay_val+1
	CALL       _MSdelay+0
;Fire_alarm.c,103 :: 		PORTC = PORTC | 0x07;
	MOVLW      7
	IORWF      PORTC+0, 1
;Fire_alarm.c,104 :: 		pump = 'k';
	MOVLW      107
	MOVWF      _pump+0
;Fire_alarm.c,105 :: 		}
L_main7:
;Fire_alarm.c,106 :: 		if(pump == 'b')
	MOVF       _pump+0, 0
	XORLW      98
	BTFSS      STATUS+0, 2
	GOTO       L_main8
;Fire_alarm.c,108 :: 		LCD_Clear();
	CALL       _LCD_Clear+0
;Fire_alarm.c,109 :: 		MSdelay(500);
	MOVLW      244
	MOVWF      FARG_MSdelay_val+0
	MOVLW      1
	MOVWF      FARG_MSdelay_val+1
	CALL       _MSdelay+0
;Fire_alarm.c,110 :: 		LCD_String_xy(1,5,"FAN OFF");
	MOVLW      1
	MOVWF      FARG_LCD_String_xy+0
	MOVLW      5
	MOVWF      FARG_LCD_String_xy+0
	MOVLW      ?lstr7_Fire_alarm+0
	MOVWF      FARG_LCD_String_xy+0
	CALL       _LCD_String_xy+0
;Fire_alarm.c,112 :: 		MSdelay(1000);
	MOVLW      232
	MOVWF      FARG_MSdelay_val+0
	MOVLW      3
	MOVWF      FARG_MSdelay_val+1
	CALL       _MSdelay+0
;Fire_alarm.c,113 :: 		PORTC = PORTC & 0xF8;
	MOVLW      248
	ANDWF      PORTC+0, 1
;Fire_alarm.c,114 :: 		pump = 'k';
	MOVLW      107
	MOVWF      _pump+0
;Fire_alarm.c,115 :: 		}
L_main8:
;Fire_alarm.c,116 :: 		if(pump == 'c')
	MOVF       _pump+0, 0
	XORLW      99
	BTFSS      STATUS+0, 2
	GOTO       L_main9
;Fire_alarm.c,118 :: 		LCD_Clear();
	CALL       _LCD_Clear+0
;Fire_alarm.c,119 :: 		MSdelay(500);
	MOVLW      244
	MOVWF      FARG_MSdelay_val+0
	MOVLW      1
	MOVWF      FARG_MSdelay_val+1
	CALL       _MSdelay+0
;Fire_alarm.c,120 :: 		LCD_String_xy(1,5,"PUMP ON");
	MOVLW      1
	MOVWF      FARG_LCD_String_xy+0
	MOVLW      5
	MOVWF      FARG_LCD_String_xy+0
	MOVLW      ?lstr8_Fire_alarm+0
	MOVWF      FARG_LCD_String_xy+0
	CALL       _LCD_String_xy+0
;Fire_alarm.c,122 :: 		MSdelay(1000);
	MOVLW      232
	MOVWF      FARG_MSdelay_val+0
	MOVLW      3
	MOVWF      FARG_MSdelay_val+1
	CALL       _MSdelay+0
;Fire_alarm.c,123 :: 		PORTC = PORTC | 0X0E;
	MOVLW      14
	IORWF      PORTC+0, 1
;Fire_alarm.c,124 :: 		pump = 'k';
	MOVLW      107
	MOVWF      _pump+0
;Fire_alarm.c,125 :: 		}
L_main9:
;Fire_alarm.c,127 :: 		if(pump == 'd')
	MOVF       _pump+0, 0
	XORLW      100
	BTFSS      STATUS+0, 2
	GOTO       L_main10
;Fire_alarm.c,129 :: 		LCD_Clear();
	CALL       _LCD_Clear+0
;Fire_alarm.c,130 :: 		MSdelay(500);
	MOVLW      244
	MOVWF      FARG_MSdelay_val+0
	MOVLW      1
	MOVWF      FARG_MSdelay_val+1
	CALL       _MSdelay+0
;Fire_alarm.c,131 :: 		LCD_String_xy(1,5,"PUMP OFF");
	MOVLW      1
	MOVWF      FARG_LCD_String_xy+0
	MOVLW      5
	MOVWF      FARG_LCD_String_xy+0
	MOVLW      ?lstr9_Fire_alarm+0
	MOVWF      FARG_LCD_String_xy+0
	CALL       _LCD_String_xy+0
;Fire_alarm.c,133 :: 		MSdelay(1000);
	MOVLW      232
	MOVWF      FARG_MSdelay_val+0
	MOVLW      3
	MOVWF      FARG_MSdelay_val+1
	CALL       _MSdelay+0
;Fire_alarm.c,134 :: 		PORTC = PORTC & 0XF1;
	MOVLW      241
	ANDWF      PORTC+0, 1
;Fire_alarm.c,135 :: 		pump = 'k';
	MOVLW      107
	MOVWF      _pump+0
;Fire_alarm.c,136 :: 		}
L_main10:
;Fire_alarm.c,137 :: 		if(flag == 1)
	MOVF       _flag+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main11
;Fire_alarm.c,139 :: 		LCD_Clear();
	CALL       _LCD_Clear+0
;Fire_alarm.c,140 :: 		LCD_String_xy(1,0,"WARNING!");
	MOVLW      1
	MOVWF      FARG_LCD_String_xy+0
	CLRF       FARG_LCD_String_xy+0
	MOVLW      ?lstr10_Fire_alarm+0
	MOVWF      FARG_LCD_String_xy+0
	CALL       _LCD_String_xy+0
;Fire_alarm.c,141 :: 		MSdelay(1000);
	MOVLW      232
	MOVWF      FARG_MSdelay_val+0
	MOVLW      3
	MOVWF      FARG_MSdelay_val+1
	CALL       _MSdelay+0
;Fire_alarm.c,142 :: 		PORTC = PORTC | 0X0E;
	MOVLW      14
	IORWF      PORTC+0, 1
;Fire_alarm.c,143 :: 		MSdelay(5000);
	MOVLW      136
	MOVWF      FARG_MSdelay_val+0
	MOVLW      19
	MOVWF      FARG_MSdelay_val+1
	CALL       _MSdelay+0
;Fire_alarm.c,144 :: 		PORTC = PORTC & 0XF1;
	MOVLW      241
	ANDWF      PORTC+0, 1
;Fire_alarm.c,145 :: 		flag = 0;
	CLRF       _flag+0
;Fire_alarm.c,146 :: 		}
L_main11:
;Fire_alarm.c,148 :: 		if(pump == 'k')
	MOVF       _pump+0, 0
	XORLW      107
	BTFSS      STATUS+0, 2
	GOTO       L_main12
;Fire_alarm.c,150 :: 		LCD_Clear();
	CALL       _LCD_Clear+0
;Fire_alarm.c,151 :: 		MSdelay(250);
	MOVLW      250
	MOVWF      FARG_MSdelay_val+0
	CLRF       FARG_MSdelay_val+1
	CALL       _MSdelay+0
;Fire_alarm.c,152 :: 		}
L_main12:
;Fire_alarm.c,153 :: 		}
	GOTO       L_main3
;Fire_alarm.c,156 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_LCD_Initialize:

;Fire_alarm.c,161 :: 		void LCD_Initialize () /* LCD Initialize function */
;Fire_alarm.c,163 :: 		LCD_Port = 0x00;       //PORT as Output Port/
	CLRF       TRISD+0
;Fire_alarm.c,164 :: 		delay_ms(20);        //15ms,16x2 LCD Power on delay/
	MOVLW      52
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_LCD_Initialize13:
	DECFSZ     R13+0, 1
	GOTO       L_LCD_Initialize13
	DECFSZ     R12+0, 1
	GOTO       L_LCD_Initialize13
	NOP
	NOP
;Fire_alarm.c,165 :: 		LCD_Command(0x02);  /*send for initialization of LCD for nibble (4-bit) mode */
	MOVLW      2
	MOVWF      FARG_LCD_command+0
	CALL       _LCD_command+0
;Fire_alarm.c,166 :: 		LCD_Command(0x28);  //use 2 line and initialize 5*8 matrix in (4-bit mode)/
	MOVLW      40
	MOVWF      FARG_LCD_command+0
	CALL       _LCD_command+0
;Fire_alarm.c,167 :: 		LCD_Command(0x01);  //clear display screen/
	MOVLW      1
	MOVWF      FARG_LCD_command+0
	CALL       _LCD_command+0
;Fire_alarm.c,168 :: 		LCD_Command(0x0c);  //display on cursor off/
	MOVLW      12
	MOVWF      FARG_LCD_command+0
	CALL       _LCD_command+0
;Fire_alarm.c,169 :: 		LCD_Command(0x06);  //increment cursor (shift cursor to right)/
	MOVLW      6
	MOVWF      FARG_LCD_command+0
	CALL       _LCD_command+0
;Fire_alarm.c,170 :: 		}
L_end_LCD_Initialize:
	RETURN
; end of _LCD_Initialize

_LCD_command:

;Fire_alarm.c,172 :: 		void LCD_command(unsigned char cmnd)
;Fire_alarm.c,174 :: 		ldata = (ldata & 0x0f) |(0xF0 & cmnd);  //Send higher nibble of command first to PORT/
	MOVLW      15
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVLW      240
	ANDWF      FARG_LCD_command_cmnd+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	IORWF      R1+0, 0
	MOVWF      PORTD+0
;Fire_alarm.c,175 :: 		RS = 0;  //Command Register is selected i.e.RS=0/
	BCF        RD0_bit+0, BitPos(RD0_bit+0)
;Fire_alarm.c,176 :: 		EN = 1;  //High-to-low pulse on Enable pin to latch data/
	BSF        RD1_bit+0, BitPos(RD1_bit+0)
;Fire_alarm.c,177 :: 		asm NOP;
	NOP
;Fire_alarm.c,178 :: 		EN = 0;
	BCF        RD1_bit+0, BitPos(RD1_bit+0)
;Fire_alarm.c,179 :: 		MSdelay(1);
	MOVLW      1
	MOVWF      FARG_MSdelay_val+0
	MOVLW      0
	MOVWF      FARG_MSdelay_val+1
	CALL       _MSdelay+0
;Fire_alarm.c,180 :: 		ldata = (ldata & 0x0f) | (cmnd<<4);  /*Send lower nibble of command to PORT */
	MOVLW      15
	ANDWF      PORTD+0, 0
	MOVWF      R2+0
	MOVF       FARG_LCD_command_cmnd+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	IORWF      R2+0, 0
	MOVWF      PORTD+0
;Fire_alarm.c,181 :: 		EN = 1;
	BSF        RD1_bit+0, BitPos(RD1_bit+0)
;Fire_alarm.c,182 :: 		asm NOP;
	NOP
;Fire_alarm.c,183 :: 		EN = 0;
	BCF        RD1_bit+0, BitPos(RD1_bit+0)
;Fire_alarm.c,184 :: 		MSdelay(3);
	MOVLW      3
	MOVWF      FARG_MSdelay_val+0
	MOVLW      0
	MOVWF      FARG_MSdelay_val+1
	CALL       _MSdelay+0
;Fire_alarm.c,185 :: 		}
L_end_LCD_command:
	RETURN
; end of _LCD_command

_LCD_String_xy:

;Fire_alarm.c,187 :: 		void LCD_String_xy (unsigned char row,unsigned char pos,unsigned char *str) //Send string to LCD function */
;Fire_alarm.c,189 :: 		location=0;
	CLRF       _location+0
;Fire_alarm.c,190 :: 		if(row<=1)
	MOVF       FARG_LCD_String_xy_row+0, 0
	SUBLW      1
	BTFSS      STATUS+0, 0
	GOTO       L_LCD_String_xy14
;Fire_alarm.c,192 :: 		location=(0x80) | ((pos) & 0x0f);  //Print message on 1st row and desired location/
	MOVLW      15
	ANDWF      FARG_LCD_String_xy_pos+0, 0
	MOVWF      R0+0
	BSF        R0+0, 7
	MOVF       R0+0, 0
	MOVWF      _location+0
;Fire_alarm.c,193 :: 		LCD_Command(location);
	MOVF       R0+0, 0
	MOVWF      FARG_LCD_command_cmnd+0
	CALL       _LCD_command+0
;Fire_alarm.c,194 :: 		}
	GOTO       L_LCD_String_xy15
L_LCD_String_xy14:
;Fire_alarm.c,197 :: 		location=(0xC0) | ((pos) & 0x0f);  //Print message on 2nd row and desired location/
	MOVLW      15
	ANDWF      FARG_LCD_String_xy_pos+0, 0
	MOVWF      R0+0
	MOVLW      192
	IORWF      R0+0, 1
	MOVF       R0+0, 0
	MOVWF      _location+0
;Fire_alarm.c,198 :: 		LCD_Command(location);
	MOVF       R0+0, 0
	MOVWF      FARG_LCD_command_cmnd+0
	CALL       _LCD_command+0
;Fire_alarm.c,199 :: 		}
L_LCD_String_xy15:
;Fire_alarm.c,201 :: 		LCD_String(str);
	MOVF       FARG_LCD_String_xy_str+0, 0
	MOVWF      FARG_LCD_String+0
	CALL       _LCD_String+0
;Fire_alarm.c,203 :: 		}
L_end_LCD_String_xy:
	RETURN
; end of _LCD_String_xy

_LCD_String:

;Fire_alarm.c,205 :: 		void LCD_String (unsigned char *str) // Send string to LCD function */
;Fire_alarm.c,207 :: 		while((*str)!=0)
L_LCD_String16:
	MOVF       FARG_LCD_String_str+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_LCD_String17
;Fire_alarm.c,209 :: 		LCD_Char(*str);
	MOVF       FARG_LCD_String_str+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_LCD_Char+0
	CALL       _LCD_Char+0
;Fire_alarm.c,210 :: 		str++;
	INCF       FARG_LCD_String_str+0, 1
;Fire_alarm.c,211 :: 		}
	GOTO       L_LCD_String16
L_LCD_String17:
;Fire_alarm.c,212 :: 		}
L_end_LCD_String:
	RETURN
; end of _LCD_String

_LCD_Char:

;Fire_alarm.c,214 :: 		void LCD_Char (unsigned char chardata) /* LCD data write function */
;Fire_alarm.c,216 :: 		ldata = (ldata & 0x0f) | (0xF0 & chardata);  //Send higher nibble of data first to PORT/
	MOVLW      15
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVLW      240
	ANDWF      FARG_LCD_Char_chardata+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	IORWF      R1+0, 0
	MOVWF      PORTD+0
;Fire_alarm.c,217 :: 		RS = 1;  //Data Register is selected/
	BSF        RD0_bit+0, BitPos(RD0_bit+0)
;Fire_alarm.c,218 :: 		EN = 1;  //High-to-low pulse on Enable pin to latch data/
	BSF        RD1_bit+0, BitPos(RD1_bit+0)
;Fire_alarm.c,219 :: 		asm NOP;
	NOP
;Fire_alarm.c,220 :: 		EN = 0;
	BCF        RD1_bit+0, BitPos(RD1_bit+0)
;Fire_alarm.c,221 :: 		MSdelay(1);
	MOVLW      1
	MOVWF      FARG_MSdelay_val+0
	MOVLW      0
	MOVWF      FARG_MSdelay_val+1
	CALL       _MSdelay+0
;Fire_alarm.c,222 :: 		ldata = (ldata & 0x0f) | (chardata<<4);  //Send lower nibble of data to PORT/
	MOVLW      15
	ANDWF      PORTD+0, 0
	MOVWF      R2+0
	MOVF       FARG_LCD_Char_chardata+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	IORWF      R2+0, 0
	MOVWF      PORTD+0
;Fire_alarm.c,223 :: 		EN = 1;  //High-to-low pulse on Enable pin to latch data/
	BSF        RD1_bit+0, BitPos(RD1_bit+0)
;Fire_alarm.c,224 :: 		asm NOP;
	NOP
;Fire_alarm.c,225 :: 		EN = 0;
	BCF        RD1_bit+0, BitPos(RD1_bit+0)
;Fire_alarm.c,226 :: 		MSdelay(3);
	MOVLW      3
	MOVWF      FARG_MSdelay_val+0
	MOVLW      0
	MOVWF      FARG_MSdelay_val+1
	CALL       _MSdelay+0
;Fire_alarm.c,227 :: 		}
L_end_LCD_Char:
	RETURN
; end of _LCD_Char

_LCD_Clear:

;Fire_alarm.c,230 :: 		void LCD_Clear()
;Fire_alarm.c,232 :: 		LCD_Command(0x01);  //clear display screen/
	MOVLW      1
	MOVWF      FARG_LCD_command_cmnd+0
	CALL       _LCD_command+0
;Fire_alarm.c,233 :: 		MSdelay(3);
	MOVLW      3
	MOVWF      FARG_MSdelay_val+0
	MOVLW      0
	MOVWF      FARG_MSdelay_val+1
	CALL       _MSdelay+0
;Fire_alarm.c,234 :: 		}
L_end_LCD_Clear:
	RETURN
; end of _LCD_Clear

_MSdelay:

;Fire_alarm.c,238 :: 		void MSdelay(unsigned int val)
;Fire_alarm.c,240 :: 		for(i=0;i<val;i++)
	CLRF       _i+0
	CLRF       _i+1
L_MSdelay18:
	MOVF       FARG_MSdelay_val+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__MSdelay38
	MOVF       FARG_MSdelay_val+0, 0
	SUBWF      _i+0, 0
L__MSdelay38:
	BTFSC      STATUS+0, 0
	GOTO       L_MSdelay19
;Fire_alarm.c,241 :: 		for(j=0;j<165;j++);  /*This count Provide delay of 1 ms for 8MHz Frequency */
	CLRF       _j+0
	CLRF       _j+1
L_MSdelay21:
	MOVLW      0
	SUBWF      _j+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__MSdelay39
	MOVLW      165
	SUBWF      _j+0, 0
L__MSdelay39:
	BTFSC      STATUS+0, 0
	GOTO       L_MSdelay22
	INCF       _j+0, 1
	BTFSC      STATUS+0, 2
	INCF       _j+1, 1
	GOTO       L_MSdelay21
L_MSdelay22:
;Fire_alarm.c,240 :: 		for(i=0;i<val;i++)
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;Fire_alarm.c,241 :: 		for(j=0;j<165;j++);  /*This count Provide delay of 1 ms for 8MHz Frequency */
	GOTO       L_MSdelay18
L_MSdelay19:
;Fire_alarm.c,242 :: 		}
L_end_MSdelay:
	RETURN
; end of _MSdelay

_UART_Init:

;Fire_alarm.c,244 :: 		void UART_Init(int baudRate)
;Fire_alarm.c,246 :: 		TRISC=0xC0;            // Configure Rx pin as input and Tx as output
	MOVLW      192
	MOVWF      TRISC+0
;Fire_alarm.c,247 :: 		TXSTA=(1<<5);  // Asynchronous mode, 8-bit data & enable transmitter
	MOVLW      32
	MOVWF      TXSTA+0
;Fire_alarm.c,248 :: 		RCSTA=(1<<7) | (1<<4);  // Enable Serial Port and 8-bit continuous receive
	MOVLW      144
	MOVWF      RCSTA+0
;Fire_alarm.c,249 :: 		SPBRG = (8000000UL/(long)(64UL*baudRate))-1;      // 96000 baud rate @8Mhz Clock
	MOVLW      6
	MOVWF      R0+0
	MOVF       FARG_UART_Init_baudRate+0, 0
	MOVWF      R4+0
	MOVF       FARG_UART_Init_baudRate+1, 0
	MOVWF      R4+1
	MOVLW      0
	BTFSC      R4+1, 7
	MOVLW      255
	MOVWF      R4+2
	MOVWF      R4+3
	MOVF       R0+0, 0
L__UART_Init41:
	BTFSC      STATUS+0, 2
	GOTO       L__UART_Init42
	RLF        R4+0, 1
	RLF        R4+1, 1
	RLF        R4+2, 1
	RLF        R4+3, 1
	BCF        R4+0, 0
	ADDLW      255
	GOTO       L__UART_Init41
L__UART_Init42:
	MOVLW      0
	MOVWF      R0+0
	MOVLW      18
	MOVWF      R0+1
	MOVLW      122
	MOVWF      R0+2
	MOVLW      0
	MOVWF      R0+3
	CALL       _Div_32x32_U+0
	DECF       R0+0, 0
	MOVWF      SPBRG+0
;Fire_alarm.c,250 :: 		}
L_end_UART_Init:
	RETURN
; end of _UART_Init

_UART_RxChar:

;Fire_alarm.c,251 :: 		char UART_RxChar()
;Fire_alarm.c,253 :: 		while(!(PIR1 & 0xDF));    // Wait till the data is received
L_UART_RxChar24:
	MOVLW      223
	ANDWF      PIR1+0, 0
	MOVWF      R0+0
	BTFSS      STATUS+0, 2
	GOTO       L_UART_RxChar25
	GOTO       L_UART_RxChar24
L_UART_RxChar25:
;Fire_alarm.c,254 :: 		PIR1 = PIR1 & 0xDF;            // Clear receiver flag
	MOVLW      223
	ANDWF      PIR1+0, 1
;Fire_alarm.c,255 :: 		return(RCREG);     // Return the received data to calling function
	MOVF       RCREG+0, 0
	MOVWF      R0+0
;Fire_alarm.c,256 :: 		}
L_end_UART_RxChar:
	RETURN
; end of _UART_RxChar
