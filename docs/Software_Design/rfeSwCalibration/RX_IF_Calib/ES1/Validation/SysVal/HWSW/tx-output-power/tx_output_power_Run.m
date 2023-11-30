function [OutputStruct] = tx_output_power_Run(InputStruct)

[OutputStruct] = ContinuousWaveStart(InputStruct);
InputStruct.monitor_select=hex2dec('0x1ff');
[OutputStruct]= MonitorReadRfe(InputStruct);

temp_struct.TxPower = reshape(OutputStruct.TxPower, 1,32);
temp_struct.Temperature = reshape(OutputStruct.Temperature,1,4);

OutputStruct = rmfield(OutputStruct, 'TxPower');
OutputStruct = rmfield(OutputStruct, 'Temperature');

OutputStruct.json_str = cellstr(jsonencode(temp_struct));

pause(10);
end