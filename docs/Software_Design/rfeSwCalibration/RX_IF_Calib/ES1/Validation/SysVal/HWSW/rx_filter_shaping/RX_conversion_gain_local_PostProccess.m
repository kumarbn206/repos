
%% variables

currentSystemSetting.LOFreq= rfeConfigStruct.chirpProfiles.chirpProfile.chirpGenerator.center_frequency_kHzAttribute*1e3;%GHz
currentSystemSetting.FStart= 100e+3;
kT= physconst('Boltzmann') * (25 + 273.15);
currentSystemSetting.RXChMeas= "RX2 ";%"RX3 ";
currentSystemSetting.MeasTemp= "RT ";
currentSystemSetting.LPFSetting= str2double(replace(rfeConfigStruct.chirpProfiles.chirpProfile.rxFilter.low_pass_filterAttribute,' MHz',''))*1e6;
currentSystemSetting.HPFSetting= str2double(replace(rfeConfigStruct.chirpProfiles.chirpProfile.rxFilter.high_pass_filterAttribute,' kHz',''))*1e3;
currentSystemSetting.CGSetting= str2double(replace(rfeConfigStruct.chirpProfiles.chirpProfile.rxGain.gainAttribute,' dB','')); % dB

load WgLossesUncertainty.mat;

[RX1PLossRow, RX1PLossCol] = PCBLossSel(currentSystemSetting.LOFreq/1e9, "TXRX1");
[RX2PLossRow, RX2PLossCol] = PCBLossSel(currentSystemSetting.LOFreq/1e9, "TXRX2");
[RX3PLossRow, RX3PLossCol] = PCBLossSel(currentSystemSetting.LOFreq/1e9, "TXRX3");
[RX4PLossRow, RX4PLossCol] = PCBLossSel(currentSystemSetting.LOFreq/1e9, "TXRX4");

% Load PCB losses and uncertainty from WgLossesUncertainty.mat cell.

% PCB Losses are extracted from WgLossesUncertainty.mat cell
PLossRX1                   = WgLossesUncertainty{RX1PLossRow, RX1PLossCol};
PLossRX2                   = WgLossesUncertainty{RX2PLossRow, RX2PLossCol};
PLossRX3                   = WgLossesUncertainty{RX3PLossRow, RX3PLossCol};
PLossRX4                   = WgLossesUncertainty{RX4PLossRow, RX4PLossCol};

% Combine all losses in one array
PLossRX14                  = [PLossRX1 PLossRX2 PLossRX3 PLossRX4];


currentSystemSetting.samples= 4096;
currentSystemSetting.sampleFreq= str2double(replace(rfeConfigStruct.chirpProfiles.chirpProfile.effectiveSamplingFrequency.frequencyAttribute,' MHz',''))*1e6;
currentSystemSetting.CHIRPS = rfeConfigStruct.chirpSequenceConfigs.chirpSequenceConfig.chirpCount.countAttribute;
currentSystemSetting.NRXChannels = 4;
currentSystemSetting.ADCInputRange = 2.8;
currentSystemSetting.ADCResolution= 16;

N = currentSystemSetting.samples*currentSystemSetting.NRXChannels*currentSystemSetting.CHIRPS;

TotalChirps                = currentSystemSetting.CHIRPS;
FBin                       = currentSystemSetting.sampleFreq/N;
FreqFFT                    = [-currentSystemSetting.sampleFreq/2:currentSystemSetting.sampleFreq/currentSystemSetting.CHIRPS:currentSystemSetting.sampleFreq/2 -currentSystemSetting.sampleFreq/currentSystemSetting.CHIRPS];
FreqFFT                    = FreqFFT(1:currentSystemSetting.CHIRPS);
FreqFFT                    = FreqFFT(currentSystemSetting.CHIRPS/2 + 1:end);


IFFreqSweep1=currentSystemSetting.FStart:20e3:1e6;
IFFreqSweep2=1.5e6:0.5e6:25e6;

IFFreqSweep=[-flip(IFFreqSweep2) -flip(IFFreqSweep1) IFFreqSweep1 IFFreqSweep2];

SGFreqSweep= currentSystemSetting.LOFreq + IFFreqSweep;


basepath = InputStruct.basepath; % this is the path the \Matlab folder
addpath(genpath(basepath));
% addpath(InputStruct.Proxy_loc);


CGFrequencyPlt = figure('Name',['Gain_vs_IF_Frequency on ' dataSet]);

strxFullData = cell(1:length(measurements));

MaxCG   = zeros(length(measurements),length(IFFreqSweep));
MaxPout = zeros(length(measurements),length(IFFreqSweep));
Gain    = zeros(1,length(measurements));

for selectedMesurement =1:length(measurements)

[strxReadData,IFFreqSweep] = strxDataImporter(singleFile,dataDir,[]);
strxFullData{selectedMesurement}.sweepDir = dataDir;
strxFullData{selectedMesurement}.sweep    = strxReadData;

CG          = zeros(currentSystemSetting.samples/2,length(IFFreqSweep));
PoutdBvrms  = zeros(currentSystemSetting.samples/2,length(IFFreqSweep));

    for ii= 1: length(strxReadData)

        Pin = 5.88; %[dBm]
        Attenuator = -50;%[dB]
        PowerValue = powerEstimation(Pin,Attenuator);

        if currentSystemSetting.LOFreq==76e9
            PinRX14=PowerValue(1)+.9; % compensating the 10dB coupler
        elseif currentSystemSetting.LOFreq==76.5e9
            PinRX14=PowerValue(1)+.9; % compensating the 10dB coupler
        elseif currentSystemSetting.LOFreq==77e9
            PinRX14=PowerValue(1)+1; % compensating the 10dB coupler
        end

        ADCCGDataArray=strxReadData{ii}.data;

        % Calculate the Conversion Gain
        [CG(:, ii), PoutdBvrms(:, ii)] = CGMeasSTRX(ADCCGDataArray, currentSystemSetting.ADCResolution, currentSystemSetting.ADCInputRange, ...
            PinRX14, PLossRX14, currentSystemSetting.samples, currentSystemSetting.CHIRPS, currentSystemSetting.RXChMeas);
        
        % Remove the very low frequency components from frequency array
        FreqFFTTruncated = FreqFFT(2:end);

        % Remove the very low frequency components from CG calculation
        CGTruncated = CG(2:end, ii);

        % Save the peaks in a separate CG matrix
        MaxCG(selectedMesurement, ii) = max(CGTruncated);

        % Save the peaks in a separate Pout matrix
        MaxPout(selectedMesurement, ii) = max(PoutdBvrms(4:end, ii));

    end
    % Estimated cut off frequency of HPF
%     fc_hpf = hpfGainEstmation(selectedMesurement,measurements{selectedMesurement},MaxCG,IFFreqSweep,Gain);

end



for selectedMesurement =1:length(measurements)
    % Plot the measured Gain of RX2 for all HPF settings
    sp(1) = subplot(4,1,1);grid on;hold on;
    myPlots(selectedMesurement) = plot(IFFreqSweep/1e6, MaxCG(selectedMesurement, :));
end
    myPlots(3) = plot(IFFreqSweep/1e6, currentSystemSetting.CGSetting*ones(size(IFFreqSweep)),'.-');
    hold off;

xlabel('IF Frequency (MHz)', 'Interpreter', 'latex', 'fontsize', 10);
ylabel('Conversion Gain (dB) ', 'Interpreter', 'latex', 'fontsize', 10);
title( [ 'Gain vs. IF Frequency with HPF:', num2str(currentSystemSetting.HPFSetting/1e3), 'KHz and LPF:', num2str(currentSystemSetting.LPFSetting/1e6), 'MHz@' num2str(currentSystemSetting.LOFreq/1e9) 'GHz'   ]);
l(1) =legend(sp(1),{append(currentSystemSetting.RXChMeas,measurements{1}), append(currentSystemSetting.RXChMeas,measurements{2}),['target Gain']}, 'location', 'best');


sp(2) = subplot(4,1,2);grid on;hold on;
    mp(1) = plot(IFFreqSweep/1e6, flip(MaxCG(1, :)),'Color',myPlots(1).Color);
    mp(2) = plot(IFFreqSweep/1e6, MaxCG(2, :),'Color',myPlots(2).Color);
    mp(3) = plot(IFFreqSweep/1e6, currentSystemSetting.CGSetting*ones(size(IFFreqSweep)),'.-','Color',myPlots(selectedMesurement+1).Color);
hold off;
xlabel('IF Frequency (MHz)', 'Interpreter', 'latex', 'fontsize', 10);
ylabel('Conversion Gain (dB) ', 'Interpreter', 'latex', 'fontsize', 10);
title( [ 'Gain vs. IF Frequency with HPF:', num2str(currentSystemSetting.HPFSetting/1e3), 'KHz and LPF:', num2str(currentSystemSetting.LPFSetting/1e6), 'MHz@' num2str(currentSystemSetting.LOFreq/1e9) 'GHz'  ]);
l(2) = legend(sp(2),{append(append(currentSystemSetting.RXChMeas,measurements{1}),' flipped'), append(currentSystemSetting.RXChMeas,measurements{2}),'target Gain'}, 'location', 'best');


%% Error

absErr = flip(MaxCG(1, :)) - MaxCG(2, :);
relErr = (flip(MaxCG(1, :)) - MaxCG(2, :))./ flip(MaxCG(1, :));
idxHpf = find(IFFreqSweep==currentSystemSetting.HPFSetting);
idxLpf = find(IFFreqSweep==currentSystemSetting.LPFSetting);
rmsAbsErr = rms(absErr(idxHpf:idxLpf));
rmsRelErr = rms(relErr(idxHpf:idxLpf));

sp(3) = subplot(4,1,3);grid on;hold on;
    ePlot(1) = plot(IFFreqSweep/1e6, absErr,'.-k');
    ylabel({'Absolute Error =';'G_{Rx1 rising flipped} - G_{Rx1 falling} '});
hold off;
title( ['G_{Rx1 rising flipped} - G_{Rx1 falling} vs. IF Frequency,@' num2str(currentSystemSetting.LOFreq/1e9) 'GHz']);
l(3) = legend(sp(3),{['Absolute Error_{rms}:' num2str(rmsAbsErr)]}, 'location', 'best');
xlabel('IF Frequency (MHz)', 'Interpreter', 'latex', 'fontsize', 10);

sp(4) = subplot(4,1,4);grid on;hold on;
    ePlot(2) = plot(IFFreqSweep/1e6, relErr,'.-k');
    ylabel({'Relative Error =';'(G_{Rx1 rising flipped} - G_{Rx1 falling})/G_{Rx1 rising flipped}'});
hold off;
title( ['(G_{Rx1 rising flipped} - G_{Rx1 falling})/G_{Rx1 rising flipped} vs. IF Frequency,@' num2str(currentSystemSetting.LOFreq/1e9) 'GHz']);
l(4) = legend(sp(4),{['Relative Error_{rms}:' num2str(rmsRelErr)]}, 'location', 'best');
xlabel('IF Frequency (MHz)', 'Interpreter', 'latex', 'fontsize', 10);

%% Patch

patchF = [currentSystemSetting.HPFSetting./1e6,currentSystemSetting.HPFSetting./1e6,currentSystemSetting.LPFSetting./1e6,currentSystemSetting.LPFSetting/1e6];
patchG = [currentSystemSetting.HPFSetting./1e6,currentSystemSetting.CGSetting, currentSystemSetting.CGSetting,currentSystemSetting.HPFSetting/1e6];
patchEabs = [min(absErr),max(absErr), max(absErr),min(absErr)];
patchErel = [min(relErr),max(relErr), max(relErr),min(relErr)];
pch(1) = patch(sp(2), patchF,patchG, 'g', 'EdgeColor', 'none', 'FaceAlpha', 0.1);
pch(2) = patch(sp(3), patchF,patchEabs, 'g', 'EdgeColor', 'none', 'FaceAlpha', 0.1);
pch(3) = patch(sp(4), patchF,patchErel, 'g', 'EdgeColor', 'none', 'FaceAlpha', 0.1);
l(2).String{4} = 'target freqs response';
l(3).String{2} = 'target freqs response';
l(4).String{2} = 'target freqs response';
% Arrange the plots to be able to add marks
sp(2).Children = [mp(1),mp(2),mp(3),pch(1)];
sp(3).Children = [ePlot(1),pch(2)];
sp(4).Children = [ePlot(2),pch(3)];