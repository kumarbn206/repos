# Brief sequence to use ATB DC bus
This sequence flow diagram is shown in _ATB SW Unit Configurationv1p2.pptx_
Please, notice that header colours are matching flow diagram.

## Unlock chirpPLL registers
chirpPLL registers must be unlocked before establishing connection via ATB driver, and they have to be locked afterwards.

```
rfeHwChirppll_unlockOrLockProtectedRegisters( false,
RFE_ERROR_FUNCTION_ARGUMENT );
```

## <span style="color:blue"> Connect IP to ATB DC bus</span>
### <span style="color:blue">Connectivity from chirpPLL Vtune node to ATB 1 DC bus</span>
1. Define struct for IP to connect ATB to chirpPLL
```
rfeHwAtb_connectedIp_t chirpPllSPIParamsAtb1;
```
2. Define the SPI parameters to connect ATB to chirpPLL this is generic for chirpPLL
```
chirpPllSPIParamsAtb1.id                = RFE_HW_SPI_CHIRP_AFC_MODULE; // SPI address of chirpPLL
chirpPllSPIParamsAtb1.atbCtlOffset      = rfeHwAtb_ctlOffset_default_e; // Offset of chirpPLL 0xA00
chirpPllSPIParamsAtb1.atbCtlEnShf       = RFE_HW_CHIRPPLL_ATB_ATB1_EN_BIT; // ATB2_EN offset for chirpPLL is on
chirpPllSPIParamsAtb1.atbCtlMaskToApply = RFE_HW_CHIRPPLL_ATB_ATB1_SEL_MSK; // ATB_SEL mask for chirpPLL
chirpPllSPIParamsAtb1.atbCtlSelShf      = RFE_HW_CHIRPPLL_ATB_ATB1_SEL_SHF; // ATB_SEL shift for chirpPLL
```
3. Check chirpPLL register map for ABT_SEL for Vtune node: `0x3b` -> `atbCtlSelValue`
```
atb1CtlSelValue = 0x3b;
```

4. API to enable connection from chirpPLL to ATB 1
```
rfeHwAtb_ctrlAtbConnectToIpMode( chirpPllSPIParams,
                                  0x0f,
                                  atb1CtlSelValue,
                                  rfeHwAtb_atbMaster_1_e,
                                  rfeHwAtb_operationMode_ipDcUsage_e,
                                  RFE_ERROR_FUNCTION_ARGUMENT );

## <span style="color:blue">ATB ADC Configuration example</span>
### <span style="color:blue">ATB ADC Settings example</span>
Define general ATBx-ADC settings to be used,**PLEASE ADJUST THESE SETTINGS TO YOUR SCENARIO**

1. ADC clocking
```
rfeHwAtb_adcFclk_t adcSamplingRate = rfeHwAtb_adcSamplingRate_5M_e;
```
2. ADC duty cycle
```
rfeHwAtb_adcDutyCycle_t adcDutyCycle = rfeHwAtb_adcDutyCycle_50_e;
```
3. ADC averaging mode
```
rfeHwAtb_adcAverageEnable_t adcAveragedEnabled = rfeHwAtb_adcAverageEnable_enabled_e;
```
4. ADC Mode of averaging (continous/mono)
```
rfeHwAtb_adcAverageMode_t adcAveragingMode = rfeHwAtb_adcAverageMode_mono_e;
```
5. ADC number of samples to averaged
```
rfeHwAtb_adcAveragingOnSamples_t adcSamplesToAverage = rfeHwAtb_adcAveragingOn_4samples_e;
```
6. ADC internal input selector based on ADC Ending configurations
```
rfeHwAtb_adcInner_Sel_In_t adcInputSel = rfeHwAtb_adcInner_Sel_In_0; // ADC_SEL=0x00 selects the
 differential inputs, check for your concrete case!
 ```
7. ADC Ending mode (differential/single)
```
rfeHwAtb_adcEndMode_t adcEndToSet = rfeHwAtb_adcEndMode_single_e;
```
8. ADC Grounding
```
rfeHwAtb_adcInputMuxer_VNeg_SE_Selector_t adcSingleModeGround = rfeHwAtb_adcInputMuxer_VNeg_SE_Selector_vssa_1v8_e; // If we are working in differential this variable is ignored by the driver!
```
9. ADC gain
```
rfeHwAtb_adcGainMode_t adcGainMode = rfeHwAtb_adcGainMode_normal_e;
```
### <span style="color:blue">ADC APIs call with above ADC settings</span>
#### <span style="color:blue">Configure ATB1-ADC settings to be used</span>
1. API for chirpPLL Sampling settings
```
rfeHwAtb_ctrlAtbAdcBasicSettingsSetter( rfeHwAtb_atbMaster_1_e,
                                        adcSamplingRate,
                                        adcDutyCycle,
                                        adcAveragedEnabled,
                                        adcAveragingMode,
                                        adcSamplesToAverage,
                                        RFE_ERROR_FUNCTION_ARGUMENT );
```
2. API for DC1 End settings
```
rfeHwAtb_ctrlAtbAdcModeSetter( rfeHwAtb_atbMaster_1_e,
                               adcInputSel,
                               adcEndToSet,
                               adcSingleModeGround,
                               adcGainMode,
                               RFE_ERROR_FUNCTION_ARGUMENT );
```

## <span style="color:blue">Disable pull down</span>
In order to use DC bus with input source rfeHwAtb_atbSource_dc1_e, we disable the pull down here with this API
```
rfeHwAtb_ctrAtbPlDownLinesSetter( rfeHwAtb_atbSource_dc1_e,
                                  RFE_ERROR_FUNCTION_ARGUMENT );
```

## <span style="color:blue">Select ATB DC input signal coming from IP towards ATB ADC</span>
Below API define the input signal to be used (i.e. _rfeHwAtb_atbSource_dc1_e_) for ATB DC bus
```
rfeHwAtb_ctrlAtbDcInputSourceSetter( rfeHwAtb_atbMaster_1_e,
                                     rfeHwAtb_atbSource_dc1_e,
                                     true,
                                     RFE_ERROR_FUNCTION_ARGUMENT );
```
## <span style="color:blue">Trigger sampling with mono mode on ATB1-ADC</span>

### <span style="color:blue">Start ATB1-ADC conversion in mono mode</span>
API for triggering in continuous mode
```
rfeHwAtb_funcAtbAdcTriggerMonoSampling( rfeHwAtb_atbMaster_1_e,
                                        true,
                                        RFE_ERROR_FUNCTION_ARGUMENT );
```

### <span style="color:blue">Read out of converted samples on ATB1-ADC and ATB2-ADC </span>

#### <span style="color:blue">Read output of ATB1-ADC</span>
API for collecting converted samples
```
rfeHwSpi_register32_t averagedATB1ADCSample = rfeHwAtb_funcAtbCollectSamples( rfeHwAtb_atbMaster_1_e, RFE_ERROR_FUNCTION_ARGUMENT );
```
## Convert ATB1 ADC Code to voltage
Function to convert the collected samples `averagedATB1ADCSample` from `rfeHwAtb_funcAtbCollectSamples()` into Voltage
```
rfeHwAtb_funcAtbAdcSamplesToVoltageConvert( (uint16_t) averagedATB1ADCSample,
                                            rfeHwAtb_atbMaster_1_e,
                                            adcEndToSet
                                            adcGainMode,
                                            RFE_ERROR_FUNCTION_ARGUMENT);
```
## Lock chirpPLL registers
chirpPLL registers must be locked afterwards having used them

```
rfeHwChirppll_unlockOrLockProtectedRegisters( true,RFE_ERROR_FUNCTION_ARGUMENT );
```

## Full sequence

```
rfeHwChirppll_unlockOrLockProtectedRegisters( false,RFE_ERROR_FUNCTION_ARGUMENT );

rfeHwAtb_connectedIp_t chirpPllSPIParamsAtb2;
chirpPllSPIParamsAtb2.id                = RFE_HW_SPI_CHIRP_AFC_MODULE; // SPI address of chirpPLL
chirpPllSPIParamsAtb2.atbCtlOffset      = rfeHwAtb_ctlOffset_default_e; // Offset of chirpPLL 0xA00
chirpPllSPIParamsAtb2.atbCtlEnShf       = RFE_HW_CHIRPPLL_ATB_ATB2_EN_BIT; // ATB2_EN offset for chirpPLL is on
chirpPllSPIParamsAtb2.atbCtlMaskToApply = RFE_HW_CHIRPPLL_ATB_ATB2_SEL_MSK; // ATB_SEL mask for chirpPLL
chirpPllSPIParamsAtb2.atbCtlSelShf      = RFE_HW_CHIRPPLL_ATB_ATB2_SEL_SHF; // ATB_SEL shift for chirpPLL
rfeHwSpi_register32_t atb2CtlSelValue = 0x2d;

rfeHwAtb_connectedIp_t chirpPllSPIParamsAtb1;
chirpPllSPIParamsAtb1.id                = RFE_HW_SPI_CHIRP_AFC_MODULE; // SPI address of chirpPLL
chirpPllSPIParamsAtb1.atbCtlOffset      = rfeHwAtb_ctlOffset_default_e; // Offset of chirpPLL 0xA00
chirpPllSPIParamsAtb1.atbCtlEnShf       = RFE_HW_CHIRPPLL_ATB_ATB1_EN_BIT; // ATB2_EN offset for chirpPLL is on
chirpPllSPIParamsAtb1.atbCtlMaskToApply = RFE_HW_CHIRPPLL_ATB_ATB1_SEL_MSK; // ATB_SEL mask for chirpPLL
chirpPllSPIParamsAtb1.atbCtlSelShf      = RFE_HW_CHIRPPLL_ATB_ATB1_SEL_SHF; // ATB_SEL shift for chirpPLL
rfeHwSpi_register32_t atb1CtlSelValue = 0x36;


rfeHwAtb_atbMaster_t atbToUse = rfeHwAtb_atbMaster_1_e;

rfeHwAtb_ctrlAtbConnectToIpModule( chirpPllSPIParamsAtb1, 0x0f,atb1CtlSelValue,atbToUse,rfeHwAtb_operationMode_ipDcUsage_e,RFE_ERROR_FUNCTION_ARGUMENT );

rfeHwAtb_adcFclk_t adcSamplingRate = rfeHwAtb_adcSamplingRate_5M_e;
rfeHwAtb_adcDutyCycle_t adcDutyCycle = rfeHwAtb_adcDutyCycle_50_e;
rfeHwAtb_adcAverageEnable_t adcAveragedEnabled = rfeHwAtb_adcAverageEnable_enabled_e;
rfeHwAtb_adcAverageMode_t adcAveragingMode = rfeHwAtb_adcAverageMode_mono_e;
rfeHwAtb_adcAveragingOnSamples_t adcSamplesToAverage = rfeHwAtb_adcAveragingOn_4samples_e;
rfeHwAtb_adcInner_Sel_In_t adcInputSel = rfeHwAtb_adcInner_Sel_In_0; // ADC_SEL=0x00 selects the differential inputs, check for your concrete case!
rfeHwAtb_adcEndMode_t adcEndToSet = rfeHwAtb_adcEndMode_single_e;
rfeHwAtb_adcInputMuxer_VNeg_SE_Selector_t adcSingleModeGround = rfeHwAtb_adcInputMuxer_VNeg_SE_Selector_vssa_1v8_e; // If we are working in differential this variable is ignored by the driver!
rfeHwAtb_adcGainMode_t adcGainMode = rfeHwAtb_adcGainMode_normal_e;
rfeHwAtb_ctrlAtbAdcBasicSettingsSetter( atbToUse, adcSamplingRate, adcDutyCycle, adcAveragedEnabled, adcAveragingMode, adcSamplesToAverage, RFE_ERROR_FUNCTION_ARGUMENT );
rfeHwAtb_ctrlAtbAdcModeSetter( atbToUse, adcInputSel, adcEndToSet, adcSingleModeGround, adcGainMode, RFE_ERROR_FUNCTION_ARGUMENT );
rfeHwAtb_ctrlAtbDcInputSourceSetter( atbToUse, rfeHwAtb_atbSource_dc1_e, true, RFE_ERROR_FUNCTION_ARGUMENT );
rfeHwAtb_ctrlAtbPullDownLinesSetter( rfeHwAtb_atbSource_dc1_e, true, RFE_ERROR_FUNCTION_ARGUMENT );

```
In order to trigger a single conversion on ATB ADC this sequence has to be used after above one
```
rfeHwAtb_funcAtbAdcTriggerMonoSampling( atbToUse, true, RFE_ERROR_FUNCTION_ARGUMENT );
rfeWait_usec( 5000, RFE_ERROR_FUNCTION_ARGUMENT );
rfeHwSpi_register32_t averagedATB1ADCSample = rfeHwAtb_funcAtbCollectSamples( atbToUse, RFE_ERROR_FUNCTION_ARGUMENT );
float vtuneVoltage = rfeHwAtb_funcAtbAdcSamplesToVoltageConvert( (uint16_t) averagedATB1ADCSample, atbToUse, adcEndToSet, adcGainMode, RFE_ERROR_FUNCTION_ARGUMENT );
```
