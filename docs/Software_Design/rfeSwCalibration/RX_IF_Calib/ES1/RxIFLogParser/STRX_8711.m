%% House keeping

% close all;
clear all;
% get path to function to import rfeConfig
addpath('../Validation/HWSW/rx_filter_shaping/')

%% Variables
dataPath = 'C:\Users\nxf59937\Desktop\STRX-8711\';
dataFileExtension = '.txt';

% Variable used to step over the measurement looking for the averaged
% results of all channels on Rx IF calibration
indxInitFirsAvg = 14;

% Variable used to define the relative error tolerance to ignore the
% measurement
gainErrOutlierTol = 1e2;

% Variable indicating what RX IF dataset to use unitTest or
% mainFsmIntegrated
dataToUse = 'calibration-tc-063';
dataToUse = 'mainFsmIntegrated-tc-007';

% Variable to use data from restoring VCs or not
dataWithRestoredVCs = ~true

% Show selected averaged values to be used as RX IF gain once the algorithm
% converged
showSelectedAvg = false;

% Legends names for plots
targetLengenName = 'Disabled VCs';
candidateLengenName = 'None Disabled VCs';

% Paths to rfeConfig.xml
rfeConfigFileName = 'rfeConfig_FCM2_Only.xml';
pathTorfeConfig = 'C:\Users\nxf59937\Downloads\';
pathToConfigGenerator = '../../../../../tools/rfeConfigGenerator/release/';

%% Import Config
rfeConfigStruct = readAnGenerateRfeConfigBin(pathTorfeConfig,rfeConfigFileName,pathToConfigGenerator);

%% Import data

if(strcmp(dataToUse,'calibration-tc-063'))
    if dataWithRestoredVCs
        targetFileName    = 'rfe_sw_calibration_tc_063CleanupRestoresVCs_DISABLED_VCS';
        candidateFileName = 'rfe_sw_calibration_tc_063CleanupRestoresVCs_NO_DISABLED_VCS';
    else
        targetFileName    = 'rfe_sw_calibration_tc_063_rxIfCalibrateConfigProfile_DISABLED_VCS';
        candidateFileName = 'rfe_sw_calibration_tc_063_rxIfCalibrateConfigProfile_NO_DISABLED_VCS';
    end
else
    if dataWithRestoredVCs
        targetFileName    = 'rfe_sw_main_fsm_tc_007_integrated_CleanupRestoresVCs_DISABLED_VCS';
        candidateFileName = 'rfe_sw_main_fsm_tc_007_integrated_CleanupRestoresVCs_NO_DISABLED_VCS';
    else
        targetFileName    = 'rfe_sw_main_fsm_tc_007_integrated_singleModeChirpSequence_DISABLED_VCS';
        candidateFileName = 'rfe_sw_main_fsm_tc_007_integrated_singleModeChirpSequence_NO_DISABLED_VCS';
    end
end

rxIfCalib_target = importGainRxIFLogs([dataPath targetFileName dataFileExtension ]);
rxIfCalib_candidate= importGainRxIFLogs([dataPath candidateFileName dataFileExtension]);
% Old data
% load('C:\Users\nxf59937\Desktop\STRX_8711_Data.mat')

%% Remove outliers

indexOutlier_target = abs(rxIfCalib_target) > gainErrOutlierTol
indexOutlier_candidate = abs(rxIfCalib_candidate) > gainErrOutlierTol;
rxIfCalib_target = rxIfCalib_target(~indexOutlier_target);
rxIfCalib_candidate = rxIfCalib_candidate(~indexOutlier_candidate);


%% Get data

% Averaged IF Gain values
avg_RxIfCalib_target    = rxIfCalib_target(indxInitFirsAvg:indxInitFirsAvg:end)
avg_RxIfCalib_candidate = rxIfCalib_candidate(indxInitFirsAvg:indxInitFirsAvg:end)

% Averaged IF Gain indexes
[~,indexAvgRxIfCalibTarget]=ismember(avg_RxIfCalib_target,rxIfCalib_target)
[~,indexAvgRxIfCalibCandidate]=ismember(avg_RxIfCalib_candidate,rxIfCalib_candidate)

% Remove averaged values from data
purgedTarget  = rxIfCalib_target;
purgedTarget(indexAvgRxIfCalibTarget)  = [];

purgedCandidate  = rxIfCalib_candidate;
purgedCandidate(indexAvgRxIfCalibCandidate)  = [];

%% Calculate rms of data
target_relErrorRms = rms(purgedTarget)
candidate_relErrorRms = rms(purgedCandidate)

avg_target_relErrorRms = rms(rxIfCalib_target(indexAvgRxIfCalibTarget))
avg_candidate_relErrorRms = rms(rxIfCalib_candidate(indexAvgRxIfCalibCandidate))

%% Set max Relative error baesd on requirements

configGain = str2num(replace(rfeConfigStruct.chirpProfiles.chirpProfile.rxGain.gainAttribute,' dB',''));
plotMaxError = ((2--2)/configGain) * 100; %Err = ((2--2)/configGain ) *100 [%] Maximum percentage error associated to +-2dB error in the configured gain

plotRelErrorMax = plotMaxError .* ones(1,max(length(rxIfCalib_target),length(rxIfCalib_candidate)));

%% Plots

% Plots values vs sample
withColors = {};
pHandlerSubplot = [];
pHandlerStems = {};

figure('Name', [targetFileName ' vs ' candidateFileName]);

pHandlerSubplot(1) = subplot(3,1,1);hold on;grid on;
                pHandlerStems{1} = stem(purgedTarget);
                pHandlerStems{2} = stem(purgedCandidate);
                
                if showSelectedAvg
                    pHandlerStems{3} = stem(indexAvgRxIfCalibTarget,rxIfCalib_target(indexAvgRxIfCalibTarget),':','filled');
                    pHandlerStems{4} = stem(indexAvgRxIfCalibCandidate,rxIfCalib_candidate(indexAvgRxIfCalibCandidate),':','filled');
                end

                if(plotMaxError > 0)
                    pHandlerStems{5} = plot(plotRelErrorMax,'--r','LineWidth',1);
                    pHandlerStems{6} = plot(-1.*plotRelErrorMax,'--r','LineWidth',1);
                end
            %     stem(rxIfCalib_target(indexOutlier_target),'c');
            %     stem(rxIfCalib_candidate(indexOutlier_candidate),'Color',[0.4940 0.1840 0.5560]);
                hold off;
                title([dataToUse ': Per Iteration IF Gain relative error']);
                legend({[ targetLengenName '_{rms:' num2str(target_relErrorRms) '}'],[ candidateLengenName '_{rms:' num2str(candidate_relErrorRms) '}']});
                xlabel("Iteration");
                ylabel("Relative Error [%]");

% Align colors with previous pltos for averaged IF gain plots
if showSelectedAvg
    withColors{1} = pHandlerStems{3}.Color;
    withColors{2} = pHandlerStems{4}.Color;
else
    withColors{1} = pHandlerStems{1}.Color;
    withColors{2} = pHandlerStems{2}.Color;
end
pHandlerSubplot(2) = subplot(3,1,2);hold on;grid on;
                stem(rxIfCalib_target(indexAvgRxIfCalibTarget),'Color',withColors{1});
                stem(rxIfCalib_candidate(indexAvgRxIfCalibCandidate),'Color',withColors{2});

                if(plotMaxError > 0)
                    plot(plotRelErrorMax(1:max(length(rxIfCalib_target(indexAvgRxIfCalibTarget)),length(rxIfCalib_candidate(indexAvgRxIfCalibCandidate)))),'--r','LineWidth',1);
                    plot(-1.*plotRelErrorMax(1:max(length(rxIfCalib_target(indexAvgRxIfCalibTarget)),length(rxIfCalib_candidate(indexAvgRxIfCalibCandidate)))),'--r','LineWidth',1);
                end
                hold off;
                title([dataToUse ': All Rxs averaged, IF Gain relative error']);
                legend({[ targetLengenName '_{rms:' num2str(avg_target_relErrorRms) '}'],[ candidateLengenName '_{rms:' num2str(avg_candidate_relErrorRms) '}']});
                xlabel("Iteration");
                ylabel("Relative Error [%]");

%% Histograms
myHistHandler ={};
pHandlerSubplot(3) = subplot(3,1,3);hold on;grid on;
    myHistHandler{1} = histfit(rxIfCalib_target(indexAvgRxIfCalibTarget));
    myHistHandler{2} = histfit(rxIfCalib_candidate(indexAvgRxIfCalibCandidate));
    if(plotMaxError > 0)
        yMax = max([myHistHandler{1}(1).YData myHistHandler{2}(1).YData]);
        pHandlerStems{5} = plot(plotMaxError*ones(1,yMax),1:yMax,'--r','LineWidth',1);
        pHandlerStems{6} = plot(-1.*plotMaxError*ones(1,yMax),1:yMax,'--r','LineWidth',1);
    end
    hold off;
    myHistHandler{1}(1).FaceColor = withColors{1};
    myHistHandler{1}(1).FaceAlpha = 0.9;
    myHistHandler{1}(2).Color = withColors{1};
    myHistHandler{1}(2).LineStyle = ':';
    myHistHandler{2}(1).FaceColor = withColors{2};
    myHistHandler{2}(1).FaceAlpha = 0.9;
    myHistHandler{2}(2).Color = withColors{2};
    myHistHandler{2}(2).LineStyle = ':';

    title([dataToUse ': Histogram All Rxs averaged, IF Gain relative error']);
    legend({targetLengenName,[ targetLengenName ' distfit'], candidateLengenName, [candidateLengenName ' distfit']});
    ylabel("Occurrences");
    xlabel("Relative Error [%]");

