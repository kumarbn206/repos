

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

IFFreqSweep=[IFFreqSweep1 IFFreqSweep2] ;

SGFreqSweep= currentSystemSetting.LOFreq + IFFreqSweep;


%% Load RFE SW into M7
basepath = InputStruct.basepath; % this is the path the \Matlab folder
addpath(genpath(basepath));
addpath(InputStruct.Proxy_loc);

StartProxyRfe(InputStruct);
ResetRfe();
LoadFwRfe(InputStruct);
SyncRfe();
OutputStruct = GetVersionRfe(InputStruct);


%%
InputStruct.dynamic_table_filename='';

strxReadData = cell(size(IFFreqSweep));

figure(1)
count=0;
for jj= 1:length(config_filenames)

    InputStruct.config_filename=config_filenames{jj};
    
    [OutputStruct] = ConfigureRfe(InputStruct);
    DATA_ADDRESS = hex2dec('0x33C80000');
    PPEConfigRfe(DATA_ADDRESS);
    
    for ii= 1: length(IFFreqSweep)
        disp([ 'Injecting IF tone at ' num2str(SGFreqSweep(ii)) '[KHz],test completion-> ' num2str(int8((ii/length(SGFreqSweep))*100)) '%' ])
        clkResetRfe(InputStruct);
        count=count+1;
        
        SGPowerLevel = [];
        if usePowerMeter
            SGPowerLevel= -13.60; % in dBm
            PowerValue= -40%power_meter_value(SGFreqSweep(ii),Powermeter1_Address);
        else
            Pin = 5.88; %[dBm]
            Attenuator = -50;%[dB]
            PowerValue = powerEstimation(Pin,Attenuator);
        end

        if currentSystemSetting.LOFreq==76e9
            PinRX14=PowerValue(1)+.9; % compensating the 10dB coupler
        elseif currentSystemSetting.LOFreq==76.5e9
            PinRX14=PowerValue(1)+.9; % compensating the 10dB coupler
        elseif currentSystemSetting.LOFreq==77e9
            PinRX14=PowerValue(1)+1; % compensating the 10dB coupler
        end
        SetSGv2(SGFreqSweep(ii),SigGenAddress, count,SGPowerLevel,'On');
        pause(1);

        ADCCGDataArray = [];


        InputStruct.num_of_radar_cycle=1;
        [OutputStruct] = RadarCycleStartRfe(InputStruct);
        clkResetRfe(InputStruct);
        data = readdata_HWSW(DATA_ADDRESS,currentSystemSetting,[basePath 'out.bin']);

        ADCCGDataArray=data;
        strxReadData{ii}.data = data;
        strxReadData{ii}.frequency = [num2str(IFFreqSweep(ii)) 'Hz'];

        % Calculate the Conversion Gain
        [CG(:, ii), PoutdBvrms(:, ii)] = CGMeasSTRX(ADCCGDataArray, currentSystemSetting.ADCResolution, currentSystemSetting.ADCInputRange, ...
            PinRX14, PLossRX14, currentSystemSetting.samples, currentSystemSetting.CHIRPS, currentSystemSetting.RXChMeas);
        
        plot(CG);
        hold on;

        % Find the closest index to the desired minimum frequency
        ind = interp1(FreqFFT, 1:length(FreqFFT), IFFreqSweep(ii), 'nearest');
        if isnan(ind)
           ind = interp1(FreqFFT, 1:length(FreqFFT), IFFreqSweep(ii), 'nearest','extrap');
        end
        
        % Remove the very low frequency components from frequency array
        FreqFFTTruncated = FreqFFT(ind:end);

        % Remove the very low frequency components from CG calculation
        CGTruncated = CG(ind:end, ii);

        % Save the peaks in a separate CG matrix
        MaxCG(jj, ii) = max(CGTruncated);

        % Save the peaks in a separate Pout matrix
        MaxPout(jj, ii) = max(PoutdBvrms(4:end, ii));
        % Power off RF signal
        SetSGv2(SGFreqSweep(ii),SigGenAddress, count,SGPowerLevel,'Off');

       if(mod(count,5) == 0)
           % to convert back the datenum(datetime) do -> datestr(datenum(datetime))
           save([ basePath 'strx_7319_RX_IF_v2_filterResponse' num2str(datenum(datetime)) '.mat'],'strxReadData');
       elseif(count == length(IFFreqSweep))
           save([InputStruct.elfFileLoc '\strx_7319_RX_IF_v2_filterResponse_' measurements '_' num2str(datenum(datetime)) '_SHA_' gitSHA '.mat'],'strxReadData');
       end


    end
end
hold off;
grid on;
axis tight;

Plot1Name = 'Gain_vs_IF_Frequency';

