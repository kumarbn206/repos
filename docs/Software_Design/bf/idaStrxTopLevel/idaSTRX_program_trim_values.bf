
// Trimm all IPs except LLDO_PDC (LLDO_PDC will be powered later, and the registers of this IP are not accessible)
// Source https://www.collabnet.nxp.com/sf/go/doc495484

#include "../idaStrxAnalog/ex_api_setup/<IP1>/idaSTRX_<IP1>_OTP.bf"
.
.
.
#include "../idaStrxAnalog/ex_api_setup/<IP2>/idaSTRX_<IP1>_OTP.bf"

