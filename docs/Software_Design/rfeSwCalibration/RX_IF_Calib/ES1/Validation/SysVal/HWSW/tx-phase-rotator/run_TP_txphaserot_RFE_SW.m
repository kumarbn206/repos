% All rights are reserved. Reproduction in whole or in part is prohibited8
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
% File Name		: run_TP_6_6_RFE_SW.m
% Author		: Dominik Huber, based on a script from Kai / Arif
% Date Creation	: 21/July/2022

% originating from:
% M:\15_STRX\8_Software\RFE_Integration_Test\rfeFW_Integration_test_RX_att 
% enuation_over_distance_editDominik.m
%
% Purpose: MIMO modulation test in loopback mode
% checks the relevant api and plots targets. if phase rotation is applied
% then checks for difference in set and get chirp to chirp phase rotation

function [output_struct] = run_TP_6_6_RFE_SW(input_struct)

currentSystemSetting.samples = str2num(input_struct.samples);
currentSystemSetting.CHIRPS = str2num(input_struct.chirps);
currentSystemSetting.Freq_BW = str2num(input_struct.Freq_BW); 
currentSystemSetting.ChirpCF = str2num(input_struct.ChirpCF); 
currentSystemSetting.Tchirp = str2num(input_struct.Tchirp); 
currentSystemSetting.chirpdirection = str2num(input_struct.chirpdirection); %chirpdirection = -1;
currentSystemSetting.Data_bit_length = str2num(input_struct.Data_bit_length); % pdc bit width
currentSystemSetting.sampleFreq = str2num(input_struct.sampleFreq);
currentSystemSetting.numRX = str2num(input_struct.numRX);
currentSystemSetting.Sequences = str2num(input_struct.Sequences);


addpath(genpath(pwd));
addpath(genpath('C:\git\mrta-tests-strx-sysval\Matlab\HWSW\common'));
addpath(genpath('C:\git\mrta-tests-strx-sysval\Matlab\Common\Analysis\ADC_FFT_Processing'));



%% is CODE and DATA files used ?
CODE_DATA_CHECK='yes';


% Use flattop windowing function
idx_win = 8;
% Use dBm as output
unit_output =1 ;

%% for peak serach
start_bin_frequency = 0.8e6;
end_bin_frequency =15e6;





%% TX measurement only ?

%% for Proxy Dump
filenamefiller='recal_2nd_seq_RCS_28_Target_distance_10m_64_chirp_fw_0_8_8';
Proxy_Name=strcat('0_5_17_',filenamefiller);
FWName='0_8_6';
SpecialProxyName='fw_check';
%%
addpath(genpath(input_struct.Proxy_loc));


%% Parameters
RADAR_CYCLE_COUNT = 1;
MONITOR_SELECT = hex2dec('1FF'); %% All monitors
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

%% Setup rfeProxy & rfeFw
Proxyfilename= strcat(input_struct.Proxy_loc,'\StartProxy.bat &')
elfFileNamewithLoc=[input_struct.elfFileLoc,'\',input_struct.elfFileName,'.elf'];
% PowerSupplyReset;

if (~exist('initialized', 'var') || ~initialized)
    disp('Run RFE Proxy');
    system(Proxyfilename);
    disp('Loading ELF');
    pause(1)
    ProxyDumpFileName=[input_struct.proxy_dump_path,Proxy_Name,'_',FWName,'_',SpecialProxyName,'.txt'];
%     ll.record_start(ProxyDumpFileName,1,1);
%     ll.record_start(ProxyDumpFileName,0,1);
    ll.t32_startelf(elfFileNamewithLoc);
    pause(10)

    disp('Selecting Lauterbach');
    ll.select(1)
if(0)
    input_struct.CODE_DATA_FILE_Path =  'C:\STRX\RFE_FW\SAF85xx_RFE_SW_CD_0_8_9_D220715\SAF85xx_RFE_SW_CD_0_8_9_D220715\rfe\rfeFw\bin'; %M:\15_STRX\8_Software\RFE_FW\SAF85xx_RFE_SW_EAR_0_8_8_D220624_RC3\rfe\rfeFw\bin';
end
    if strcmp(lower(CODE_DATA_CHECK),'yes')
        ll.t32_cmd(['Data.Load.binary ' input_struct.CODE_DATA_FILE_Path '\CODE 0x0'])
        ll.t32_cmd(['Data.Load.binary ' input_struct.CODE_DATA_FILE_Path '\DATA 0x20000000'])
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

%% PDC coefficient 

% ll.t32_cmd('break.set rfeSwMainFsm_handleCmds')

pause(1)


% % AuroraPll Workarround
% % Switch from RFE M7 to APP M7 JTag access
% ll.t32_cmd('PER.Set.simple ASD:0x400CC040 %Long 0xfffffffc');
% ll.t32_cmd('SYStem.Down');
% ll.t32_cmd('SYStem.CPU SAF8544-M7-0');
% ll.t32_cmd('SYStem.Option DUALPORT ON');
% ll.t32_cmd('SYStem.memaccess DAP');
% ll.t32_cmd('SYStem.Option EnReset ON');
% ll.t32_cmd('SYStem.Option TRST OFF');
% ll.t32_cmd('SYStem.Option ResBreak off');
% ll.t32_cmd('ITM.off');
% ll.t32_cmd('SYStem.Attach');
% 
% 
% 
% % Apply new AuroraPLL settings (this is the actual AuroraPll Workarround)
% ll.t32_cmd('PER.Set.simple ASD:0x51033050 %Long 0x00000C70');
% ll.t32_cmd('PER.Set.simple ASD:0x51033058 %Long 0x0010FCF1');
% ll.t32_cmd('PER.Set.simple ASD:0x51033074 %Long 0x00077888');
% ll.t32_cmd('PER.Set.simple ASD:0x5103307C %Long 0x00000000');
% ll.t32_cmd('PER.Set.simple ASD:0x51033080 %Long 0x00000040');
% ll.t32_cmd('PER.Set.simple ASD:0x51033060 %Long 0x00a91a00');
% ll.t32_cmd('PER.Set.simple ASD:0x51033070 %Long 0x00000029');
% ll.t32_cmd('PER.Set.simple ASD:0x51033088 %Long 0x00000001');


% ll.writeSpi('SPIM.ADPLL_LOSS_OF_LOCK_MASK_REG',1);
% ll.writeSpi('ADPLL.DCO_GAIN_CONTROL_TR.FREF_DIV_KDCO_TR',0x);
% ll.writeSpi('ADPLL.DATA_STROBE');

% ll.readSpi('RX1.P0_IBIAS.AMP80_IREF');
% ll.writeSpi('PDC1.P0_PDC_EQ1.EQ_COEFF1', 0x2c47);
% ll.writeSpi('PDC1.P0_PDC_EQ1.EQ_COEFF2', 0xEC22);
% ll.writeSpi('PDC1.P0_PDC_CTL0.EQ_COEFF3', 0xF191);
% ll.readSpi('PDC1.P0_PDC_EQ1.EQ_COEFF1');
% ll.readSpi('PDC1.P0_PDC_EQ1.EQ_COEFF2');
% ll.readSpi('PDC1.P0_PDC_CTL0.EQ_COEFF3');

% ll.t32_cmd('go')

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
[ error, time ] = rfeabstract.rfe_getTime();
if (~error)
    fprintf("RFE Time: %.3f ms\n", time / RFE_TIME_TICKS_PER_MS );
else
    return
end

%% rfe_monitorRead
% [ error, radarCycleCount, chirpSequenceCount, rxSaturationCount_stage1I1, rxSaturationCount_stage1I2, rxSaturationCount_stage1I3, rxSaturationCount_stage1I4, rxSaturationCount_stage1Q1, rxSaturationCount_stage1Q2, rxSaturationCount_stage1Q3, rxSaturationCount_stage1Q4, rxSaturationCount_stage2I1, rxSaturationCount_stage2I2, rxSaturationCount_stage2I3, rxSaturationCount_stage2I4, rxSaturationCount_stage2Q1, rxSaturationCount_stage2Q2, rxSaturationCount_stage2Q3, rxSaturationCount_stage2Q4, pdcClippingCount1, pdcClippingCount2, pdcClippingCount3, pdcClippingCount4, temperature_beforeChirpSequence1, temperature_beforeChirpSequence2, temperature_beforeChirpSequence3, temperature_beforeChirpSequence4, temperature_afterChirpSequence1, temperature_afterChirpSequence2, temperature_afterChirpSequence3, temperature_afterChirpSequence4, temperature_immediately1, temperature_immediately2, temperature_immediately3, temperature_immediately4 ] = rfeabstract.rfe_monitorRead( MONITOR_SELECT );

% [output] = rfeabstract.rfe_monitorRead( MONITOR_SELECT );
% if (~error)
%     fprintf( "Temperature: Tx12 %.1f C, Tx34 %.1f C, XO %.1f C, RX %.1f C\n", temperature_immediately1 / RFE_TEMPERATURE_1_DEG_CELSIUS, temperature_immediately2 / RFE_TEMPERATURE_1_DEG_CELSIUS, temperature_immediately3 / RFE_TEMPERATURE_1_DEG_CELSIUS, temperature_immediately4 / RFE_TEMPERATURE_1_DEG_CELSIUS );
% else
%     return
% end


    %% rfe_configure
    [ error ] = rfeabstract.rfe_configure(input_struct.CONFIG_filename,input_struct.dynamic_table );
    if (~error)
        disp('RFE Configured');
    else
        disp('RFE not configured - return');
        return
    end
    
    
    
    
    
    % rfeabstract.rfe_testContinuousWaveTransmissionStart(0)
    % rfeabstract.rfe_radarCycleStart(1,0,0)
    
    %% rfe_testSetParam: configure packet processor
    rfeabstract.rfe_testSetParam( 100, DATA_ADDRESS );
    
    % rfeabstract.rfe_testSetParam(1,1)
    % rfeabstract.rfe_testContinuousWaveTransmissionStart(1)
    
    %% Radar Cycles
    radarCycleCounter = 0;
    state = 0;
    
    
    t0 = clock;
    
    
    
    
    [ error ] = rfeabstract.rfe_radarCycleStart( 1, 0, 0);
    
    %% read ADC data
    
    
    %samples = readdata(DATA_ADDRESS, CHIRPS*SAMPLES,en_conversion );
    adc_data = readdata_HWSW(DATA_ADDRESS,currentSystemSetting);
    %samples1 = reshape(samples, SAMPLES*CHIRPS, 4);
    [ error, radarCycleCount, chirpSequenceCount, monitorValues ] = rfeabstract.rfe_monitorRead( MONITOR_SELECT );
     
    
    samples=(reshape(adc_data, currentSystemSetting.samples, currentSystemSetting.CHIRPS, 4))/2^15;
    
    peak_powers=helper_plot_all4Rx_1stFFTavg(samples, currentSystemSetting);
    plottitle = input_struct.CONFIG_filename;
    helper_plot_all4Rx_2ndFFT(samples,currentSystemSetting, plottitle);

    samples_collect{str2num(input_struct.running_index)} = samples;

    output_struct.save_filepath = input_struct.save_filepath;
    
    save(input_struct.save_filepath, 'samples', 'input_struct', 'currentSystemSetting');



% pause(2)
% en_conversion=0;
% samples_without_conversion = readdata(DATA_ADDRESS, CHIRPS*SAMPLES,en_conversion );

date_now = datetime(now, 'ConvertFrom', 'datenum');
date_now = string(datestr(date_now));
date_now = replace(date_now,{'-',' ',':'},'_' );



%     %% rfe_getTime
%     [ error, time ] = rfeabstract.rfe_getTime();
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

% ll.record_stop;
% ll.t32_cmd('break')
% ll.dump('TX1')
% ll.dump('TX2')
% ll.dump('TX3')
% ll.dump('TX4')
% ll.dump('RX1')
% ll.dump('RX2')
% ll.dump('RX3')
% ll.dump('RX4')
% ll.dump('GLDO')
% ll.dump('ADC1')
% ll.dump('ADC2')
% ll.dump('ADC3')
% ll.dump('ADC4')
% ll.dump('PDC1')
% ll.dump('PDC2')
% ll.dump('PDC3')
% ll.dump('PDC4')
% ll.dump('LLDOPDC')
% 
% ll.t32_cmd('go')


%% reset the device after the test
pause(0.5)
ll.POR_set(0)
pause(2)
ll.POR_set(1)
pause(2)

end


