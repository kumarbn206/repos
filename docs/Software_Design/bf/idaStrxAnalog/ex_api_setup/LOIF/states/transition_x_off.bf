/**************************************************
 *                                                *
 * Owner: Maarten Lont                            *
 * Creation date: 29-Nov-2021                     *
 **************************************************
 *                                                *
 * Changelog [dd-mm-yyyy]: notes                  *
 *                                                *
 **************************************************/
 
// Transition the IP from Standby or On->Off
// - Keep the main enable low
// - Toggle the pon_ls

// Toggle LS + bypass the LLDO
LOIF.PON_CTL.PON_LS = 0;
LOIF.PON_CTL.LOI_IP_EN = 0;
LOIF.PON_CTL.FAST_ENABLE_M7 = 1;	// Short bias filters
LOIF.PON_CTL.FAST_PON_LDO = 1;		// Short LDO filters

