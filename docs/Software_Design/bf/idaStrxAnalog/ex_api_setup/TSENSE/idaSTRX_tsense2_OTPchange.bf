/* idaSTRX_tsense2_OTPchange.bf */

// currently using the reset values from the register map, since no new values are available yet

TEMPSENSOR2.TDC_CAL0.VAL_A=0xA57A;     // Obtain from OTP/characterization - fitting parameter (analog pin = d_val_a); current value is a placeholder (reset value)
TEMPSENSOR2.TDC_CAL0.VAL_B=0xBA0D;     // Obtain from OTP/characterization - fitting parameter (analog pin = d_val_b); current value is a placeholder (reset value)
TEMPSENSOR2.TDC_CAL1.VAL_ALPHA=0x6D48; // Obtain from OTP/characterization - fitting parameter (analog pin = d_val_alpha); current value is a placeholder (reset value)
TEMPSENSOR2.TDC_CAL1.VAL_XOFFSET=0;    //	Obtain from OTP:	fitting parameter	(analog pin = d_val_xoffset) - currently using only a dummy value (reset value)


