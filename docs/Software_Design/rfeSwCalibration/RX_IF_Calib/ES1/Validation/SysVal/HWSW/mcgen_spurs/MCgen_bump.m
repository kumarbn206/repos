basepath = InputStruct.basepath; % this is the path the \Matlab folder
addpath(genpath(basepath));
addpath(InputStruct.Proxy_loc);





StartProxyRfe(InputStruct);
ResetRfe();
LoadFwRfe(InputStruct);
SyncRfe();
OutputStruct = GetVersionRfe(InputStruct);

count= 0;
InputStruct.config_filename='C:\STRX\RFE_FW\SAF85xx_RFE_SW_0_8_10_RC6\SAF85xx_RFE_SW\rfe\tools\rfeConfigGenerator\release\rfeConfig.bin';
InputStruct.dynamic_table_filename='';


[OutputStruct] = ConfigureRfe(InputStruct);
FastSwitchDisable(InputStruct);
% clkResetRfe(InputStruct);
DATA_ADDRESS = hex2dec('0x33C80000');

PPEConfigRfe(DATA_ADDRESS);

fsw_spectrum_mode_init(Spectrum_analyzer_address,'MCGEN',InputStruct.Center_freq,count);

for ii =1:100


    InputStruct.profile_index='0';

    [OutputStruct] = ContinuousWaveStart(InputStruct);
    pause(2)

%     clkResetRfe(InputStruct);
    [OutputStruct] = ContinuousWaveStop(InputStruct);


end

[trace_data_x1,trace_data_y1]=fsw_spectrum_mode_data_read(Spectrum_analyzer_address);

plot(trace_data_x1/1e9,trace_data_y1);
xlabel('Frequency[GHz]')
ylabel('RF Power[dBm]')
axis('tight')
ylim([-60,10]);
title('Spurs around MCGEN');
grid on;
fig_filename= strcat(InputStruct.result_path,'\MCGEN_measurements.fig');
png_filename=strcat(InputStruct.result_path,'\MCGEN_measurements.png');
saveas(gcf,fig_filename);
saveas(gcf,png_filename);
