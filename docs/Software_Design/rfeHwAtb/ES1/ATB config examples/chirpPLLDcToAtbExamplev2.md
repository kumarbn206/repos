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
rfeHwAtb_connectedIp_t chirpPllSPIParams;
```
2. Define the SPI parameters to connect ATB to chirpPLL this is generic for chirpPLL
```
chirpPllSPIParams.id                = 0x03; // SPI address of chirpPLL
chirpPllSPIParams.atbCtlOffset      = 0xA00; // Offset of chirpPLL 0xA00
chirpPllSPIParams.atbCtlEnShf       = 0x1B; // ATB1_EN offset for chirpPLL is on
chirpPllSPIParams.atbCtlMaskToApply = 0x00ff0000; // ATB_SEL mask for chirpPLL
chirpPllSPIParams.atbCtlSelShf      = 0x08; // ATB_SEL shift for chirpPLL
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
rfeHwAtb_adcInputMuxer_VNeg_SE_Selector_t adcSingleModeGround =
rfeHwAtb_adcInputMuxer_VNeg_SE_Selector_vssa_1v8_e; // If we are working in differential this variable is ignored by the driver!
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
rfeHwSpi_register32_t averagedATB1ADCSample = rfeHwAtb_funcAtbCollectSamples( rfeHwAtb_atbMaster_1_e,
                                                                              RFE_ERROR_FUNCTION_ARGUMENT );
```
## Convert ATB1 ADC Code to voltage
Function to convert the collected samples `averagedATB1ADCSample` from `rfeHwAtb_funcAtbCollectSamples()` into Voltage
```
rfeHwAtb_funcAtbAdcSamplesToVoltageConvert( (uint16_t) averagedATB1ADCSample,
                                            rfeHwAtb_atbMaster_1_e,
                                            adcEndToSet
                                            adcGainMode,
                                            RFE_ERROR_FUNCTION_PARAMETER);
```
## Lock chirpPLL registers
chirpPLL registers must be locked afterwards having used them

```
rfeHwChirppll_unlockOrLockProtectedRegisters( true,
                                              RFE_ERROR_FUNCTION_ARGUMENT );
```

## Full sequence

```
rfeHwChirppll_unlockOrLockProtectedRegisters( false,
                                              RFE_ERROR_FUNCTION_ARGUMENT );
rfeHwAtb_connectedIp_t chirpPllSPIParams;
chirpPllSPIParams.id                = 0x03; // SPI address of chirpPLL
chirpPllSPIParams.atbCtlOffset      = 0xA00; // Offset of chirpPLL 0xA00
chirpPllSPIParams.atbCtlEnShf       = 0x1B; // ATB1_EN offset for chirpPLL is on
chirpPllSPIParams.atbCtlMaskToApply = 0x00ff0000; // ATB_SEL mask for chirpPLL
chirpPllSPIParams.atbCtlSelShf      = 0x08; // ATB_SEL shift for chirpPLL
atb1CtlSelValue = 0x3b;
rfeHwAtb_atbMaster_t chirpPllAtb1 = rfeHwAtb_atbMaster_1_e;//0x0

rfeHwAtb_ctrlAtbConnectToIpMode( chirpPllSPIParams,
                                   0x0f,
                                   atb1CtlSelValue,
                                   chirpPllAtb1,
                                   rfeHwAtb_operationMode_ipDcUsage_e,
                                   RFE_ERROR_FUNCTION_ARGUMENT );

rfeHwAtb_adcFclk_t adcSamplingRate = rfeHwAtb_adcSamplingRate_5M_e;// 0x0
rfeHwAtb_adcDutyCycle_t adcDutyCycle = rfeHwAtb_adcDutyCycle_50_e;//0x0
rfeHwAtb_adcAverageEnable_t adcAveragedEnabled = rfeHwAtb_adcAverageEnable_enabled_e;//0x1
rfeHwAtb_adcAverageMode_t adcAveragingMode = rfeHwAtb_adcAverageMode_mono_e;//0x1
rfeHwAtb_adcAveragingOnSamples_t adcSamplesToAverage = rfeHwAtb_adcAveragingOn_4samples_e;//0x4
rfeHwAtb_adcInner_Sel_In_t adcInputSel = rfeHwAtb_adcInner_Sel_In_0;//0x0
rfeHwAtb_adcEndMode_t adcEndToSet = rfeHwAtb_adcEndMode_single_e;//0x1
rfeHwAtb_adcInputMuxer_VNeg_SE_Selector_t adcSingleModeGround =
rfeHwAtb_adcInputMuxer_VNeg_SE_Selector_vssa_1v8_e;//0x0
rfeHwAtb_adcGainMode_t adcGainMode = rfeHwAtb_adcGainMode_normal_e;//0x0


rfeHwAtb_ctrlAtbAdcBasicSettingsSetter( chirpPllAtb1,
                                        adcSamplingRate,
                                        adcDutyCycle,
                                        adcAveragedEnabled,
                                        adcAveragingMode,
                                        adcSamplesToAverage,
                                        RFE_ERROR_FUNCTION_ARGUMENT );

rfeHwAtb_ctrlAtbAdcModeSetter( chirpPllAtb1,
                               adcInputSel,
                               adcEndToSet,
                               adcSingleModeGround,
                               adcGainMode,
                               RFE_ERROR_FUNCTION_ARGUMENT );
rfeHwAtb_ctrlAtbDcInputSourceSetter( chirpPllAtb1,
                                     rfeHwAtb_atbSource_dc1_e,
                                     true,
                                     RFE_ERROR_FUNCTION_ARGUMENT );
rfeHwAtb_ctrAtbPlDownLinesSetter( rfeHwAtb_atbSource_dc1_e,
                                 RFE_ERROR_FUNCTION_ARGUMENT );

rfeHwAtb_funcAtbAdcTriggerMonoSampling( chirpPllAtb1,
                                        true,
                                        RFE_ERROR_FUNCTION_ARGUMENT );

rfeHwSpi_register32_t averagedATB1ADCSample = rfeHwAtb_funcAtbCollectSamples( chirpPllAtb1,
                                                                              RFE_ERROR_FUNCTION_ARGUMENT );

rfeHwAtb_funcAtbAdcSamplesToVoltageConvert( (uint16_t) averagedATB1ADCSample,
                                            chirpPllAtb1,
                                            adcEndToSet
                                            adcGainMode,
                                            RFE_ERROR_FUNCTION_PARAMETER);

rfeHwChirppll_unlockOrLockProtectedRegisters( true,
                                              RFE_ERROR_FUNCTION_ARGUMENT );
```
