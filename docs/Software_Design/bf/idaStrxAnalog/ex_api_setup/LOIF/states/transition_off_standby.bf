/**************************************************
 *                                                *
 * Owner: Maarten Lont                            *
 * Creation date: 23-Nov-2021                     *
 **************************************************
 *                                                *
 * Changelog [dd-mm-yyyy]: notes                  *
 *                                                *
 **************************************************/
 
// Transition the IP from Off->Standby (assume we start from off)
// - Keep the main enable low
// - Toggle the pon_ls
// - Raise the fast LDO start-up for 10us

// Toggle LS + bypass the LLDO
LOIF.PON_CTL.PON_LS = 1;
LOIF.PON_CTL.LOI_IP_EN = 0;
LOIF.PON_CTL.FAST_ENABLE_M7 = 1;	// Short
LOIF.PON_CTL.FAST_PON_LDO = 1;		// Short

// Wait for 10us
sleep(10);

// Release LLDO bypass
LOIF.PON_CTL.FAST_PON_LDO = 0;		// FILTER

