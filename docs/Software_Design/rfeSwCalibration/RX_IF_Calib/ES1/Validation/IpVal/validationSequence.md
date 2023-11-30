
# Validation plan

## Current situation

### A - rfeIpValFw sequence integrated -> working 

1. rfeSwInit                                                                    ->m7

2. rfe power manager all ON                                                     ->m7

3. rfeSwCalibration_rfIfValiationInit                                           ->m7

4. rfeSwCalibration_rfChainCalib                                                ->m7

5. Call rfeSwCalibration_rxIfCalibrate_validatev2 + restore validation settings ->m7

6. Enable fgpa                                                                  ->Maiwenn

7. Collect samples                                                              ->Maiwenn

8. Next RX IF loop starting from #7                                             ->Maiwenn


### B - rfeIpValFw sequence with rfe proxy ->  working need of rfeProxy without timeout!

1. rfeSwInit                                                                    ->m7

2. rfe power manager all ON                                                     ->m7

3. rfeSwCalibration_rfIfValiationInit                                           ->m7

4. rfeSwCalibration_rfChainCalib                                                ->m7

5. Call rfeSwCalibration_rxIfCalibrate_validatev2 + restore validation settings ->Maiwenn

6. Enable fgpa                                                                  ->Maiwenn

7. Collect samples                                                              ->Maiwenn

8. Next RX IF loop starting from #5                                             ->Maiwenn

### C - rfeIpValFw Maiwenn's init -> working working need of rfeProxy without timeout!
1. rfeSwInit                                                                    ->m7

2. rfe power manager all ON                                                     ->m7

3. rfeSwCalibration_rfIfValiationInit                                           ->Maiwenn

4. rfeSwCalibration_rfChainCalib                                                ->m7

5. Call rfeSwCalibration_rxIfCalibrate_validatev2 + restore validation settings ->Maiwenn

6. Enable fgpa                                                                  ->Maiwenn

7. Collect samples                                                              ->Maiwenn

8. Next RX IF loop starting from #3                                             ->Maiwenn

### D - rfeIpValFw Maiwenn's init & power On ->  working working need of rfeProxy without timeout!

1. rfeSwInit                                                                    ->m7

2. rfe power manager all ON                                                     ->Maiwenn

3. rfeSwCalibration_rfIfValiationInit                                           ->Maiwenn

4. rfeSwCalibration_rfChainCalib                                                ->to be implemented by Maiwenn

5. Call rfeSwCalibration_rxIfCalibrate_validatev2 + restore validation settings -> Maiwenn

6. Enable fgpa                                                                  ->Maiwenn

7. Collect samples                                                              ->Maiwenn

8. Next RX IF loop starting from #3                                             ->Maiwenn

### E - rfeIpValFw Maiwenn's init & rfCalibChain & power On-> **not tested**

1. rfeSwInit                                                                    ->m7

2. rfe power manager all ON                                                     ->Maiwenn

3. rfeSwCalibration_rfIfValiationInit                                           ->Maiwenn

4. rfeSwCalibration_rfChainCalib                                                ->to be implemented by Maiwenn

5. Call rfeSwCalibration_rxIfCalibrate_validatev2 + restore validation settings -> Maiwenn

6. Enable fgpa                                                                  ->Maiwenn

7. Collect samples                                                              ->Maiwenn

8. Next RX IF loop starting from #3                                             ->Maiwenn

## Functions implemented in m7 
Ensure that these bits have the shown value before calling RX IF calib v2 after Validiation measurements
```
Timing_Engine.CHIRP_GLOBAL_CTL.ENABLE_PROFILE_RESET = 1

Timing_Engine.CHIRP_GLOBAL_CTL.PROFILE_REPEAT_COUNT_VAL = 0

PDC1.PDC_CTL4.DATA_ACTIVE_SET = 0

PDC_MC.PDC_BYPASSES.BYPASS_FSHIFT2 = 0

PDC_MC.PDC_BYPASSES.BYPASS_FSHIFT3 = 0

PDC1.PDC_CTL6.FS_DIV5_EN = 1
```
Above is check is implemented in function `rfeSwCalibration_rxIfValidationRegisterCheck`, which will issue and rfe error if fails

### rfeSwCalibration_rfIfValiationInit
No inputs needed
```
void rfeSwCalibration_rfIfValiationInit(
    RFE_ERROR_FUNCTION_PARAMETER )
{
    // == Inits ==

    rfeHwCsi2_init( rfe_effectiveSamplingFrequency_40MHz_e,
                    rfe_pdcBitwidth_16bit_e,
                    rfeHwCsi2_clockspeed_continous_mode_e,
                    RFE_ERROR_FUNCTION_ARGUMENT );

    //== UNCLOCKING ==
    // unlock all RX
    rfeHwRx_unlockOrLockProtectedReg( rfe_rxIndex_1_e,
                                      false,
                                      RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwRx_unlockOrLockProtectedReg( rfe_rxIndex_2_e,
                                      false,
                                      RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwRx_unlockOrLockProtectedReg( rfe_rxIndex_3_e,
                                      false,
                                      RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwRx_unlockOrLockProtectedReg( rfe_rxIndex_4_e,
                                      false,
                                      RFE_ERROR_FUNCTION_ARGUMENT );
    // unlock McGen
    rfeHwMcgen_unlockOrLockProtectedRegisters(
                                               false,
                                               RFE_ERROR_FUNCTION_ARGUMENT );

    // == StandbyToOn ==
    // Atb
    rfeHwAtb_standbyToOn( RFE_ERROR_FUNCTION_ARGUMENT );
    // Rxs's
    rfeHwRx_standbyToOn( rfe_rxIndex_1_e,
                                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwRx_standbyToOn( rfe_rxIndex_2_e,
                                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwRx_standbyToOn( rfe_rxIndex_3_e,
                                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwRx_standbyToOn( rfe_rxIndex_4_e,
                                            RFE_ERROR_FUNCTION_ARGUMENT );
    // ADCs
    rfeHwRxAdc_offToOn( rfeHwRxAdc_adcIndex_1_e,
                        RFE_ERROR_FUNCTION_ARGUMENT );
    // LOIF
    rfeHwLoif_standbyToOn( RFE_ERROR_FUNCTION_ARGUMENT );

    // == Inits ==
    // Calibration done  in labView test case for RX IF Calib v2
    rfeHwLoif_setMode( rfeHwLoif_mode_standalone_e,
                       RFE_ERROR_FUNCTION_ARGUMENT );

    // == Tsense ==
    rfeHwTsense_setModeOfOperation( rfe_temperatureSensorIndex_rx_e,
                                    rfeHwTsense_operationMode_acquisition_e,
                                    RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTsense_setModeOfOperation( rfe_temperatureSensorIndex_xo_e,
                                    rfeHwTsense_operationMode_acquisition_e,
                                    RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTsense_setModeOfOperation( rfe_temperatureSensorIndex_tx34_e,
                                    rfeHwTsense_operationMode_acquisition_e,
                                    RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTsense_setModeOfOperation( rfe_temperatureSensorIndex_tx12_e,
                                    rfeHwTsense_operationMode_acquisition_e,
                                    RFE_ERROR_FUNCTION_ARGUMENT );

    rfeHwTSense_startTemperatureConversion( rfe_temperatureSensorIndex_rx_e,
                                            rfeHwTsense_conversionMode_continuous_e,
                                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTSense_startTemperatureConversion( rfe_temperatureSensorIndex_xo_e,
                                            rfeHwTsense_conversionMode_continuous_e,
                                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTSense_startTemperatureConversion( rfe_temperatureSensorIndex_tx34_e,
                                            rfeHwTsense_conversionMode_continuous_e,
                                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTSense_startTemperatureConversion( rfe_temperatureSensorIndex_tx12_e,
                                            rfeHwTsense_conversionMode_continuous_e,
                                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTSense_startTemperatureConversion( rfe_temperatureSensorIndex_rx_e,
                                            rfeHwTsense_conversionMode_mono_e,
                                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTSense_startTemperatureConversion( rfe_temperatureSensorIndex_xo_e,
                                            rfeHwTsense_conversionMode_mono_e,
                                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTSense_startTemperatureConversion( rfe_temperatureSensorIndex_tx34_e,
                                            rfeHwTsense_conversionMode_mono_e,
                                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTSense_startTemperatureConversion( rfe_temperatureSensorIndex_tx12_e,
                                            rfeHwTsense_conversionMode_mono_e,
                                            RFE_ERROR_FUNCTION_ARGUMENT );
    /* This get temperature gives error since we don't wait what we should
     *
     */
    rfeWait_usec(100ul, RFE_ERROR_FUNCTION_ARGUMENT);
    rfeHwTsense_getTemperature( rfe_temperatureSensorIndex_rx_e,
                                RFE_ERROR_FUNCTION_ARGUMENT );
//    rfeHwTsense_getTemperature( rfe_temperatureSensorIndex_xo_e,
//                                RFE_ERROR_FUNCTION_ARGUMENT );
//    rfeHwTsense_getTemperature( rfe_temperatureSensorIndex_tx34_e,
//                                RFE_ERROR_FUNCTION_ARGUMENT );
//    rfeHwTsense_getTemperature( rfe_temperatureSensorIndex_tx12_e,
//                                RFE_ERROR_FUNCTION_ARGUMENT );

    // == CHIRP_PLL SETTINGS ==e
    rfeHwChirppll_configSafetyMonitor(
                                       false,
                                       false,
                                       RFE_ERROR_FUNCTION_ARGUMENT );
    // == // TE SETTINGS ==
    // number of samples 5th variable, check with value of for rx enable?

    rfeHwTe_chirpProfileParams_t teChirpProfile;
    rfeHwTe_chirpProfileParams_t* pTeChirpProfile = &teChirpProfile;

    pTeChirpProfile->chirpIntervalTimeTicks = 200;
    pTeChirpProfile->dwellTimeTicks = 10;
    pTeChirpProfile->settleTimeTicks = 10;
    pTeChirpProfile->acquisitionTimeTicks = 128;
    pTeChirpProfile->txEnable = 0;
    pTeChirpProfile->txTransmissionEnable = 0;
    pTeChirpProfile->txPhaseRotation[0] = 0;
    pTeChirpProfile->txPhaseRotation[1] = 0;
    pTeChirpProfile->txPhaseRotation[2] = 0;
    pTeChirpProfile->txPhaseRotation[3] = 0;
    pTeChirpProfile->txTransmissionReferenceTime = 0;
    pTeChirpProfile->txTransmissionTimeOffset = 0;
    pTeChirpProfile->rxEnable = 15;
    pTeChirpProfile->virtualChannel = 0;

    //200, 10, 10, 128, 0, 0, 0, 0, 0, 0, 0, 0, 15, 0
    rfeHwTe_setChirpProfile( rfeHw_profileIndex_0_e,
                             pTeChirpProfile,
                             RFE_ERROR_FUNCTION_ARGUMENT );

    rfeHwTe_setChirpDeactivationTime( 6,
                                      RFE_ERROR_FUNCTION_ARGUMENT );

    // rfeHwTe_setChirpSequence 100, 0, 0, 0 // pre RfeProxy 0.5.11
    rfeHwTe_setChirpSequence( 0,
                              0,
                              0,
                              0,
                              0,
                              RFE_ERROR_FUNCTION_ARGUMENT );
    // use for GPIO control
    rfeHwTe_setChirpActiveSignalConfig( rfe_chirpActiveSignalConfig_chirp_e,
                                        RFE_ERROR_FUNCTION_ARGUMENT );

    rfeHwTe_ipPowerControl( rfeHwTe_ipPowerControl_rxBist_e,
                            false,
                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTe_ipPowerControl( rfeHwTe_ipPowerControl_adc1_e,
                            true,
                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTe_ipPowerControl( rfeHwTe_ipPowerControl_adc2_e,
                            true,
                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTe_ipPowerControl( rfeHwTe_ipPowerControl_adc3_e,
                            true,
                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTe_ipPowerControl( rfeHwTe_ipPowerControl_adc4_e,
                            true,
                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTe_ipPowerControl( rfeHwTe_ipPowerControl_tempSens1_e,
                            true,
                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTe_ipPowerControl( rfeHwTe_ipPowerControl_tempSens2_e,
                            true,
                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTe_ipPowerControl( rfeHwTe_ipPowerControl_tempSens3_e,
                            true,
                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTe_ipPowerControl( rfeHwTe_ipPowerControl_tempSens4_e,
                            true,
                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTe_ipPowerControl( rfeHwTe_ipPowerControl_loif_e,
                            true,
                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTe_ipPowerControl( rfeHwTe_ipPowerControl_packer_e,
                            true,
                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTe_ipPowerControl( rfeHwTe_ipPowerControl_chirpGen_e,
                            true,
                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTe_ipPowerControl( rfeHwTe_ipPowerControl_tx1_e,
                            false,
                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTe_ipPowerControl( rfeHwTe_ipPowerControl_tx2_e,
                            false,
                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTe_ipPowerControl( rfeHwTe_ipPowerControl_tx3_e,
                            false,
                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTe_ipPowerControl( rfeHwTe_ipPowerControl_tx4_e,
                            false,
                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTe_ipPowerControl( rfeHwTe_ipPowerControl_rx1_e,
                            true,
                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTe_ipPowerControl( rfeHwTe_ipPowerControl_rx2_e,
                            true,
                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTe_ipPowerControl( rfeHwTe_ipPowerControl_rx3_e,
                            true,
                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTe_ipPowerControl( rfeHwTe_ipPowerControl_rx4_e,
                            true,
                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTe_ipPowerControl( rfeHwTe_ipPowerControl_pdc_e,
                            true,
                            RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTe_loadProfile( rfeHw_profileIndex_0_e,
                         RFE_ERROR_FUNCTION_ARGUMENT );

    //== RX SETTINGS ==
    // RX1 - ADC path only
    rfeHwRx_configIfbist_t ifbistSettings;
    rfeHwRx_configIfbist_t* pIfbistSetting = &ifbistSettings;
    /** Connect/Disconnect IFBIST IN  to Input of the IF. */
    pIfbistSetting->bistToIn = false;
    /** Connect/Disconnect IFBIST to the ADC for Calibration. */
    pIfbistSetting->bistToAdc = false;
    /** Connect/Disconnect VGA1 Out to ADC. */
    pIfbistSetting->vga1ToAdc = false;
    /** Connect/Disconnect VGA1 Output to VGA2 Input. */
    pIfbistSetting->vga1ToVga2 = true;
    /** Connect/Disconnect VGA2 Output to ADC. */
    pIfbistSetting->vga2ToAdc = false;
    /** Connect/Disconnect AC ATB out to IFBIST. */
    pIfbistSetting->bistLoopback = false;
    /** Overwrite the timing engine and connect the IF_HB signals to the pins. */
    pIfbistSetting->hbRstOverwrite = true;
    /** Value for SW_VGA1_TO_VGA2 to be used during reset */
    pIfbistSetting->hbVga1toVga2 = false;
    /** Enabling/disabling BIST input buffer. */
    pIfbistSetting->enInputBuf = false;
    /** Enabling/disabling BIST output buffer. */
    pIfbistSetting->enOutputBuf = false;
    /** Enabling/disabling the BIST output buffer common mode part */
    pIfbistSetting->enCommonMode = false;
    /** Gain setting for IFBIST output buffer. */
    pIfbistSetting->selectOutputGain = rfeHwRx_Ifbist_Gain_0dB_e;

    rfeHwRx_configIfbist( rfe_rxIndex_1_e,
                          pIfbistSetting,
                          RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwRx_configIfbist( rfe_rxIndex_2_e,
                          pIfbistSetting,
                          RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwRx_configIfbist( rfe_rxIndex_3_e,
                          pIfbistSetting,
                          RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwRx_configIfbist( rfe_rxIndex_4_e,
                          pIfbistSetting,
                          RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwSpi_write( RFE_HW_SPI_RX_MC_MODULE,
                    RFE_HW_RX_TEST_RESET_ERROR_REG,
                    0x0,
                    RFE_ERROR_FUNCTION_ARGUMENT );
    // == TE ==
    // Equivalent writeSpi "01.138.31:0",0x2
    rfeSwCalibration_rxIfConfigTeForCwMode(
                                            true,
                                            RFE_ERROR_FUNCTION_ARGUMENT );

//== ADC SETTINGS ==
// can be done in multicast mode
    rfeHwRxAdc_selectInputI( rfeHwRxAdc_adcIndex_1_e,
                             rfeHwRxAdc_inputI_rx_e,
                             RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwRxAdc_selectInputQ( rfeHwRxAdc_adcIndex_1_e,
                             rfeHwRxAdc_inputQ_rx_e,
                             RFE_ERROR_FUNCTION_ARGUMENT );

    // PDC SETTINGS - profile 0 only
    rfeHwPdc_samplingRateSetter(
        rfe_rxIndex_1_e,
        rfeHw_profileIndex_0_e,
        rfe_effectiveSamplingFrequency_40MHz_e,
        RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwPdc_samplingRateSetter(
        rfe_rxIndex_2_e,
        rfeHw_profileIndex_0_e,
        rfe_effectiveSamplingFrequency_40MHz_e,
        RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwPdc_samplingRateSetter(
        rfe_rxIndex_3_e,
        rfeHw_profileIndex_0_e,
        rfe_effectiveSamplingFrequency_40MHz_e,
        RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwPdc_samplingRateSetter(
        rfe_rxIndex_4_e,
        rfeHw_profileIndex_0_e,
        rfe_effectiveSamplingFrequency_40MHz_e,
        RFE_ERROR_FUNCTION_ARGUMENT );

    rfeHwPdc_equalizerCoeffs eqCoeffs;
    eqCoeffs.k0xa0Imag = -3695;
    eqCoeffs.k0xa0Real = -5086;
    eqCoeffs.k0xa1 = 11335;

    rfeHwPdc_equalizerCoeffsSetter( rfe_rxIndex_1_e,
                                    rfeHw_profileIndex_0_e,
                                    eqCoeffs,
                                    RFE_ERROR_FUNCTION_ARGUMENT );

    rfeHwSpi_modifyBit( rfeHwPdc_indexMapperToSPIModule( rfe_rxIndex_1_e,
                                                         RFE_ERROR_FUNCTION_ARGUMENT ),
                        RFE_HW_PDC_PDC_PDC_OL_CNT_REG,
                        RFE_HW_PDC_PDC_PDC_OL_CNT_DECI1_HLD_DIS_BIT,
                        false,
                        RFE_ERROR_FUNCTION_ARGUMENT);
    rfeHwSpi_modifyBit( rfeHwPdc_indexMapperToSPIModule( rfe_rxIndex_2_e,
                                                         RFE_ERROR_FUNCTION_ARGUMENT ),
                        RFE_HW_PDC_PDC_PDC_OL_CNT_REG,
                        RFE_HW_PDC_PDC_PDC_OL_CNT_DECI1_HLD_DIS_BIT,
                        false,
                        RFE_ERROR_FUNCTION_ARGUMENT);
    rfeHwSpi_modifyBit( rfeHwPdc_indexMapperToSPIModule( rfe_rxIndex_3_e,
                                                         RFE_ERROR_FUNCTION_ARGUMENT ),
                        RFE_HW_PDC_PDC_PDC_OL_CNT_REG,
                        RFE_HW_PDC_PDC_PDC_OL_CNT_DECI1_HLD_DIS_BIT,
                        false,
                        RFE_ERROR_FUNCTION_ARGUMENT);
    rfeHwSpi_modifyBit( rfeHwPdc_indexMapperToSPIModule( rfe_rxIndex_4_e,
                                                         RFE_ERROR_FUNCTION_ARGUMENT ),
                        RFE_HW_PDC_PDC_PDC_OL_CNT_REG,
                        RFE_HW_PDC_PDC_PDC_OL_CNT_DECI1_HLD_DIS_BIT,
                        false,
                        RFE_ERROR_FUNCTION_ARGUMENT);
    rfeHwSpi_modifyBit( RFE_HW_SPI_TE_MODULE,
                        RFE_HW_TE_DYNAMIC_POWER_CONTROL_ENABLE_REG,
                        RFE_HW_TE_DYNAMIC_POWER_CONTROL_ENABLE_PDC_DY_PWR_CTRL_BIT,
                        false,
                        RFE_ERROR_FUNCTION_ARGUMENT );

    rfeHwSpi_modifyBit( rfeHwPdc_indexMapperToSPIModule( rfe_rxIndex_1_e,
                                                         RFE_ERROR_FUNCTION_ARGUMENT ),
                        RFE_HW_PDC_PDC_CTL2_REG,
                        RFE_HW_PDC_PDC_CTL2_INP_EN_WA_ADC_BIT,
                        false,
                        RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwSpi_modifyBit( rfeHwPdc_indexMapperToSPIModule( rfe_rxIndex_2_e,
                                                         RFE_ERROR_FUNCTION_ARGUMENT ),
                        RFE_HW_PDC_PDC_CTL2_REG,
                        RFE_HW_PDC_PDC_CTL2_INP_EN_WA_ADC_BIT,
                        false,
                        RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwSpi_modifyBit( rfeHwPdc_indexMapperToSPIModule( rfe_rxIndex_3_e,
                                                         RFE_ERROR_FUNCTION_ARGUMENT ),
                        RFE_HW_PDC_PDC_CTL2_REG,
                        RFE_HW_PDC_PDC_CTL2_INP_EN_WA_ADC_BIT,
                        false,
                        RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwSpi_modifyBit( rfeHwPdc_indexMapperToSPIModule( rfe_rxIndex_4_e,
                                                         RFE_ERROR_FUNCTION_ARGUMENT ),
                        RFE_HW_PDC_PDC_CTL2_REG,
                        RFE_HW_PDC_PDC_CTL2_INP_EN_WA_ADC_BIT,
                        false,
                        RFE_ERROR_FUNCTION_ARGUMENT );

    rfeHwSpi_modifyBit( rfeHwPdc_indexMapperToSPIModule( rfe_rxIndex_1_e,
                                                         RFE_ERROR_FUNCTION_ARGUMENT ),
                        RFE_HW_PDC_PDC_BYPASSES_REG,
                        RFE_HW_PDC_PDC_BYPASSES_BYPASS_CORDIC_BIT,
                        false,
                        RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwSpi_modifyBit( rfeHwPdc_indexMapperToSPIModule( rfe_rxIndex_2_e,
                                                         RFE_ERROR_FUNCTION_ARGUMENT ),
                        RFE_HW_PDC_PDC_BYPASSES_REG,
                        RFE_HW_PDC_PDC_BYPASSES_BYPASS_CORDIC_BIT,
                        false,
                        RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwSpi_modifyBit( rfeHwPdc_indexMapperToSPIModule( rfe_rxIndex_3_e,
                                                         RFE_ERROR_FUNCTION_ARGUMENT ),
                        RFE_HW_PDC_PDC_BYPASSES_REG,
                        RFE_HW_PDC_PDC_BYPASSES_BYPASS_CORDIC_BIT,
                        false,
                        RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwSpi_modifyBit( rfeHwPdc_indexMapperToSPIModule( rfe_rxIndex_4_e,
                                                         RFE_ERROR_FUNCTION_ARGUMENT ),
                        RFE_HW_PDC_PDC_BYPASSES_REG,
                        RFE_HW_PDC_PDC_BYPASSES_BYPASS_CORDIC_BIT,
                        false,
                        RFE_ERROR_FUNCTION_ARGUMENT );

    rfeHwSpi_modifyBit( rfeHwPdc_indexMapperToSPIModule( rfe_rxIndex_1_e,
                                                         RFE_ERROR_FUNCTION_ARGUMENT ),
                        RFE_HW_PDC_PDC_BYPASSES_REG,
                        RFE_HW_PDC_PDC_BYPASSES_BYPASS_FSHIFT2_BIT,
                        false,
                        RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwSpi_modifyBit( rfeHwPdc_indexMapperToSPIModule( rfe_rxIndex_2_e,
                                                         RFE_ERROR_FUNCTION_ARGUMENT ),
                        RFE_HW_PDC_PDC_BYPASSES_REG,
                        RFE_HW_PDC_PDC_BYPASSES_BYPASS_FSHIFT2_BIT,
                        false,
                        RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwSpi_modifyBit( rfeHwPdc_indexMapperToSPIModule( rfe_rxIndex_3_e,
                                                         RFE_ERROR_FUNCTION_ARGUMENT ),
                        RFE_HW_PDC_PDC_BYPASSES_REG,
                        RFE_HW_PDC_PDC_BYPASSES_BYPASS_FSHIFT2_BIT,
                        false,
                        RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwSpi_modifyBit( rfeHwPdc_indexMapperToSPIModule( rfe_rxIndex_4_e,
                                                         RFE_ERROR_FUNCTION_ARGUMENT ),
                        RFE_HW_PDC_PDC_BYPASSES_REG,
                        RFE_HW_PDC_PDC_BYPASSES_BYPASS_FSHIFT2_BIT,
                        false,
                        RFE_ERROR_FUNCTION_ARGUMENT );

    rfeHwSpi_modifyBit( rfeHwPdc_indexMapperToSPIModule( rfe_rxIndex_1_e,
                                                         RFE_ERROR_FUNCTION_ARGUMENT ),
                        RFE_HW_PDC_PDC_BYPASSES_REG,
                        RFE_HW_PDC_PDC_BYPASSES_BYPASS_FSHIFT3_BIT,
                        false,
                        RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwSpi_modifyBit( rfeHwPdc_indexMapperToSPIModule( rfe_rxIndex_2_e,
                                                         RFE_ERROR_FUNCTION_ARGUMENT ),
                        RFE_HW_PDC_PDC_BYPASSES_REG,
                        RFE_HW_PDC_PDC_BYPASSES_BYPASS_FSHIFT3_BIT,
                        false,
                        RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwSpi_modifyBit( rfeHwPdc_indexMapperToSPIModule( rfe_rxIndex_3_e,
                                                         RFE_ERROR_FUNCTION_ARGUMENT ),
                        RFE_HW_PDC_PDC_BYPASSES_REG,
                        RFE_HW_PDC_PDC_BYPASSES_BYPASS_FSHIFT3_BIT,
                        false,
                        RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwSpi_modifyBit( rfeHwPdc_indexMapperToSPIModule( rfe_rxIndex_4_e,
                                                         RFE_ERROR_FUNCTION_ARGUMENT ),
                        RFE_HW_PDC_PDC_BYPASSES_REG,
                        RFE_HW_PDC_PDC_BYPASSES_BYPASS_FSHIFT3_BIT,
                        false,
                        RFE_ERROR_FUNCTION_ARGUMENT );

#ifdef RFE_SW_CALIBRATION_IP_VALIDATION_PDC_EQ_DISABLE
    rfeHwSpi_modifyBit( rfeHwPdc_indexMapperToSPIModule( rfe_rxIndex_1_e,
                                                         RFE_ERROR_FUNCTION_ARGUMENT ),
                        RFE_HW_PDC_PDC_CTL4_REG,
                        RFE_HW_PDC_PDC_CTL4_EQ_EN_BIT,
                        false,
                        RFE_ERROR_FUNCTION_ARGUMENT );

    rfeHwSpi_modifyBit( rfeHwPdc_indexMapperToSPIModule( rfe_rxIndex_2_e,
                                                         RFE_ERROR_FUNCTION_ARGUMENT ),
                        RFE_HW_PDC_PDC_CTL4_REG,
                        RFE_HW_PDC_PDC_CTL4_EQ_EN_BIT,
                        false,
                        RFE_ERROR_FUNCTION_ARGUMENT );

    rfeHwSpi_modifyBit( rfeHwPdc_indexMapperToSPIModule( rfe_rxIndex_3_e,
                                                         RFE_ERROR_FUNCTION_ARGUMENT ),
                        RFE_HW_PDC_PDC_CTL4_REG,
                        RFE_HW_PDC_PDC_CTL4_EQ_EN_BIT,
                        false,
                        RFE_ERROR_FUNCTION_ARGUMENT );

    rfeHwSpi_modifyBit( rfeHwPdc_indexMapperToSPIModule( rfe_rxIndex_4_e,
                                                         RFE_ERROR_FUNCTION_ARGUMENT ),
                        RFE_HW_PDC_PDC_CTL4_REG,
                        RFE_HW_PDC_PDC_CTL4_EQ_EN_BIT,
                        false,
                        RFE_ERROR_FUNCTION_ARGUMENT );
#endif //RFE_SW_CALIBRATION_IP_VALIDATION_PDC_EQ_DISABLE

    rfeHwPdc_funcOverrideDefaultPhaseCorrectionValues( rfeHwPdc_effectiveSamplingFrequency_40MHz_e,
                                                       rfeHwPdc_filterMode_steepNarrowBand_e,
                                                       RFE_ERROR_FUNCTION_ARGUMENT );

    rfeHwPdc_multicastModeSetter( true,
                                  RFE_ERROR_FUNCTION_ARGUMENT );

    rfeHwPdc_iqcCorrectionSetter( rfe_rxIndex_1_e,
                                  rfeHw_profileIndex_0_e,
                                  2497,
                                  55562,
                                  RFE_ERROR_FUNCTION_ARGUMENT );

    rfeHwPdc_outputSelector( rfe_rxIndex_1_e,
                             rfeHwPdc_pdcOutput_I_e,
                             RFE_ERROR_FUNCTION_ARGUMENT );

    rfeHwPdc_qComponentEnabledViaSpi( rfe_rxIndex_1_e,
                                      true,
                                      RFE_ERROR_FUNCTION_ARGUMENT );
}
```
### rfeSwCalibration_rfChainCalib
Inputs needed -> `selectedProfile = rfeHw_profileIndex_0_e` 
```
void rfeSwCalibration_rfChainCalib( rfeHw_profileIndex_t selectedProfile,RFE_ERROR_FUNCTION_PARAMETER)
{
    uint32_t cwFreqKhz = 77000000ul;
     // SET VCO TO CW MODE
    {
        // Free VCO for calibration of CW signal
        rfeHwChirppll_pllLockedToFreeRunningMode( RFE_ERROR_FUNCTION_ARGUMENT );

        // We will use default values from Register map
        uint16_t settleTimeTicks = 10ul;
        float acqTimeTicksMultiplier = ( float ) RFE_SW_CALIBRATION_RX_CALIBRATION_BIST_SAMPLING_RATE_80_MHZ / rxIfCalibrationBistSamplingRate;
        uint32_t acquisitionTimeTicks = roundFloat( acqTimeTicksMultiplier * rxIfCalibrationBistSamples )+10ul;
        uint32_t resetTimeTicks = 10ul;
        uint8_t jumpbackTimeTicks = 10ul;
        rfe_chirpSlopeDirection_t slopeDirection = rfe_chirpSlopeDirection_rising_e;

        rfeHwChirppll_configSweepControl( selectedProfile, cwFreqKhz, 0ul, settleTimeTicks,
                                          acquisitionTimeTicks, resetTimeTicks, jumpbackTimeTicks, slopeDirection,
                                          RFE_ERROR_FUNCTION_ARGUMENT );

        // Program PLL profile for CW signal
        rfe_chirpPllVco_t chirpPllVcoSelect = rfe_chirpPllVco_1GHz_e;
        rfeHwChirppll_calibrateVco( cwFreqKhz, chirpPllVcoSelect, selectedProfile, true, RFE_ERROR_FUNCTION_ARGUMENT);

        // Call Timing Engine to load profile
        rfeHwTe_loadProfile( selectedProfile, RFE_ERROR_FUNCTION_ARGUMENT );

        // Set PLL to PLL locked mode
        rfeHwChirppll_calibratedToPllLockedCwMode( RFE_ERROR_FUNCTION_ARGUMENT );
    }


    rfeHwTSense_startTemperatureConversion( rfe_temperatureSensorIndex_rx_e, true, RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTSense_startTemperatureConversion( rfe_temperatureSensorIndex_tx12_e, true, RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTSense_startTemperatureConversion( rfe_temperatureSensorIndex_tx34_e, true, RFE_ERROR_FUNCTION_ARGUMENT );
    rfeHwTSense_startTemperatureConversion( rfe_temperatureSensorIndex_xo_e, true, RFE_ERROR_FUNCTION_ARGUMENT );
    rfeWait_usec(60ul, RFE_ERROR_FUNCTION_ARGUMENT);

    // LOI RX Calibration takes place here (via Validate version)
    rfeSwCalibrationPpd_t loiPpd;
    rfeSwCalibration_loiRxBufferCalibrate_validate( cwFreqKhz,
                                                    RFE_SW_CALIBRATION_LOI_RX_POWER_TARGET,
                                                    &loiPpd,
                                                    RFE_ERROR_FUNCTION_ARGUMENT );

    // RX LOX2 Calibration takes place here
    rfeSwCalibration_rxLox2Calibrate( selectedProfile,
                                      RFE_SW_CALIBRATION_RX_LOX2_TARGET_VOLTAGE,
                                      0.0f,
                                      rfeSwCalib_state.temperatureQ16_6[0ul],
                                      RFE_ERROR_FUNCTION_ARGUMENT);

    // RX BIST Calibration takes place here
    rfeHwRxbist_standbyToOnRfMode( RFE_ERROR_FUNCTION_ARGUMENT );

    rfeSwCalibrationPpd_t rxbistLox2Ppd;
    rfeSwCalibrationPpd_t rxbistSsbPpd;
    rfeSwCalibration_rxbistLox2Calibrate_validate( cwFreqKhz,
                                                   RFE_SW_CALIBRATION_RXBIST_LOX2_POWER_TARGET,
                                                   &rxbistLox2Ppd,
                                                   RFE_ERROR_FUNCTION_ARGUMENT );
    rfeSwCalibration_rxbistSsbCalibrate_validate( cwFreqKhz,
                                                  RFE_SW_CALIBRATION_RXBIST_SSB_POWER_TARGET,
                                                  &rxbistSsbPpd,
                                                  RFE_ERROR_FUNCTION_ARGUMENT );

    rfeHwRxbist_standbyToOnBbMode( RFE_ERROR_FUNCTION_ARGUMENT );
}
```