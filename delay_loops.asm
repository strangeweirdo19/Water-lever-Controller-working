; ------------- READS51 generated header -------------- 
; module  : C:\srib\water lc\software\wlcv00\delay_loops.asm
; created : 10:31:46, Wednesday, May 30, 2007
; Code    : Code for various delay introduction
; WLC programming   by B.Sridharan
; ----------------------------------------------------- 

; include SFR definitions (located in the include directory)
#include <sfr51.inc>

; declare relative segments to be used in this module (file)
DelayloopCode      segment code

; declare exported labels and symbols (defined in this
; module and referred to in other modules)
public    usec4_delay

;Registers Used
;Static:
;Dynamic: r1

    rseg    DelayloopCode           ; rseg is the keyword to start a relative segment


usec4_delay:    ; register R1 passes the delay required
usec4_loop:
        nop
        nop
        djnz    r1, usec4_loop      ; keep repeating till r1 is zero
usec4fn_exit:
        ret

    end                 ; terminate segment "4usecCode"

