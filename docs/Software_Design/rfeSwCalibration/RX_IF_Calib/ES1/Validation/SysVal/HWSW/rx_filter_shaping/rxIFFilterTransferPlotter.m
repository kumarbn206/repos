%% Function to plot RX IF v2 filter transfer function for chirp slop positive and negative
%
% Inputs
%   dataDir : path  to where the data is stored, the expected directory
%             struct is C:\x\y\z\falling\
%                       C:\x\y\z\rising\
%   chirpSlopes : array of char indicating the slope of the chirps
%   IFFreqSweep: 
%   FreqFFT:
%   currentSystemSetting:
%   measuredPower: measured power at the Rx under test
%   PLossRX14: 
% Outputs
%   fc_hpf : estimated Fc for HPF via interpolation 
% Author : Javier Cuadros Linde, nxf59937
function fc_hpf = rxIFFilterTransferPlotter(dataDir,chirpSlopes,IFFreqSweep,FreqFFT,currentSystemSetting,measuredPower,PLossRX14)

% Scale for MHz
toMega = 1e6;

strxFullData = cell(1:length(chirpSlopes));

MaxCG   = zeros(length(chirpSlopes),length(IFFreqSweep));
MaxPout = zeros(length(chirpSlopes),length(IFFreqSweep));
Gain    = zeros(1,length(chirpSlopes));

% Check if the measured power is an scalar
if isscalar(measuredPower)
    measuredPowerVector = measuredPower.*ones(size(IFFreqSweep));
end

for selectedMesurement =1:length(chirpSlopes)

[strxReadData,~] = strxDataImporter(false,[dataDir chirpSlopes{selectedMesurement} '\'],IFFreqSweep);
strxFullData{selectedMesurement}.sweepDir = dataDir;
strxFullData{selectedMesurement}.sweep    = strxReadData;
fc_hpf      = zeros(size(chirpSlopes));

CG          = zeros(currentSystemSetting.samples/2,length(IFFreqSweep));
PoutdBvrms  = zeros(currentSystemSetting.samples/2,length(IFFreqSweep));

    for selectedFreqIF= 1: length(strxReadData)
        % call function to compensate coupler
        PinRX14=measuredPowerVector(selectedFreqIF)+couplerCompensation(currentSystemSetting.LOFreq);

        ADCCGDataArray=strxReadData{selectedFreqIF}.ADCCGDataArray;

        % Calculate the Conversion Gain
        [CG(:, selectedFreqIF), PoutdBvrms(:, selectedFreqIF)] = CGMeasSTRX(ADCCGDataArray, currentSystemSetting.ADCResolution, currentSystemSetting.ADCInputRange, ...
            PinRX14, PLossRX14, currentSystemSetting.samples, currentSystemSetting.CHIRPS, currentSystemSetting.RXChMeas);
        
        % Remove the very low frequency components from frequency array
        FreqFFTTruncated = FreqFFT(2:end);

        % Remove the very low frequency components from CG calculation
        CGTruncated = CG(2:end, selectedFreqIF);

        % Save the peaks in a separate CG matrix
        MaxCG(selectedMesurement, selectedFreqIF) = max(CGTruncated);

        % Save the peaks in a separate Pout matrix
        MaxPout(selectedMesurement, selectedFreqIF) = max(PoutdBvrms(4:end, selectedFreqIF));

    end
    % Estimated cut off frequency of HPF
    fc_hpf(selectedMesurement) = hpfGainEstmation(selectedMesurement,chirpSlopes{selectedMesurement},MaxCG,IFFreqSweep,Gain);

end

CGFrequencyPlt = figure('Name',['Gain_vs_IF_Frequency on ' dataDir]);

for selectedMesurement =1:length(chirpSlopes)
    % Plot the measured Gain of RX2 for all HPF settings
    sp(1) = subplot(2,1,1);grid on;hold on;
    myPlots(selectedMesurement) = plot(IFFreqSweep/toMega, MaxCG(selectedMesurement, :));
end
    myPlots(3) = plot(IFFreqSweep/toMega, currentSystemSetting.CGSetting*ones(size(IFFreqSweep)),'.-');
    hold off;

xlabel('IF Frequency (MHz)', 'Interpreter', 'latex', 'fontsize', 10);
ylabel('Conversion Gain (dB) ', 'Interpreter', 'latex', 'fontsize', 10);
title( [ 'Gain vs. IF Frequency with HPF:', num2str(currentSystemSetting.HPFSetting/1e3), 'KHz and LPF:', num2str(currentSystemSetting.LPFSetting/toMega), 'MHz@' num2str(currentSystemSetting.LOFreq/1e9) 'GHz'   ]);
l(1) =legend(sp(1),{append(currentSystemSetting.RXChMeas,chirpSlopes{1}), append(currentSystemSetting.RXChMeas,chirpSlopes{2}),['target Gain']}, 'location', 'best');


sp(2) = subplot(2,1,2);grid on;hold on;
    mp(1) = plot(IFFreqSweep/toMega, flip(MaxCG(1, :)),'Color',myPlots(1).Color);
    mp(2) = plot(IFFreqSweep/toMega, MaxCG(2, :),'Color',myPlots(2).Color);
    mp(3) = plot(IFFreqSweep/toMega, currentSystemSetting.CGSetting*ones(size(IFFreqSweep)),'.-','Color',myPlots(selectedMesurement+1).Color);
hold off;
xlabel('IF Frequency (MHz)', 'Interpreter', 'latex', 'fontsize', 10);
ylabel('Conversion Gain (dB) ', 'Interpreter', 'latex', 'fontsize', 10);
title( [ 'Gain vs. IF Frequency with HPF:', num2str(currentSystemSetting.HPFSetting/1e3), 'KHz and LPF:', num2str(currentSystemSetting.LPFSetting/toMega), 'MHz@' num2str(currentSystemSetting.LOFreq/1e9) 'GHz'  ]);
l(2) = legend(sp(2),{append(append(currentSystemSetting.RXChMeas,chirpSlopes{1}),' flipped'), append(currentSystemSetting.RXChMeas,chirpSlopes{2}),'target Gain'}, 'location', 'best');


%% Error calculatioin between chirp slope positive vs negative

absErr = log10(flip(MaxCG(1, :)) - MaxCG(2, :));
relErr = log10((flip(MaxCG(1, :)) - MaxCG(2, :))./ flip(MaxCG(1, :)));
idxHpf = find(IFFreqSweep==currentSystemSetting.HPFSetting);
idxLpf = find(IFFreqSweep==currentSystemSetting.LPFSetting);
idxDc = 
rmsAbsErr = rms(absErr(idxHpf:idxLpf));
rmsRelErr = rms(relErr(idxHpf:idxLpf));
titleString1 = ['G_{' char(currentSystemSetting.RXChMeas) ' rising flipped} - G_{' char(currentSystemSetting.RXChMeas) ' falling}'];
titleString2 = ['(' titleString1 ')/G_{' char(currentSystemSetting.RXChMeas) ' rising flipped} '];


ErrorPlt = figure('Name',['Gain_vs_IF_Frequency on ' dataDir]);

sp(3) = subplot(2,1,1);grid on;hold on;
    ePlot(1) = plot(IFFreqSweep(idxHpf:idxLpf)/toMega, absErr(idxHpf:idxLpf),'.-k');
    ylabel({'log10(Absolute Error) =';titleString1});
hold off;
title( [ titleString1 ' vs. IF Frequency,@' num2str(currentSystemSetting.LOFreq/1e9) 'GHz']);
l(3) = legend(sp(3),{['Absolute Error_{rms}:' num2str(rmsAbsErr)]}, 'location', 'best');
xlabel('IF Frequency (MHz)', 'Interpreter', 'latex', 'fontsize', 10);

sp(4) = subplot(2,1,2);grid on;hold on;
    ePlot(2) = plot(IFFreqSweep(idxHpf:idxLpf)/toMega, relErr(idxHpf:idxLpf),'.-k');
    ylabel({'log10(Relative Error) =';titleString2});
hold off;
title( [titleString2 'vs. IF Frequency,@' num2str(currentSystemSetting.LOFreq/1e9) 'GHz']);
l(4) = legend(sp(4),{['Relative Error_{rms}:' num2str(rmsRelErr)]}, 'location', 'best');
xlabel('IF Frequency (MHz)', 'Interpreter', 'latex', 'fontsize', 10);

%% Patch plotter

patchF = [currentSystemSetting.HPFSetting./toMega,currentSystemSetting.HPFSetting./toMega,currentSystemSetting.LPFSetting./toMega,currentSystemSetting.LPFSetting/toMega];
patchG = [currentSystemSetting.HPFSetting./toMega,currentSystemSetting.CGSetting, currentSystemSetting.CGSetting,currentSystemSetting.HPFSetting/toMega];
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

end



