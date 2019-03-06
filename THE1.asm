; When you press and relase the RB0 then the four top most LEDs connected to PORTC will be turned on
; Then when you press the RB0 the other four LEDs connected to PORTC  will be turned on
; To execute this program The jumper J13 should be ground side

LIST    P=18F8722

#INCLUDE <p18f8722.inc> 
    
CONFIG OSC = HSPLL, FCMEN = OFF, IESO = OFF, PWRT = OFF, BOREN = OFF, WDT = OFF, MCLRE = ON, LPT1OSC = OFF, LVP = OFF, XINST = OFF, DEBUG = OFF

 led_flag        udata 0X20
 led_flag
 button_released udata 0X21
 button_released
 button_pressed  udata 0X22
 button_pressed
 counter1	 udata 0X23
 counter1
 counter2	 udata 0X24
 counter2
 counter3	 udata 0X25
 counter3

ORG     0x00
goto    main

init
movlw h'00'
movwf TRISA
clrf  LATA
movwf TRISB
clrf  LATB
movwf TRISC
clrf  LATC
movwf TRISD
clrf  LATD
 
movlw b'00011000'
movf TRISE
clrf LATE
clrf PORTE

movlw b'00010000'
movwf TRISA
clrf LATA
clrf PORTA

movlw h'00'
movwf led_flag

movlw h'00'
movwf button_released

movlw h'00'
movwf button_pressed
 
movlw h'00'
movwf counter1
movwf counter2
movwf counter3

BCF INTCON2,7

return
	 
allup
movlw h'0F'
movwf LATA
movwf LATB
movwf LATC
movwf LATD
call wait2000
call turnoff
	
return
 
 
turnoff ; turn off leds for 1 second
movlw h'00'
movwf LATA
movwf LATB
movwf LATC
movwf LATD
call wait1000
return
 
wait1000
movlw 0XFF
movwf counter1
movlw 0xAA
movwf counter2
movlw 0x33
movwf counter3
    loop1000
    decfsz counter1
    goto loop1000
    decfsz counter2
    goto loop1000
    decfsz counter3
    goto loop1000
return
    
wait_input500 ; checks for button action for 500 ms.
movlw 0XFF
movwf counter1
movlw 0xED
movwf counter2
movlw 0x07
movwf counter3 ; counters are used to set the amount of time to wait
    
    iloop500
    movlw 0x01
    btfsc button_pressed, 0
    goto substate1
    substate0: ; no button activity so far, expecting push down
    btfsc PORTA,4 ; check input from RA4, continue if none
    movwf button_pressed ; set flag if button is down
    goto iloop500_end
    substate1: ; button pressed, expecting release
    nop
    btfss PORTA,4 ; check input from RA4, continue if button is still down
    goto return_with_flag ; button released, take action
    
    iloop500_end
    decfsz counter1
    goto iloop500
    decfsz counter2
    goto iloop500
    decfsz counter3
    goto iloop500
return
return_with_flag ; return by setting the button released flag for the program to take action
movwf button_released ; button_released = true
movlw 0x00
movwf button_pressed ; reset flag
return


led1 ;turn on 1 led
movlw h'01'
movwf LATA
movlw h'00'
movwf LATB
movwf LATC
movwf LATD
call wait_input500
btfsc button_released, 0
goto state2
goto led2
    
led2 ;turn on 2 leds
movlw h'03'
movwf LATA
movlw h'00'
movwf LATB
movwf LATC
movwf LATD
call wait_input500
btfsc button_released, 0
goto state2
goto led3
    
led3 ;turn on 3 leds
movlw h'07'
movwf LATA
movlw h'00'
movwf LATB
movwf LATC
movwf LATD
call wait_input500
btfsc button_released, 0
goto state2
goto led4
    
led4 ;turn on 4 leds
movlw h'0F'
movwf LATA
movlw h'00'
movwf LATB
movwf LATC
movwf LATD
call wait_input500
btfsc button_released, 0
goto state2
goto led5
    
led5 ;turn on 5 leds
movlw h'0F'
movwf LATA
movlw h'01'
movwf LATB
movlw h'00'
movwf LATC
movwf LATD
call wait_input500
btfsc button_released, 0
goto state2
goto led6
    
led6 ;turn on 6 leds
movlw h'0F'
movwf LATA
movlw h'03'
movwf LATB
movlw h'00'
movwf LATC
movwf LATD
call wait_input500
btfsc button_released, 0
goto state2
goto led7
    
led7 ;turn on 7 leds
movlw h'0F'
movwf LATA
movlw h'07'
movwf LATB
movlw h'00'
movwf LATC
movwf LATD
call wait_input500
btfsc button_released, 0
goto state2
goto led8
    
led8 ;turn on 8 leds
movlw h'0F'
movwf LATA
movwf LATB
movlw h'00'
movwf LATC
movwf LATD
call wait_input500
btfsc button_released, 0
goto state2
goto led9
    
led9 ;turn on 9 leds
movlw h'0F'
movwf LATA
movwf LATB
movlw h'01'
movwf LATC
movlw h'00'
movwf LATD
call wait_input500
btfsc button_released, 0
goto state2
goto led10
    
led10 ;turn on 10 leds
movlw h'0F'
movwf LATA
movwf LATB
movlw h'03'
movwf LATC
movlw h'00'
movwf LATD
call wait_input500
btfsc button_released, 0
goto state2
goto led11
    
led11 ;turn on 11 leds
movlw h'0F'
movwf LATA
movwf LATB
movlw h'07'
movwf LATC
movlw h'00'
movwf LATD
call wait_input500
btfsc button_released, 0
goto state2
goto led12
    
led12 ;turn on 12 leds
movlw h'0F'
movwf LATA
movwf LATB
movwf LATC  
movlw h'00'
movwf LATD
call wait_input500
btfsc button_released, 0
goto state2
goto led13
    
led13 ;turn on 13 leds
movlw h'0F'
movwf LATA
movwf LATB
movwf LATC
movlw h'01'
movwf LATD
call wait_input500
btfsc button_released, 0
goto state2
goto led14
    
led14 ;turn on 14 leds
movlw h'0F'
movwf LATA
movwf LATB
movwf LATC
movlw h'03'
movwf LATD
call wait_input500
btfsc button_released, 0
goto state2
goto led15
    
led15 ;turn on 15 leds
movlw h'0F'
movwf LATA
movwf LATB
movwf LATC
movlw h'07'
movwf LATD
call wait_input500
btfsc button_released, 0
goto state2
goto led16
    
led16 ;turn on 16 leds
movlw h'0F'
movwf LATA
movwf LATB
movwf LATC
movwf LATD
call wait_input500
btfsc button_released, 0
goto state2
goto led16
  
state2:
movlw h'F0'
movwf LATA
movwf LATB
movwf LATC
movwf LATD
goto state2

 
wait2000
movlw 0XFF
movwf counter1
movlw 0x60
movwf counter2
movlw 0x66
movwf counter3
    loop2000
    decfsz counter1
    goto loop2000
    decfsz counter2
    goto loop2000
    decfsz counter3
    goto loop2000

    return


;movlw h'0F'
;movwf LATC


;btfsc PORTA,4

main:
call init
loop:
    call allup
    goto led1
;endloop:
    ;call turnoff
    ;goto endloop
    

end