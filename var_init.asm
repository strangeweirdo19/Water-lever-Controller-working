; ------------- READS51 generated header -------------- 
; module  : D:\remote system\remotev00\var_init.asm
; created : 16:16:08, Wednesday, December 06, 2006
; Code    : Code for var declarion and definition
; WLC programming   by B.Sridharan
; -----------------------------------------------------

; system variables definition program
; only direct memoty is used in the system 

; include SFR definitions (located in the include directory)
#include <sfr51.inc>


; declare relative segments to be used in this module (file)
VarCode     segment code

; declare exported labels and symbols (defined in this
; module and referred to in other modules)

; Variable to know the state of system
public      is_water_flow
public      voltage_level
public      vtemp_level
public      probe_level
public      pprev_level
public      pnew_level
public      wflow_delayh
public      wflow_delayl
public      motor_ctrl
public      ledupdate_count 
public      ondisp_pattern
public      wflow_led_ctrl
public      power_on_delay
public      water_flowerr 
public      psample_count
public      demo_control
public      setp_delayh
public      setp_delayl

;exported function labels
public      var_init

;Registers Used
;Static:
;Dynamic: 

;All the data variables are defined to be static

    dseg    at  0x30    ; absolute internal direct data segment at 0x30 
is_water_flow:          ; status to know whether water is flowing
    ds      1           
voltage_level:          ; status to know the voltage levels
    ds      1
vtemp_level:            ; temp storage for voltage levels
    ds      1
probe_level:            ; status to know the probe levels
    ds      1
pprev_level:            ; status of probe in the previous cycle
    ds      1
pnew_level:             ; status of probe in the present cycle
    ds      1
wflow_delayh:           ; high part of 16 bit delay counter
    ds      1   
wflow_delayl:           ; low part of 16 bit delay counter
    ds      1  
motor_ctrl:             ; var for control of motor
     ds      1  
ledupdate_count:        ; to introduce delay for LED updation
     ds      1  
ondisp_pattern:         ; pattern to rotate the LEDS
     ds      1  
wflow_led_ctrl:         ; control to use water flow LED 
     ds      1 
power_on_delay:         ; power up delay  before motor switch on
     ds      1
water_flowerr:          ; water flow timeout has occured
     ds     1
psample_count:           ; storage to keep the cycle count for consistancy of probe pattern
    ds      1
demo_control:           ; control to invoke demo of WLC
    ds      1
setp_delayh:            ; demo delay counter high
    ds      1
setp_delayl:            ; demo delay counter low
    ds      1

    end                 ; terminate variable segment


    rseg    VarCode     ; This is a code segment

var_init:
    mov     is_water_flow, #ZERO        ; no water flowing
    mov     voltage_level, #V_INVALID   ; voltage level not valid
    mov     probe_level, #ZERO          ; probe level to zero
    mov     pprev_level, #ZERO          ; previous cyvle level zero
    mov     motor_ctrl, #MOTOR_OFF      ; switch the motor OFF
    mov     wflow_delayh, #ZERO         ; Water flow is not being monitered 
    mov     wflow_delayl, #ZERO         ;       it is 16 bit counter
    mov     ledupdate_count, #ZERO      ; duation to update LED
    mov     wflow_led_ctrl, #ZERO       ; to use water flow LED
    mov     power_on_delay, #PWR_ON_DELAY   ; init to 5 secs
    mov     water_flowerr, #INVALID
    mov     psample_count, #ZERO
    mov     setp_delayh, #ZERO         ;Delay counter for demo conditions 
    mov     setp_delayl, #ZERO         ;       it is 16 bit counter
    jb      DERROR, varinit_end           
    mov     demo_control, #VALID        ; demo of WLC is desired
    mov     setp_delayh, #ONE           ; init the delay counter to countup
    ret
varinit_end:
    mov     demo_control, #INVALID      ; normal operation of WLC (default)
    ret

    end             ; terminate code segment Varcode
