%% Constand path definitions in repository
clear all;
xml_folder = 'C:\\git\\mrta-tests-strx-sysval\\TestStand\\ConfigFiles\\';
xml_file = 'base_rfeConfig_v0_88.xml';
path_config_python_wrapper = "C:\git\mrta-tests-strx-sysval\TestStand\Common\Parameter2ConfigWrapper";

addpath(genpath('M:\15_STRX\8_Software\RFE_Integration_Test'));

result_path='M:\15_STRX\10_HWSW_integration\release_testing_0_8_8\RX_attenuation_over_distance\';
filenamefiller='rfeFW_0_8_8_rc2';

TXPower=readTxOutputPowerParam("M:\15_STRX\8_Software\RFE_Integration_Test\TX_Power.xlsx");


powervalues=[];
power_cycle();

%% for prost processing plots

Proxy_loc='C:\STRX\RFEProxy\RFEProxy_V0_5_18\bin';
elfFileLoc='M:\15_STRX\8_Software\RFE_FW\SAF85xx_RFE_SW_EAR_0_8_8_D220624_RC2\SAF85xx_RFE_SW_EAR_0_8_8_D220624\rfe\rfeFw\bin\';
elfFileName='rfeFw_hw101_release_armclang';
filenamefiller='celing_test_STB_fw_0_8_8';

addpath(genpath(Proxy_loc));
addpath(genpath(pwd));


%% is CODE and DATA files used ?
CODE_DATA_CHECK='no';
CODE_DATA_FILE_Path='M:\15_STRX\8_Software\RFE_FW\SAF85xx_RFE_SW_EAR_0.8.8_D220624\rfe\rfeFw\bin';
result_path='C:\Users\nxf80974\Desktop\HW_SW_Integration\Release_08_8_RC2';








%% Parameters
RADAR_CYCLE_COUNT = 1;
MONITOR_SELECT = hex2dec('FF'); %% All monitors
DATA_ADDRESS = hex2dec('33E00000');

CHIRPS = 64;
SAMPLES = 1024;



%% RFE constants
RFE_TIME_TICKS_PER_MS = 40000;
RFE_TEMPERATURE_1_DEG_CELSIUS = 64;

%% Setup rfeProxy & rfeFw
Proxyfilename= strcat(Proxy_loc,'\StartProxy.bat &')
elfFileNamewithLoc=[elfFileLoc,'\',elfFileName,'.elf'];
% PowerSupplyReset;

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

    if strcmp(lower(CODE_DATA_CHECK),'yes')
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




% powervalues=[];
[row,col]=size(TXPower);

for ii = 1: row

    pause(5)
    %% Variable path and parameter definitions
    center_freq = num2str(TXPower{ii,1});
    tx_power = num2str(TXPower{ii,2});
    tx1_enable=num2str(TXPower{ii,3});
    tx2_enable=num2str(TXPower{ii,4});
    tx3_enable=num2str(TXPower{ii,5});
    tx4_enable=num2str(TXPower{ii,6});
    tx1_enable=num2str(TXPower{ii,7});
    tx2_enable=num2str(TXPower{ii,8});
    tx3_enable=num2str(TXPower{ii,9});
    tx4_enable=num2str(TXPower{ii,10});




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
    
    CONFIG_filename= 'C:\git\mrta-tests-strx-sysval\TestStand\ConfigFiles\rfeConfig.bin'
    dynamic_table='C:\git\mrta-tests-strx-sysval\TestStand\ConfigFiles\rfeDynamicTables.bin'
    
    
    [ error ] = rfeabstract.rfe_configure(CONFIG_filename, '');
    if (~error)
        disp('RFE Configured');
    else
        return
    end
    
    
    error=rfeabstract.rfe_testContinuousWaveTransmissionStart(0);
    
    pause(2)
    values= power_meter_value(str2double(center_freq));

    powervalues= [powervalues; values]
    
    rfeabstract.rfe_testContinuousWaveTransmissionStop;
    

%     helper_plot_avg_fft(samples, Tx, currentSystemSetting,exp_peak,filename_1st_fft,filename_doppler_fft,filename_distance_velocity );
    
end
