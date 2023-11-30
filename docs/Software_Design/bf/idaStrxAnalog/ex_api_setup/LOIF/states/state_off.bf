/**************************************************
 *                                                *
 * Owner: Maarten Lont                            *
 * Creation date: 23-Nov-2021                     *
 **************************************************
 *                                                *
 * Changelog [dd-mm-yyyy]: notes                  *
 *                                                *
 **************************************************/
 
// Everything is off (only control the main signals)
// Also bypass all filters
LOIF.PON_CTL.PON_LS = 0;
LOIF.PON_CTL.LOI_IP_EN = 0;
LOIF.PON_CTL.FAST_ENABLE_M7 = 1;	// Short
LOIF.PON_CTL.FAST_PON_LDO = 1;		// Short

