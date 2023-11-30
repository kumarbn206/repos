function [OutputStruct] = rx_attn_over_distance_Configure(InputStruct)
%% Set variables
% Constants
exp_peak = str2double(InputStruct.exp_peak);

currentSystemSetting.Temperature = "30";

currentSystemSetting.samples = str2double(InputStruct.SAMPLES);
currentSystemSetting.CHIRPS = str2double(InputStruct.CHIRPS);
%currentSystemSetting.ChirpCF = str2double(center_freq)*1e3; %Chirp_CF = 76.5e9;

% Variables from function call
currentSystemSetting.ChirpCF = str2double(InputStruct.ChirpCF) * 1e3 ; % string must be in kHz
currentSystemSetting.Freq_BW = str2double(InputStruct.Freq_BW); %320e6;
currentSystemSetting.Tchirp = str2double(InputStruct.Tchirp); %59.2e-6;
currentSystemSetting.chirpdirection = str2double(InputStruct.chirpdirection); %-1;
currentSystemSetting.Data_bit_length = str2double(InputStruct.Data_bit_length); %12; % pdc bit width
currentSystemSetting.sampleFreq = str2double(InputStruct.sampleFreq); %40e6;
currentSystemSetting.numRX = str2double(InputStruct.numRX); %4;
DATA_ADDRESS = hex2dec('0x33C80000');


[OutputStruct] = ConfigureRfe(InputStruct);

PPEConfigRfe(DATA_ADDRESS);


end