; --------------------------------------------------- 
; module  : D:\remote system\remotev00\sfr51.inc
; created : Wednesday, December 06, 2006
; header file with the defs
; WLC programming by B.Sridharan
; -----------------------------------------------------
; definition for all the registers of the 89S51

;sfr
ACC        data    0xE0
B          data    0xF0
DPH        data    0x83
DPL        data    0x82
IE         data    0xA8
IP         data    0xB8
P0         data    0x80
P1         data    0x90
P2         data    0xA0
P3         data    0xB0
PCON       data    0x87
PSW        data    0xD0
SBUF       data    0x99
SCON       data    0x98
SP         data    0x81
TCON       data    0x88
TMOD       data    0x89
TL0        data    0x8A
TL1        data    0x8B
TH0        data    0x8C
TH1        data    0x8D

; --- 89S51 register bit fields --- page 6 of 89c51 
; IE 
EA         bit     0xAF
ES         bit     0xAC
ET1        bit     0xAB
EX1        bit     0xAA
ET0        bit     0xA9
EX0        bit     0xA8

; IP 
PS         bit     0xBC
PT1        bit     0xBB
PX1        bit     0xBA
PT0        bit     0xB9
PX0        bit     0xB8

; ACC for variable manupulation
SWMID       bit     0xE0
SWHIGH      bit     0xE1
SWLOW       bit     0xE2
TWLOW       bit     0xE3
TWHIGH      bit     0xE4
TWFLOW      bit     0xE5   
P0NA0       bit     0xE6    
P0NA1       bit     0xE7    
           

;P1
UNDER       bit     0x90
OVER        bit     0x91
SDLOW       bit     0x92 ; sump display low water
SDMID       bit     0x93
SDHIGH      bit     0x94
WDFLOW      bit     0x95
DERROR      bit     0x96
BUZZER      bit     0x97

; P2
SDL        bit     0xA7
SCL        bit     0xA6
AD13       bit     0xA5
AD12       bit     0xA4
ZEROCR     bit     0xA3
RESENB     bit     0xA2
FAN2       bit     0xA1
MOTOR      bit     0xA0

; P3
RD         bit     0xB7
WR         bit     0xB6
T1         bit     0xB5
T0         bit     0xB4
INT1       bit     0xB3
IRRECD     bit     0xB2
INT0       bit     0xB2
TXD        bit     0xB1
RXD        bit     0xB0

; PSW
CY         bit     0xD7
AC         bit     0xD6
F0         bit     0xD5
RS1        bit     0xD4
RS0        bit     0xD3
OV         bit     0xD2
P          bit     0xD0

; TCON
TF1        bit     0x8F
TR1        bit     0x8E
TF0        bit     0x8D
TR0        bit     0x8C
IE1        bit     0x8B
IT1        bit     0x8A
IE0        bit     0x89
IT0        bit     0x88

; SCON
SM0        bit     0x9F
SM1        bit     0x9E
SM2        bit     0x9D
REN        bit     0x9C
TB8        bit     0x9B
RB8        bit     0x9A
TI         bit     0x99
RI         bit     0x98

; All the magic numbers used in the system

ZERO        equ     0x00
ONE         equ     0x01
FOUR        equ     0x04

VALID       equ     0x5A
INVALID     equ     0xA5

LED_PATTERN equ     0xFB

; status of the system voltage levels
    
V_HIGH      equ     0x00
V_INVALID   equ     0x01
V_NORMAL    equ     0x02
V_LOW       equ     0x03

; control of motor
MOTOR_ON        equ     0x01
MOTOR_OFF       equ     0x00

; The number of cycles the probe patten has to be consistant
PCYCLE_COUNT    equ     20

; period for various demo conditions in seconds
SUMPMID_STATE   equ     10 
SUMPHIGH_STATE  equ     20 
MOTORON_STATE   equ     30
WFLOWON_STATE   equ     40 
WFLOWOFF_STATE  equ     50
WFLERR_STATE    equ     60

SUMPMID_VALUE   equ     0xCD    ; 0b11001101
SUMPHIGH_VALUE  equ     0xCF    ; 0b11001111
MOTORON_VALUE   equ     0xC7    ; 0b11000111
WFLOWON_VALUE   equ     0xE7    ; 0b11100111
WFLOWOFF_VALUE  equ     0xC7    ; 0b11000111
WFLERR_VALUE    equ     0xC7    ; 0b11000111  ; no specific state is reqd.


; 40/4 msec delay to check the uv/ov voltage/probe status of 1msec loop

MSLOOP_40   equ     40
MSLOOP_4    equ     4

; wait for the delivery while pumping water
WFLOW_DELAY     equ     110     ; 110 * 1sec = 110 secs, needs 16 bit storage 
WFLOW_DELAY_PRESET      equ     90 ; 90 * 1sec = 90 secs useful for demo 

; 1 sec counter value for 64 msec timer
ONESEC_DELAY    equ     16      ; 16 * 64 msec = 1 sec
PWR_ON_DELAY    equ     150      ; 150 * 64 msec = 9.6 secs  


; constant for running/error LED display
LEDUPDATE_DELAY  equ     8      ; 8 * 64msec      = 0.5 sec      

; timer 0 constants for 64msec delays ie, almost max
; calculation is 228(TH0)*255(TL0)*12(default prescalar)/11mhZ = 64 msec
MS64_LOW     equ       0x00 
MS64_HIG     equ       0x1A

; these short values are useful at testing time
    ; change no 1
;MSLOOP_40   equ     2
;MSLOOP_4    equ     2

; wait for the delivery while pumping water
;WFLOW_DELAY     equ     10     ; 110 * 1sec = 110 secs, needs 16 bit storage 

; 1 sec counter value for 64 msec timer
;ONESEC_DELAY    equ     1     ; 16 * 64 msec = 1 sec
;PWR_ON_DELAY    equ     2     ; 80 * 64 msec = 5 secs
   
; constant for running/error LED display
;LEDUPDATE_DELAY     equ     1   

; timer 0 constants for 64ms delays
;MS64_LOW     equ        0xE0     
;MS64_HIG     equ        0xFF 

; period for various demo conditions in seconds


;SUMPMID_STATE   equ     5 
;SUMPHIGH_STATE  equ     7 
;MOTORON_STATE   equ     9
;WFLOWON_STATE   equ     11 
;WFLOWOFF_STATE  equ     13
;WFLERR_STATE    equ     15
