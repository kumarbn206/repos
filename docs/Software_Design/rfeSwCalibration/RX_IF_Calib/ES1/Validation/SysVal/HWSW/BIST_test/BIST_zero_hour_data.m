basepath = InputStruct.basepath; % this is the path the \Matlab folder
addpath(genpath(basepath));
addpath(InputStruct.Proxy_loc);



input_table=load('');


tx12_phase_diff_all=[];
tx13_phase_diff_all=[];
tx14_phase_diff_all=[];

tx_power_level_all=[];
tx_freq_all=[];
rx12_phase_diff_all=[];
rx13_phase_diff_all=[];
rx14_phase_diff_all=[];

rx12_gain_diff_all=[];
rx13_gain_diff_all=[];
rx14_gain_diff_all=[];

rx_freq_all=[];

DATA_ADDRESS = hex2dec('0x33C80000');




StartProxyRfe(InputStruct);
ResetRfe();
LoadFwRfe(InputStruct);
SyncRfe();
OutputStruct = GetVersionRfe(InputStruct);

count= 0;




InputStruct.config_filename='C:\STRX\RFE_FW\SAF85xx_RFE_SW_0_8_10_RC6\SAF85xx_RFE_SW\rfe\tools\rfeConfigGenerator\release\rfeConfig.bin';
InputStruct.dynamic_table_filename='';


% [OutputStruct] = ConfigureRfe(InputStruct);
% FastSwitchDisable(InputStruct);
% clkResetRfe(InputStruct);
   
for ii=1:16
    
    
    
     [OutputStruct] = ConfigureRfe(InputStruct);
%      FastSwitchDisable(InputStruct);

%     clkResetRfe(InputStruct);

    [tx_phase_diff,tx_power_level, tx_freq,rx_phase_diff,rx_gain_diff,rx_freq]=getBistZeroHourData;

    tx12_phase_diff_all=[tx12_phase_diff_all,tx_phase_diff(1)];
    tx13_phase_diff_all=[tx13_phase_diff_all,tx_phase_diff(2)];
    tx14_phase_diff_all=[tx14_phase_diff_all,tx_phase_diff(3)];

    tx_power_level_all=[tx_power_level_all,tx_power_level];
    tx_freq_all=[tx_freq_all,tx_freq];

    rx12_phase_diff_all=[rx12_phase_diff_all,rx_phase_diff(1)];
    rx13_phase_diff_all=[rx13_phase_diff_all,rx_phase_diff(2)];
    rx14_phase_diff_all=[rx14_phase_diff_all,rx_phase_diff(3)];

    rx12_gain_diff_all=[rx12_gain_diff_all,rx_gain_diff(1)];
    rx13_gain_diff_all=[rx13_gain_diff_all,rx_gain_diff(2)];
    rx14_gain_diff_all=[rx14_gain_diff_all,rx_gain_diff(3)];

    rx_freq_all=[rx_freq_all,rx_freq];

end

disp(['tx12_phase_diff ',num2str(tx12_phase_diff_all)]);
disp(['tx13_phase_diff ',num2str(tx13_phase_diff_all)]);
disp(['tx14_phase_diff ',num2str(tx14_phase_diff_all)]);
disp(['tx_power_level ',num2str(tx_power_level_all)]);
disp(['tx_freq ',num2str(tx_freq_all)]);
disp(['rx12_phase_diff ',num2str(rx12_phase_diff_all)]);
disp(['rx13_phase_diff ',num2str(rx12_phase_diff_all)]);
disp(['rx14_phase_diff ',num2str(rx12_phase_diff_all)]);
disp(['rx12_gain_diff ',num2str(rx12_gain_diff_all)]);
disp(['rx13_gain_diff ',num2str(rx13_gain_diff_all)]);
disp(['rx14_gain_diff ',num2str(rx14_gain_diff_all)]);
disp(['rx_freq ',num2str(rx_freq_all)]);



