; ------------- READS51 generated header -------------- 
; module  : C:\srib\water lc\software\wlcv00\mainc_fn.c
; created : 13:51:16, Tuesday, May 29, 2007
; This is system init routine executed after power up
; WLC programme by B.Sridharan
; -----------------------------------------------------

; initialization routines

; include SFR definitions (located in the include directory)
#include <sfr51.inc>

; declare relative segments to be used in this module (file)
SysinitCode      segment code

; declare exported labels and symbols (defined in this
; module and referred to in other modules)
public    sys_init

;Registers Used
;Static:
;Dynamic: 

    rseg    SysinitCode        ; rseg is the keyword to start a relative segment

sys_init:
    mov     p0, #0xFF   ; Output port with high impedance input, so that probes shall be read                     
    mov     p1, #0xFF   ; Output port with logic 1, all LEDs OFF, relay OFF
    mov     p2, #0xFF   ; Output port with logic 1              
    mov     p3, #0xFF   ; Output port with logic 1
    ret

    end                 ; terminate segment "SysinitCode"

