; ------------- READS51 generated header -------------- 
; module  : C:\srib\water lc\software\wlcv00\get_vstate.asm
; created : 09:18:54, Wednesday, May 30, 2007
; Function to update the voltage levels
; WLC programming by B.Sridharan
; ----------------------------------------------------- 

; include SFR definitions (located in the include directory)
#include <sfr51.inc>

; declare relative segments to be used in this module (file)
GetvstateCode      segment code

; declare imported labels and symbols (defined in other 
; modules but referred to in this module)
extern      code    usec4_delay      ; function (label)

; declare imported vars (defined in other 
; modules but referred to in this module)
extern      data    voltage_level 
extern      data    vtemp_level 

; declare exported labels and symbols (defined in this
; module and referred to in other modules)
public    get_vstate

;Registers Used
;Static:
;Dynamic: 

    rseg    GetvstateCode        ; rseg is the keyword to start a relative segment

get_vstate:
    mov     a, p1               ; load the voltage levels for comparison
    anl     a, #0x03            ; extract the voltage sense levels
    cjne    a, voltage_level, vstate_chg 
    sjmp    vstatefn_exit
vstate_chg:
    mov     a, p1               ; load the voltage levels for comparison
    anl     a, #0x03            ; extract the voltage sense levels
    mov     vtemp_level, a      ; get it to a temp storage
    mov     r0, #MSLOOP_40      ; sampling duration is 40 msec
poolv_loop:
    mov     a, p1               ; load the voltage levels for comparison
    anl     a, #0x03            ; extract the voltage sense levels 
    cjne    a, vtemp_level, vstatefn_exit ; get out if misses out  
    mov     r1, #250
    lcall   usec4_delay         ; introduces 4 micro sec delay * r1 = 1 msec
    djnz    r0, poolv_loop       ; keep sampling for at least 40 times max
    mov     voltage_level, vtemp_level ; update the status and exit
 ; added oneline for testing because of hardware voltage sensing problem
 ;   mov     voltage_level, #V_NORMAL   
vstatefn_exit:
    ret

    end                 ; terminate segment

