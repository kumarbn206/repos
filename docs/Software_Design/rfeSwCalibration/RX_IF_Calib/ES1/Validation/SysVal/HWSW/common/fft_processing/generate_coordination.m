function [distance_gates,velocity_gates,frequency_gates] = generate_coordination(SampleFreq,SampleNum,ChirpNum,Freq_Center,tChirp,fSlope)
% This function generate distance, velocity and frequency
% coordinations for ploting
% Input: SampleFreq, (ADC) sample frequency in Hz
% Input: SampleNum, Sample per chirp after decimation
% Input: ChirpNum, Chirp number per sequence
% Input: Freq_Center, center frequency of the chirp in Hz
% Input: tChirp, Chirp duration in us
% Input: fSlope, Chirp aquisition slope in Hz/s

% Output: distance_gates, vector of distance coordination
% Output: velocity_gates, vector of velocity coordination
% Output: frequency_gates, vector of frequency coordination

%light Speed
c = 299792458;
Freq_Center=Freq_Center;



distance_gates = c * SampleFreq / 2 / fSlope / 2 * (0:SampleNum / 2 - 1) / (SampleNum / 2); %m
velocity_gates = c / (double(Freq_Center) * 2 * double(tChirp)) * ((-ChirpNum/ 2:ChirpNum / 2 - 1) / ChirpNum); %m/s  
frequency_gates = (1:SampleNum/2)* (SampleFreq/SampleNum) ;
end


