/* idaSTRX_tsense1_stdby2on.bf */
//  == Temperature Sensor IP is STDBY state ==

TEMPSENSOR1.PON_CTL.PWR_EN=1;    //	Enable TDC (analog pin = d_power_enable)


//  == Temperature Sensor IP is NOW IN ON mode and can be triggered to do a temperature conversion (using the TDC_CTL.START field)
// by default (HW reset value), TDC_CTL.EXT_TRIG_EN = 0, so SW can trigger the conversion.
 
	

