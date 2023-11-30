%% House keeping
clear all;
clc;
close all;

%% Parameters
Fs = 40e6;

scaleMHz = 1e6;

% number of samples
Nfft = 512;
% mode 
mode = [3,3,2];

% Select y-axis (magnitude of FFT) in dB or in linear 
magnitudeIndB = false;

% Select the user to adtap the path to the data ['MG','JCL']
user = 'JCL'

% Select wheter we are calibrating LPF or not
calibrateLPF = true

if(calibrateLPF)
Fs = 80e6;
f1 = 7500000;
f2 = 2656250;
f1Code = f1 / 80e6 * 2^16;
f2Code = f2 / 80e6 * 2^16;
else
f1 = 78125;
f2 = 39843752;
f1Code = f1 / 80e6 * 2^16;
f2Code = f2 / 80e6 * 2^16;
end
Fcode = [f1Code,f2Code]% 8200; 
%% Import data
% File name of the data

if strcmp(user,'MG')
    dataNamePrefix =  'mem';
    dataNameFFTPrefix =  'fft';
    dataNameLocation =  'Z:\STRX\';
else
    dataNamePrefix = 'memoryDumpInput'
    dataNameFFTPrefix = 'memoryDumpFFT' 
    dataNameLocation = '\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-4294\'

    if(calibrateLPF)
        dataNamePrefix = insertAfter(dataNamePrefix,"Dump","Lpf");
        dataNameFFTPrefix = insertAfter(dataNameFFTPrefix,"Dump","Lpf");
    end

end


rxIfCalibDataMod{1} = importAllData(dataNamePrefix,dataNameFFTPrefix,dataNameLocation,Nfft,mode(1));
rxIfCalibDataMod{2} = importAllData(dataNamePrefix,dataNameFFTPrefix,dataNameLocation,Nfft,mode(2));
rxIfCalibDataMod{3} = importAllData(dataNamePrefix,dataNameFFTPrefix,dataNameLocation,Nfft,mode(3));


for rxModeMesurement=1:length(rxIfCalibDataMod)

    rxIfCalibData.input = rxIfCalibDataMod{rxModeMesurement}.input;
    rxIfCalibData.FFTSingle  = rxIfCalibDataMod{rxModeMesurement}.FFTSingle;
    rxIfCalibData.FFTFull = rxIfCalibDataMod{rxModeMesurement}.FFTFull;
    rxIfCalibData.filename = rxIfCalibDataMod{rxModeMesurement}.filename


%% Operationms 

L = length(rxIfCalibData.input);

% Matlab FFT calculation
% Frequency axis
n = 2^nextpow2(L);
f = (Fs*(0:(n-1)))/n;

% Full FFT of input
X = fft(rxIfCalibData.input')/n;
% Magnitude of full input FFT
targetFFTXMag = abs(X);
targetFFTXPhase = angle(X);
% Full FFT Magnitude in [dB]
targetFFTXmag_dB = 20*log10(targetFFTXMag);

% Single side FFT 
targetFFTXmagSingle = targetFFTXMag(1:L/2);
targetFFTXPhaseSingle = targetFFTXPhase(1:L/2);
% Single side FFT DC
targetFFTXmagSingle(2:end-1) = targetFFTXmagSingle(2:end-1);
% Single side FFT frequency
fsingle = f(1:Nfft/2);
% Single side FFT Magnitude in [dB]
targetFFTXmagSingle_dB = 20*log10(targetFFTXmagSingle);

% M7 FFT calculation
m7FFTMagFull = abs(rxIfCalibData.FFTFull)';
m7FFTPhaseFull = angle(rxIfCalibData.FFTFull);
m7FFTMagFull_dB = 20*log10(m7FFTMagFull/2^16);

m7FFTMagSingle = abs(rxIfCalibData.FFTSingle)';
m7FFTPhaseSingle = angle(rxIfCalibData.FFTSingle);
m7FFTMagSingle_dB = 20*log10(m7FFTMagSingle/2^16);

% Calculation of ftones
ftone=rfeBistCodeToF(Fcode);
%% Plots

myLegend = {'target-FFT','M7-FFT','expected ftone '};
if magnitudeIndB
    targetFFTMag = targetFFTXmag_dB;
    m7FFTMag = m7FFTMagFull_dB;

    targetFFTMagSingle = targetFFTXmagSingle_dB;
    m7FftMagSingle =  m7FFTMagSingle_dB;

    myYlabel = '|X(f)|[dB]';
else
    targetFFTMag = targetFFTXMag;
    m7FFTMag = m7FFTMagFull;

    targetFFTMagSingle = targetFFTXmagSingle;
    m7FftMagSingle =  m7FFTMagSingle;

    myYlabel = '|X(f)|';
end

%%
% h = figure;
% plot(rxIfCalibData.input);
% savefig(h, strcat(['C:\Users\nxf09622\Desktop\rxIfCalibSim\' dataname '.fig']));
% saveas(h, strcat(['C:\Users\nxf09622\Desktop\rxIfCalibSim\' dataname '.png']));
% close(h)
% h = figure;
% plot(fsingle./scaleMHz,m7FftMagSingle);
% savefig(h, strcat(['C:\Users\nxf09622\Desktop\rxIfCalibSim\' dataname '.fig']));
% saveas(h, strcat(['C:\Users\nxf09622\Desktop\rxIfCalibSim\' dataname '.png']));
% close(h)

%%
figure('Name',['Comparison FFT M7 vs Matlab for ' replace(['Input signal ' rxIfCalibData.filename],'_',' ')]);
s(1) = subplot(3,1,1);grid on; hold on;
    p(1) = plot(0:L-1,rxIfCalibData.input,'.-');
    ylabel('x[n]');xlabel('samples [n]');
    legend({'input signal'},'Location','Best');
    title(replace(['Input signal ' rxIfCalibData.filename],'_',' '));
    hold off;
s(2) = subplot(3,1,2);grid on; hold on;
    p(2) = plot(fsingle./scaleMHz,targetFFTMagSingle,'+-','MarkerSize',5,'Color',[0.8500, 0.3250, 0.0980]);
    p(3) = plot(fsingle./scaleMHz,m7FftMagSingle,'.--','Color',[0, 0.4470, 0.7410]);
    scatter(ftone/scaleMHz,zeros(size(ftone)),'magenta','filled');
    ylabel(myYlabel);xlabel('f[MHz]')
    legend(myLegend,'Location','northeast');
    title('Single side FFT input signal Matlab vs M7');
    hold off; 
%     p(2) = plot(f./scaleMHz,fftshift(targetFFTMag),'+-','MarkerSize',5,'Color',	[0.8500, 0.3250, 0.0980]);
%     p(3) = plot(f./scaleMHz,[0 m7FFTMag(1:end-1)],'.--','Color',[0, 0.4470, 0.7410]);
%     scatter((ftone+Fs/2)/scaleMHz,zeros(size(ftone)),'magenta','filled');
%     ylabel(myYlabel);xlabel('f[MHz]')
%     legend(myLegend,'Location','northeast');
%     title('Full FFT input signal Matlab vs M7');
%     hold off;
s(3) = subplot(3,1,3);grid on; hold on;   
    p(4) = plot(fsingle./scaleMHz,targetFFTXPhaseSingle,'+-','MarkerSize',5,'Color',p(2).Color);
    p(5) = plot(fsingle./scaleMHz,m7FFTPhaseSingle,'.--','Color',p(3).Color);
    scatter(ftone/scaleMHz,zeros(size(ftone)),'magenta','filled');
    ylabel('phase[rad]');xlabel('f[MHz]')
    legend(myLegend,'Location','northeast');
    title('Single side FFT input signal Matlab vs M7');
    hold off; 

% linkaxes(s(2:3),'x');

% Check the collected data
% myPlotter(rxIfCalibData.input,Fs,Fcode,rxIfCalibData.filename);

end
%% Functions

function rxIfCalibData = importAllData(dataNamePrefix,dataNameFFTPrefix,dataNameLocation,Nfft,mode)

dataname = strcat([dataNamePrefix num2str(Nfft) '_mode' num2str(mode)]);
datanameFFT = strcat([dataNameFFTPrefix num2str(Nfft) '_mode' num2str(mode)]);

filename = strcat([dataname '.txt']);
fileNameFFT = strcat([datanameFFT '.txt']);
filenamePathInput = [dataNameLocation filename ];
filenamePathFFT = [dataNameLocation fileNameFFT ];

rxIfCalibData.filename = filename;
rxIfCalibData.fileNameFFT = fileNameFFT;
rxIfCalibData.filenamePathInput = filenamePathInput;
rxIfCalibData.filenamePathFFT = filenamePathFFT;


% Import memory dump of input from Eclipse
memoryDump = importfileFromInput(filenamePathInput);
% Swap bytes from ARM and cast to right integer from input
rxIfCalibData.input = swapAndCastInput(memoryDump);

% Import memory dump from Eclipse
memoryDumpFFT = importfileFromFFT(filenamePathFFT);
[rxIfCalibData.FFTSingle,rxIfCalibData.FFTFull]  = swapAndCastFFT(memoryDumpFFT,Nfft);

end

function inputSignal = swapAndCastInput(memoryDump)
% col = 32;
% row = 32;
% mem_dump = zeros(col*row/2,1);
% arr = reshape(memoryDumpSinWave',[col*row,1]);
% for i = 1:length(mem_dump)
% idx = (i - 1) * 2 + 1;
% mem_dump(i) = hex2dec(arr(idx)) + 256*hex2dec(arr(idx + 1));
% end
% neg_idx = mem_dump > 2^15-1;
% mem_dump(neg_idx) = -1*(2^16 - mem_dump(neg_idx));

    % Get even columns with MSB
    evenIndx = memoryDump(:,2:2:end);
    % Get odd colums with LSB
    oddIndx = memoryDump(:,1:2:end);
    % Swap ARM format big endian to little endian into new matrix
    swappedMemoryDumpSinWave = strcat(evenIndx,oddIndx);
    % Get size of matrix
    [row,col] = size(swappedMemoryDumpSinWave);
    % Convert matrix into an hex array
    hexArray = reshape(swappedMemoryDumpSinWave',[row*col,1]);
    % Convert hex array to decimal array but it will be uint16 and we want
    % signed data
    intArray = hex2dec(hexArray);
    % Get values that are signed and convert them to int16
    neg_idx = intArray > 2^15-1;
    intArray(neg_idx) = -1*(2^16 - intArray(neg_idx));
    inputSignal = intArray;
end

function [fftM7Single,fftM7Full] = swapAndCastFFT(memoryDumpFFT,Nfft)

% Get even columns with MSB
evenIndx = memoryDumpFFT(:,2:2:end);
% Get odd colums with LSB
oddIndx = memoryDumpFFT(:,1:2:end);
% Swap ARM format big endian to little endian into new matrix
swappedMemoryDumpFFT = strcat(evenIndx,oddIndx);
evenIndx = swappedMemoryDumpFFT(:,2:2:end);
oddIndx = swappedMemoryDumpFFT(:,1:2:end);
swappedMemoryDumpFFT = strcat(evenIndx,oddIndx);

% Get size of matrix
[row,col] = size(swappedMemoryDumpFFT);
% Convert matrix into an hex array
hexArray = reshape(swappedMemoryDumpFFT',[row*col,1]);
% Convert hex to float via matlab directly
intArray = typecast(hex2num(hexArray(1:Nfft)),'single');
intArray= intArray(2:2:end);
% Real part of fft m7 is on odd samples
fftM7.real = intArray(1:2:end);
% Imag part of fft m7 is on enven samples
fftM7.imag = intArray(2:2:end);

% Following Hong's comments in his fft implementation we need to remove the
% fftSize/2 from the values...
%  2. To save memory, result bin fftSize/2 is stored in the imaginary of bin 0 in pHalf. 
%  Full FFT spectrum pFreq can be reconstructed by the following:
%  pFreq[0].re           = pHalf[0].re;              pFreq[0].im           = 0;
%  pFreq[1].re           = pHalf[1].re;              pFreq[1].im           = pHalf[1].im;
% ...
%  pFreq[fftSize/2-1].re = pHalf[fftSize/2-1].re;    pFreq[fftSize/2-1].im = pHalf[fftSize/2-1].im;
%  pFreq[fftSize/2].re   = pHalf[0].im;              pFreq[fftSize/2].im   = 0;
%  pFreq[fftSize/2+1].re = pHalf[fftSize/2-1].re;    pFreq[fftSize/2+1].im = -pHalf[fftSize/2-1].im;
%  pFreq[fftSize/2+2].re = pHalf[fftSize/2-2].re;    pFreq[fftSize/2+2].im = -pHalf[fftSize/2-2].im;
%  pFreq[fftSize-1].re   = pHalf[1].re;              pFreq[fftSize-1].im   = -pHalf[1].im;
fftM7.imag(1) = 0;
fftM7.imag(Nfft/2) = 0;

% FFT as complex value
fftM7Single = fftM7.real+1j.*fftM7.imag;
%% Full FFT calculation
fftM7Full = zeros(Nfft,1);
% f < 0 -> applying FFT symmetry property for real signals : X(w) = X*(-w)
fftM7Full(1:Nfft/2-1) = flip(conj(fftM7Single(2:Nfft/2)));
% f == 0
fftM7Full(Nfft/2) = conj(fftM7Single(Nfft/2)) + fftM7Single(1);
% f > 0
fftM7Full(Nfft/2+1:end-1) = fftM7Single(2:end);
end

function myPlotter(x,Fs,fcode,filename)

    scaleMHz = 1e6;
    ftone=rfeBistCodeToF(fcode);
    L = length(x);

    n = 2^nextpow2(L);
    f = (Fs*(0:(n-1)))/n;
    X = fft(x)/n;
    Xmag = abs(X);

    XmagSingle = Xmag(1:L/2+1);
    XmagSingle(2:end-1) = 2*XmagSingle(2:end-1);
    fsingle = Fs*(0:(L/2))/L;

    fshift = (-n/2:n/2-1)*(Fs/n);
    Xshift = fftshift(X);
    Xmagshift = abs(Xshift);

    figure('Name',filename);
    sp(1)=subplot(3,1,1);
        plot(1:length(x),x);grid on;
        xlabel('samples');ylabel('Amplitude');
        title('x(t)');
    sp(2)=subplot(3,1,2);grid on; hold on;
%         p(1) = plot(f/scaleMHz,Xmag,'.-');
        mp(1) = plot(fsingle/scaleMHz,XmagSingle,'.-');
        scatter(ftone/scaleMHz,zeros(size(ftone)),'magenta','filled');
        xlabel('f[MHz]');ylabel('|X(f)|');
        title(['X(f), Single side Spectrum of x(t)@Fs=' num2str(Fs/scaleMHz) '[MHz]']);
        legend({'X(f)','expected ftone '});
        hold off;
    sp(3)=subplot(3,1,3);grid on; hold on;
        mp(3) = plot(fshift/scaleMHz,Xmagshift,'.-');
        scatter(ftone/scaleMHz,zeros(size(ftone)),'magenta','filled');
        xlabel('f[MHz]');ylabel('|X(f)|');
        title(['X(f), Centered Spectrum of x(t)@Fs=' num2str(Fs/scaleMHz) '[MHz]']);
        legend({'centered X(f)','expected ftone '});
        hold off;        
end
function f = rfeBistCodeToF(code)
    fo = 80e6;
    N = 16;
    f = (code ./2^N) .* fo;
end
