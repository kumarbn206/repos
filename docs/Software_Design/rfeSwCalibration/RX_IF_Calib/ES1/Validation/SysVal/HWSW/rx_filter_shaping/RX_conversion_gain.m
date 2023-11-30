

currentSystemSetting.LOFreq= 76e9;
currentSystemSetting.FStart= 100e+3;
kT= physconst('Boltzmann') * (25 + 273.15);
currentSystemSetting.RXChMeas= "RX3 ";
currentSystemSetting.MeasTemp= "RT ";
currentSystemSetting.LPFSetting= "LPF 25 MHz ";
currentSystemSetting.CGSetting= "Gain 46 dB";

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
currentSystemSetting.sampleFreq= 40e6;
currentSystemSetting.CHIRPS = 16;
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

IFFreqSweep=IFFreqSweep1;

SGFreqSweep= currentSystemSetting.LOFreq + IFFreqSweep;



basepath = InputStruct.basepath; % this is the path the \Matlab folder
addpath(genpath(basepath));
addpath(InputStruct.Proxy_loc);

StartProxyRfe(InputStruct);
ResetRfe();
LoadFwRfe(InputStruct);
SyncRfe();
OutputStruct = GetVersionRfe(InputStruct);


%%
config_filenames{1}='C:\LocalData\Projects\STRX\tools\rfeConfigGenerator\release\rfeConfig.bin';
% config_filenames{2}='C:\STRX\RFE_Proxy\RFEProxy_V0_5_23_0_8_10_RC5\bin\rfe_m7Images_tools\tools\rfeConfigGenerator\release\rfeConfig_800KHz.bin';
InputStruct.dynamic_table_filename='';

figure(1)
count=0;
for jj= 1:length(config_filenames)

    InputStruct.config_filename=config_filenames{jj};
    
    [OutputStruct] = ConfigureRfe(InputStruct);
    DATA_ADDRESS = hex2dec('0x33C80000');
    PPEConfigRfe(DATA_ADDRESS);
    
    for ii= 1: length(IFFreqSweep)
        clkResetRfe(InputStruct);
        count=count+1;

        SGPowerLevel= -13.60; % in dBm
        SetSG(SGFreqSweep(ii),SigGenAddress, count,SGPowerLevel);
        pause(1);

        PowerValue= power_meter_value(SGFreqSweep(ii),Powermeter1_Address);

        if currentSystemSetting.LOFreq==76e9
            PinRX14=PowerValue(1)+.9; % compensating the 10dB coupler
        elseif currentSystemSetting.LOFreq==76.5e9
            PinRX14=PowerValue(1)+.9; % compensating the 10dB coupler
        elseif currentSystemSetting.LOFreq==77e9
            PinRX14=PowerValue(1)+1; % compensating the 10dB coupler
        end 

        ADCCGDataArray = [];


    

        InputStruct.num_of_radar_cycle=1;
        [OutputStruct] = RadarCycleStartRfe(InputStruct);
        clkResetRfe(InputStruct);
        data = readdata_HWSW(DATA_ADDRESS,currentSystemSetting);


%         [ error ] = rfeabstract.rfe_radarCycleStart( 1, 0, 0);
%         samplecount=currentSystemSetting.Ns*currentSystemSetting.NChirps;
%         startaddr=DATA_ADDRESS;
%         bytecount = samplecount * 4 * 2;
%         endaddr = startaddr + bytecount - 1;
% 
%         
% %         % readout binary sample data and write it to a file
% %         cmd = sprintf('Data.SAVE.Binary C:\\STRX\\temp\\out.bin SD:0x%08x--0x%08x', startaddr, endaddr);
% %         ll.t32_cmd(cmd);
% %         pause(3);
% 
%         f = fopen('C:\STRX\temp\out.bin');
%         data = fread(f, 'int16');
%         fclose(f);
%         data=double(data);
%         data = reshape(data, 4, samplecount)';

        
%         pause(2)    

        ADCCGDataArray=data;


        % Calculate the Conversion Gain
        [CG(:, ii), PoutdBvrms(:, ii)] = CGMeasSTRX(ADCCGDataArray, currentSystemSetting.ADCResolution, currentSystemSetting.ADCInputRange, ...
            PinRX14, PLossRX14, currentSystemSetting.samples, currentSystemSetting.CHIRPS, currentSystemSetting.RXChMeas);
        
        plot(CG);
        hold on;

        % Find the closest index to the desired minimum frequency
        ind = interp1(FreqFFT, 1:length(FreqFFT), IFFreqSweep(ii), 'nearest');

        % Remove the very low frequency components from frequency array
        FreqFFTTruncated = FreqFFT(ind:end);

        % Remove the very low frequency components from CG calculation
        CGTruncated = CG(ind:end, ii);

        % Save the peaks in a separate CG matrix
        MaxCG(jj, ii) = max(CGTruncated);

        % Save the peaks in a separate Pout matrix
        MaxPout(jj, ii) = max(PoutdBvrms(4:end, ii));
        ShutDownRFPower(SigGenAddress);

       


    end
end
hold off;
grid on;
axis tight;

Plot1Name = 'Gain_vs_IF_Frequency';
CGFrequencyPlt = figure(2);

% Plot the measured Gain of RX2 for all HPF settings
semilogx(IFFreqSweep/1e6, MaxCG(1, :));
hold on;
semilogx(IFFreqSweep/1e6, MaxCG(2, :));
hold off;
xlabel('IF Frequency (MHz)', 'Interpreter', 'latex', 'fontsize', 10);
ylabel('Conversion Gain (dB) ', 'Interpreter', 'latex', 'fontsize', 10);
title('Gain vs. IF Frequency', 'Interpreter', 'latex', 'fontweight', 'bold', 'fontsize', 11);
% subtitle(convertCharsToStrings(RXChMeas) + convertCharsToStrings(MeasTemp) + ...
%     convertCharsToStrings(LPFSetting) + convertCharsToStrings(CGSetting), ...
%     'Interpreter', 'latex', 'FontWeight', 'bold', 'FontSize', 10);
grid on;
legend('HPF 200 kHz', 'HPF 800 kHz', 'location', 'southeast', 'Interpreter', 'latex');
% axis(0 50);

