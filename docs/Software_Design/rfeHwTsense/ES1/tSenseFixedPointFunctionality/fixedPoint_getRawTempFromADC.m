%% House keeping
clear;
clc;
% close all;
%% Input Values

% ADC word width
N = 15;

% Internal gain stage of the ADC
Nadc = 6.0;

% ADC output range. To generate random values of adcOut, define the vector
% as empty
adcOut_hex{1} = '30db'
adcOut_hex{2} = '26b5'
%adcOut_hex = '';
if(isempty(adcOut_hex))
    adcOut = 0.283 
    adcOut = 0:1./2^(N):1 
else
    adcOut = hex2dec(adcOut_hex)/2^15
end

% Represent the temperature as an int16 as in register map or value shown
% by rfeHwTsense_getRawTempFromADC or rfeHwTsense_getTemperature
encodedIntoInt = ~true;

% valA value from register map
valA_hex = 'a57a'
valA = hex2dec(valA_hex)/2^6
% valB value  from register map
valB_hex = 'ba0d'
valB = (hex2dec(valB_hex)-2^16)/2^6
% valAlpha value  from register map
valAlpha_hex = '6d48'
valAlpha = hex2dec(valAlpha_hex)/2^11
% valXoffset value  from register map
valXoffset_hex = '0000'
valXoffset= hex2dec(valXoffset_hex)/2^11

%% Fixed point variables as in register map
% Define the usage of fixed point format aritmetic operation
F = fimath('SumMode', 'SpecifyPrecision','RoundingMethod','floor', 'SumWordLength', 16,'SumFractionLength', 6,'OverflowAction','wrap');

% ADC out is unsigned Q15 
adcOutQ15   = fi(0,0,16,15);
if(~isempty(adcOut_hex) && ~iscell(adcOut_hex))
    adcOutQ15.hex = adcOut_hex
else
    adcOutQ15   = fi(adcOut,0,16,15);
end

% valA is unsigned Q16
valAQ6     = fi(0,0,16,6);
valAQ6.hex = valA_hex;

% valB is signed Q16
valBSQ6     = fi(0,1,16,6);
valBSQ6.hex = valB_hex

% valAlpha is unsinged Q11
valAlphaQ11 = fi(0,0,16,11);
valAlphaQ11.hex = valAlpha_hex

% valXoffset is signed Q11
valXoffsetSQ11 =  fi(0,1,16,11);
valXoffsetSQ11.hex = valXoffset_hex

%% Fixed point object in SQ6 as required for calculation

% Nadc devised with Q21 to avoid fixed point rounding issues we use as word
% uint32_t make sure the codes does too!
NadcQ21 = fi(Nadc,0,32,21,F);

% valAlpha as SQ6
valAlphaSQ6 = fi(valAlphaQ11,1,16,6)

% adcOut as SQ6
adcOutSQ6 = fi(adcOutQ15,1,16,6)

% valXoffset as SQ6
valXoffsetSQ6 = fi(valXoffsetSQ11,1,16,6)

%% Floating point calculations
% Applying Trimming equation in section 11.3 Trimming Equations of temperature sensor documentation C028HPCP_TDC1DG10K
% C028HPCP High Accuracy Temperature-to-Digital Converter Rev. 1.4, 14 October 2020

% xOut calculation
% xOut = Nadc ./ adcOutSQ6
xOut = Nadc ./ adcOut 

% Denominator of equation
denominatorFloat = valAlpha + xOut - valXoffset

% Numerator of equation
numeratorFloat =  valA * valAlpha

% Complete fraction for equation
fractionFloat = numeratorFloat ./ denominatorFloat

% Calculated trimmed temperature
tTrimFloat = fractionFloat + valB

%% Fixed point aritmetics
% Applying Trimming equation in section 11.3 Trimming Equations of temperature sensor documentation C028HPCP_TDC1DG10K
% C028HPCP High Accuracy Temperature-to-Digital Converter Rev. 1.4, 14 October 2020
% Ttrimmed = valA * (valAlpha / ( valAlpha + xout -valOffset ) ) + valB
% But now we try to work with SQ6 as is how the result is given in HW

% Xout
    % xOut calculation in fixed point SQ6 this will be NadcQ21[Q21] / adcOutQ15[Q15] = Q6 but using
    % 32word
    xOutSQ32 = NadcQ21 ./ adcOutQ15
    % We explicitely cast tTrimSQ6sum[SQ6] into an int16 because this will be
    % done too on code and we want to ensure same result after casting
    xOutSQ6 = fi(xOutSQ32,1,16,6,F)

% Denominator operations
    % Denominator of main equation as result of fixed point operations 
    % using denominator[SQ6] = valAlphaSQ6[SQ6] + xOutSQ6[Q6] - valXoffsetSQ6[SQ6]
    denominator = valAlphaSQ6 + xOutSQ6 - valXoffsetSQ6

    % Denominator of main equation, denominator, converted to SQ6 explicitely
    % to control the fractional bits during operation
    denominatorSQ6 = fi(denominator,1,16,6,F)

% Numerator operations
    % Numerator of main equation as result of fixed point operations using
    % numeratorQ17[Q17] = numeratorQ17[Q6] + valAlphaQ11[Q11]
    numeratorQ17 = valAQ6 * valAlphaQ11

    % Numerator of main equiation,numeratorQ17, conversted to SQ12. 
    % Notice that we use 32 bits now since, we will need a cast in the m7
    numeratorSQ12 = fi(numeratorQ17,1,32,12,F)

% Fraction
    % Fraction complete of main equation as result of fixed point operations 
    % using  fractionSQ6[SQ6] = numeratorSQ12[SQ12] - denominatorSQ6[SQ6]
    fractionSQ6 = numeratorSQ12 ./ denominatorSQ6

% Trimmed Temperature
    % Result of trimmed temperature as result of fixed point
    % operations using  tTrimSQ6[SQ6] = fractionSQ6[SQ6]  + valBSQ6[SQ6]
    tTrimSQ6sum = fractionSQ6  + valBSQ6

    % We explicitely cast tTrimSQ6sum[SQ6] into an int16 because this will be
    % done too on code and we want to ensure same result after casting
    tTrimSQ6 = fi(tTrimSQ6sum,1,16,6,F)


%% Errors

absError = abs( tTrimFloat - tTrimSQ6 );
relError = (absError ./ tTrimSQ6) * 100;
absErrorRms = rms(double(absError));
relErrorRms = rms(double(relError));


%% Conversions
% Convert the trimmed temperature in float and fixed point to int16 to
% compare to implementation
if encodedIntoInt
    tTrimSQ6AsInt   = str2num(tTrimSQ6.dec);
    tTrimFloaAsInt  = tTrimFloat * 2^(tTrimSQ6.FractionLength);
    % If temperature is negative we need complemnt 2 of that
    tTrimFloaAsInt(tTrimFloaAsInt < 0) = tTrimFloaAsInt(tTrimFloaAsInt < 0) + 2^tTrimSQ6.WordLength;
    absErrorAsInt   = absError;
    relErrorAsInt   = relError;
    absErrorRmsAsInt = absErrorRms;
    relErrorRmsAsInt = relErrorRms;
else
    tTrimSQ6AsInt   = tTrimSQ6;
    tTrimFloaAsInt = tTrimFloat;
    absErrorAsInt   = absError;
    relErrorAsInt   = relError;
    absErrorRmsAsInt = absErrorRms;
    relErrorRmsAsInt = relErrorRms;
end

%% Plotting

% Adjust legend and title
if encodedIntoInt
    myTitle = 'Integer representation of '
    myLegend = ' as int16'
else
    myTitle  = '';
    myLegend = '';
end

figure();
s(1)= subplot(4,1,1);hold on;grid on;
        plot(adcOut,tTrimFloaAsInt,'o-','MarkerSize',2);
        plot(adcOut,tTrimSQ6AsInt,'o-','MarkerSize',2);
        legend(s(1),{'Float','SQ6'},'location','best');
        title([myTitle 'tTrim Float vs SQ6']);
        ylabel(['tTrim value' myLegend]);xlabel('adcOut');
        hold off;
    
s(2)= subplot(4,1,2);hold on;grid on;
        plot(tTrimFloat,absErrorAsInt,'o-','MarkerSize',2);
        legend(s(2),{['absError_{rms}:' num2str(absErrorRmsAsInt) ]},'location','best');
        title([ myTitle 'Abs error, |Float - SQ6|']);
        ylabel(['|Abs Error|' myLegend]);xlabel('tTrimFloat');
        hold off;
s(3)= subplot(4,1,3);hold on;grid on;
        plot(adcOut,denominatorFloat,'o-','MarkerSize',2);
        plot(adcOut,denominatorSQ6,'o-','MarkerSize',2);
        errorbar(adcOut,denominatorFloat,abs( double(denominatorFloat) - double(denominatorSQ6)));
        legend(s(3),{'Float','SQ6','absError'},'location','best');
        title('denominator Float vs SQ6');
        ylabel('denominator value');xlabel('adcOut');
        hold off;     
s(4)= subplot(4,1,4);hold on;grid on;
        plot(adcOut,fractionFloat,'o-','MarkerSize',2);
        plot(adcOut,fractionSQ6,'o-','MarkerSize',2);
        errorbar(adcOut,fractionFloat,( fractionFloat - fractionSQ6 ));
        legend(s(4),{'Float','SQ6','absError'},'location','best');
        title('fraction Float vs SQ6');
        ylabel('fraction value');xlabel('adcOut');
        hold off;             
%% Linking plots
xMin = -51.0044922941534;
xMax = 150;
xlim(s(2),[xMin,xMax])
xlim([s(1),s(3),s(4)],[Ttrim2AdcOut(xMin,valA,valB,valAlpha,valXoffset,Nadc) Ttrim2AdcOut(xMax,valA,valB,valAlpha,valXoffset,Nadc) ]);
linkaxes([s(1),s(3),s(4)],'x');

%% Functions
% Inverse conversion

function ADCin = Ttrim2AdcOut(Ttrim,valA,valB,valAlpha,valXoffset,Nadc)

    den = (valA * valAlpha) / (Ttrim - valB);

    xout = den - valAlpha + valXoffset;
    
    ADCin = Nadc / xout;
    
end
