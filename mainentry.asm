; ------------- READS51 generated header -------------- 
; module  : C:\srib\water lc\software\wlcv00\mainentry.asm
; created : 13:44:54, Tuesday, May 29, 2007
; This is main entry point after system reset
; WLC programming by B.Sridharan
; ----------------------------------------------------- 

; main assembly program

; include SFR definitions (located in the include directory)
#include <sfr51.inc>

; declare relative segments to be used in this module (file)
MainCode      segment code

; declare imported labels and symbols (defined in other 
; modules but referred to in this module)
extern      code    sys_init      ; function (label)
extern      code    var_init
extern      code    motor_offctrl
extern      code    motor_onctrl
extern      code    tim0_init
extern      code    get_vstate
extern      code    get_pstate
extern      code    set_pstate
extern      code    is_waterflow


; declare imported vars (defined in other 
; modules but referred to in this module)
extern      data    motor_ctrl 
extern      data    demo_control 
extern      data    setp_delayh  

; declare exported labels and symbols (defined in this
; module and referred to in other modules)
public      main_entry

;Registers Used
;Static:
;Dynamic: r3

; code written to an absolute code segment at the reset vector
; the following code is automatically added by the project manager
; it assumes there is a function called "_main"

    cseg at 0x00       ; cseg is the keyword to start an absolute code segment
                        ; Equivalent to cseg /n org 0x00
    ljmp    main_entry
    end            ; each segment must terminate with an "end" directive
    
; code written to the relative code segment "MainCode"
; note that "MainCode" is a user-given name

    rseg    MainCode    ; rseg is the keyword to start a relative segment
main_entry :                    ; this label is exported
    lcall   sys_init            ; Init the system  
    lcall   var_init            ; initialize the variables
    lcall   tim0_init           ; initialize the timer 0 for 64msec

sys_loop:
    lcall   get_vstate          ; how is voltage limit 
    mov     a, demo_control     ; invoke if demo is desired
    cjne    a, #VALID, normal_flow  ; proceed with the normal operation
    sjmp    join_sysloop        ; else skip reading probe
normal_flow:
    lcall   get_pstate          ; how is the probe status
join_sysloop:
    jnb     tf0, sysloop_end    ; no change of motor status if timer no overflow   
    mov     a, demo_control     ; invoke if demo is desired
    cjne    a, #VALID, skip_demoflow  ; proceed with the normal operation
demo_flow:    
    lcall   set_pstate          ; for the purpose of demo, set probe state as desired
skip_demoflow:     
    mov     r3, motor_ctrl
    cjne    r3, #MOTOR_OFF, when_motoron
when_motoroff:
    lcall   motor_offctrl       ; process when the motor is off
    sjmp    reset_tim0
when_motoron:
    lcall   motor_onctrl        ; process when the motor is on
    lcall   is_waterflow        ; monitor for the water flow
reset_tim0:    
    lcall   tim0_init
sysloop_end:
    sjmp    sys_loop            ; continue in the infinite loop
    ret

    end     ; end of code section
