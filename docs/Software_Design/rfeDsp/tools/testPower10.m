%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% testPower10
%
% This function checks accuracy of embedded power of 10 function using the
% following algorithm with single precision FPU for an exponent x<=9:
%       10^x = 10^floor(x) * 10^xFrac;  where xFrac = x - floor(x);
%       10^xFrac = e^(ln(10)*xFrac);
%       let eX = ln(10) * xFrac / 16, calculate e^eX using Taylor expension for
%       a N loops.
%       powerFloat = 1 + eX + Sum_n_2ToN(eX^n / n!);
%       10^x ~ ( powerFloat^16 ) * 10^floor(x);
%       
% History
%   02-11-2021   Hong Li   First implementation
%

function power = testPower10( nLoops )

% Prepare input data and referance data
arraySize = 256;
dataIn = (rand(1,arraySize)-0.5)*2*4;
powerDouble = 10.^dataIn;

% reduce accuracy to single-precision floating point
inSingle = single(dataIn);
inFloat = double(inSingle);
powerSingle = 10.^(double(inFloat));

% Test floating-point 10^x 
expoInt = floor(inFloat);
power =  10.^expoInt;

% Get fractional expo and divided by 16 
expoFractional = inFloat - expoInt;
eX = expoFractional .* 0.1439115703105926513671875; %log(10)/16;
eXSingle = single(eX);
eX = double(eXSingle);

powerFloat = 1;
eXp = 1;
fractorial = 1;
for loop = 1:nLoops
    eXp = eXp .* eX;
    fractorial = fractorial .* loop;
    powerFloat = powerFloat + eXp / fractorial;
end

power = power .* ( powerFloat.^16 );

diff = (power - powerDouble)./powerDouble;
maxDiff = max(abs(diff))

% Check error and plot error
figure;
plot(1:arraySize, diff);

end