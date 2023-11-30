/* idaSTRX_tsense4_off2stdby.bf */
//  == Temperature Sensor IP is OFF state ==


#include "./idaSTRX_tsense4_OTPchange.bf"      // change of OTP hardwired reset values 

TEMPSENSOR4.PON_CTL.PON_LS=1;    //	Enable level shifters	(analog pin = d_pon_ls)
sleep(1); // wait before moving from STDBY to ON

//  == Temperature Sensor IP is NOW IN STANDBY MODE
 
	

