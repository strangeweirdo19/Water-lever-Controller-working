; ------------- READS51 generated header -------------- 
; module  : C:\srib\water lc\software\wlcv00\timer0.asm
; created : 12:58:42, Wednesday, May 30, 2007
; Code    : Code for timer functions
; WLC programming   by B.Sridharan
; -----------------------------------------------------

; system variables definition program
; only direct memoty is used in the system 

; include SFR definitions (located in the include directory)
#include <sfr51.inc>


; declare relative segments to be used in this module (file)
TimerCode     segment code

; declare exported labels and symbols (defined in this
; module and referred to in other modules)

;exported function labels
public      tim0_init

;Registers Used
;Static:
;Dynamic: 

    rseg    TimerCode     ; This is a code segment

tim0_init:
    mov     tmod, #0x01
    mov     tcon, #0x00
    mov     tl0, #MS64_LOW
    mov     th0, #MS64_HIG
    clr     tf0         ; clear the overflow bit
    setb    tr0         ; start the timer 0
    ret

    end             ; terminate code segment
