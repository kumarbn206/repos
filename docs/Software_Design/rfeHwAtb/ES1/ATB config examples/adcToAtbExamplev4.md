continuous
# Brief sequence to use ATB DC bus
This sequence flow diagram is shown in _ATB SW Unit Configurationv1.pptx_
Please, notice that header colour are matching flow diagram.

## <span style="color:blue"> Connect IP to ATB DC bus</span>
### <span style="color:blue">Connectivity from ADC1 ATB_CLK_0_I to ATB 1 DC bus</span>
1. Define struct for IP to connect ATB to ADC1
```
rfeHwAtb_connectedIp_t adc1Atb1;
```
2. Define the SPI parameters to connect ATB to ADC1 this is generic for ADC1
```
adc1Atb1.id                = 0x04; // SPI address of ADC1
adc1Atb1.atbCtlOffset      = rfeHwAtb_ctlOffset_defat_e; // Offset of ADC1 0xA00
adc1Atb1.atbCtlEnShf       = 0x08; // ATB1_EN offset for ADC1 is on 8 bit
adc1Atb1.atbCtlMaskToApply = 0x00ff0000; // ATB_SEL mask for ADC1
adc1Atb1.atbCtlSelShf      = 0x10; // ATB_SEL shift for ADC1
```        
4. Check ADC1 register map for ABT_SEL for ATB_CLK_0_I:  `ATB_CLK_0_I` -> `0b00000001 = 0x00000001` -> `atbCtlSelValue`
```
atb1CtlSelValue = 0x00000001;
```
5. API to enable connection from ADC1 to ATB 1
```
rfeHwAtb_ctrlAtbConnectToIpMode( adc1Atb1,
                                   0x0f,
                                   atb1CtlSelValue,
                                   rfeHwAtb_atbMaster_1_e,
                                   rfeHwAtb_operationMode_ipDcUsage_e,
                                   RFE_ERROR_FUNCTION_ARGUMENT );
```
### <span style="color:blue">Connectivity from ADC1 ATB_CLK_1_I to  ATB 2 DC bus </span>
1. Define struct for IP to connect ATB to ADC1
```
rfeHwAtb_connectedIp_t adc1Atb2;
```
2. Define Connect selected ATB2 to ATB_CLK_1_I
```
adc1Atb2.id                = 0x04; // SPI address of ADC1
adc1Atb2.atbCtlEnShf = 0x0C; // ATB2_EN offset for ADC1 is on 12(0xC) bit
adc1Atb2.atbCtlMaskToApply = 0x00ff0000; // ATB_SEL mask for ADC1
adc1Atb2.atbCtlSelShf = 0x10;// ATB_SEL shift for ADC1 is on 16(0x10) bit
```
3. Check ADC1 register map  for  ATB_CLK_1_I: `ATB_CLK_1_I`  -> `0b00000010 = 0x02` -> atb2CtlSelValue

Hence the value to be set to connect the node ppd SSB to ATB2 is

```
atb2CtlSelValue = 0x00000002;
```

4. API to enable connection from ADC1 to ATB 2
```
rfeHwAtb_ctrlAtbConnectToIpMode( adc1Atb2,
                                   0x0f,
                                   atb2CtlSelValue,
                                   rfeHwAtb_atbMaster_2_e,
                                   rfeHwAtb_operationMode_ipDcUsage_e,
                                   RFE_ERROR_FUNCTION_ARGUMENT );
```

## <span style="color:blue">ADC Configuration example</span>
### <span style="color:blue">ADC Settings example</span>
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
rfeHwAtb_adcAverageMode_t adcAveragingMode = rfeHwAtb_adcAverageMode_cont_e;
```
5. ADC number of samples to averaged
```
rfeHwAtb_adcAveragingOnSamples_t adcSamplesToAverage = rfeHwAtb_adcAveragingOn_8samples_e;
```
6. ADC internal input selector based on ADC Ending configurations
```
rfeHwAtb_adcInner_Sel_In_t adcInputSel = rfeHwAtb_adcInner_Sel_In_0; // ADC_SEL=0x00 selects the
 differential inputs, check for your concrete case!
 ```
7. ADC Ending mode (differential/single)
```
rfeHwAtb_adcEndMode_t adcEndToSet = rfeHwAtb_adcEndMode_differential_e;
```
8. ADC Grounding
```
rfeHwAtb_adcInputMuxer_VNeg_SE_Selector_t adcSingleModeGround =
rfeHwAtb_adcInputMuxer_VNeg_SE_Selector_vssa_1v8_e; // We are working in differential this is ignore!
```
9. ADC gain
```
rfeHwAtb_adcGainMode_t adcGainMode = rfeHwAtb_adcGainMode_normal_e;
```
### <span style="color:blue">ADC APIs call with above ADC settings</span>
#### <span style="color:blue">Configure ATB1-ADC settings to be used</span>
1. API for ADC1 Sampling settings
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
#### <span style="color:blue">Configure ATB2-ADC settings to be used</span>
3. API for ADC2 Sampling settings
```
rfeHwAtb_ctrlAtbAdcBasicSettingsSetter( rfeHwAtb_atbMaster_2_e,
                                        adcSamplingRate,
                                        adcDutyCycle,
                                        adcAveragedEnabled,
                                        adcAveragingMode,
                                        adcSamplesToAverage,
                                        RFE_ERROR_FUNCTION_ARGUMENT );
```
4. API for ADC2 End settings
```
rfeHwAtb_ctrlAtbAdcModeSetter( rfeHwAtb_atbMaster_2_e,
                              adcInputSel,
                              adcEndToSet,
                              adcSingleModeGround,
                              adcGainMode,
                              RFE_ERROR_FUNCTION_ARGUMENT );
```


## <span style="color:blue">Disable pl down</span>
In order to use DC bus with input source rfeHwAtb_atbSource_dc1_e, we disable the pl down here with this API
```
rfeHwAtb_ctrAtbPlDownLinesSetter( rfeHwAtb_atbSource_dc1_e,
                                    RFE_ERROR_FUNCTION_ARGUMENT );
```
## <span style="color:green">Enabling/Disabling trimming resistors</span>
API for disabling trimming resistors since we are measuring voltage
```
rfeHwAtb_ctrlAtbTrimmingResistorsEnable( selectedAtbX,
                                         rfeHwAtb_trimmingResistor_diconnected,
                                         false,
                                         RFE_ERROR_FUNCTION_ARGUMENT );
```

## <span style="color:blue">Select ATB DC input signal coming from IP towards ATB ADC</span>
Below API define the input signal to be used (i.e. _rfeHwAtb_atbSource_dc1_e_) for ATB DC bus
```
rfeHwAtb_ctrlAtbDcInputSourceSetter( selectedAtbX,
                                     rfeHwAtb_atbSource_dc1_e,
                                     true,
                                     RFE_ERROR_FUNCTION_ARGUMENT );
```
## <span style="color:blue">Trigger sampling with continuous mode on ATB1-ADC and ATB2-ADC</span>

### <span style="color:blue">Start ATB1-ADC conversion in continuous mode</span>
API for triggering in continuous mode
```
rfeHwAtb_funcAtbAdcTriggerContSampling( rfeHwAtb_atbMaster_1_e,
                                        true,
                                        RFE_ERROR_FUNCTION_ARGUMENT );
```

### <span style="color:blue">Start ATB2-ADC convertion in continous mode</span> </span>
API for triggering in continuous mode
```
rfeHwAtb_funcAtbAdcTriggerContSampling( rfeHwAtb_atbMaster_2_e,
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
### <span style="color:blue">Read output of ATB2-ADC</span>
API for collecting converted samples
```
rfeHwSpi_register32_t averagedATB2ADCSample = rfeHwAtb_funcAtbCollectSamples( rfeHwAtb_atbMaster_2_e,
                                                                              RFE_ERROR_FUNCTION_ARGUMENT );
```
## <span style="color:green">Disconnect ATB1 from ADC1 </span>
API to disconnect an IP from ATB DC bus
```
rfeHwAtb_ctrlAtbDisconnectFromIpMode( rfeHwAtb_atbMaster_1_e,
                                        RFE_ERROR_FUNCTION_ARGUMENT );
```
## Settings to connect ADC2,3 and 4 to ATBx
### <span style="color:blue">Connectivity from ADC2 ATB_CLK_0_I to ATB 1 DC bus</span>
1. Define struct for IP to connect ATB to ADC2
```
rfeHwAtb_connectedIp_t adc2Atb1;
```
2. Define the SPI parameters to connect ATB to ADC2 this is generic for ADC2
```
adc2Atb1.id                = 0x05; // SPI address of ADC2
adc2Atb1.atbCtlOffset      = rfeHwAtb_ctlOffset_defat_e; // Offset of ADC2 0xA00
adc2Atb1.atbCtlEnShf       = 0x08; // ATB1_EN offset for ADC2 is on 8 bit
adc2Atb1.atbCtlMaskToApply = 0x00ff0000; // ATB_SEL mask for ADC2
adc2Atb1.atbCtlSelShf      = 0x10; // ATB_SEL shift for ADC2
```        
4. Check ADC2 register map for ABT_SEL for ATB_CLK_0_I:  `ATB_CLK_0_I` -> `0b00000001 = 0x00000001` -> `atbCtlSelValue`
```
atb1CtlSelValue = 0x00000001;
```
5. API to enable connection from ADC2 to ATB 1
```
rfeHwAtb_ctrlAtbConnectToIpMode( adc1Atb1,
                                   0x0f,
                                   atb1CtlSelValue,
                                   rfeHwAtb_atbMaster_1_e,
                                   rfeHwAtb_operationMode_ipDcUsage_e,
                                   RFE_ERROR_FUNCTION_ARGUMENT );
```
### <span style="color:blue">Connectivity from ADC2 ATB_CLK_1_I to  ATB 2 DC bus </span>
1. Define struct for IP to connect ATB2 to ADC2
```
rfeHwAtb_connectedIp_t adc2Atb2;
```
2. Define Connect selected ATB2 to ATB_CLK_1_I
```
adc2Atb2.id                = 0x05; // SPI address of ADC2
adc2Atb2.atbCtlEnShf = 0x0C; // ATB2_EN offset for ADC2 is on 12(0xC) bit
adc2Atb2.atbCtlMaskToApply = 0x00ff0000; // ATB_SEL mask for ADC1
adc2Atb2.atbCtlSelShf = 0x10;// ATB_SEL shift for ADC1 is on 16(0x10) bit
```
3. Check ADC2 register map  for  ATB_CLK_1_I: `ATB_CLK_1_I`  -> `0b00000010 = 0x02` -> atb2CtlSelValue

Hence the value to be set to connect the node ppd SSB to ATB2 is

```
atb2CtlSelValue = 0x00000002;
```

4. API to enable connection from ADC2 to ATB 2
```
rfeHwAtb_ctrlAtbConnectToIpMode( adc2Atb2,
                                   0x0f,
                                   atb2CtlSelValue,
                                   rfeHwAtb_atbMaster_2_e,
                                   rfeHwAtb_operationMode_ipDcUsage_e,
                                   RFE_ERROR_FUNCTION_ARGUMENT );
```
### <span style="color:blue">Connectivity from ADC3 ATB_CLK_0_I to ATB 1 DC bus</span>
1. Define struct for IP to connect ATB1 to ADC3
```
rfeHwAtb_connectedIp_t adc3Atb1;
```
2. Define the SPI parameters to connect to ATB1 this is generic for ADC3
```
adc3Atb1.id                = 0x06; // SPI address of ADC3
adc3Atb1.atbCtlOffset      = rfeHwAtb_ctlOffset_defat_e; // Offset of ADC3 0xA00
adc3Atb1.atbCtlEnShf       = 0x08; // ATB1_EN offset for ADC1 is on 8 bit
adc3Atb1.atbCtlMaskToApply = 0x00ff0000; // ATB_SEL mask for ADC3
adc3Atb1.atbCtlSelShf      = 0x10; // ATB_SEL shift for ADC3
```        
4. Check ADC3 register map for ABT_SEL for ATB_CLK_0_I:  `ATB_CLK_0_I` -> `0b00000001 = 0x00000001` -> `atbCtlSelValue`
```
atb1CtlSelValue = 0x00000001;
```
5. API to enable connection from ADC3 to ATB 1
```
rfeHwAtb_ctrlAtbConnectToIpMode( adc1Atb1,
                                   0x0f,
                                   atb1CtlSelValue,
                                   rfeHwAtb_atbMaster_1_e,
                                   rfeHwAtb_operationMode_ipDcUsage_e,
                                   RFE_ERROR_FUNCTION_ARGUMENT );
```
### <span style="color:blue">Connectivity from ADC4 ATB_CLK_0_I to ATB 1 DC bus</span>
1. Define struct for IP to connect ATB1 to ADC4
```
rfeHwAtb_connectedIp_t adc4Atb1;
```
2. Define the SPI parameters to connect ATB to ADC4 this is generic for ADC4
```
adc4Atb1.id                = 0x07; // SPI address of ADC4
adc4Atb1.atbCtlOffset      = rfeHwAtb_ctlOffset_defat_e; // Offset of ADC4 0xA00
adc4Atb1.atbCtlEnShf       = 0x08; // ATB1_EN offset for ADC4 is on 8 bit
adc4Atb1.atbCtlMaskToApply = 0x00ff0000; // ATB_SEL mask for ADC4
adc4Atb1.atbCtlSelShf      = 0x10; // ATB_SEL shift for ADC4
```        
4. Check ADC4 register map for ABT_SEL for ATB_CLK_0_I:  `ATB_CLK_0_I` -> `0b00000001 = 0x00000001` -> `atbCtlSelValue`
```
atb1CtlSelValue = 0x00000001;
```
5. API to enable connection from ADC4 to ATB 1
```
rfeHwAtb_ctrlAtbConnectToIpMode( adc4Atb1,
                                   0x0f,
                                   atb1CtlSelValue,
                                   rfeHwAtb_atbMaster_1_e,
                                   rfeHwAtb_operationMode_ipDcUsage_e,
                                   RFE_ERROR_FUNCTION_ARGUMENT );
```
