/**************************************************
 *                                                *
 * Owner: Maarten Lont                            *
 * Creation date: 29-Nov-2021                     *
 **************************************************
 *                                                *
 * Changelog [dd-mm-yyyy]: notes                  *
 *                                                *
 **************************************************/
 
// Transition the IP from On->Standby (assume we start from On)
// - Dont touch the pon_ls
// - Toggle the main enable
// - Raise the fast LDO start-up for 1us

// Toggle LS + bypass the LLDO
LOIF.PON_CTL.PON_LS = 1;
LOIF.PON_CTL.LOI_IP_EN = 0;
LOIF.PON_CTL.FAST_ENABLE_M7 = 1;	// Short the bias filters

