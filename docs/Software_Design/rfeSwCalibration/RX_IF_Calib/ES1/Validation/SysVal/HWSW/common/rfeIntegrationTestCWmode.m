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
% File Name		: rfeFw_Integration_test_TRX_Loopback.m
% Author		: Mohammad Arif Saber
% Date Creation	: 1/April/2022
%
% Purpose: rfeFw_integration_test in loopback mode
% checks the relevant api and plots targets. if phase rotation is applied
% then checks for difference in set and get chirp to chirp phase rotation
<<<<<<< Updated upstream:Matlab/HWSW/common/rfeIntegrationTestCWmode.m
% power_cycle_molex

Proxy_loc='C:\STRX\RFEProxy\RFEProxy_V0_5_18\bin';
elfFileLoc='M:\15_STRX\8_Software\RFE_FW\SAF85xx_RFE_SW_EAR_0_8_8_D220624_RC2\SAF85xx_RFE_SW_EAR_0_8_8_D220624\rfe\rfeFw\bin';
elfFileName='rfeFw_hw101_release_armclang';
=======
function [output_struct] = rfeFw_Integration_test_TRX_Loopback(input_struct)

% power_cycle_molex

Proxy_loc='C:\STRX\RFEProxy\RFEProxy_V0_5_18\bin';
elfFileLoc='C:\STRX\RFEProxy\RFEProxy_V0_5_18\bin\rfem7_images\rfeFw\bin\NEW';
% elfFileName='rfeFw_hw101_release_armclang_rfeFw_reliability_V1_220622';
elfFileName = input_struct.elf_filename;
Config_loc = input_struct.config_loc;

% Config_loc='C:\SAF85xx_RFE_SW_EAR_0_8_8_D220624\rfe\tools\rfeConfigGenerator\release\P5';   
% P1= 15, 15, 3, 3 ; P2= 15, 15, -3, -3 ; P3= 15, 15, 15, 15 ; P4= 3, 3, 15, 15 ; P5= -3, -3, 15, 15 

% elfFileName='rfeFw_hw101_release_armclang_while1_atEndOfConfigCali';
>>>>>>> Stashed changes:Matlab/TestProcedures/di-dt_test/rfeFw_Integration_test_TRX_Loopback.m

%% is CODE and DATA files used ?

CODE_DATA_CHECK='yes';

% if yes then the path
% CODE_DATA_FILE_Path='C:\STRX\RFEProxy\RFEProxy_V0_5_18\bin\rfem7_images\rfeFw\bin';
CODE_DATA_FILE_Path='M:\15_STRX\8_Software\RFE_FW\SAF85xx_RFE_SW_CD_0_8_7_D220610\rfe\rfeFw\bin';
% CODE_DATA_FILE_Path='C:\SAF85xx_RFE_SW_EAR_0_8_8_D220624\rfe\rfeFw\bin';

%% config file path (if you do not explicitely need then do not change the values)
CONFIG_filename='C:\\git\\mrta-tests-strx-sysval\\TestStand\\ConfigFiles\\rfeConfig.bin';
% dynamic_filename= 'D:\SAF85xx_RFE_SW_BN_030622_071251_1292\SAF85xx_RFE_SW\rfe\tools\rfeConfigGenerator\release\rfeDynamicTables.bin';
%% for prost processing plots
% CHIRPS = 64;
% SAMPLES = 1024;

peak_bin=7;
% rotation_applied=[0,45,90,135];
%% TX measurement only ?

%% for Proxy Dump
Proxy_Name='0_5_18';
FWName='_0_8_7';
SpecialProxyName='_CW_Mode_check';

%%
addpath(genpath(Proxy_loc));

close all;
%% Parameters
RADAR_CYCLE_COUNT = 1;
MONITOR_SELECT = hex2dec('FF'); %% All monitors
DATA_ADDRESS = hex2dec('33e00000');
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
% measured_power=[];
% for ii= -5:1:15

    pause(1)
%     power_cycle;

%        dynamic_filename='';
%     if contains(CONFIG_filename,'-')
%         CONFIG_filename= replace(CONFIG_filename,'-','m');
%     end


    %% Setup rfeProxy & rfeFw
    Proxyfilename= strcat(Proxy_loc,'\StartProxy.bat &')
    elfFileNamewithLoc=[elfFileLoc,'\',elfFileName,'.elf'];
    power_value=[];

    disp('Run RFE Proxy');
    system(Proxyfilename);
    ll.POR_set(0);
    pause(2)
    ll.POR_set(1);
    pause(2)

    disp('Loading ELF');
    pause(1)
    %     ProxyDumpFileName=[pwd,'\',Proxy_Name,'_',FWName,'_',SpecialProxyName,'.txt'];
    %     ll.record_start(ProxyDumpFileName,1,1);

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
        if error ~= rfe_error_api_unresponsive_e
            initialized = true;
        end
    end
    if (~error)
        fprintf('\nRFE Initialized!\n');
    else
        return
    end

    %
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
%     %% rfe_getTime
%     [ error, time ] = rfeabstract.rfe_getTime()
%     if (~error)
%         fprintf("RFE Time: %.3f ms\n", time / RFE_TIME_TICKS_PER_MS );
%     else
%         return
%     end
%     %% rfe_monitorRead
%     [ error, radarCycleCount, chirpSequenceCount, rxSaturationCount_stage1I1, rxSaturationCount_stage1I2, rxSaturationCount_stage1I3, rxSaturationCount_stage1I4, rxSaturationCount_stage1Q1, rxSaturationCount_stage1Q2, rxSaturationCount_stage1Q3, rxSaturationCount_stage1Q4, rxSaturationCount_stage2I1, rxSaturationCount_stage2I2, rxSaturationCount_stage2I3, rxSaturationCount_stage2I4, rxSaturationCount_stage2Q1, rxSaturationCount_stage2Q2, rxSaturationCount_stage2Q3, rxSaturationCount_stage2Q4, pdcClippingCount1, pdcClippingCount2, pdcClippingCount3, pdcClippingCount4, temperature_beforeChirpSequence1, temperature_beforeChirpSequence2, temperature_beforeChirpSequence3, temperature_beforeChirpSequence4, temperature_afterChirpSequence1, temperature_afterChirpSequence2, temperature_afterChirpSequence3, temperature_afterChirpSequence4, temperature_immediately1, temperature_immediately2, temperature_immediately3, temperature_immediately4 ] = rfeabstract.rfe_monitorRead( MONITOR_SELECT );
%     if (~error)
%         fprintf( "Temperature: Tx12 %.1f C, Tx34 %.1f C, XO %.1f C, RX %.1f C\n", temperature_immediately1 / RFE_TEMPERATURE_1_DEG_CELSIUS, temperature_immediately2 / RFE_TEMPERATURE_1_DEG_CELSIUS, temperature_immediately3 / RFE_TEMPERATURE_1_DEG_CELSIUS, temperature_immediately4 / RFE_TEMPERATURE_1_DEG_CELSIUS );
%     else
%         return
%     end

    %% rfe_configure
    [ error ] = rfeabstract.rfe_configure(CONFIG_filename, '');
    if (~error)
        disp('RFE Configured');
    else
        return
    end

    %     ll.t32_cmd('break')
    %     ll.dump('TX1')
    %     ll.t32_cmd('go')
    % rfe_test
    % rfeabstract.rfe_testContinuousWaveTransmissionStop;
    % rfeabstract.rfe_testSetParam(1,1);
    %% rfe_testSetParam: configure packet processor
    % rfeabstract.rfe_testSetParam( 100, DATA_ADDRESS );
    %  enable CLKOUT0 signal
    %     ll.t32_cmd('PER.Set.simple ASD:0x40100254 %Long 0x00200004')
    %     ll.t32_cmd('PER.Set.simple ASD:0x400C8348 %Long 0x80000000')
    %     ll.t32_cmd('PER.Set.simple ASD:0x400C8340 %Long 0x09000000')
    %     ll.t32_cmd('PER.Set.simple ASD:0x440C0020 %Long 0x00000002')
    %     ll.t32_cmd('PER.Set.simple ASD:0x440C0000 %Long 0x80000000')
    %     ll.t32_cmd('PER.Set.simple ASD:0x440C0000 %Long 0x00000000')
    %     ll.t32_cmd('PER.Set.simple ASD:0x440C0094 %Long 0x800F0000')
    %
    %     % Switch from RFE M7 to APP M7 JTag access
    %     ll.t32_cmd('PER.Set.simple ASD:0x400CC040 %Long 0xfffffffc');
    %     ll.t32_cmd('SYStem.Down');
    %     ll.t32_cmd('SYStem.CPU SAF8544-M7-0');
    %     ll.t32_cmd('SYStem.Option DUALPORT ON');
    %     ll.t32_cmd('SYStem.memaccess DAP');
    %     ll.t32_cmd('SYStem.Option EnReset ON');
    %     ll.t32_cmd('SYStem.Option TRST OFF');
    %     ll.t32_cmd('SYStem.Option ResBreak off');
    %     ll.t32_cmd('ITM.off');
    %     ll.t32_cmd('SYStem.Attach');
    %
    %     % Apply new AuroraPLL settings (this is the actual AuroraPll Workarround)
    %     ll.t32_cmd('PER.Set.simple ASD:0x51033050 %Long 0x00000C70');
    %     ll.t32_cmd('PER.Set.simple ASD:0x51033058 %Long 0x0010FCF1');
    %     ll.t32_cmd('PER.Set.simple ASD:0x51033074 %Long 0x00077888');
    %     ll.t32_cmd('PER.Set.simple ASD:0x5103307C %Long 0x00000000');
    %     ll.t32_cmd('PER.Set.simple ASD:0x51033080 %Long 0x00000040');
    %     ll.t32_cmd('PER.Set.simple ASD:0x51033060 %Long 0x00a91a00');
    %     ll.t32_cmd('PER.Set.simple ASD:0x51033070 %Long 0x00000029');21`
    %     ll.t32_cmd('PER.Set.simple ASD:0x51033088 %Long 0x00000001');
    %
    %     % Switch from APP M7 jTag access back to RFE M7 jTag access
    %     ll.t32_cmd('SYStem.Down');
    %     ll.t32_cmd('SYStem.CPU SAF8544-M7-RFE');
    %     ll.t32_cmd('SYStem.Option DUALPORT ON');
    %     ll.t32_cmd('SYStem.memaccess DAP');
    %     ll.t32_cmd('SYStem.Option EnReset ON');
    %     ll.t32_cmd('SYStem.Option TRST OFF');
    %     ll.t32_cmd('SYStem.Option ResBreak off');
    %     ll.t32_cmd('ITM.off');
    %     ll.t32_cmd('SYStem.Attach');
    %% Radar Cycles
%     radarCycleCounter = 0;
%     state = 0;
    % while (1)
%  rfeabstract.rfe_radarCycleStart(1,0,0)
    error=rfeabstract.rfe_testContinuousWaveTransmissionStart(0);
%     venu= power_meter_value(76500000);
%     measured_power=[measured_power;venu];
%     pause(2)
%     error=rfeabstract.rfe_testContinuousWaveTransmissionStop;


% end



% pause(1)
% center_freq=76500000;
%
% venu= power_meter_value(center_freq);
% power_value= [power_value;venu];
