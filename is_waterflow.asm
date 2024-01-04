; ------------- READS51 generated header -------------- 
; module  : C:\srib\water lc\software\wlcv00\is_waterflow.asm
; created : 09:06:40, Friday, June 01, 2007
; Function monitors the flow of water into the tank
; WLC programming   by B.Sridharan
; ----------------------------------------------------- 
; include SFR definitions (located in the include directory)
#include <sfr51.inc>

; declare relative segments to be used in this module (file)
WaterflowCode      segment code

; declare imported labels and symbols (defined in other 
; modules but referred to in this module)
; extern      code          ; function (label)

; declare imported vars (defined in other 
; modules but referred to in this module)
extern      data    probe_level
extern      data    motor_ctrl 
extern      data    wflow_delayh
extern      data    wflow_delayl
extern      data    wflow_led_ctrl 
extern      data    water_flowerr  

; declare exported labels and symbols (defined in this
; module and referred to in other modules)
public      is_waterflow


;Registers Used
;Static:
;Dynamic: 

    
; code written to the relative code segment "WaterflowCode"
; note that "MainCode" is a user-given name

    rseg    WaterflowCode    ; rseg is the keyword to start a relative segment

is_waterflow :                
    mov     a, wflow_delayh     ; get the delay counter 
    jz      wflowfn_end         ; no monitoring reqd, just exit
    mov     a, probe_level      ; get the probe status  
    jb      TWFLOW, wflow_on  
    ; no water flow started
    mov     wflow_led_ctrl, #INVALID    ;hence do not allow the LED for rolling display
    mov     a, wflow_delayl             ; get the delay counter 
    inc     a                           ; increment for every 64 msec
    mov     wflow_delayl, a             ; update the count in the memory
    cjne    a, #ONESEC_DELAY, wflowfn_end 
    ; one sec delay is reached here 
    mov     wflow_delayl, #ZERO         ; reset to 0   
    mov     a, wflow_delayh             ; get the delay counter 
    inc     a
    mov     wflow_delayh, a             ; store the updated count bac
    cjne    a, #WFLOW_DELAY, wflowfn_end     ; time limit not exceed yet
    ; time delay has reached, probabily serious motor problem, inform the same
    setb    MOTOR                       ; shut the motor
    mov     water_flowerr, #VALID       ; water flow error has occured
    sjmp    wflowfn_end  
wflow_on: 
    ; water has started flowing 
    mov     wflow_delayh, #ONE      ; reinit the flow counters
    mov     wflow_delayl, #ZERO     
    mov     wflow_led_ctrl, #VALID  ; hence allow the LED for rolling display

wflowfn_end:   
    ret


    end     ; end of code section
