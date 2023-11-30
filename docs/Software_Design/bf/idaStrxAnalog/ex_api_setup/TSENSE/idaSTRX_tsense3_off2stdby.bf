/* idaSTRX_tsense3_off2stdby.bf */
//  == Temperature Sensor IP is OFF state ==


#include "./idaSTRX_tsense3_OTPchange.bf"      // change of OTP hardwired reset values 

TEMPSENSOR3.PON_CTL.PON_LS=1;    //	Enable level shifters	(analog pin = d_pon_ls)
sleep(1); // wait before moving from STDBY to ON

//  == Temperature Sensor IP is NOW IN STANDBY MODE
 
	

