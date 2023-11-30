%%
function hpfRxIfPlotter(dataPath,baselineFileName,candidateFileName,dataToUse,rfeConfigStruct,HpfSpecTolerancePercent,legendValues,correctedHPFLog)
    
    % Data extension of the log
    dataFileExtension = '.txt';
    % Enable stage2 plot in error plot and histogram
    showStage2ErrAndHist = false;
    
    % Iteration indicating average result on log
    iterAverage = 4;

    
    %% Import data
    [hpfRelError_baseline,hpfRxIFCalibFullLog_baseline] = importHPFRxIFLogsfile([dataPath baselineFileName dataFileExtension ]);
    [hpfRelError_candidate,hpfRxIFCalibFullLog_candidate] = importHPFRxIFLogsfile([dataPath candidateFileName dataFileExtension]);

    % Index with all averaged values stage1, stage2 and total
    [indexAllAverages_candidate,indexFinalAvg_candidate,indexAvgStageOne_candidate,indexAvgStageTwo_candidate]=obtainAverageIndexes(hpfRxIFCalibFullLog_candidate,iterAverage);
    [indexAllAverages_baseline,indexFinalAvg_baseline,indexAvgStageOne_baseline,indexAvgStageTwo_baseline]=obtainAverageIndexes(hpfRxIFCalibFullLog_baseline,iterAverage);

    
    %% Set max Relative error baesd on requirements

    configTotalHPF = str2double(replace(rfeConfigStruct.chirpProfiles.chirpProfile.rxFilter.high_pass_filterAttribute,' kHz',''));
    configRxGain  = str2double(replace(rfeConfigStruct.chirpProfiles.chirpProfile.rxGain.gainAttribute,' dB','')); 
    % Check whether we need to apply any HPF correction
    hpfTargetConfig = rxIfCorrectHpfTargetEstimate(configTotalHPF,configRxGain,correctedHPFLog)

    errMaxHpf = hpfTargetConfig * ( 1+(HpfSpecTolerancePercent/100));
    errMinHpf = hpfTargetConfig * ( 1-(HpfSpecTolerancePercent/100));

    %% Calculate total HPF cutoff from stage1 and stage 2

    [hpfTotalFromStage1,hpfTotalFromStage2,hpfTotalFromAverage] = hpfTargetFromStages(hpfRxIFCalibFullLog_candidate.HPFTarget(indexAvgStageOne_candidate.positional),hpfRxIFCalibFullLog_candidate.HPFTarget(indexAvgStageTwo_candidate.positional));
    [hpfTotalFromStage1_baseline,hpfTotalFromStage2_baseline,hpfTotalFromAverage_baseline] = hpfTargetFromStages(hpfRxIFCalibFullLog_baseline.HPFTarget(indexAvgStageOne_baseline.positional),hpfRxIFCalibFullLog_baseline.HPFTarget(indexAvgStageTwo_baseline.positional));
    %% Plots
    samples_baseline = 1:length(hpfRxIFCalibFullLog_baseline.HPFMeasured);
    samples_candidate = 1:length(hpfRxIFCalibFullLog_candidate.HPFMeasured);
    runs = 1:min(length(indexAvgStageOne_candidate.positional),length(indexAvgStageOne_baseline.positional));
    figure('Name', ['HPF comparison' baselineFileName ' vs ' candidateFileName]);
    
    pHandlerSubplotHpf(1) = subplot(4,1,1);hold on;grid on;
        p{1} = plot(samples_candidate,hpfRxIFCalibFullLog_candidate.HPFTarget./1e3,'-.','Marker','*','MarkerSize',4);
        p{end+1} = plot(samples_baseline,hpfRxIFCalibFullLog_baseline.HPFMeasured./1e3,'LineStyle',p{1}.LineStyle,'Marker',p{1}.Marker,'MarkerSize',p{1}.MarkerSize);
        p{end+1} = plot(samples_candidate,hpfRxIFCalibFullLog_candidate.HPFMeasured./1e3,'LineStyle',p{1}.LineStyle,'Marker','o','MarkerSize',p{1}.MarkerSize);
        p{end+1} = plot(samples_candidate(indexAvgStageTwo_candidate.positional),hpfRxIFCalibFullLog_candidate.HPFMeasured(indexAvgStageTwo_candidate.positional)./1e3,'o','MarkerSize',5,'Color','#77AC30');
        p{end+1} = plot(samples_candidate(indexFinalAvg_candidate.logical),hpfRxIFCalibFullLog_candidate.HPFMeasured(indexFinalAvg_candidate.logical)./1e3,'o','MarkerSize',5,'Color','#7E2F8E');
        hold off;
        legend({'HPF target', ...
            [legendValues.baselineLegend  ' HPF mesaured'], ...
            [legendValues.candidateLegend ' HPF measured'], ...
            [legendValues.candidateLegend ' Averaged HPF_{stage2}'], ...
            [legendValues.candidateLegend ' Averaged HPF_{calibSelected}']});
        title([replace(dataToUse,'_','-') ': Per Iteration Full log stage baseline vs candidate']);
        xlabel("Ireration");ylabel("Frequency[KHz]");

    pHandlerSubplotHpf(2) = subplot(4,1,2);hold on;grid on;
        p{end+1} = stem(runs,hpfTargetConfig.*ones(size(runs)),'LineStyle',p{1}.LineStyle,'Marker',p{1}.Marker,'MarkerSize',p{1}.MarkerSize);
        p{end+1} = stem(runs,totalHpfFromHpfStage(hpfRxIFCalibFullLog_baseline.HPFMeasured(indexFinalAvg_baseline.logical),'stage2')./1e3,'LineStyle',p{2}.LineStyle,'Marker',p{2}.Marker,'MarkerSize',p{2}.MarkerSize,'Color',p{2}.Color);
        p{end+1} = stem(runs,totalHpfFromHpfStage(hpfRxIFCalibFullLog_candidate.HPFMeasured(indexAvgStageOne_candidate.positional),'stage1')./1e3,'LineStyle',':','Marker',p{3}.Marker,'MarkerSize',p{3}.MarkerSize);
        p{end+1} = stem(runs,totalHpfFromHpfStage(hpfRxIFCalibFullLog_candidate.HPFMeasured(indexAvgStageTwo_candidate.positional),'stage2')./1e3,'LineStyle',':','Marker',p{3}.Marker,'MarkerSize',p{3}.MarkerSize,'Color',p{4}.Color);
        p{end+1} = stem(runs,totalHpfFromHpfStage(hpfRxIFCalibFullLog_candidate.HPFMeasured(indexFinalAvg_candidate.logical),'stage2')./1e3,'LineStyle',':','Marker',p{4}.Marker,'MarkerSize',p{4}.MarkerSize,'Color',p{5}.Color);
        if(HpfSpecTolerancePercent > 0)
%             pHandler{1} = plot(runs,errMaxHpf.*ones(size(runs)),'--r','LineWidth',1);
%             pHandler{2} = plot(runs,errMinHpf.*ones(size(runs)),'--r','LineWidth',1);
            pHandler{1} = errorbar(runs,hpfTargetConfig.*ones(size(runs)),(HpfSpecTolerancePercent/100).*hpfTargetConfig.*ones(size(runs)),'LineStyle','none','Color','r','LineWidth',1);
        end
        hold off;
        legend({'HPF_{total} target', ...
            [legendValues.baselineLegend  ' HPF_{total}'], ...
            [legendValues.candidateLegend ' Averaged HPF_{stage1}'], ...
            [legendValues.candidateLegend ' Averaged HPF_{stage2}'], ...
            [legendValues.candidateLegend ' Averaged HPF_{calibSelected}']});
        title([replace(dataToUse,'_','-') ': Per Iteration Total HPF cutoff frequency baseline vs candidate']);
        xlabel("Run #");ylabel("Frequency[KHz]");
        ylim(pHandlerSubplotHpf(2),[hpfTargetConfig-50,hpfTargetConfig+50])

    pHandlerSubplotHpf(3) = subplot(4,1,3);hold on;grid on;
        pError{1}     = stem(runs,hpfRelError_baseline(indexFinalAvg_baseline.positional),'Color',p{2}.Color);
        pError{end+1} = stem(runs,hpfRelError_candidate(indexFinalAvg_candidate.positional),'Color',p{5}.Color);
        if(showStage2ErrAndHist)
            pError{end+1} = stem(runs,hpfRelError_candidate(indexAvgStageTwo_candidate.positional),'Color',p{4}.Color);
        end
        if(HpfSpecTolerancePercent > 0)
%             pHandler{1} = plot(runs,HpfSpecTolerancePercent.*ones(size(runs)),'--r','LineWidth',1);
%             pHandler{2} = plot(runs,-HpfSpecTolerancePercent.*ones(size(runs)),'--r','LineWidth',1);
            pHandler{2} = errorbar(runs,zeros(size(runs)),HpfSpecTolerancePercent*ones(size(runs)),'LineStyle','none','Color','r','LineWidth',1);
        end
        hold off;
        if(showStage2ErrAndHist)
            legend({[legendValues.baselineLegend  ' relError_{rms:' num2str(rms(hpfRelError_baseline(indexFinalAvg_baseline.positional))) '}'], ...
                [legendValues.candidateLegend ' Calibration relError_{rms:' num2str(rms(hpfRelError_candidate(indexFinalAvg_candidate.logical))) '}'] ...
                [legendValues.candidateLegend ' stage2 relError_{rms:' num2str(rms(hpfRelError_candidate(indexAvgStageTwo_candidate.positional))) '}']});
        else
            legend({[legendValues.baselineLegend  ' relError_{rms:' num2str(rms(hpfRelError_baseline(indexFinalAvg_baseline.positional))) '}'], ...
                [legendValues.candidateLegend ' Calibration relError_{rms:' num2str(rms(hpfRelError_candidate(indexFinalAvg_candidate.logical))) '}'] ...
                });
        end
        xlabel("Run #");ylabel("Relative Error HPF_{Total}[%]");
        title([replace(dataToUse,'_','-') ': All Rxs averaged, HPF_{total} Relative error baseline vs candidate']);
    
    pHandlerSubplotHpf(4) = subplot(4,1,4);hold on;grid on;
        myHistHandler{1} = histfit(hpfRelError_baseline(indexFinalAvg_baseline.positional));
        myHistHandler{2} = histfit(hpfRelError_candidate(indexFinalAvg_candidate.positional));
        if(showStage2ErrAndHist)
            myHistHandler{end+1} = histfit(hpfRelError_candidate(indexAvgStageTwo_candidate.positional));
        end
        if(HpfSpecTolerancePercent > 0)
            yMax = max([myHistHandler{1}(1).YData myHistHandler{2}(1).YData]);
            pHandler{1} = plot(HpfSpecTolerancePercent*ones(1,yMax),1:yMax,'--r','LineWidth',2);
            pHandler{2} = plot(-HpfSpecTolerancePercent*ones(1,yMax),1:yMax,'--r','LineWidth',2);
        end
        hold off;
        legend({legendValues.baselineLegend,[ legendValues.baselineLegend ' distfit'], legendValues.candidateLegend, [legendValues.candidateLegend ' distfit']});
        myHistHandler{1}(1).FaceColor = pError{1}.Color;
        myHistHandler{1}(1).FaceAlpha = 0.9;
        myHistHandler{1}(2).Color = myHistHandler{1}(1).FaceColor;
        myHistHandler{1}(2).LineStyle = ':';
        myHistHandler{2}(1).FaceColor = pError{2}.Color;
        myHistHandler{2}(1).FaceAlpha = 0.9;
        myHistHandler{2}(2).Color = myHistHandler{2}(1).FaceColor;
        myHistHandler{2}(2).LineStyle = ':';
        if(showStage2ErrAndHist)
            legend({legendValues.baselineLegend,[legendValues.baselineLegend ' distfit'], ...
                    legendValues.candidateLegend,[legendValues.candidateLegend ' distfit'], ...
                    [legendValues.candidateLegend ' stage2'],[legendValues.candidateLegend ' stage2 distfit']});
            myHistHandler{3}(1).FaceColor = pError{3}.Color;
            myHistHandler{3}(1).FaceAlpha = 0.8;
            myHistHandler{3}(2).Color = myHistHandler{3}(1).FaceColor;
            myHistHandler{3}(2).LineStyle = ':';
        end
        title([replace(dataToUse,'_','-') ': Histogram All Rxs averaged, HPF relative error baseline vs candidate']);
        xlabel("Relative Error [%]");ylabel("Ocurrences");

   linkaxes([pHandlerSubplotHpf(2),pHandlerSubplotHpf(3)],'x');
end

%% Function the obtain the total HPF cutoff frequency from both HPF stages target cutoff frequencies
% Thus function does the direct coversion but also uses the average as
% output to compare
function [hpfTotalFromStage1,hpfTotalFromStage2,hpfTotalFromAverage] = hpfTargetFromStages(hpfStage1,hpfStage2)

    hpfTotalFromStage1  = totalHpfFromHpfStage(hpfStage1,'stage1');
    hpfTotalFromStage2  = totalHpfFromHpfStage(hpfStage2,'stage2');
    if(length(hpfStage2)~=length(hpfStage1))
        hpfTotalFromAverage = [];
    else
        hpfTotalFromAverage = (hpfStage1 + hpfStage2)./2;
    end
end
%% Function the obtain the total HPF cutoff frequency from HPF stage target cutoff frequency
function hpfTotalFromStage = totalHpfFromHpfStage(hpfStage,stage)
    switch stage
        case 'stage1'
            hpfTotalFromStage  = hpfStage .*(2);
        case 'stage2'
            hpfTotalFromStage  = hpfStage .*(2/2.965);
        otherwise
            error('Ivalid HPF stage');
    end
end

%% 
function [hpfStage1,hpfStage2]= padWithLastValue(hpfStage1,hpfStage2)
    if(length(hpfStage2)~=length(hpfStage1))
        l2 = length(hpfStage2);
        l1 = length(hpfStage1);
       if l2 > l1
           hpfStage1(end+1)=hpfStage1(end);
       else
           hpfStage2(end+1)=hpfStage2(end);
       end
    end
end

function correctedtotalHpfIf = rxIfCorrectHpfTargetEstimate(totalHPF,rxGain,applyCorrection)

    hpfToCorrect = 200;%[KHz] ;
    rxGainToCorrect = [43,46]; % dB
    hpfCorrection = 1.075;
    
    if(applyCorrection && totalHPF == hpfToCorrect && any(ismember(rxGain,rxGainToCorrect)))
        correctedtotalHpfIf  = totalHPF.*hpfCorrection;
%         correctedtotalHpfIf.stage1Hpf = totalHpfIf.*hpfCorrection;
%         correctedtotalHpfIf.stage2Hpf = totalHpfIf.*hpfCorrection;
    else
        correctedtotalHpfIf  = totalHPF;
%         correctedtotalHpfIf.stage1Hpf = totalHpfIf;
%         correctedtotalHpfIf.stage2Hpf = totalHpfIf;
    end

end
