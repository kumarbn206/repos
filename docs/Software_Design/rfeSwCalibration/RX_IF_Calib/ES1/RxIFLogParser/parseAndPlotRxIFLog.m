%% House keeping

close all;
clear all;
% get path to function to import rfeConfig
addpath('../Validation/SysVal/HWSW/rx_filter_shaping/')

%% Variables
dataPath = 'C:\Users\nxf59937\Desktop\STRX-7831\';
dataFileExtension = '.txt';

% Variable used to step over the measurement looking for the averaged
% results of all channels on Rx IF calibration
indxInitFirsAvg = 14;
indxInitFirsAvg = 13;

% Variable used to define the relative error tolerance to ignore the
% measurement
gainErrOutlierTol = 1e2;

% Variable specifying the Rx Total Gain tolerance as estaed in the spec
% (+/- 2dB)
rxIfTotalGainSpec_dB = 2;

% Variable specifyig the HPF tolerance as stated in the spec +/-10%
HpfSpecTolerancePercent = 10;

% Variable indicating what RX IF dataset to use unitTest or
% mainFsmIntegrated
dataToUse = 'rfe_sw_calibration_tc_073';
% dataToUse = 'rfe_sw_main_fsm_tc_007_integrated';
% dataToUse = 'rxIfCalibApp'

% Variable to indicate whether we use legacy logs or not
legacyLog = ~true;

% Variable to indicate whether use RC 0.8.12 or Develop
useRC0_8_12 = ~true

% Variable to use data from restoring VCs or not
dataWithRestoredVCs = ~true

% Show selected averaged values to be used as RX IF gain once the algorithm
% converged
showSelectedAvg = true;

% Paths to rfeConfig.xml
rfeConfigFileName = 'rfe_sw_calibration_tc_073_rfeConfig.xml';
pathTorfeConfig = '../../../../../../rfem7/code/tests/testSwCalibration/unitTestsRfeConfigs/';
pathToConfigGenerator = '../../../../../../tools/rfeConfigGenerator/release/';

%% Import Config
rfeConfigStruct = readAnGenerateRfeConfigBin(pathTorfeConfig,rfeConfigFileName,pathToConfigGenerator);

%% Select data

dataPath = [dataPath dataToUse '\']

switch dataToUse
    case 'rfe_sw_calibration_tc_073'
        if legacyLog
            targetFileName    = 'rfe_sw_calibration_tc_073_Develop_SHA_b593d09_tempMonitor_legacyLog';
            candidateFileName = 'rfe_sw_calibration_tc_073_Develop_SHA_b593d09_repFixed_tempMonitor_legacyLog';  
        else
            targetFileName    = 'rfe_sw_calibration_tc_073_SHA_cd35d39_noTemp';
            candidateFileName = 'rfe_sw_calibration_tc_073_SHA_066f21c_noTemp';        

            targetFileName    = 'rfe_sw_calibration_tc_073_SHA_bd4ddac_NoGainFixedNoHPF';
            targetFileName = 'rfe_sw_calibration_tc_073_SHA_bd4ddac_GainFixed_run1';
            candidateFileName = 'rfe_sw_calibration_tc_073_SHA_bd4ddac_GainFixed_HPF_corrected_run1';

            targetFileName = 'rfe_sw_calibration_tc_073_SHA_bd7ef2a_NoGainFixedNoHPF_multicastMapper_run3';
            candidateFileName = 'rfe_sw_calibration_tc_073_SHA_bd7ef2a_GainFixed_mutlicastMapper_run2';
        end
    case 'rfe_sw_calibration_tc_063'
        if legacyLog
            if dataWithRestoredVCs
                targetFileName    = 'rfe_sw_calibration_tc_063CleanupRestoresVCs_DISABLED_VCS';
                
                candidateFileName = 'rfe_sw_calibration_tc_063CleanupRestoresVCs_NO_DISABLED_VCS';
            else
                if useRC0_8_12
                    targetFileName    = 'rfe_sw_calibration_tc_063_rxIfCalibrateConfigProfile_RC0p8p12';
                    candidateFileName = 'rfe_sw_calibration_tc_063_rxIfCalibrateConfigProfile_RC0p8p12_RfeChainCalibrated#1';
                    %                 candidateFileName = 'rfe_sw_calibration_tc_063_rxIfCalibrateConfigProfile_RC0p8p12_RfeChainCalibrated#2';
                else%Devlop SHA 6b992f8
                    targetFileName    = 'rfe_sw_calibration_tc_063_rxIfCalibrateConfigProfile_DISABLED_VCS';
                    candidateFileName = 'rfe_sw_calibration_tc_063_rxIfCalibrateConfigProfile_NO_DISABLED_VCS';
                end
            end
        else
            targetFileName    = '';
            candidateFileName = '';
        end
    case 'rfe_sw_main_fsm_tc_007_integrated'

        if legacyLog
            if dataWithRestoredVCs
                targetFileName    = 'rfe_sw_main_fsm_tc_007_integrated_CleanupRestoresVCs_DISABLED_VCS';
                candidateFileName = 'rfe_sw_main_fsm_tc_007_integrated_CleanupRestoresVCs_NO_DISABLED_VCS';
            else
                if useRC0_8_12
                    targetFileName    = 'rfe_sw_main_fsm_tc_007_integrated_singleModeChirpSequence_RC0p8p12';
                    candidateFileName = 'rfe_sw_main_fsm_tc_007_integrated_RC0.8.12_PowerMangrOffRXADC#1';
                    candidateFileName = 'rfe_sw_main_fsm_tc_007_integrated_RC0.8.12_PowerMangrOffRXADC#2';
                    candidateFileName = 'rfe_sw_main_fsm_tc_007_integrated_RC0.8.12_PowerMangrOffRXADC#3';
                    candidateFileName = 'rfe_sw_main_fsm_tc_007_integrated_RC0.8.12_12BitsPDC';
                    candidateFileName = 'rfe_sw_main_fsm_tc_007_integrated_RC0.8.12_NoNotch';
                else%Devlop SHA 6b992f8
                    targetFileName    = 'rfe_sw_main_fsm_tc_007_integrated_singleModeChirpSequence_DISABLED_VCS';
                    candidateFileName = 'rfe_sw_main_fsm_tc_007_integrated_singleModeChirpSequence_NO_DISABLED_VCS';
                    candidateFileName = 'rfe_sw_main_fsm_tc_007_integrated_Develop_866101a_PowerManangerOffRXADC_1';
                    candidateFileName = 'rfe_sw_main_fsm_tc_007_integrated_Develop_866101a_PowerManangerOffRXADC_2';
                    candidateFileName = 'rfe_sw_main_fsm_tc_007_integrated_Develop_866101a_PowerManangerOffRXADC_3';
                end
            end
        else
            targetFileName    = 'rfe_sw_main_fsm_tc_007_integrated_073_SHA_cd35d39';
            candidateFileName = 'rfe_sw_main_fsm_tc_007_integrated_073_SHA_cd35d39_GainFixed';    
        end
    case'rxIfCalibApp'
        if legacyLog
            if useRC0_8_12
                targetFileName    = 'rxIfCalibApp_RC0p8p12';
                candidateFileName = 'rfeSwRxIFCalibrationAppIFGainLog_RC0.8.12_NoDoubleRxADCCal#1';
                %             candidateFileName = 'rfeSwRxIFCalibrationAppIFGainLog_RC0.8.12_NoDoubleRxADCCal#2';
            else%Devlop SHA 6b992f8
                targetFileName = 'rfeSwRxIFCalibrationAppIFGainLog_Devlop_SHA_6b992f8';
                candidateFileName = 'rfeSwRxIFCalibrationAppIFGainLog_Devlop_SHA_c341a33_NoDoubleRxADCCal#1';
                candidateFileName = 'rfeSwRxIFCalibrationAppIFGainLog_Devlop_SHA_c341a33_NoDoubleRxADCCal#2';
                candidateFileName = 'rfeSwRxIFCalibrationAppIFGainLog_Devlop_SHA_c341a33_NoDoubleRxADCCal#3';
            end
        else
        end
    otherwise
        error(['Unknonw input dataToUse :' dataToUse]);
end

nameLengend{1} = split(extractAfter(targetFileName,[dataToUse '_']),'_');
nameLengend{2} = split(extractAfter(candidateFileName,[dataToUse '_']),'_');

legendValues.baselineLegend  = ['baseline ' nameLengend{1}{1} ' ' nameLengend{1}{2} ' ' nameLengend{1}{3}]
legendValues.candidateLegend = ['candidate ' nameLengend{2}{1} ' ' nameLengend{2}{2} ' ' [nameLengend{2}{3:end-1}] ]

%% RX IF Gain Calib
% gainRxIfPlotter(dataPath,targetFileName,candidateFileName,dataToUse,legacyLog,indxInitFirsAvg,gainErrOutlierTol,rxIfTotalGainSpec_dB,showSelectedAvg,rfeConfigStruct,legendValues)

gainRxIfPlotterv2(dataPath,targetFileName,candidateFileName,dataToUse,legacyLog,gainErrOutlierTol,rxIfTotalGainSpec_dB,rfeConfigStruct,legendValues)

%% RX IF HPF Calib
% Check whether HPF correction is enabled in any of the input logs based on
% their name
correctedHPFLog = any(contains({legendValues.baselineLegend,legendValues.candidateLegend },'HPFcorrected'));

hpfRxIfPlotter(dataPath,targetFileName,candidateFileName,dataToUse,rfeConfigStruct,HpfSpecTolerancePercent,legendValues,correctedHPFLog)
