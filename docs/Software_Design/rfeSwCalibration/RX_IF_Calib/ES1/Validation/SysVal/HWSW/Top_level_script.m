%% House keeping
% close all;
clear all;
%% Variables post processing
localMachine = ~false
sysvalData = ~false

gitSHA = '85e11ee'

if sysvalData

    measurements = {'rising','falling'}
    
    dataSet = '76_GHz_rfeFw_SHA_c943bf1_calibOnRx2_UsingV2_STRX_7319';
    dataSet = '76GHz_rfeFw_SHA_fede9df';
    dataSet = 'rfeFw_SHA_07691a3_calibOnRx2_results'
    dataSet = 'SHA_946173a'
    dataSet = '76700000000_GHz_hpf_200KHz_Gain43'

    dataDir = ['C:\Users\nxf59937\Downloads\' dataSet '\'];

    % Variable indicating using a single file coming from sys val
    singleFile = false;
else
    dataSet = 'strx_7319_RX_IF_v2_filterResponse_SHA_141f580'
    dataSet = 'strx_7319_RX_IF_v2_filterResponse738820.5053_SHA_85e11ee'
    dataSet = 'strx_7319_RX_IF_v2_filterResponse_falling_738820.6444_SHA_95d98f1'
    dataDir = ['Y:\bringUpScript\STRX-7319\' dataSet];

    measurements = {'rising'}
%     measurements = {'falling'} 

    % Variable indicating using a single file coming from our setup
    singleFile = true;
end

%% Path Settings 
if localMachine
    basePath = 'C:\Users\nxf59937\Downloads\strx4294-wo-timeout_SHA_64a6ba0\strx4294\';
    InputStruct.basepath= basePath;
    InputStruct.Proxy_loc= basePath;
    InputStruct.elfFileLoc='C:\LocalData\Projects\build\rfeFw\hw102\release\armclang\apps\rfeFw\';
    InputStruct.elfFileName='rfeFw_hw102_release_armclang';
    InputStruct.resultpath='';
    config_filenames{1}='C:\LocalData\Projects\STRX\tools\rfeConfigGenerator\release\rfeConfig.bin';
    addpath(genpath('C:\LocalData\Projects\STRX\docs\Software_Design\rfeSwCalibration\RX_IF_Calib\Validation\HWSW\'));
    
else
    basePath = 'C:\Users\nxf59937\Desktop\bringUpScript-setUp03\workspaceSetup03\'
    InputStruct.basepath=[basePath 'rfeProxy-9301b13ef0-STRX-4294-rx-if-calibration-v2\'];
    InputStruct.Proxy_loc=[basePath 'rfeProxy-9301b13ef0-STRX-4294-rx-if-calibration-v2\'];
    InputStruct.elfFileLoc='Z:\bringUpScript\STRX-7319';
    InputStruct.elfFileName='rfeFw_hw102_release_armclang';
    InputStruct.resultpath='';
    config_filenames{1}=[basePath 'rfeProxy-9301b13ef0-STRX-4294-rx-if-calibration-v2\SAF85xx_RFE_SW\tools\rfeConfigGenerator\release\rfeConfig.bin'];
    addpath(genpath([basePath 'STRX\rfe\docs\Software_Design\rfeSwCalibration\RX_IF_Calib\Validation\HWSW\']));
end

    InputStruct.CodeDataCheck='no';
    InputStruct.CodeDataFilePath='';

%% xml config 
if localMachine
    rfeConfigStruct = readAnGenerateRfeConfigBin('C:\LocalData\Projects\STRX\docs\Software_Design\rfeSwCalibration\RX_IF_Calib\Validation\','rfeConfig_Sysval.xml','C:\LocalData\Projects\STRX\tools\rfeConfigGenerator\release\')
else
    rfeConfigStruct = readAnGenerateRfeConfigBin([basePath 'STRX\rfe\docs\Software_Design\rfeSwCalibration\RX_IF_Calib\Validation\'],'rfeConfig_Sysval.xml',[basePath 'rfeProxy-9301b13ef0-STRX-4294-rx-if-calibration-v2\SAF85xx_RFE_SW\tools\rfeConfigGenerator\release\'])
end

%% Instrument settings
if localMachine
else
    SigGenAddress='USB0::0x0AAD::0x0054::179661::INSTR';
    Powermeter1_Address=convertStringsToChars(strcat('GPIB', num2str(0), '::', num2str(14), '::INSTR'));
    Powermeter2_Address=convertStringsToChars(strcat('GPIB', num2str(0), '::', num2str(22), '::INSTR'));
    DMM1_Address=convertStringsToChars(strcat('GPIB', num2str(0), '::', num2str(16), '::INSTR'));
end


%% measurement scripts 

% RX_conversion_gain;
if localMachine
    if sysvalData
        RX_conversion_gain_sysVal_PostProccess;
    else
        RX_conversion_gain_local_PostProccess;
    end
else
    usePowerMeter = false;
    RX_conversion_gain_Capture;
end

% TX_output_power;

% rx_filter_shaping

% InputStruct.Center_freq=78; %in GHz
% OBW_single_setting;
% InputStruct.Center_freq=78; %in GHz

% MCgen_bump;


% RTS_2_targets_MR_Profile;
