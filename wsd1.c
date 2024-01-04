#include <reg51.h>

sbit REF_PIN = P0^6;  // Reference input pin
sbit FLOW_PIN = P0^5; // Water flow input pin
sbit MAX_PIN = P0^4;  // Maximum water level input pin
sbit MIN_PIN = P0^3;  // Minimum water level input pin

sbit lightPin = P2^0;  // Light output pin

sbit L1 = P1^5;  // Light output pin
sbit L2 = P1^4;  // Light output pin
sbit L3 = P1^2;  // Light output pin

void delay(unsigned int ms) {
	while(ms--){
    TMOD = 0x01;    // Timer 0 Mode 1
    TH0= 0xFC;     //initial value for 1ms
    TL0 = 0x66;
    TR0 = 1;     // timer start
    while (TF0 == 0); // check overflow condition
    TR0 = 0;    // Stop Timer
    TF0 = 0;   // Clear flag
	}
}

void main() {
    unsigned int flow,max,min,i;
		L1 = 0;
		L2 = 0;
		L3 = 0;
	
    flow = 0;
		max = 0;
		min = 0;
		i = 0;
		
		REF_PIN = 1;
		FLOW_PIN = 1;
		MAX_PIN = 1;
		MIN_PIN = 1;
	
    lightPin = 1; // Initialize light pin as high (light off)
	
    while (1) {
			if(REF_PIN)
				{
        if(FLOW_PIN)
					flow++;      // Read flow pin value and add it to the sum
				if(MAX_PIN)
					max++;      // Read max pin value and add it to the sum
				if(MIN_PIN)
					min++;
        i++;
				delay(20);   // Delay for blinking effect
				}
      else if (i >= 10) {
				if (min < 1 && flow < 1) {
					L1 = 1;
					L2 = 1;
					L3 = 0;
					// Water level is at the minimum
					lightPin = 0; // Turn on the light
					delay(1000);   // Delay for blinking effect
					lightPin = 1; // Turn off the light
					delay(800);   // Delay for blinking effect
					} 
				else if (max >= 1 && flow >= 1) {
					// Water level is at the maximum and motor is ON
					L1 = 0;
					L2 = 0;
					L3 = 1;

					lightPin = 0; // Turn on the light
					delay(200);   // Delay for blinking effect
					lightPin = 1; // Turn off the light
		//			delay(100);   // Delay for blinking effect
					} 
				else if (flow >= 1) {
					L1 = 0;
					L2 = 1;
					L3 = 1;
					// Water flow is detected
					lightPin = 0; // Turn on the light to show motor is on
					} 
				else {
					L1 = 1;
					L2 = 1;
					L3 = 1;
					// Normal water level and no flow
					lightPin = 1; // Turn off the light
					}
        //RESET
				i = 0;
				flow = 0;
				max = 0;
				min = 0;
			}
		}
}