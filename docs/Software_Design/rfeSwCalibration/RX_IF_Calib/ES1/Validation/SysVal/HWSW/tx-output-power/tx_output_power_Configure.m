function [OutputStruct] = tx_output_power_Configure(InputStruct)

[OutputStruct] = ConfigureRfe(InputStruct);
InputStruct.num_of_radar_cycle=1;
% [OutputStruct]=RadarCycleStartRfe(InputStruct);
% pause(3)
% [OutputStruct] = StopRadarCycle(InputStructure);
pause(3);



end