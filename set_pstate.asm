; ------------- READS51 generated header -------------- 
; module  : D:\water lc\software\wlcv00\set_pstate.asm
; created : 15:19:13, Friday, June 08, 2007
; Function to automatically update the probe status/waer levels
; WLC programming by B.Sridharan
; ----------------------------------------------------- 

; include SFR definitions (located in the include directory)
#include <sfr51.inc>

; declare relative segments to be used in this module (file)
SetpstateCode      segment code

; declare imported labels and symbols (defined in other 
; modules but referred to in this module)

; declare imported vars (defined in other 
; modules but referred to in this module)
extern      data    probe_level 
extern      data    setp_delayh
extern      data    setp_delayl
extern      data    wflow_delayh

; declare exported labels and symbols (defined in this
; module and referred to in other modules)
public    set_pstate

;Registers Used
;Static:
;Dynamic: 

    rseg    SetpstateCode        ; rseg is the keyword to start a relative segment

set_pstate:
    mov     a, setp_delayh      ; get the delay counter 
    jz      setpfn_end          ; no demo reqd, just exit
    inc     setp_delayl         ; increment for every 64 msec
    mov     a, setp_delayl      ; get the delay counter 
    cjne    a, #ONESEC_DELAY, setpfn_end 
    mov     setp_delayl, #ZERO      ; wait for another one sec
    inc     setp_delayh             ; increment high count by 1
    mov     a, setp_delayh          ; store the updated count bac
nxt_sumpmid:
    cjne    a, #SUMPMID_STATE, nxt_sumphigh     
    ; time to display sump water mid level 
    mov     probe_level, #SUMPMID_VALUE
    sjmp    setpfn_end
nxt_sumphigh:
    cjne    a, #SUMPHIGH_STATE, nxt_motoron     
    ; time to display sump water high level 
    mov     probe_level, #SUMPHIGH_VALUE
    sjmp    setpfn_end
nxt_motoron:
    cjne    a, #MOTORON_STATE, nxt_wflowon     
    ; time to display motor is ON 
    mov     probe_level, #MOTORON_VALUE
    sjmp    setpfn_end
nxt_wflowon:
    cjne    a, #WFLOWON_STATE, nxt_wflowoff     
    ; time to display motor is ON and water flowing 
    mov     probe_level, #WFLOWON_VALUE
    sjmp    setpfn_end
nxt_wflowoff:
    cjne    a, #WFLOWOFF_STATE, nxt_wflerr     
    ; time to display motor is ON and no water flowing 
    mov     probe_level, #WFLOWOFF_VALUE
    sjmp    setpfn_end

nxt_wflerr:
    cjne    a, #WFLERR_STATE,  setpfn_end    
    ; time to display no-water flow error condition 
    mov     probe_level, #WFLERR_VALUE
    mov     wflow_delayh, #WFLOW_DELAY_PRESET   ; load preset, so need not wait for 110 secs 
    mov     setp_delayh, #ZERO             ; reached the end of demo stop inc of counters
    sjmp    setpfn_end

setpfn_end:
    ret
   
    end                 ; terminate segment

