; ------------- READS51 generated header -------------- 
; module  : C:\srib\water lc\software\wlcv00\motor_offctrl.asm
; created : 15:09:41, Wednesday, May 30, 2007
; Function gets executed when the motor is switched ON 
; WLC programming   by B.Sridharan
; ----------------------------------------------------- 
; include SFR definitions (located in the include directory)
#include <sfr51.inc>

; declare relative segments to be used in this module (file)
MotoroffCode      segment code

; declare imported labels and symbols (defined in other 
; modules but referred to in this module)
; extern      code          ; function (label)

; declare imported vars (defined in other 
; modules but referred to in this module)
extern      data    probe_level
extern      data    motor_ctrl 
extern      data    voltage_level
extern      data    wflow_delayh 
extern      data    wflow_delayl
extern      data    ondisp_pattern
extern      data    wflow_led_ctrl
extern      data    power_on_delay 
extern      data    water_flowerr 
extern      data    ledupdate_count 

; declare exported labels and symbols (defined in this
; module and referred to in other modules)
public      motor_offctrl

;Registers Used
;Static:
;Dynamic: 

    
; code written to the relative code segment "MotoronCode"
; note that "MainCode" is a user-given name

    rseg    MotoroffCode    ; rseg is the keyword to start a relative segment

motor_offctrl :                
    setb    MOTOR               ; Switch OFF the motor
; wait for 10 sec before switching on the motor after system power-up
    mov     a, power_on_delay
    jz      nxt_offctrl         ; power-up delay is over 
    dec     power_on_delay
    sjmp    set_offdisplay      ; just set the display donot ON the motor
nxt_offctrl:   
    mov     a, probe_level      ; get the probe status  
    jb      TWLOW, set_offdisplay  ; water is enough in tank just set the display
    jnb     SWMID, set_offdisplay  ; no water in sump just set the display
 ; now set the trigger to switch ON the motor and 
 ; initialize for water flow monitoring
    mov     a, water_flowerr
    cjne    a, #INVALID,set_offdisplay  ; donot switch ON if water flow has been timedout
    mov     motor_ctrl, #MOTOR_ON  
    mov     ondisp_pattern, #LED_PATTERN    ; initialize the rolling pattern
    mov     wflow_delayh, #ONE      ; Initiate water flow monitoring and Delay is wflow_delay * 64 msec                
    mov     wflow_delayl, #ZERO     

    ; Control the display LEDS when the motor is OFF
set_offdisplay:
    mov     a, probe_level      ; get the probe status  

ctrl_sdlow:     ; sump low level water LED
    jb      SWLOW, on_sdlow
    setb    SDLOW       ; switch off
    sjmp    ctrl_sdmid
on_sdlow:
    clr     SDLOW       ; switch on
    sjmp    ctrl_sdmid

ctrl_sdmid:     ; sump mid level water LED
    jb      SWMID, on_sdmid
    setb    SDMID       ; switch off
    sjmp    ctrl_sdhigh
on_sdmid:
    clr     SDMID       ; switch on
    sjmp    ctrl_sdhigh

ctrl_sdhigh:    ; sump high level water LED
    jb      SWHIGH, on_sdhigh
    setb    SDHIGH      ; switch off
    sjmp    ctrl_wdflow
on_sdhigh:
    clr     SDHIGH      ; switch on
    sjmp    ctrl_wdflow

ctrl_wdflow:    ; water flow LED
    jb      TWFLOW, on_wdflow
    setb    WDFLOW     ; switch off
    sjmp    ctrl_error
on_wdflow:
    clr     WDFLOW      ; switch on
    sjmp    ctrl_error

ctrl_error:    ; voltage/flerr error LED
    mov     a, water_flowerr
    cjne    a, #VALID, ctrl_verror
ctrl_flerr:
  ; Indicate the water flow error condition
    mov     a, ledupdate_count
    inc     a
    cjne    a, #LEDUPDATE_DELAY, update_cnt     ; exit for timeout
    mov     ledupdate_count, #ZERO              ; reset the count to 0
    cpl     DERROR
    sjmp    mofffn_end         
update_cnt:
    mov     ledupdate_count, a      
    sjmp    mofffn_end

ctrl_verror:        
    mov     a, voltage_level        ; load the var into acc
    cjne    a, #V_NORMAL, on_verror 
    setb    DERROR                  ; switch off
    jb      DERROR, mofffn_end
tank_reset:          ; if the user presses reset button, then reset tank low level probe status 
    anl     probe_level, #0xF7
    sjmp    mofffn_end

on_verror:              ; not a normal voltage sensed
    clr     DERROR      ; switch on
    sjmp    mofffn_end

mofffn_end:   
    ret


    end     ; end of code section
