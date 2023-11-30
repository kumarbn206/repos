function [CGRX, PoutRX] = CGMeasSTRX(ADCCGDataArray, ADCResolution, ADCInputRange, PinRX14, ...
                                   PLossRX14, Ns, NChirps, RXChMeas)
% Function to measure the Conversion Gain based on ADC Raw Data for each channel
% ADCCGDataArray    - Recorded ADC Raw Data 
% PinRX14           - Input power levels at the measured RX channel
% PLossRX14         - Losses at the measured RX channel
% Ns                - Number of Samples
% NChirps           - Number of Chirps 
% N                 - Number of FFT points
% FreqFFT           - Defines the discrete frequency after FFT

%% Break-down the ADC Data array into separate RX channels and separate chirps. For each chirp, there are Ns samples

% Select the RX Channel under measurement
RXChSel = RXSel(RXChMeas);

% Initialize a control variable n
n = 0;

% Using the for loop, break-down the ADC Data array into separate RX channels and separate chirps
for k = 1:NChirps

    % Channelization of raw Data 
    RXADC(:, k) = ADCCGDataArray(n+1:n+Ns, RXChSel);

    % Increase the control variable n at each loop with the number of samples
    % per chirp in order to define a new column for the RX ADC raw Data
    n=n+Ns;
                                              
end

% Transpose the array to match the window 
RXADC = RXADC.';

% Define a Flattop window with the size of the number of samples 
FlatTopWin = flattopwin(Ns).';
FlatTopWin = FlatTopWin/mean(FlatTopWin);          

% Organize the window in individual chirps
FlatTopWin = repmat(FlatTopWin, NChirps, 1);

% First, convert the ADC Data to a voltage and eliminate the DC offset
RXData = (RXADC * ADCInputRange)/2^ADCResolution;

% Perform FFT and averaging
RXDataFFT = fftshift(fft((RXData.*FlatTopWin).', Ns))/(Ns);

% Root mean square averaging over the entire number of chirps
RX1DataAv = sqrt(mean(abs(RXDataFFT).^2, 2));

% Convert RX data to power 
PowerRXdBvrms = abs(RX1DataAv(Ns/2+1:end)).^2;
PowerRXdBvrms = 10*log10([PowerRXdBvrms(1); 2*PowerRXdBvrms(2:end)]);

% Propagate the noise floor to the output
PoutRX = PowerRXdBvrms;

% Convert power units to dBvrms
PinRX14dBvrms = PinRX14 - PLossRX14(RXChSel) - 13;

% Conversion from dBV to dBm
CGRX = PoutRX - PinRX14dBvrms;

end