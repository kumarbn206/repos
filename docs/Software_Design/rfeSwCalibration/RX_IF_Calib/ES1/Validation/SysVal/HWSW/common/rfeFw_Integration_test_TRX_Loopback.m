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
% power_cycle_molex



%% config file path (if you do not explicitely need then do not change the values)
%CONFIG_filename='M:\15_STRX\8_Software\RFE_FW\SAF85xx_RFE_SW_EAR_0_8_8_D220624_RC2\SAF85xx_RFE_SW_EAR_0_8_8_D220624\rfe\tools\rfeConfigGenerator\release\rfeConfig.bin';
CONFIG_filename='C:\Users\nxf80974\Desktop\rfeConfig.bin';
Proxy_loc='C:\STRX\RFE_Proxy\RFEProxy_V0_5_18\bin';
elfFileLoc='C:\STRX\RFE_FW\SAF85xx_RFE_SW_EAR_0_8_8_D220624_RC2\rfe\rfeFw\bin';
elfFileName='rfeFw_hw101_release_armclang';
filenamefiller='celing_test_STB_fw_0_8_8';
%%
addpath(genpath(Proxy_loc));


% close all;
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

    %% rfe_configure
    [ error ] = rfeabstract.rfe_configure(CONFIG_filename, '');
    if (~error)
        disp('RFE Configured');
    else
        return
    end
    rfeabstract.rfe_testSetParam(1,1);

    error=rfeabstract.rfe_radarCycleStart(1,0,0);
 
    [ error, radarCycleCount, chirpSequenceCount, OutputStruct ] = rfe_monitorRead( monitorSelect );


    OutputStruct.rxSaturationCount_stage1I(1) = str2num(cell2mat(resp(4)));
    OutputStruct.rxSaturationCount_stage1I(2) = str2num(cell2mat(resp(5)));
    OutputStruct.rxSaturationCount_stage1I(3) = str2num(cell2mat(resp(6)));
    OutputStruct.rxSaturationCount_stage1I(4) = str2num(cell2mat(resp(7)));
    OutputStruct.rxSaturationCount_stage1Q(1) = str2num(cell2mat(resp(8)));
    OutputStruct.rxSaturationCount_stage1Q(2) = str2num(cell2mat(resp(9)));
    OutputStruct.rxSaturationCount_stage1Q(3) = str2num(cell2mat(resp(10)));
    OutputStruct.rxSaturationCount_stage1Q(4) = str2num(cell2mat(resp(11)));
    OutputStruct.rxSaturationCount_stage2I(1) = str2num(cell2mat(resp(12)));
    OutputStruct.rxSaturationCount_stage2I(2) = str2num(cell2mat(resp(13)));
    OutputStruct.rxSaturationCount_stage2I(3) = str2num(cell2mat(resp(14)));
    OutputStruct.rxSaturationCount_stage2I(4) = str2num(cell2mat(resp(15)));
    OutputStruct.rxSaturationCount_stage2Q(1) = str2num(cell2mat(resp(16)));
    OutputStruct.rxSaturationCount_stage2Q(2) = str2num(cell2mat(resp(17)));
    OutputStruct.rxSaturationCount_stage2Q(3) = str2num(cell2mat(resp(18)));
    OutputStruct.rxSaturationCount_stage2Q(4) = str2num(cell2mat(resp(19)));
    OutputStruct.pdcClippingCount(1) = str2num(cell2mat(resp(20)));
    OutputStruct.pdcClippingCount(2) = str2num(cell2mat(resp(21)));
    OutputStruct.pdcClippingCount(3) = str2num(cell2mat(resp(22)));
    OutputStruct.pdcClippingCount(4) = str2num(cell2mat(resp(23)));
    OutputStruct.temperature_beforeChirpSequence(1) = str2num(cell2mat(resp(24)));
    OutputStruct.temperature_beforeChirpSequence(2) = str2num(cell2mat(resp(25)));
    OutputStruct.temperature_beforeChirpSequence(3) = str2num(cell2mat(resp(26)));
    OutputStruct.temperature_beforeChirpSequence(4) = str2num(cell2mat(resp(27)));
    OutputStruct.temperature_afterChirpSequence(1) = str2num(cell2mat(resp(28)));
    OutputStruct.temperature_afterChirpSequence(2) = str2num(cell2mat(resp(29)));
    OutputStruct.temperature_afterChirpSequence(3) = str2num(cell2mat(resp(30)));
    OutputStruct.temperature_afterChirpSequence(4) = str2num(cell2mat(resp(31)));
    OutputStruct.temperature_immediately(1) = str2num(cell2mat(resp(32)));
    OutputStruct.temperature_immediately(2) = str2num(cell2mat(resp(33)));
    OutputStruct.temperature_immediately(3) = str2num(cell2mat(resp(34)));
    OutputStruct.temperature_immediately(4) = str2num(cell2mat(resp(35)));
    OutputStruct.txPower(1,1) = str2num(cell2mat(resp(36)));
    OutputStruct.txPower(1,2) = str2num(cell2mat(resp(37)));
    OutputStruct.txPower(1,3) = str2num(cell2mat(resp(38)));
    OutputStruct.txPower(1,4) = str2num(cell2mat(resp(39)));
    OutputStruct.txPower(2,1) = str2num(cell2mat(resp(40)));
    OutputStruct.txPower(2,2) = str2num(cell2mat(resp(41)));
    OutputStruct.txPower(2,3) = str2num(cell2mat(resp(42)));
    OutputStruct.txPower(2,4) = str2num(cell2mat(resp(43)));
    OutputStruct.txPower(3,1) = str2num(cell2mat(resp(44)));
    OutputStruct.txPower(3,2) = str2num(cell2mat(resp(45)));
    OutputStruct.txPower(3,3) = str2num(cell2mat(resp(46)));
    OutputStruct.txPower(3,4) = str2num(cell2mat(resp(47)));
    OutputStruct.txPower(4,1) = str2num(cell2mat(resp(48)));
    OutputStruct.txPower(4,2) = str2num(cell2mat(resp(49)));
    OutputStruct.txPower(4,3) = str2num(cell2mat(resp(50)));
    OutputStruct.txPower(4,4) = str2num(cell2mat(resp(51)));
    OutputStruct.txPower(5,1) = str2num(cell2mat(resp(52)));
    OutputStruct.txPower(5,2) = str2num(cell2mat(resp(53)));
    OutputStruct.txPower(5,3) = str2num(cell2mat(resp(54)));
    OutputStruct.txPower(5,4) = str2num(cell2mat(resp(55)));
    OutputStruct.txPower(6,1) = str2num(cell2mat(resp(56)));
    OutputStruct.txPower(6,2) = str2num(cell2mat(resp(57)));
    OutputStruct.txPower(6,3) = str2num(cell2mat(resp(58)));
    OutputStruct.txPower(6,4) = str2num(cell2mat(resp(59)));
    OutputStruct.txPower(7,1) = str2num(cell2mat(resp(60)));
    OutputStruct.txPower(7,2) = str2num(cell2mat(resp(61)));
    OutputStruct.txPower(7,3) = str2num(cell2mat(resp(62)));
    OutputStruct.txPower(7,4) = str2num(cell2mat(resp(63)));
    OutputStruct.txPower(8,1) = str2num(cell2mat(resp(60)));
    OutputStruct.txPower(8,2) = str2num(cell2mat(resp(61)));
    OutputStruct.txPower(8,3) = str2num(cell2mat(resp(62)));
    OutputStruct.txPower(8,4) = str2num(cell2mat(resp(63)));
    
    currentSystemSetting.Temperature=OutputStruct.temperature_immediately(1)/64;
    
    
%     [ error, radarCycleCount, chirpSequenceCount, rxSaturationCount_stage1I1, rxSaturationCount_stage1I2, rxSaturationCount_stage1I3, rxSaturationCount_stage1I4, rxSaturationCount_stage1Q1, rxSaturationCount_stage1Q2, rxSaturationCount_stage1Q3, rxSaturationCount_stage1Q4, rxSaturationCount_stage2I1, rxSaturationCount_stage2I2, rxSaturationCount_stage2I3, rxSaturationCount_stage2I4, rxSaturationCount_stage2Q1, rxSaturationCount_stage2Q2, rxSaturationCount_stage2Q3, rxSaturationCount_stage2Q4, pdcClippingCount1, pdcClippingCount2, pdcClippingCount3, pdcClippingCount4, temperature_beforeChirpSequence1, temperature_beforeChirpSequence2, temperature_beforeChirpSequence3, temperature_beforeChirpSequence4, temperature_afterChirpSequence1, temperature_afterChirpSequence2, temperature_afterChirpSequence3, temperature_afterChirpSequence4, temperature_immediately1, temperature_immediately2, temperature_immediately3, temperature_immediately4 ] = rfeabstract.rfe_monitorRead( MONITOR_SELECT );
%     if (~error)
%         fprintf( "Temperature: Tx12 %.1f C, Tx34 %.1f C, XO %.1f C, RX %.1f C\n", temperature_immediately1 / RFE_TEMPERATURE_1_DEG_CELSIUS, temperature_immediately2 / RFE_TEMPERATURE_1_DEG_CELSIUS, temperature_immediately3 / RFE_TEMPERATURE_1_DEG_CELSIUS, temperature_immediately4 / RFE_TEMPERATURE_1_DEG_CELSIUS );
%     else
%         return
%     end

    


