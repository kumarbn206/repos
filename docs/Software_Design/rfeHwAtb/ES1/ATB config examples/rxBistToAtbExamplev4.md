# Brief sequence to use ATB DC bus
This sequence flow diagram is shown in _ATB SW Unit Configurationv5.pptx_
Please, notice that header colour are matching flow diagram.

## <span style="color:blue"> Connect IP to ATB DC bus</span>
### <span style="color:blue">Connectivity from RXBist 1 PPD LOx2 to ATB 1 DC bus</span>
1. Define struct for IP to connect to ATB
```
rfeHwAtb_connectedIp_t atbIP;
```
2. Define the SPI parameters to connect to ATB this is generic for RXBist1
```
atbIP.id = RFE_HW_SPI_RX_BIST_MODULE; // 0x17 - SPI address of RXBist1
atbIP.atbCtlOffset = rfeHwAtb_ctlOffset_default_e; // Offset of ATB register on RXBist1
atbIP.atbCtlEnShf = RFE_HW_RXBIST_ATB_ATB1_EN_BIT; // 8 - ATB1_EN offset for RXBist1
atbIP.atbCtlMaskToApply = RFE_HW_RXBIST_ATB_ATB1_SEL_MSK; // 0x000ff000 - ATB1_SEL mask for RX1
atbIP.atbCtlSelShf = RFE_HW_RXBIST_ATB_ATB1_SEL_SHF; // 12 - ATB1_SEL shift for RX1
```        
4. Check RXBist register map for ABT1_SEL for atb control PPD LOx2:  `d_t_lox2_atb1_ppd_en_ls1v8<0>: vbp, atb_typ=TBA` -> `0b00001011 = 0x0000000Bul` -> `atbCtlSelValue`
```
atbCtlSelValue = 0x0000000Bul;
```
5. API to enable connection from RXBist 1 to ATB 1
```
rfeHwAtb_ctrlAtbConnectToIpModule( atbIP,
                                   RFE_HW_ATB_DEFAULT_ATB_COUNTER_VALUE,
                                   atbCtlSelValue,
                                   rfeHwAtb_atbMaster_1_e,
                                   rfeHwAtb_operationMode_ipDcUsage_e,
                                   RFE_ERROR_FUNCTION_ARGUMENT );
```
### <span style="color:blue">Connectivity from RXBist 1 PPD ssb to ATB 2 DC bus </span>
2. Define Connect selected ATB2to RXBist1 PPD ssb
```
atbIP.atbCtlEnShf = RFE_HW_RX_ATB_CTL_ATB2_EN_BIT; // ATB2_EN offset for RXBist1
atbIP.atbCtlMaskToApply = RFE_HW_RX_ATB_CTL_ATB2_SEL_MSK; // ATB2_SEL mask for RXBist1
atbIP.atbCtlSelShf = RFE_HW_RX_ATB_CTL_ATB2_SEL_SHF;// ATB2_SEL shift for RXBist1
```
3. Check RXBist register map  for  ATB2_SEL ppd SSB test mode: `d_ppd_atb2_ctrl_ls1v8<3>: vdda_ppd_1v45, atb_typ=TBA`  -> `0b00001110 = 0xEul` -> atbCtlSelValue

Hence the value to be set to connect the node ppd SSB to ATB2 is

```
atbCtlSelValue = 0x0000000Eul;
```

4. API to enable connection from RXBist 1 to ATB 2
```
rfeHwAtb_ctrlAtbConnectToIpModule( atbIP,
                                   RFE_HW_ATB_DEFAULT_ATB_COUNTER_VALUE,
                                   atbCtlSelValue,
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
rfeHwAtb_adcAverageMode_t adcAveragingMode = rfeHwAtb_adcAverageMode_mono_e;
```
5. ADC number of samples to averaged
```
rfeHwAtb_adcAveragingOnSamples_t adcSamplesToAverage = rfeHwAtb_adcAveragingOn_8samples_e;
```
6. ADC internal input selector based on ADC Ending configurations
```
rfeHwAtb_adcInner_Sel_In_t adcInputSel = rfeHwAtb_adcInner_Sel_In_0; // ADC_SEL=0x00 selects the differential inputs, check for your concrete case!
 ```
7. ADC Ending mode (differential/single)
```
rfeHwAtb_adcEndMode_t adcEndToSet = rfeHwAtb_adcEndMode_single_e;
```
8. ADC Grounding
```
rfeHwAtb_adcInputMuxer_VNeg_SE_Selector_t adcSingleModeGround = rfeHwAtb_adcInputMuxer_VNeg_SE_Selector_vssa_1v8_e; 
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


## <span style="color:blue">Disable pull down</span>
In order to use DC bus with input source rfeHwAtb_atbSource_dc1_e, we disable the pull down here with this API
```
rfeHwAtb_ctrAtbPullDownLinesSetter( rfeHwAtb_atbSource_dc1_e,
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
## <span style="color:blue">Trigger sampling with mono mode on ATB1-ADC and ATB2-ADC</span>

### <span style="color:blue">Start ATB1-ADC conversion in mono mode</span>
API for triggering in mono mode
```
rfeHwAtb_funcAtbAdcTriggerMonoSampling( rfeHwAtb_atbMaster_1_e,
                                        true,
                                        RFE_ERROR_FUNCTION_ARGUMENT );
```

### <span style="color:blue">Start ATB2-ADC convertion in mono mode</span> </span>
API for triggering in mono mode
```
rfeHwAtb_funcAtbAdcTriggerMonoSampling( rfeHwAtb_atbMaster_2_e,
                                        true,
                                        RFE_ERROR_FUNCTION_ARGUMENT );
```
### <span style="color:blue">Read out of converted samples on ATB1-ADC and ATB2-ADC*/</span>

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
## <span style="color:green">Disconnect ATB1 from RXBist 1 PPD</span>
API to disconnect an IP from ATB DC bus
```
rfeHwAtb_ctrlAtbDisconnectFromIpModule( rfeHwAtb_atbMaster_1_e,
                                        RFE_ERROR_FUNCTION_ARGUMENT );
```

## Full sequence
```
rfeHwAtb_connectedIp_t atbIP;
atbIP.id = RFE_HW_SPI_RX_BIST_MODULE; // 0x17 - SPI address of RXBist1
atbIP.atbCtlOffset = rfeHwAtb_ctlOffset_default_e; // Offset of ATB register on RXBist1
atbIP.atbCtlEnShf = RFE_HW_RXBIST_ATB_ATB1_EN_BIT; // 8 - ATB1_EN offset for RXBist1
atbIP.atbCtlMaskToApply = RFE_HW_RXBIST_ATB_ATB1_SEL_MSK; // 0x000ff000 - ATB1_SEL mask for RX1
atbIP.atbCtlSelShf = RFE_HW_RXBIST_ATB_ATB1_SEL_SHF; // 12 - ATB1_SEL shift for RX1

atbCtlSelValue = 0x0000000Bul; //`d_t_lox2_atb1_ppd_en_ls1v8<0>: vbp, atb_typ=TBA` -> `0b00001011 = 0x0000000Bul` -> `atbCtlSelValue`

rfeHwAtb_ctrlAtbConnectToIpModule( atbIP,
                                   RFE_HW_ATB_DEFAULT_ATB_COUNTER_VALUE,
                                   atbCtlSelValue,
                                   rfeHwAtb_atbMaster_1_e,
                                   rfeHwAtb_operationMode_ipDcUsage_e,
                                   RFE_ERROR_FUNCTION_ARGUMENT );

atbIP.atbCtlEnShf = RFE_HW_RX_ATB_CTL_ATB2_EN_BIT; // ATB2_EN offset for RXBist1
atbIP.atbCtlMaskToApply = RFE_HW_RX_ATB_CTL_ATB2_SEL_MSK; // ATB2_SEL mask for RXBist1
atbIP.atbCtlSelShf = RFE_HW_RX_ATB_CTL_ATB2_SEL_SHF;// ATB2_SEL shift for RXBist1

atbCtlSelValue = 0x0000000Eul; //`d_ppd_atb2_ctrl_ls1v8<3>: vdda_ppd_1v45, atb_typ=TBA`  -> `0b00001110 = 0xEul` -> atbCtlSelValue

rfeHwAtb_ctrlAtbConnectToIpModule( atbIP,
                                   RFE_HW_ATB_DEFAULT_ATB_COUNTER_VALUE,
                                   atbCtlSelValue,
                                   rfeHwAtb_atbMaster_2_e,
                                   rfeHwAtb_operationMode_ipDcUsage_e,
                                   RFE_ERROR_FUNCTION_ARGUMENT );

rfeHwAtb_adcFclk_t adcSamplingRate = rfeHwAtb_adcSamplingRate_5M_e;
rfeHwAtb_adcDutyCycle_t adcDutyCycle = rfeHwAtb_adcDutyCycle_50_e;
rfeHwAtb_adcAverageEnable_t adcAveragedEnabled = rfeHwAtb_adcAverageEnable_enabled_e;
rfeHwAtb_adcAverageMode_t adcAveragingMode = rfeHwAtb_adcAverageMode_mono_e;
rfeHwAtb_adcAveragingOnSamples_t adcSamplesToAverage = rfeHwAtb_adcAveragingOn_8samples_e;
rfeHwAtb_adcInner_Sel_In_t adcInputSel = rfeHwAtb_adcInner_Sel_In_0;
rfeHwAtb_adcEndMode_t adcEndToSet = rfeHwAtb_adcEndMode_single_e;
rfeHwAtb_adcInputMuxer_VNeg_SE_Selector_t adcSingleModeGround = rfeHwAtb_adcInputMuxer_VNeg_SE_Selector_vssa_1v8_e; 
rfeHwAtb_adcGainMode_t adcGainMode = rfeHwAtb_adcGainMode_normal_e;

rfeHwAtb_ctrlAtbAdcBasicSettingsSetter( rfeHwAtb_atbMaster_1_e,
                                        adcSamplingRate,
                                        adcDutyCycle,
                                        adcAveragedEnabled,
                                        adcAveragingMode,
                                        adcSamplesToAverage,
                                        RFE_ERROR_FUNCTION_ARGUMENT );

rfeHwAtb_ctrlAtbAdcModeSetter( rfeHwAtb_atbMaster_1_e,
                               adcInputSel,
                               adcEndToSet,
                               adcSingleModeGround,
                               adcGainMode,
                               RFE_ERROR_FUNCTION_ARGUMENT );

rfeHwAtb_ctrlAtbAdcBasicSettingsSetter( rfeHwAtb_atbMaster_2_e,
                                        adcSamplingRate,
                                        adcDutyCycle,
                                        adcAveragedEnabled,
                                        adcAveragingMode,
                                        adcSamplesToAverage,
                                        RFE_ERROR_FUNCTION_ARGUMENT );

rfeHwAtb_ctrlAtbAdcModeSetter( rfeHwAtb_atbMaster_2_e,
                              adcInputSel,
                              adcEndToSet,
                              adcSingleModeGround,
                              adcGainMode,
                              RFE_ERROR_FUNCTION_ARGUMENT );

rfeHwAtb_ctrAtbPullDownLinesSetter( rfeHwAtb_atbSource_dc1_e,
                                    RFE_ERROR_FUNCTION_ARGUMENT );



rfeHwAtb_ctrlAtbDcInputSourceSetter( selectedAtbX,
                                     rfeHwAtb_atbSource_dc1_e,
                                     true,
                                     RFE_ERROR_FUNCTION_ARGUMENT );

// Do a SW average to overcome ATB ADC first sample wrong
rfeHwSpi_register32_t averagedATB1ADCSample = 0;
rfeHwSpi_register32_t averagedATB2ADCSample = 0;
for( uint8_t i = 0ul; i < 2; i++ )
{                                     
rfeHwAtb_funcAtbAdcTriggerMonoSampling( rfeHwAtb_atbMaster_1_e,
                                        true,
                                        RFE_ERROR_FUNCTION_ARGUMENT );
rfeHwAtb_funcAtbAdcTriggerMonoSampling( rfeHwAtb_atbMaster_2_e,
                                        true,
                                        RFE_ERROR_FUNCTION_ARGUMENT );
rfeWait_usec( 10u, RFE_ERROR_FUNCTION_ARGUMENT );
rfeHwAtb_funcAtbAdcTriggerMonoSampling( rfeHwAtb_atbMaster_1_e,
                                        true,
                                        RFE_ERROR_FUNCTION_ARGUMENT );
rfeHwAtb_funcAtbAdcTriggerMonoSampling( rfeHwAtb_atbMaster_2_e,
                                        true,
                                        RFE_ERROR_FUNCTION_ARGUMENT );
rfeWait_usec( 10u, RFE_ERROR_FUNCTION_ARGUMENT );                                        


averagedATB1ADCSample = averagedATB1ADCSample + rfeHwAtb_funcAtbCollectSamples( feHwAtb_atbMaster_1_e,
                                                                              RFE_ERROR_FUNCTION_ARGUMENT );
averagedATB2ADCSample = averagedATB1ADCSample + rfeHwAtb_funcAtbCollectSamples( rfeHwAtb_atbMaster_2_e,
                                                                              RFE_ERROR_FUNCTION_ARGUMENT );

}

voltageMeasuredATB1 =  rfeHwAtb_funcAtbAdcSamplesToVoltageConvert(  averagedATB1ADCSample/2, selectedAtb1, adcEndToSet, adcGainMode, RFE_ERROR_FUNCTION_ARGUMENT );

voltageMeasuredATB2 =  rfeHwAtb_funcAtbAdcSamplesToVoltageConvert(  averagedATB1ADCSample/2, selectedAtb2, adcEndToSet, adcGainMode, RFE_ERROR_FUNCTION_ARGUMENT );

rfeHwAtb_ctrlAtbDisconnectFromIpModule( rfeHwAtb_atbMaster_1_e,
                                        RFE_ERROR_FUNCTION_ARGUMENT );
```
