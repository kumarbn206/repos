function [OutputStruct] = rx_attenuation_over_distance(InputStruct)

%% Set variables
% Constants
exp_peak = str2double(InputStruct.exp_peak);
CHIRPS = 64;
SAMPLES = 2048;

currentSystemSetting.samples = SAMPLES;
currentSystemSetting.CHIRPS = CHIRPS;
%currentSystemSetting.ChirpCF = str2double(center_freq)*1e3; %Chirp_CF = 76.5e9;

% Variables from function call
currentSystemSetting.ChirpCF = str2double(InputStruct.ChirpCF) * 1e3 ; % string must be in kHz
currentSystemSetting.Freq_BW = str2double(InputStruct.Freq_BW); %320e6;
currentSystemSetting.Tchirp = str2double(InputStruct.Tchirp); %59.2e-6;
currentSystemSetting.chirpdirection = str2double(InputStruct.chirpdirection); %-1;
currentSystemSetting.Data_bit_length = str2double(InputStruct.Data_bit_length); %12; % pdc bit width
currentSystemSetting.sampleFreq = str2double(InputStruct.sampleFreq); %40e6;
currentSystemSetting.numRX = str2double(InputStruct.numRX); %4;

tx_power = str2double(InputStruct.tx_power);
tx1_enable = InputStruct.tx1_enable;
tx2_enable = InputStruct.tx2_enable;
tx3_enable = InputStruct.tx3_enable;
tx4_enable = InputStruct.tx4_enable;

% tx1_enable=num2str(RX_attenuation_over_distance{ii,7});
% tx2_enable=num2str(RX_attenuation_over_distance{ii,8});
% tx3_enable=num2str(RX_attenuation_over_distance{ii,9});
% tx4_enable=num2str(RX_attenuation_over_distance{ii,10});


% flattop window fft , dBm output, startbin 0.5e6, end_bin=10e6
idx_win=1;
unit_output=1;
start_bin=0.2e6;
end_bin=20e6;

% Generate string(s) for logging
tx1_enable_1 = {tx1_enable};
tx1_enable_num1 = strcat(tx1_enable_1{:});
tx2_enable_1 = {tx2_enable};
tx2_enable_num1 = strcat(tx2_enable_1{:});
tx3_enable_1 = {tx3_enable};
tx3_enable_num1 = strcat(tx3_enable_1{:});
tx4_enable_1 = {tx4_enable};
tx4_enable_num1 = strcat(tx4_enable_1{:});
tx = {tx1_enable_num1,tx2_enable_num1,tx3_enable_num1,tx4_enable_num1};
findEnabledTX = num2str(find(contains(tx,'enabled')));
tx_enabled = strcat('TX',findEnabledTX);
TX = tx_enabled;
Tx = TX;

center_freq_str = num2str(currentSystemSetting.ChirpCF);

%% Constant path definitions in repository
%addpath(genpath('M:\15_STRX\8_Software\RFE_Integration_Test'));
%result_path='M:\15_STRX\10_HWSW_integration\release_testing_0_8_8\RX_attenuation_over_distance\';
%filenamefiller = 'rfeFW_0_8_7';

addpath(genpath(InputStruct.basepath));
result_path = InputStruct.result_path;
filenamefiller = InputStruct.filenamefiller;



%% Call Integration Test
[samples,Tx_temp]= rfeFw_Integration_test_TRX_Loopback_with_2nd_fft(SAMPLES,CHIRPS);

%% Post Processing
% Generate filenames
filename_fig_1DFFT = strcat(result_path,filenamefiller,'_first_fft_',Tx,'_',center_freq_str,'_',num2str(exp_peak),'m');
filename_fig_1DFFT_range = strcat(result_path,filenamefiller,'_range_fft_',Tx,'_',center_freq_str,'_',num2str(exp_peak),'m');
filename_fig_2DFFT = strcat(result_path,filenamefiller,'_velocity_distance_plot_',Tx,'_',center_freq_str,'_',num2str(exp_peak),'m');

% Run post processing script
PostProcessing_rfeDSP_simplified(samples, currentSystemSetting, idx_win,unit_output,start_bin,end_bin,filename_fig_1DFFT, filename_fig_2DFFT,filename_fig_1DFFT_range,Tx)

end
