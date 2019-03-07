; CENG336 THE1
; Fatih Develi

LIST    P=18F8722

#INCLUDE <p18f8722.inc> 
    
CONFIG OSC = HSPLL, FCMEN = OFF, IESO = OFF, PWRT = OFF, BOREN = OFF, WDT = OFF, MCLRE = ON, LPT1OSC = OFF, LVP = OFF, XINST = OFF, DEBUG = OFF

 ra4_pressed  udata 0X20 ; flag to indicate button is pressed
 ra4_pressed
 ra4_released udata 0X21 ; flag to indicate button is released
 ra4_released
 re3_pressed  udata 0X22
 re3_pressed
 re4_pressed  udata 0X24
 re4_pressed
 counter1	  udata 0X25 ; counters are used to set a specific amount of
 counter1                ; waiting time
 counter2	  udata 0X26
 counter2
 counter3     udata 0X27
 counter3
 state		  udata 0X28 ; current state of the program
 state
	 
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
 
movlw b'00011000' ; RE3 and RE4 are inputs
movf TRISE
clrf LATE
clrf PORTE

movlw b'00010000' ; RA4 is an input
movwf TRISA
clrf LATA
clrf PORTA

movlw h'00'
movwf ra4_released
movwf ra4_pressed
movwf re3_pressed
movwf re4_pressed
 
movwf counter1
movwf counter2
movwf counter3

movlw h'01' ; set the current state to 1
movwf state

return
	 
allup ; turn on all leds for 2 seconds
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
 
wait1000 ; wait for 1 second
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
    btfsc ra4_pressed, 0
    goto substate1
    substate0: ; no button activity so far, expecting push down
    btfsc PORTA,4 ; check input from RA4, continue if none
    movwf ra4_pressed ; set flag if button is down
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
movwf ra4_released ; ra4_released = true
movlw 0x00
movwf ra4_pressed ; ra4_pressed = false
return


led1 ;turn on 1 led
movlw h'01'
movwf LATA
movlw h'00'
movwf LATB
movwf LATC
movwf LATD
call wait_input500
btfsc ra4_released, 0
call state2
btfsc state, 1
goto led1
goto led2
    
led2 ;turn on 2 leds
movlw h'03'
movwf LATA
movlw h'00'
movwf LATB
movwf LATC
movwf LATD
call wait_input500
btfsc ra4_released, 0
call state2
btfsc state, 1 ; if the state is 1, go forward, otherwise (state3) go backwards.
goto led1
goto led3
    
led3 ;turn on 3 leds
movlw h'07'
movwf LATA
movlw h'00'
movwf LATB
movwf LATC
movwf LATD
call wait_input500
btfsc ra4_released, 0
call state2
btfsc state, 1 ; if the state is 1, go forward, otherwise (state3) go backwards.
goto led2
goto led4
    
led4 ;turn on 4 leds
movlw h'0F'
movwf LATA
movlw h'00'
movwf LATB
movwf LATC
movwf LATD
call wait_input500
btfsc ra4_released, 0
call state2
btfsc state, 1 ; if the state is 1, go forward, otherwise (state3) go backwards.
goto led3
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
btfsc ra4_released, 0
call state2
btfsc state, 1 ; if the state is 1, go forward, otherwise (state3) go backwards.
goto led4
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
btfsc ra4_released, 0
call state2
btfsc state, 1 ; if the state is 1, go forward, otherwise (state3) go backwards.
goto led5 ; backward
goto led7 ; forward
    
led7 ;turn on 7 leds
movlw h'0F'
movwf LATA
movlw h'07'
movwf LATB
movlw h'00'
movwf LATC
movwf LATD
call wait_input500
btfsc ra4_released, 0
call state2
btfsc state, 1 ; if the state is 1, go forward, otherwise (state3) go backwards.
goto led6
goto led8
    
led8 ;turn on 8 leds
movlw h'0F'
movwf LATA
movwf LATB
movlw h'00'
movwf LATC
movwf LATD
call wait_input500
btfsc ra4_released, 0
call state2
btfsc state, 1 ; if the state is 1, go forward, otherwise (state3) go backwards.
goto led7
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
btfsc ra4_released, 0
call state2
btfsc state, 1 ; if the state is 1, go forward, otherwise (state3) go backwards.
goto led8
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
btfsc ra4_released, 0
call state2
btfsc state, 1 ; if the state is 1, go forward, otherwise (state3) go backwards.
goto led9
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
btfsc ra4_released, 0
call state2
btfsc state, 1 ; if the state is 1, go forward, otherwise (state3) go backwards.
goto led10
goto led12
    
led12 ;turn on 12 leds
movlw h'0F'
movwf LATA
movwf LATB
movwf LATC  
movlw h'00'
movwf LATD
call wait_input500
btfsc ra4_released, 0
call state2
btfsc state, 1 ; if the state is 1, go forward, otherwise (state3) go backwards.
goto led11
goto led13
    
led13 ;turn on 13 leds
movlw h'0F'
movwf LATA
movwf LATB
movwf LATC
movlw h'01'
movwf LATD
call wait_input500
btfsc ra4_released, 0
call state2
btfsc state, 1 ; if the state is 1, go forward, otherwise (state3) go backwards.
goto led12
goto led14
    
led14 ;turn on 14 leds
movlw h'0F'
movwf LATA
movwf LATB
movwf LATC
movlw h'03'
movwf LATD
call wait_input500
btfsc ra4_released, 0
call state2
btfsc state, 1 ; if the state is 1, go forward, otherwise (state3) go backwards.
goto led13
goto led15
    
led15 ;turn on 15 leds
movlw h'0F'
movwf LATA
movwf LATB
movwf LATC
movlw h'07'
movwf LATD
call wait_input500
btfsc ra4_released, 0
call state2
btfsc state, 1 ; if the state is 1, go forward, otherwise (state3) go backwards.
goto led14
goto led16
    
led16 ;turn on 16 leds
movlw h'0F'
movwf LATA
movwf LATB
movwf LATC
movwf LATD
call wait_input500
btfsc ra4_released, 0
call state2
btfsc state, 1 ; if the state is 1, go forward, otherwise (state3) go backwards.
goto led15
goto led16
  
state2: ; Expect input RE3 or RE4
movlw 0x00
movwf ra4_released

movlw 0x02
movwf state ; set the current state to 2

movlw 0x01
btfsc re3_pressed, 0   ; check if re3 was pressed previously
goto state2_substate2
btfsc re4_pressed, 0   ; check if re4 was pressed previously
goto state2_substate3

state2_substate0   ; no RE3 activity so far, expecting push down
btfsc PORTE, 3     ; check input from RE3, continue if none
movwf re3_pressed  ; set flag if RE4 is down

state2_substate1   ; no RE4 activity so far, expecting push down
btfsc PORTE, 4     ; check input from RE4, continue if none
movwf re4_pressed  ; set flag if RE4 is down
goto state2
    
state2_substate2
btfss PORTE, 3     ; check input from RE3, continue if button is still down
goto re3_return
goto state2
    
state2_substate3   ; check input from RE4, continue if button is still down
btfss PORTE, 4
goto re4_return

goto state2        ; restart loop if there is no input
    
re3_return         ; go to state 1
movlw 0x00
movwf re3_pressed
movlw 0x01
movwf state        ; update the state
return
    
re4_return         ; go to state 3
movlw 0x00
movwf re4_pressed
movlw 0x03
movwf state        ; update the state
return
 
wait2000 ; wait for 2 seconds
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

main:
call init
call allup
goto led1

end
