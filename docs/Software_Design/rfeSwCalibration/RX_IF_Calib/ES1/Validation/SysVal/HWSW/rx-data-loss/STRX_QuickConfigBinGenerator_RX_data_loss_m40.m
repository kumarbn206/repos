%% Constand path definitions in repository
clear all;
xml_folder = 'C:\\git\\mrta-tests-strx-sysval\\TestStand\\ConfigFiles\\';
xml_file = 'base_rfeConfig_v0_88.xml';
path_config_python_wrapper = "C:\git\mrta-tests-strx-sysval\TestStand\Common\Parameter2ConfigWrapper";

addpath(genpath('M:\15_STRX\8_Software\RFE_Integration_Test'));

result_path='M:\15_STRX\10_HWSW_integration\release_testing_0_8_8_RC3\RX_data_loss\';

filenamefiller='rfeFW_0_8_8_rc3';

RX_attenuation_over_distance=read_input_RX_attenuation_over_distance("M:\15_STRX\8_Software\RFE_Integration_Test\RX_attenuation_over_distance.xlsx");
%% for prost processing plots

exp_peak=1;


CHIRPS = 64;
SAMPLES = 2048;

currentSystemSetting.samples=SAMPLES;
currentSystemSetting.CHIRPS=CHIRPS;
currentSystemSetting.Freq_BW=320e6; %Freq_BW = 800e6;
currentSystemSetting.Tchirp=51.2e-6; %Tchirp = 30e-6;
currentSystemSetting.chirpdirection=-1; %chirpdirection = -1;
currentSystemSetting.Data_bit_length=12; % pdc bit width
currentSystemSetting.sampleFreq=40e6;
currentSystemSetting.numRX=4;

% flattop window fft , dBm output, startbin 0.5e6, end_bin=10e6



% plotenable = 1;
% plot_doppler = 1;
% closeallenable = 0;
%
% %%%%helper variables
% k=1;
% exp_peak(k) = 10; % [meter]
% exp_peak_width(k) = 0.5; %[meters]
% TX = 'TX1';
% Tx = TX;

% powervalues=[];
[row,col]=size(RX_attenuation_over_distance);

for count= 1: 600
    
    pause(5)
    %% Variable path and parameter definitions
    center_freq = num2str(RX_attenuation_over_distance{ii,1});
    tx_power = num2str(RX_attenuation_over_distance{ii,2});
    tx1_enable=(RX_attenuation_over_distance{ii,3});
    tx2_enable=(RX_attenuation_over_distance{ii,4});
    tx3_enable=(RX_attenuation_over_distance{ii,5});
    tx4_enable=(RX_attenuation_over_distance{ii,6});
    tx1_enable=(RX_attenuation_over_distance{ii,7});
    tx2_enable=(RX_attenuation_over_distance{ii,8});
    tx3_enable=(RX_attenuation_over_distance{ii,9});
    tx4_enable=(RX_attenuation_over_distance{ii,10});
    
    
    
    
    %% Simple test script
    addpath(genpath(pwd));
    base_path_matlab = pwd;
    
    name_array = {"chirpProfiles__chirpProfile0__chirpGenerator__center___frequency___kHz", ...
        "chirpProfiles__chirpProfile0__txPower__dBm",...
        "chirpProfiles__chirpProfile0__txTransmissionEnable__tx___1",...
        "chirpProfiles__chirpProfile0__txTransmissionEnable__tx___2",...
        "chirpProfiles__chirpProfile0__txTransmissionEnable__tx___3",...
        "chirpProfiles__chirpProfile0__txTransmissionEnable__tx___4",...
        "chirpSequenceConfigs__chirpSequenceConfig0__txEnable__tx___1",...
        "chirpSequenceConfigs__chirpSequenceConfig0__txEnable__tx___2",...
        "chirpSequenceConfigs__chirpSequenceConfig0__txEnable__tx___3",...
        "chirpSequenceConfigs__chirpSequenceConfig0__txEnable__tx___4"
        };
    
    
    value_array = {center_freq, ...
        tx_power, ...
        tx1_enable,...
        tx2_enable,...
        tx3_enable,...
        tx4_enable,...
        tx1_enable,...
        tx2_enable,...
        tx3_enable,...
        tx4_enable
        };
    
    cd(path_config_python_wrapper);
    
    % Script 1: Modify RFE Config file
    res = pyrunfile("RunConfigWrapper.py", "out", xml_folder = xml_folder, xml_file = xml_file, name_array = name_array, value_array = value_array);
    %     power_cycle();
    
    tx1_enable_1={tx1_enable};
    tx1_enable_num1=strcat(tx1_enable_1{:});
    
    tx2_enable_1={tx2_enable};
    tx2_enable_num1=strcat(tx2_enable_1{:});
    
    
    tx3_enable_1={tx3_enable};
    tx3_enable_num1=strcat(tx3_enable_1{:});
    
    tx4_enable_1={tx4_enable};
    tx4_enable_num1=strcat(tx4_enable_1{:});
    
    
    tx={tx1_enable_num1,tx2_enable_num1,tx3_enable_num1,tx4_enable_num1};
    findEnabledTX=num2str(find(contains(tx,'enabled')));
    tx_enabled=strcat('TX',findEnabledTX);
    currentSystemSetting.ChirpCF=str2double(center_freq)*1e3; %Chirp_CF = 76.5e9;
    
    center_freq=num2str(center_freq);
    
    
    rfeFw_Integration_test_TRX_Loopback;
    
    InputStruct.idx_win='1';
    InputStruct.unit_output='1';
    InputStruct.start_bin='0.2e6';
    InputStruct.end_bin='10e6';
    InputStruct.result_path='M:\15_STRX\10_HWSW_integration\rekease_testing_0_8_9\RX_data_loss';
    
    [OutputStruct]=PostProcessing_rfeDSP_simplified(samples,currentSystemSetting,InputStruct)
    
    
end
