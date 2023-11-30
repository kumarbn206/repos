/* idaSTRX_chirppll_initRegisters.bf */

// Release reset of TE and chirpPLL_dig_core
#include "./config/idaSTRX_chirppll_releaseReset.bf"

// override reset values in chirpPLL dig core
#include "./config/idaSTRX_chirppll_cfg_ChirpGenerator.bf"
#include "./config/idaSTRX_chirppll_cfg_AAFC_default.bf"
#include "./config/idaSTRX_chirppll_cfg_SgdMod.bf"

// override reset values in chirpPLL PLL BW cfg
#include "./config/idaSTRX_chirppll_cfg_BW.bf"

// override reset values for other chirp profiles
#include "./config/idaSTRX_chirppll_cfg_Profiles.bf"

// cfg the chirpPLL in static power control state (no transition chirp to chirp)
#include "./config/idaSTRX_chirppll_cfg_StaticPwrCtrl.bf"

  


 
