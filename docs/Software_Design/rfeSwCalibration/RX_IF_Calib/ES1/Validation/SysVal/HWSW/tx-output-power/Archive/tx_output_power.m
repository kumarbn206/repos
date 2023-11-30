function [OutputStruct] = tx_output_power(InputStruct)
%% Constant and variables definitions
clear all;

% is CODE and DATA files used ?
CODE_DATA_CHECK='no';
CODE_DATA_FILE_Path='M:\15_STRX\8_Software\RFE_FW\SAF85xx_RFE_SW_EAR_0.8.8_D220624\rfe\rfeFw\bin';

% CONFIG_filename = 'C:\git\mrta-tests-strx-sysval\TestStand\ConfigFiles\rfeConfig.bin';
% dynamic_table ='C:\git\mrta-tests-strx-sysval\TestStand\ConfigFiles\rfeDynamicTables.bin'
% RADAR_CYCLE_COUNT = 1;
% DATA_ADDRESS = hex2dec('33E00000');
% CHIRPS = 64;
% SAMPLES = 1024;

MONITOR_SELECT = hex2dec('FF'); %% All monitors

CONFIG_filename = InputStruct.config_filename;

% RFE constants
RFE_TIME_TICKS_PER_MS = 40000;
RFE_TEMPERATURE_1_DEG_CELSIUS = 64;


%% Start of code
addpath(genpath(InputStruct.basepath));
center_freq = str2double(InputStruct.ChirpCF) * 1e3 ; % string must be in kHz

addpath(genpath(InputStruct.Proxy_loc));
addpath(genpath(pwd));

%% Setup rfeProxy & rfeFw
Proxyfilename = strcat(InputStruct.Proxy_loc,'\StartProxy.bat &');
elfFileNamewithLoc = [InputStruct.elfFileLoc, '\', InputStruct.elfFileName, '.elf'];

if (~exist('initialized', 'var') || ~initialized)
    disp('Run RFE Proxy');
    system(Proxyfilename);
    ll.POR_set(0);
    pause(2)
    ll.POR_set(1);
    pause(2)
    disp('Loading ELF');
    pause(1)

    ll.t32_startelf(elfFileNamewithLoc);
    pause(10)

    disp('Selecting Lauterbach');
    ll.select(1)

    if strcmpi(CODE_DATA_CHECK,'yes')
        ll.t32_cmd(['Data.Load.binary ' CODE_DATA_FILE_Path '\CODE 0x0'])
        ll.t32_cmd(['Data.Load.binary ' CODE_DATA_FILE_Path '\DATA 0x20000000'])
        ll.t32_cmd('Register.Init') % This resets the registers to start again from entry
    end

    disp('Starting rfeFw');
    ll.t32_cmd('go');

    initialized = false;
    fprintf('Initializing');
    while (~initialized)
        error = rfeabstract.rfe_sync();
        fprintf('.');
        if ~error
            initialized = true;
        end
    end
    if (~error)
        fprintf('\nRFE Initialized!\n');
    else
        return
    end
end

%% rfe_testSetParam: Mask all FCCU errors
%rfeabstract.rfe_testSetParam( rfe_testParam_maskError_e, rfe_maskError_all_error );

%% rfe_getVersion
[ error, hwType, hwVariant, hwVersion, fwVariant, fwVersionReleased, fwVersionMajor, fwVersionMinor, fwVersionPatch, fwHash ] = rfeabstract.rfe_getVersion()
if (~error)
    if (fwVersionReleased)
        fprintf("RFE FW Version: %u.%u.%u\n", fwVersionMajor, fwVersionMinor, fwVersionPatch );
    else
        fprintf("RFE FW Version: %08x\n", fwHash );
    end
else
    return
end
%% rfe_getTime
[ error, time ] = rfeabstract.rfe_getTime()
if (~error)
    fprintf("RFE Time: %.3f ms\n", time / RFE_TIME_TICKS_PER_MS );
else
    return
end
%% rfe_monitorRead
[ error, radarCycleCount, chirpSequenceCount, rxSaturationCount_stage1I1, rxSaturationCount_stage1I2, rxSaturationCount_stage1I3, rxSaturationCount_stage1I4, rxSaturationCount_stage1Q1, rxSaturationCount_stage1Q2, rxSaturationCount_stage1Q3, rxSaturationCount_stage1Q4, rxSaturationCount_stage2I1, rxSaturationCount_stage2I2, rxSaturationCount_stage2I3, rxSaturationCount_stage2I4, rxSaturationCount_stage2Q1, rxSaturationCount_stage2Q2, rxSaturationCount_stage2Q3, rxSaturationCount_stage2Q4, pdcClippingCount1, pdcClippingCount2, pdcClippingCount3, pdcClippingCount4, temperature_beforeChirpSequence1, temperature_beforeChirpSequence2, temperature_beforeChirpSequence3, temperature_beforeChirpSequence4, temperature_afterChirpSequence1, temperature_afterChirpSequence2, temperature_afterChirpSequence3, temperature_afterChirpSequence4, temperature_immediately1, temperature_immediately2, temperature_immediately3, temperature_immediately4 ] = rfeabstract.rfe_monitorRead( MONITOR_SELECT );
if (~error)
    fprintf( "Temperature: Tx12 %.1f C, Tx34 %.1f C, XO %.1f C, RX %.1f C\n", temperature_immediately1 / RFE_TEMPERATURE_1_DEG_CELSIUS, temperature_immediately2 / RFE_TEMPERATURE_1_DEG_CELSIUS, temperature_immediately3 / RFE_TEMPERATURE_1_DEG_CELSIUS, temperature_immediately4 / RFE_TEMPERATURE_1_DEG_CELSIUS );
else
    return
end

pause(5)

%% Simple test script
addpath(genpath(pwd));

[ error ] = rfeabstract.rfe_configure(CONFIG_filename, '');
if (~error)
    disp('RFE Configured');
else
    return
end

error = rfeabstract.rfe_testContinuousWaveTransmissionStart(0);
pause(2)
values = power_meter_value(str2double(center_freq));
powervalues = [powervalues; values]
rfeabstract.rfe_testContinuousWaveTransmissionStop;

%     helper_plot_avg_fft(samples, Tx, currentSystemSetting,exp_peak,filename_1st_fft,filename_doppler_fft,filename_distance_velocity );

end