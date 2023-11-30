
%% Path Settings 
% InputStruct.basepath='';
% InputStruct.Proxy_loc='';
% InputStruct.CodeDataCheck='no';
% InputStruct.CODE_DATA_FILE_Path='';
% InputStruct.elfFileLoc='';
% InputStruct.elfFileName='';

%% xml file info for Michaels Script
% xml_folder = 'C:\\git\\mrta-tests-strx-sysval\\TestStand\\ConfigFiles\\';
% xml_file = 'base_rfeConfig_v0_8.xml'; 
% path_config_python_wrapper = "C:\git\mrta-tests-strx-sysval\TestStand\Common\Parameter2ConfigWrapper";

%% parameter for RX filter 
currentSystemSettings.LOFreq= 76.5;%provide val in GHz
currentSystemSettings.FStart= 5e+4;
kT                         = physconst('Boltzmann') * (25 + 273.15);
currentSystemSettings.RXChMeas = "RX2 ";
currentSystemSettings.MeasTemp = "RT ";
currentSystemSettings.LPFSetting = "LPF 25 MHz ";
currentSystemSettings.CGSetting  = "Gain 46 dB";

load WgLossesUncertainty.mat;
PLossRX1                   = WgLossesUncertainty{RX1PLossRow, RX1PLossCol};
PLossRX2                   = WgLossesUncertainty{RX2PLossRow, RX2PLossCol};
PLossRX3                   = WgLossesUncertainty{RX3PLossRow, RX3PLossCol};
PLossRX4                   = WgLossesUncertainty{RX4PLossRow, RX4PLossCol};

PLossRX14                  = [PLossRX1 PLossRX2 PLossRX3 PLossRX4];
[RX1PLossRow, RX1PLossCol] = PCBLossSel(currentSystemSettings.LOFreq, "TXRX1");
[RX2PLossRow, RX2PLossCol] = PCBLossSel(currentSystemSettings.LOFreq, "TXRX2");
[RX3PLossRow, RX3PLossCol] = PCBLossSel(currentSystemSettings.LOFreq, "TXRX3");
[RX4PLossRow, RX4PLossCol] = PCBLossSel(currentSystemSettings.LOFreq, "TXRX4");

currentSystemSettings.Ns                         = 4096;
currentSystemSettings.Fs                         = 40e6;
currentSystemSettings.NChirps                    = 16;
currentSystemSettings.NRXChannels                = 4;
currentSystemSettings.ADCInputRange              = 2.8;
currentSystemSettings.ADCResolution              = 16;
currentSystemSettings.N                          = currentSystemSettings.Ns*currentSystemSettings.NRXChannels*currentSystemSettings.NChirps;

TotalChirps = currentSystemSettings.NChirps;
FBin= currentSystemSettings.Fs/currentSystemSettings.N;
FreqFFT= [-currentSystemSettings.Fs/2:currentSystemSettings.Fs/currentSystemSettings.Ns:currentSystemSettings.Fs/2 -currentSystemSettings.Fs/currentSystemSettings.Ns];
FreqFFT= FreqFFT(1:currentSystemSettings.Ns);
FreqFFT= FreqFFT(currentSystemSettings.Ns/2 + 1:end);

IFFreqSweep1=currentSystemSettings.FStart:5e4:1e6;
IFFreqSweep2=1e6:0.5e6:25e6;

IFFreqSweep=[IFFreqSweep1,IFFreqSweep2];
SGFreqSweep= LOFreq + IFFreqSweep;

SigGenAddress='TCPIP::192.168.0.21::INSTR';
PowermeterAddress=23;
