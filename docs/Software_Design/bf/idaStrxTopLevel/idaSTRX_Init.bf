// STEP 0: HW Autonomous Start

// STEP 0.5: Boot
// SoC Init => Executed Prior to RFE FW, by bootloader, Minimal Validaton App (APP-M7) or in CMM
// #include "../idaStrxInfra/SOC/idaSTRX_soc_init_rfe.bf" // This bitfields are not part of RFE. It is application for RFE IOs,

// STEP1: Core Start-Up Main
// SW Only

// STEP2: Init SW Only Units (including Safety Manager)
// SW Only

// STEP3: Init APB2SPI
// #include "../idaStrxInfra/APB2SPI/idaSTRX_apb2spi_init.bf" // rfeHwSpi_setGrant() // This bitfields are not part of RFE. It is application for RFE IOs,

// STEP4: Init Other Digital IPs
// Nothing for now

// STEP 5: SW OCOTP Read
// Trim values stored in local variable, also because we need to program LLDOPDC later not with other IPs.
// Variant valued stored in local variable
// SW Only

// STEP6: SPIM Init => Mani + Mani Kai init, to close today, need to understand the CRC error from Kai
// PDC, ADC SPI slaves are not initialized in thisstep, because registers of these IPs are suppplied by LLDOPDC which is not self-starting.
// Clocks for analog are directly from XO therefore we need to check XOSC OK.
#include "../idaStrxDigital/ex_named_scripts/idaSTRX_spim_init.bf"

// STEP7: Program Trim All IPs
// Except for LLDOPDC that will be powered later, the registers of LLDOPDC (and ADC) are not accessible
// Note: GBIAS must to be trimmed before LLDODIG is trimmed, see ../idaStrxAnalog/ex_api_setup/"LLDODIG/idaSTRX_lldodig_off2stdby.bf
//Comment out this include for now as this sw sequence is not ready yet
//#include "idaSTRX_program_trim_values.bf" // SW sequence to be generated directly from OTP xls.

// STEP 8: Config GLDO
// 1.3V output configuration
#include "../idaStrxAnalog/ex_api_setup/GLDO/idaSTRX_gldo_initRegisters.bf" 
#include "../idaStrxAnalog/ex_api_setup/GLDO/idaSTRX_gldo_stdby2on.bf" // This is only for 1.3V (as 1.45 is self starting) is for TX buffers and PA

// STEP 9: Config GBIAS
#include "../idaStrxAnalog/ex_api_setup/GBIAS/idaSTRX_gbias_initRegisters.bf" 
#include "../idaStrxAnalog/ex_api_setup/GBIAS/idaSTRX_gbias_stdby2on.bf"

// STEP 10: XOSC Error Check
#include "../idaStrxDigital/ex_api_setup/SPIM/STATUS/idaSTRX_spim_rfe_raw_status_mcgen_v9ana.bf"
#include "../idaStrxDigital/ex_api_setup/ISM/idaSTRX_ism_err_mcu_reset.bf"

// STEP 11: Analog IPs Init
#include "../idaStrxAnalog/ex_api_setup/ATB/idaSTRX_atb_initRegisters.bf"
#include "../idaStrxAnalog/ex_api_setup/CHIRPPLL/idaSTRX_chirppll_initRegisters.bf"
#include "../idaStrxAnalog/ex_api_setup/LLDODIG/idaSTRX_lldodig_initRegisters.bf"  
#include "../idaStrxAnalog/ex_api_setup/LLDOPDC/idaSTRX_lldopdc_initRegisters.bf"
#include "../idaStrxAnalog/ex_api_setup/LOIF/idaSTRX_loif_initRegisters.bf" 
#include "../idaStrxAnalog/ex_api_setup/MCGEN/idaSTRX_mcgen_initRegisters.bf" 
#include "../idaStrxAnalog/ex_api_setup/RCOSC/idaSTRX_rcosc_initRegisters.bf" 
#include "../idaStrxAnalog/ex_api_setup/RX/idaSTRX_rx_initRegisters.bf" 
#include "../idaStrxAnalog/ex_api_setup/RXBIST/idaSTRX_rxbist_initRegisters.bf" 
#include "../idaStrxAnalog/ex_api_setup/TX/idaSTRX_tx_initRegisters.bf" 
//#include "../idaStrxAnalog/ex_api_setup/TSENSE/idaSTRX_tsense_initRegisters.bf" // empty use bf per Tsense
// per Tsense, this are register init functions
#include "../idaStrxAnalog/ex_api_setup/TSENSE/idaSTRX_tsense1_OTPchange.bf" // values from validation, what about OTP value here?
#include "../idaStrxAnalog/ex_api_setup/TSENSE/idaSTRX_tsense2_OTPchange.bf" // values from validation
#include "../idaStrxAnalog/ex_api_setup/TSENSE/idaSTRX_tsense3_OTPchange.bf" // values from validation
#include "../idaStrxAnalog/ex_api_setup/TSENSE/idaSTRX_tsense4_OTPchange.bf" // values from validation

// AP Mani: do we need to initialize TE? idaSTRX_TE_initRegisters.bf \ idaSTRX_TE_Interrupt.bf 
// interupt config is part of functional configuration after RFE init. no step required in Init for Timing engine
// AP Mani: How about TX clocks managed by TE, part of Global STBY2ON idaSTRX_stby2on.bf?
// TX clock should be managed locally instead of TE. This config  should be part of TX off2stby.bf 
// In TX stdby2off.bf clock can be turned off, otherwise clock will be always running. 
// For Bringup, it is okay to keep the clock always on.
// AP Mani: Trigger the HW designer to add above setting to the TX off2stby.bf
// AP Mani: check clock enabling for PDC and chirp PLL 

// STEP 12: Analog IPs OFF2STDBY 
#include "idaSTRX_off2stby.bf"

// STEP 13 LLDOPDC ON
// OFF2STBY LDOPDC (LLDOPDC also powers up ADC digital and registers)
// LLDOPDC clock enabling and release reset will be done here. 
// AP Mani: to add this setting before we proceed with following bf files. 
#include "../idaStrxAnalog/ex_api_setup/LLDOPDC/idaSTRX_lldopdc_off2stdby.bf" 
#include "../idaStrxAnalog/ex_api_setup/LLDOPDC/idaSTRX_lldopdc_stdby2on.bf" //LLDOPDC needs to be on before writing to RXADC and PDC as suggested by Francoise.

// Programming Trimming values to LLDOPDC registers
//#include "../idaStrxAnalog/ex_api_setup/LLDOPDC/..."

// Config ADCs
// Enable clock and release reset for PDC. Only PDC1 clock and reset to be released
#include "../idaStrxDigital/ex_api_setup/SPIM/IP/idaSTRX_spim_pdc1_clock_reset_enable.bf"
// Init PDC with power management disabled from TE and set ti default 40MSPS mode
#include "../idaStrxDigital/ex_api_setup/PDC/idaSTRX_pdc_init_40MSps.bf" //

#include "../idaStrxDigital/ex_api_setup/SPIM/IP/idaSTRX_spim_adc1_clock_reset_enable.bf"
#include "../idaStrxDigital/ex_api_setup/SPIM/IP/idaSTRX_spim_adc2_clock_reset_enable.bf"
#include "../idaStrxDigital/ex_api_setup/SPIM/IP/idaSTRX_spim_adc3_clock_reset_enable.bf"
#include "../idaStrxDigital/ex_api_setup/SPIM/IP/idaSTRX_spim_adc4_clock_reset_enable.bf"

//ADC init register cannot be done earlier as registers are powered by PDCLLDO. 
//Programimg trimming values to ADC should also be done here. 
#include "../idaStrxAnalog/ex_api_setup/RXADC/idaSTRX_rxadc_initRegisters.bf" 

// STEP 14: Config Local Bias
// SKIP: Integrated with Step 9

// STEP 15: MCGEN ON \ Tune ADPLL
// MCGEN is protected with an LDO, and the temperature drift should be representative
// But still better all IPs are powered ON before MCGEN config
// tuning.bf -> covered by idaSTRX_mcgen_stdby2on.bf
// Note: ADPLL when powered off will lose the content of registers, hence ADPLL register init need to be done in this script not in "idaSTRX_mcgen_initRegisters.bf"
#include "../idaStrxAnalog/ex_api_setup/MCGEN/idaSTRX_mcgen_stdby2on.bf"

// STEP 16: CGU
// cgu.bf

// STEP 17: Clock Handshake
// SW synch

// STEP 18: RX ADC Calibration
// RCOSC Cap Bank is supplied by GLDO1.45
// RCOSC Calibration FSM is powered by LLDODIG 
// RCOSC OFF2STDBY.bf => WHY NOT WITH ALL OTHER IPs
#include "../idaStrxAnalog/ex_api_setup/RCOSC/idaSTRX_rcosc_off2stdby.bf" // PON LS
// Trigger RCOSC Calib => N\M is the result
#include "../idaStrxAnalog/ex_api_setup/RCOSC/idaSTRX_rcosc_stdby2on.bf"  // Enable, calibrate, wait
// Switchig RCOSC off, will not be used at run-time
#include "../idaStrxAnalog/ex_api_setup/RCOSC/idaSTRX_rcosc_on2stdby.bf"
#include "../idaStrxAnalog/ex_api_setup/RCOSC/idaSTRX_rcosc_stdby2off.bf"
// RCOSC_RES = result from RCOSC measurement, as calculated in SW using the N and M values from the RCOSC.
// Here a SW C routine will compute RCOSC_RES from M\N
// Write RCOSC_RES to ADCs
#include "../idaStrxAnalog/ex_api_setup/RXADC/idaSTRX_rxadc_calibrate.bf"

// STEP: 19 ATB ADC Calibration
// Start-up Calibration special ATB OFF2STBY, STBY2ON
#include "../idaStrxAnalog/ex_api_setup/ATB/idaSTRX_atb_stdby2on.bf"
// ATB Calib SW
// SW Only
#include "../idaStrxAnalog/ex_api_setup/ATB/idaSTRX_atb_on2stdby.bf"
// Start-up Calibration special ATB ON2STBY, STBY2OFF

// STEP 20: Safety Sensors
// ISM_init.bf // which monitors in which phase
#include "../idaStrxDigital/ex_named_scripts/idaSTRX_ism_init.bf"
// ISM_safety_sensor_reset.bf

// Now unmask loss of lock bit in SPIM to enable the initiating reset to the chip incase adpll unlocks
// At reset unlock flag is masked but between the resets of the mcgen (only mcgen) then we need to do ../idaStrxDigital/ex_api_setup/SPIM/idaSTRX_spim_adpll_lossoflock_mask.bf
#include "../idaStrxDigital/ex_api_setup/SPIM/idaSTRX_spim_adpll_lossoflock_unmask.bf"

// STEP 21: ERROR_N Check
// SW Only
// FCCU Start-up checks => ideally at every step

// STEP 22: FIT1
// SKIP for bring Up

// STEP 23: FIT2
// SKIP for bring Up

// STEP 24: Reset Errors
// SKIP for bring up only needed when FIT is executed

// STEP 25:
// SW: Configuration

