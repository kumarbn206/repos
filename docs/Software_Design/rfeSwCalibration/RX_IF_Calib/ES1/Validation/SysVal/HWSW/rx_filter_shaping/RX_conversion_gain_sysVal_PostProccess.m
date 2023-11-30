%% house keeping
% close all;
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

if currentSystemSetting.HPFSetting == 200000
    IFFreqSweep1=currentSystemSetting.FStart:10e3:300e3;
    IFFreqSweep2=500e3:500e3:17e6;
    IFFreqSweep3=17.1e6:100e3:25e6;

    IFFreqSweep=[IFFreqSweep1,IFFreqSweep2,IFFreqSweep3];

    IFFreqSweep = [ -flip(IFFreqSweep)  IFFreqSweep];
    
elseif currentSystemSetting.HPFSetting == 800000
    IFFreqSweep1=currentSystemSetting.FStart:100e3:600e3;

    IFFreqSweep2=610e3:10e3:1e6;
    
    IFFreqSweep3=1.5e6:0.5e6:17e6;
    
    IFFreqSweep4=17.1e6:100e3:25e6;

    IFFreqSweep=[IFFreqSweep1,IFFreqSweep2,IFFreqSweep3,IFFreqSweep4];

    IFFreqSweep = [ -flip(IFFreqSweep)  IFFreqSweep];
else

    IFFreqSweep1=currentSystemSetting.FStart:20e3:1e6;
    IFFreqSweep2=1.5e6:0.5e6:25e6;

    IFFreqSweep=[-flip(IFFreqSweep2) -flip(IFFreqSweep1) IFFreqSweep1 IFFreqSweep2];

end

SGFreqSweep= currentSystemSetting.LOFreq + IFFreqSweep;


basepath = InputStruct.basepath; % this is the path the \Matlab folder
addpath(genpath(basepath));
% addpath(InputStruct.Proxy_loc);

PinRX14 = -38.02;
% PinRX14 = -13.6;
%% Call function to plot
rxIFFilterTransferPlotter(dataDir,measurements,IFFreqSweep,FreqFFT,currentSystemSetting,PinRX14,PLossRX14);
