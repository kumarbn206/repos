function OutputStruct=MonitorReadRfe(InputStruct)


 monitor_select=InputStruct.monitor_select;
[ error, radarCycleCount, chirpSequenceCount, monitorValues ] = rfeabstract.rfe_monitorRead( monitor_select );

OutputStruct.Temperature= monitorValues.temperature_immediately/64;
OutputStruct.TxPower=monitorValues.txPower/10;

