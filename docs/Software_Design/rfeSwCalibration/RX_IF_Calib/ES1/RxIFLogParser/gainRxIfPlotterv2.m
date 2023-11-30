function gainRxIfPlotterv2(dataPath,baselineFileName,candidateFileName,dataToUse,legacyLog,gainErrOutlierTol,rxIfTotalGainSpec_dB,rfeConfigStruct,legendValues)
% Data extension of the log
dataFileExtension = '.txt';

% Enable stage2 plot in error plot and histogram
showStage2ErrAndHist = false;

%% Import data
if legacyLog
    [rxIfCalibRelErr_baseline,~] = importGainRxIFLogs([dataPath baselineFileName dataFileExtension ],legacyLog);
    [rxIfCalibRelErr_candidate,~]= importGainRxIFLogs([dataPath candidateFileName dataFileExtension],legacyLog);
else
    [rxIfCalibRelErr_baseline,gainRxIFCalibFullLog_baseline] = importGainRxIFLogs([dataPath baselineFileName dataFileExtension ]);
    [rxIfCalibRelErr_candidate,gainRxIFCalibFullLog_candidate]= importGainRxIFLogs([dataPath candidateFileName dataFileExtension]);
end
% Old data
% load('C:\Users\nxf59937\Desktop\STRX_8711_Data.mat')

%% Remove outliers

% indexOutlier_baseline = abs(rxIfCalib_baseline) > gainErrOutlierTol
% indexOutlier_candidate = abs(rxIfCalib_candidate) > gainErrOutlierTol;
% rxIfCalib_baseline = rxIfCalib_baseline(~indexOutlier_baseline);
% rxIfCalib_candidate = rxIfCalib_candidate(~indexOutlier_candidate);


%% Get averaged data
% Iteration indicating average result on log
iterAverage = 4;
% Index with all averaged values stage1, stage2 and total
[indexAllAverages_baseline,indxFinalAvg_baseline,indexStageOne_baseline,indexStageTwo_baseline]=obtainAverageIndexes(gainRxIFCalibFullLog_baseline,iterAverage);
[indexAllAverages_candidate,indxFinalAvg_cadidate,indexStageOne_candidate,indexStageTwo_candidate]=obtainAverageIndexes(gainRxIFCalibFullLog_candidate ,iterAverage);


% Remove averaged values from data
purgedbaseline  = rxIfCalibRelErr_baseline;
purgedbaseline(indexAllAverages_baseline)  = [];

purgedCandidate  = rxIfCalibRelErr_candidate;
purgedCandidate(indexAllAverages_candidate)  = [];
%% Calculate rms of data
baseline_relErrorRms = rms(gainRxIFCalibFullLog_baseline.IF_Gain_RelError(indxFinalAvg_baseline.positional))
avg_candidateCalib_relErrorRms = rms(gainRxIFCalibFullLog_candidate.IF_Gain_RelError(indxFinalAvg_cadidate.positional))
avg_candidateStg2_relErrorRms = rms(gainRxIFCalibFullLog_candidate.IF_Gain_RelError(indexStageTwo_candidate.positional))
avg_candidateStg1_relErrorRms = rms(gainRxIFCalibFullLog_candidate.IF_Gain_RelError(indexStageOne_candidate.positional))

%% Set max Relative error baesd on requirements

configGain_dB = str2num(replace(rfeConfigStruct.chirpProfiles.chirpProfile.rxGain.gainAttribute,' dB',''));
%Conversion of +/- total Rx Gain specification (in dB) into percentage is carried out via Err = (rxIfTotalGainSpec_dB)/configGain ) *100 [%] Maximum percentage error associated to +-2dB error in the configured gain
plotMaxError = (rxIfTotalGainSpec_dB/configGain_dB) * 100; 

plotRelErrorMax = plotMaxError .* ones(1,max(length(rxIfCalibRelErr_baseline),length(rxIfCalibRelErr_candidate)));

%% Plots
% if(useRC0_8_12)
%     legendValues.baselineLegend = 'RC 0.8.12';
% end

samples_baseline = 1:length(gainRxIFCalibFullLog_baseline.IF_Gain_measured);
samples_candidate = 1:length(gainRxIFCalibFullLog_candidate.IF_Gain_measured);
runs_baseline = 1:length(indexStageTwo_baseline.positional);
runs_candidate = 1:length(indexStageTwo_candidate.positional);
% Plots values vs sample
pHandlerSubplot = [];
pHandlers = {};

figure('Name', ['Gain comparison' baselineFileName ' vs ' candidateFileName]);

pHandlerSubplot(1) = subplot(4,1,1);hold on;grid on;
        pHandlers{1} = plot(samples_baseline,mag2db(gainRxIFCalibFullLog_baseline.IF_Gain_target),'-.','Marker','*','MarkerSize',4);
        pHandlers{2} = plot(samples_baseline,mag2db(gainRxIFCalibFullLog_baseline.IF_Gain_measured),'LineStyle',pHandlers{1}.LineStyle,'Marker',pHandlers{1}.Marker,'MarkerSize',pHandlers{1}.MarkerSize);
        pHandlers{3} = plot(samples_candidate,mag2db(gainRxIFCalibFullLog_candidate.IF_Gain_measured),'LineStyle',pHandlers{1}.LineStyle,'Marker','o','MarkerSize',pHandlers{1}.MarkerSize);
        pHandlers{4} = plot(samples_candidate(indexStageTwo_candidate.positional),mag2db(gainRxIFCalibFullLog_candidate.IF_Gain_measured(indexStageTwo_candidate.positional)),'o','MarkerSize',5,'Color','#77AC30');
        pHandlers{5} = plot(samples_candidate(indxFinalAvg_cadidate.logical),mag2db(gainRxIFCalibFullLog_candidate.IF_Gain_measured(indxFinalAvg_cadidate.logical)),'o','MarkerSize',5,'Color','#7E2F8E');
        hold off;
        title([replace(dataToUse,'_','-') ': Per Iteration IF Gain baseline vs candidate']);
        legend({'RxGain_{total} target','RxGain_{total} baseline','RxGain_{total} candidate','Averaged RxGain_{stage2} candidate','RxGain_{calibSelected} candidate'});
        xlabel("Iteration");
        ylabel("IF Gain [dB]");

pHandlerSubplot(2) = subplot(4,1,2);hold on;grid on;
        pHandlers{6} = plot(runs_baseline,mag2db(gainRxIFCalibFullLog_baseline.IF_Gain_target(indxFinalAvg_baseline.positional)),'LineStyle',pHandlers{1}.LineStyle,'Marker',pHandlers{1}.Marker,'MarkerSize',pHandlers{1}.MarkerSize);
        pHandlers{7} = plot(runs_baseline,mag2db(gainRxIFCalibFullLog_baseline.IF_Gain_measured(indxFinalAvg_baseline.positional)),'LineStyle',':','Marker',pHandlers{2}.Marker,'MarkerSize',pHandlers{2}.MarkerSize,'Color',pHandlers{2}.Color);
        pHandlers{8} = plot(runs_candidate,mag2db(gainRxIFCalibFullLog_candidate.IF_Gain_measured(indexStageTwo_candidate.positional)),'LineStyle',':','Marker',pHandlers{4}.Marker,'MarkerSize',pHandlers{4}.MarkerSize,'Color',pHandlers{4}.Color);
        pHandlers{9} = plot(runs_candidate,mag2db(gainRxIFCalibFullLog_candidate.IF_Gain_measured(indxFinalAvg_cadidate.positional)),'LineStyle',':','Marker',pHandlers{5}.Marker,'MarkerSize',pHandlers{5}.MarkerSize,'Color',pHandlers{5}.Color);
        
        hold off;
        title([replace(dataToUse,'_','-') ': All Rxs averaged, IF Total Gain baseline vs IF stage Gain candidate vs IF Total Gain candidate  ']);
        legend({['target'] ...
                [legendValues.baselineLegend ' calibration'] ...
                [legendValues.candidateLegend ' stage2'], ...
                [legendValues.candidateLegend ' calibration']});
        xlabel("Run #");
        ylabel("IF Gain [dB]");

pHandlerSubplot(3) = subplot(4,1,3);hold on;grid on;
        pError{1} = stem(runs_baseline,gainRxIFCalibFullLog_baseline.IF_Gain_RelError(indxFinalAvg_baseline.positional),'LineStyle',pHandlers{2}.LineStyle,'Marker',pHandlers{2}.Marker,'MarkerSize',pHandlers{2}.MarkerSize,'Color',pHandlers{2}.Color);
        pError{2} = stem(runs_candidate,gainRxIFCalibFullLog_candidate.IF_Gain_RelError(indxFinalAvg_cadidate.positional),'LineStyle',pHandlers{2}.LineStyle,'Marker',pHandlers{5}.Marker,'MarkerSize',pHandlers{5}.MarkerSize,'Color',pHandlers{5}.Color);
        if(showStage2ErrAndHist)
            pError{end+1} = stem(runs_candidate,gainRxIFCalibFullLog_candidate.IF_Gain_RelError(indexStageTwo_candidate.positional),'LineStyle',pHandlers{2}.LineStyle,'Marker',pHandlers{4}.Marker,'MarkerSize',pHandlers{4}.MarkerSize,'Color',pHandlers{4}.Color);
        end
        if(plotMaxError > 0)
            plot(plotRelErrorMax(1:max(length(rxIfCalibRelErr_baseline(indxFinalAvg_baseline.positional)),length(rxIfCalibRelErr_candidate(indxFinalAvg_cadidate.positional)))),'--r','LineWidth',1);
            plot(-1.*plotRelErrorMax(1:max(length(rxIfCalibRelErr_baseline(indxFinalAvg_baseline.positional)),length(rxIfCalibRelErr_candidate(indxFinalAvg_cadidate.positional)))),'--r','LineWidth',1);
        end
        hold off;
        if(showStage2ErrAndHist)
            legend({[legendValues.baselineLegend ' relError_{rms:' num2str(baseline_relErrorRms) '}'], ...
                [legendValues.candidateLegend ' calibration relError_{rms:' num2str(avg_candidateCalib_relErrorRms) '}'], ...
                [legendValues.candidateLegend ' stage2 relError_{rms:' num2str(avg_candidateStg2_relErrorRms) '}'] ...
                });
        else
            legend({[legendValues.baselineLegend ' relError_{rms:' num2str(baseline_relErrorRms) '}'], ...
                [legendValues.candidateLegend ' calibration relError_{rms:' num2str(avg_candidateCalib_relErrorRms) '}'], ...
                });
        end
        title([replace(dataToUse,'_','-') ': All Rxs averaged, IF Gain relative error baseline vs candidate']);
        xlabel("Run #");
        ylabel("Relative Error [%]");

linkaxes([pHandlerSubplot(2),pHandlerSubplot(3)],'x')

%% Histograms
myHistHandler ={};
pHandlerSubplot(4) = subplot(4,1,4);hold on;grid on;
    myHistHandler{1} = histfit(rxIfCalibRelErr_baseline(indxFinalAvg_baseline.positional));
    myHistHandler{2} = histfit(rxIfCalibRelErr_candidate(indxFinalAvg_cadidate.positional));
    if(showStage2ErrAndHist)
        myHistHandler{end+1} = histfit(rxIfCalibRelErr_candidate(indexStageTwo_candidate.positional));
    end
    if(plotMaxError > 0)
        yMax = max([myHistHandler{1}(1).YData myHistHandler{2}(1).YData]);
        pHandlers{12} = plot(plotMaxError*ones(1,yMax),1:yMax,'--r','LineWidth',2);
        pHandlers{13} = plot(-1.*plotMaxError*ones(1,yMax),1:yMax,'--r','LineWidth',2);
    end
    hold off;
    myHistHandler{1}(1).FaceColor = pError{1}.Color;
    myHistHandler{1}(1).FaceAlpha = 0.9;
    myHistHandler{1}(2).Color = myHistHandler{1}(1).FaceColor;
    myHistHandler{1}(2).LineStyle = ':';
    myHistHandler{2}(1).FaceColor = pError{2}.Color;
    myHistHandler{2}(1).FaceAlpha = 0.9;
    myHistHandler{2}(2).Color = myHistHandler{2}(1).FaceColor;
    myHistHandler{2}(2).LineStyle = ':';
    legend({legendValues.baselineLegend,[ legendValues.baselineLegend ' distfit'], legendValues.candidateLegend, [legendValues.candidateLegend ' distfit']});
    if(showStage2ErrAndHist)
        legend({legendValues.baselineLegend,[legendValues.baselineLegend ' distfit'], ...
                legendValues.candidateLegend,[legendValues.candidateLegend ' distfit'], ...
                [legendValues.candidateLegend ' stage2'],[legendValues.candidateLegend ' stage2 distfit']});
        myHistHandler{3}(1).FaceColor = pError{3}.Color;
        myHistHandler{3}(1).FaceAlpha = 0.8;
        myHistHandler{3}(2).Color = myHistHandler{3}(1).FaceColor;
        myHistHandler{3}(2).LineStyle = ':';
    end
    title([replace(dataToUse,'_','-') ': Histogram All Rxs averaged, IF Gain relative error baseline vs candidate']);
    ylabel("Occurrences");
    xlabel("Relative Error [%]");
end
