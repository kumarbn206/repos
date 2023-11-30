basepath = InputStruct.basepath; % this is the path the \Matlab folder
addpath(genpath(basepath));
addpath(InputStruct.Proxy_loc);

currentSystemSetting.samples=2048;
currentSystemSetting.CHIRPS=128;
currentSystemSetting.Tacq=55.2;
currentSystemSetting.numRX=4;
currentSystemSetting.Deci=1;
currentSystemSetting.ChirpCF=76.5e9;
currentSystemSetting.sampleFreq=40e6;
currentSystemSetting.Freq_BW=320e6;
currentSystemSetting.Tchirp=54.2e6;
currentSystemSetting.chirpdirection=-1;
currentSystemSetting.chirpBW=320e6;


DATA_ADDRESS = hex2dec('0x33C80000');




StartProxyRfe(InputStruct);
ResetRfe();
LoadFwRfe(InputStruct);
SyncRfe();
OutputStruct = GetVersionRfe(InputStruct);

count= 0;




InputStruct.config_filename='C:\STRX\RFE_FW\SAF85xx_RFE_SW_0_8_10_RC6\SAF85xx_RFE_SW\rfe\tools\rfeConfigGenerator\release\rfeConfig_LR_chirp.bin';
InputStruct.dynamic_table_filename='';


[OutputStruct] = ConfigureRfe(InputStruct);
FastSwitchDisable(InputStruct);
clkResetRfe(InputStruct);

PPEConfigRfe(DATA_ADDRESS);
InputStruct.num_of_radar_cycle=1;
[OutputStruct]=RadarCycleStartRfe(InputStruct);
clkResetRfe(InputStruct);


data = readdata_HWSW(DATA_ADDRESS,currentSystemSetting);


raw_data=(reshape(data, currentSystemSetting.samples, currentSystemSetting.CHIRPS, 4))/2^15;
[D1FFT_dB,D2FFT_dB,D1FFT_complex,D2FFT_complex, peak_powers_allRx_log,range_vector,velocity_vector,phases_per_chirp,peak_idcs] = Postprocessing_1D_2D_FFT(raw_data,currentSystemSetting);
Plot_1D_2D_FFT(D1FFT_dB,D2FFT_dB,range_vector,velocity_vector);
Plot_Phase(phases_per_chirp,range_vector,velocity_vector,peak_idcs,currentSystemSetting);
% StandardProcessing;