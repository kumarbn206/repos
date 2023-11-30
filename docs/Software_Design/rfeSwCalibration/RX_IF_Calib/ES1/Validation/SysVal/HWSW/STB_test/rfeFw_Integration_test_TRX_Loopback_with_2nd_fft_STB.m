% All rights are reserved. Reproduction in whole or in part is prohibited
% without the prior written consent of the copy-right owner.
% This source code and any compilation or derivative thereof is the sole
% property of NXP B.V. and is provided pursuant to a Software License
% Agreement. This code is the proprietary information of NXP B.V. and
% is confidential in nature. Its use and dissemination by any party other
% than NXP B.V. is strictly limited by the confidential information
% provisions of the agreement referenced above
%
% NXP reserves the right to make changes without notice at any time.
% NXP makes no warranty, expressed, implied or statutory, including but
% not limited to any implied warranty of merchantability or fitness for any
% particular purpose, or that the use will not infringe any third party patent,
% copyright or trademark. NXP must not be liable for any loss or damage
% arising from its use.
%
% File Name		: rfeFw_Integration_test_TX_Loopback.m
% Author		: Mohammad Arif Saber
% Date Creation	: 1/April/2022
%
% Purpose: rfeFw_integration_test in loopback mode
% checks the relevant api and plots targets. if phase rotation is applied
% then checks for difference in set and get chirp to chirp phase rotation

function [samples, Tx_temp]= rfeFW_Integration_test_RX_attenuation_over_distance(SAMPLES,CHIRPS)

Proxy_loc='C:\STRX\RFEProxy\RFEProxy_V0_5_18\bin';
elfFileLoc='C:\STRX\RFEProxy\RFEProxy_V0_5_18\bin\rfem7_images\rfeFw\bin';
elfFileName='rfeFw_hw101_release_armclang';
% filenamefiller=strcat('rfeFW_0_8_8_rc1_',exp_peak);


%% config file path (if you do not explicitely need then do not change the values)
CONFIG_filename='C:\git\mrta-tests-strx-sysval\TestStand\ConfigFiles\rfeConfig.bin';
dynamic_table='';

%% are you using CODE and DATA files for fw Load
CODE_DATA_CHECK='yes';

% if yes then the path
CODE_DATA_FILE_Path='M:\15_STRX\8_Software\RFE_FW\SAF85xx_RFE_SW_CD_0_8_7_D220610\rfe\rfeFw\bin';


counter=0;
%% TX measurement only ?

%% for Proxy Dump
Proxy_Name='0_5_14';
FWName='0_8_6';
SpecialProxyName='IF_filter_check';
%%
addpath(genpath(Proxy_loc));
close all;
%% Parameters
RADAR_CYCLE_COUNT = 1;
MONITOR_SELECT = hex2dec('FF'); %% All monitors
DATA_ADDRESS = hex2dec('0x33C80000');
%% RFE constants
RFE_TIME_TICKS_PER_MS = 40000;
RFE_TEMPERATURE_1_DEG_CELSIUS = 64;
%% RFE state defines
rfe_state_busy_e = 0;
rfe_state_initialized_e = 1;
rfe_state_configured_e = 2;
rfe_state_radarCycleIdle_e = 3;
rfe_state_testContinuousWaveTransmission_e = 4;
rfe_state_fusaError_e = 5;
%% RFE error defines
rfe_error_api_unresponsive_e = 1;
rfe_error_fusaError_e = 4096;
%% RFE test param defines
rfe_testParam_outputDataTestPattern_e = 0;
rfe_testParam_keepTxTransmissionEnabled_e = 1;
rfe_testParam_chirpPllTestPinEnable_e = 2;
rfe_testParam_maskError_e = 3;
rfe_testParam_unmaskError_e = 4;
%% RFE test pattern defines
rfe_outputDataTestPattern_sineWave_e = 0;
rfe_outputDataTestPattern_incremental_e = 1;
rfe_outputDataTestPattern_prbs7_e = 2;
rfe_outputDataTestPattern_disabled_e = 3;
%% RFE mask error defines
rfe_maskError_all_error = 967;

%% Setup rfeProxy & rfeFw
Proxyfilename= strcat(Proxy_loc,'\StartProxy.bat &')
elfFileNamewithLoc=[elfFileLoc,'\',elfFileName,'.elf'];
% PowerSupplyReset;

if (~exist('initialized', 'var') || ~initialized)
    disp('Run RFE Proxy');
    system(Proxyfilename);
    disp('Loading ELF');
    
    ll.POR_set(0)
    pause(2)
    ll.POR_set(1)
    pause(2)
    ll.t32_startelf(elfFileNamewithLoc);
    pause(6)

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
        if error ~= rfe_error_api_unresponsive_e
            initialized = true;
        end
    end
    if (~error)
        fprintf('\nRFE Initialized!\n');
    else
        return
    end
end


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
[ error, time ] = rfeabstract.rfe_getTime();
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
%% rfe_configure
[ error ] = rfeabstract.rfe_configure(CONFIG_filename, dynamic_table);
if (~error)
    disp('RFE Configured');
else
    return
end


%% rfe_testSetParam: configure packet processor
rfeabstract.rfe_testSetParam( 100, DATA_ADDRESS );


% rfeabstract.rfe_testSetParam(1,1)

%% Radar Cycles
radarCycleCounter = 0;
state = 0;

t0 = clock;


[ error ] = rfeabstract.rfe_radarCycleStart( 1, 0, 0);

[ error, radarCycleCount, chirpSequenceCount, rxSaturationCount_stage1I1, rxSaturationCount_stage1I2, rxSaturationCount_stage1I3, rxSaturationCount_stage1I4, rxSaturationCount_stage1Q1, rxSaturationCount_stage1Q2, rxSaturationCount_stage1Q3, rxSaturationCount_stage1Q4, rxSaturationCount_stage2I1, rxSaturationCount_stage2I2, rxSaturationCount_stage2I3, rxSaturationCount_stage2I4, rxSaturationCount_stage2Q1, rxSaturationCount_stage2Q2, rxSaturationCount_stage2Q3, rxSaturationCount_stage2Q4, pdcClippingCount1, pdcClippingCount2, pdcClippingCount3, pdcClippingCount4, temperature_beforeChirpSequence1, temperature_beforeChirpSequence2, temperature_beforeChirpSequence3, temperature_beforeChirpSequence4, temperature_afterChirpSequence1, temperature_afterChirpSequence2, temperature_afterChirpSequence3, temperature_afterChirpSequence4, temperature_immediately1, temperature_immediately2, temperature_immediately3, temperature_immediately4 ] = rfeabstract.rfe_monitorRead( MONITOR_SELECT );
if (~error)
    fprintf( "Temperature: Tx12 %.1f C, Tx34 %.1f C, XO %.1f C, RX %.1f C\n", temperature_immediately1 / RFE_TEMPERATURE_1_DEG_CELSIUS, temperature_immediately2 / RFE_TEMPERATURE_1_DEG_CELSIUS, temperature_immediately3 / RFE_TEMPERATURE_1_DEG_CELSIUS, temperature_immediately4 / RFE_TEMPERATURE_1_DEG_CELSIUS );
else
    return
end


Tx_temp= temperature_immediately1 / RFE_TEMPERATURE_1_DEG_CELSIUS;

samples=readdata(DATA_ADDRESS, CHIRPS*SAMPLES,0);
samples = reshape(samples, SAMPLES*CHIRPS, 4);

% samples = readdata(DATA_ADDRESS, CHIRPS*SAMPLES,en_conversion );
