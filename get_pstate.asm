; ------------- READS51 generated header -------------- 
; module  : C:\srib\water lc\software\wlcv00\get_pstate.asm
; created : 11:01:14, Wednesday, May 30, 2007
; Function to update the probe status/waer levels
; WLC programming by B.Sridharan
; ----------------------------------------------------- 

; include SFR definitions (located in the include directory)
#include <sfr51.inc>

; declare relative segments to be used in this module (file)
GetpstateCode      segment code

; declare imported labels and symbols (defined in other 
; modules but referred to in this module)
extern      code    usec4_delay      ; function (label)

; declare imported vars (defined in other 
; modules but referred to in this module)
extern      data    probe_level 
extern      data    pprev_level
extern      data    pnew_level
extern      data    psample_count 
extern      data    water_flowerr
extern      data    motor_ctrl

; declare exported labels and symbols (defined in this
; module and referred to in other modules)
public    get_pstate

;Registers Used
;Static:
;Dynamic: 

    rseg    GetpstateCode        ; rseg is the keyword to start a relative segment

get_pstate:
    mov     a, p0               ; load the voltage levels for comparison
    jz      pstatefn_exit       ; on the negative half cycle, just exit
    mov     r1, #250            ; allow 1ms for edges to stabilize
    lcall   usec4_delay         ; introduces 4 micro sec delay * r1 = 1 msec
    mov     a, p0               ; in case of glitch just exit
    jz      pstatefn_exit
    cjne    a, probe_level, pstate_chg
    sjmp    pstatefn_exit
pstate_chg:
    mov     pnew_level, a       ; get it to a temp storage
    mov     r0, #MSLOOP_4       ; sampling duration is 4 msec and 4 samples
poolp_loop:
    mov     a, p0               ; load the voltage levels for comparison
    cjne    a, pnew_level,pstatefn_exit       ; get out if misses out
    mov     r1, #250
    lcall   usec4_delay         ; introduces 4 micro sec delay * r1 = 1 msec
    djnz    r0, poolp_loop      ; keep sampling for 4 times 
; probe status is consistant for one half cycle
    cjne    a, pprev_level, is_newsample  
    inc     psample_count
    mov     a, psample_count
    cjne    a, #PCYCLE_COUNT, pstatefn_exit   ; wait for some more cycles
    mov     probe_level, pprev_level ; update the status and check for valid combinations
tank_probe:
    mov     a, probe_level
    anl     a, #0x18
    cjne    a, #0x10, sump_probe ; if tank high probe is high but low probe is low then error
    sjmp    probe_error
sump_probe:
    mov     a, probe_level
    anl     a, #0x05
    cjne    a, #0x01, pstatefn_exit ; if sump med probe is high but low probe is low the error
probe_error:
    mov     motor_ctrl, #MOTOR_OFF      ; shut the motor
    mov     water_flowerr, #VALID     ; serious error has occured
    sjmp    pstatefn_exit
is_newsample:
; in case of new sample obseved then clear the count and look for stability of the pattern
    mov     pprev_level,pnew_level 
    mov     psample_count, #ZERO
pstatefn_exit:
    ret

    end                 ; terminate segment

