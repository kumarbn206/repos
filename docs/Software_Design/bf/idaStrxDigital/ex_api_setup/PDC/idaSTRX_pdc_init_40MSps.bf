/* idaSTRX_pdc_init_40MSps.bf */

/* assumed PDC up and running with basic init sequence, such as init LLDODIG, 
LLDO_PDC, MCGEN, ADC are assumed aleady done as well as PDC functional reset 
applied at least one 40 MHz after ADC clock divider was enabled */


/* switch for chirp profile 0 to the new default output sample rate of 40 MSps
 instead of (old) reset value of 80 MSps and set corresponding EQ coefficients */
PDC_MC.P0_PDC_CTL0.FSOUT_SEL=1;
PDC_MC.P0_PDC_CTL0.EQ_COEFF3=3695;// Salvo: it was -3695 conversion needed in hex
PDC_MC.P0_PDC_EQ1.EQ_COEFF1=11335;
PDC_MC.P0_PDC_EQ1.EQ_COEFF2=5086; // Salvo: it was -3695 conversion needed in hex
 
 
// enable DECI1 HOLD by default:
PDC_MC.PDC_PDC_OL_CNT.DECI1_HLD_DIS=0;

//Enable the clock160 always and not controlled by TE power management
TIMING_ENGINE.POWER_CONTROL_ENABLE.PDC_PWR_CTRL=0x1;  
TIMING_ENGINE.DYNAMIC_POWER_CONTROL_ENABLE.PDC_DY_PWR_CTRL=0x0;   


