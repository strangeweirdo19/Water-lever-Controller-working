; ------------- READS51 generated header -------------- 
; module  : C:\srib\water lc\software\wlcv00\motor_onctrl.asm
; created : 15:00:36, Tuesday, May 29, 2007
; Function gets executed when the motor is switched ON 
; WLC programming   by B.Sridharan
; ----------------------------------------------------- 
; include SFR definitions (located in the include directory)
#include <sfr51.inc>

; declare relative segments to be used in this module (file)
MotoronCode      segment code

; declare imported labels and symbols (defined in other 
; modules but referred to in this module)
;

; declare imported vars (defined in other 
; modules but referred to in this module)
extern      data    probe_level
extern      data    voltage_level
extern      data    motor_ctrl
extern      data    wflow_delayh 
extern      data    ledupdate_count 
extern      data    ondisp_pattern
extern      data    wflow_led_ctrl 
extern      data    water_flowerr  

; declare exported labels and symbols (defined in this
; module and referred to in other modules)
public      motor_onctrl

;Registers Used
;Static:
;Dynamic: r0

    
; code written to the relative code segment "MotoronCode"
; note that "MainCode" is a user-given name

    rseg    MotoronCode    ; rseg is the keyword to start a relative segment

motor_onctrl :                  ; this label is exported
    mov     a, voltage_level
    anl     a, #0x03            ; extract the voltage sense levels 
    cjne    a, #V_NORMAL,switch_off  ; switch off if voltage is not good
    mov     a, water_flowerr
    cjne    a, #INVALID,switch_off  ; switch off if water flow has been timedout
  ; Healthy condition so monitor the water levels
    clr     MOTOR               ; Switch ON the motor
    mov     a, probe_level      ; get the probe status  
    jb      TWHIGH, switch_off  ; water has  been to high tank switch-off the motor
    jnb     SWLOW, switch_off   ; no water in sump, switch-off the motor
    ; just set the display
    sjmp    set_ondisplay
 switch_off:
    mov     motor_ctrl, #MOTOR_OFF 
    mov     wflow_delayh, #ZERO     ; Disable water flow monitoring  
    sjmp    monfn_end 

    ; Control the display LEDS when the motor is ON
set_ondisplay:
    mov     a, ledupdate_count
    inc     a
    cjne    a, #LEDUPDATE_DELAY, update_count    ; exit for timeout
    mov     ledupdate_count, #ZERO              ; reset the count to 0
    mov     a, P1
    anl     a, #0xC3                ; donot disterb other pins, 
    mov     b, ondisp_pattern
    anl     b, #0x7C                ; mask other bits and also  DERROR off
    orl     a, b
    mov     P1, a                   ; update the display
;    update the pattern for next LED display cycle
    mov     r0, wflow_led_ctrl
    mov     a, ondisp_pattern
    rl      a 
    mov     ondisp_pattern, a               ; update the pattern, may be modified below
    ; no restriction on the using flow LED    
    cjne    r0, #VALID, restrict_disp    
    cjne    a, #0xBF, monfn_end
    mov     ondisp_pattern, #LED_PATTERN    ; reinit LED pattern  
    sjmp    monfn_end
restrict_disp:
    cjne    a, #0xDF, monfn_end
    mov     ondisp_pattern, #LED_PATTERN    ; reinit LED pattern
    sjmp    monfn_end
update_count:
    mov     ledupdate_count, a
    sjmp    monfn_end          

monfn_end:   
    ret

    end     ; end of code section
