%% House keeping
clear all
close all
%% Variables
% Use x-axis as degress Celsisus(true) or raw register value(false)
converToCelsius = ~true;

% Factor to multiply the standard deviation (sigma) of the tempererate to
% define the tolerance
sigmasToTake = 9;

% Conversion factor from register value to degrees, depending on resolution
conversionFactor = 2^6;
%% Input data

tSense1Index = 1;
measurementFiles{1,tSense1Index} = ['\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3373-tSense_setup01\tsense' num2str(tSense1Index) 'Measurements3.txt'];
measurementFiles{2,tSense1Index} = ['\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3373-tSense_setup01\tsense' num2str(tSense1Index) 'Measurements4.txt'];
measurementFiles{3,tSense1Index} = ['\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3373-tSense_setup01\tsense' num2str(tSense1Index) 'Measurements5.txt'];
measurementFiles{4,tSense1Index} = ['\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3373-tSense_setup01\tsense' num2str(tSense1Index) 'Measurements6.txt'];
measurementFiles{5,tSense1Index} = ['\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3373-tSense_setup01\tsense' num2str(tSense1Index) 'Measurements7.txt'];
measurementFiles{6,tSense1Index} = ['\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3373-tSense_setup01\tsense' num2str(tSense1Index) 'Measurements8.txt'];

tSense2Index = 2;
measurementFiles{1,tSense2Index} = ['\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3373-tSense_setup01\tsense' num2str(tSense2Index) 'Measurements3.txt'];
measurementFiles{2,tSense2Index} = ['\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3373-tSense_setup01\tsense' num2str(tSense2Index) 'Measurements4.txt'];
measurementFiles{3,tSense2Index} = ['\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3373-tSense_setup01\tsense' num2str(tSense2Index) 'Measurements5.txt'];
measurementFiles{4,tSense2Index} = ['\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3373-tSense_setup01\tsense' num2str(tSense2Index) 'Measurements6.txt'];
measurementFiles{5,tSense2Index} = ['\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3373-tSense_setup01\tsense' num2str(tSense2Index) 'Measurements7.txt'];
measurementFiles{6,tSense2Index} = ['\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3373-tSense_setup01\tsense' num2str(tSense2Index) 'Measurements8.txt'];

tSense3Index = 3;
measurementFiles{1,tSense3Index} = ['\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3373-tSense_setup01\tsense' num2str(tSense3Index) 'Measurements3.txt'];
measurementFiles{2,tSense3Index} = ['\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3373-tSense_setup01\tsense' num2str(tSense3Index) 'Measurements4.txt'];
measurementFiles{3,tSense3Index} = ['\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3373-tSense_setup01\tsense' num2str(tSense3Index) 'Measurements5.txt'];
measurementFiles{4,tSense3Index} = ['\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3373-tSense_setup01\tsense' num2str(tSense3Index) 'Measurements6.txt'];
measurementFiles{5,tSense3Index} = ['\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3373-tSense_setup01\tsense' num2str(tSense3Index) 'Measurements7.txt'];
measurementFiles{6,tSense3Index} = ['\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3373-tSense_setup01\tsense' num2str(tSense3Index) 'Measurements8.txt'];

tSense4Index = 4;
measurementFiles{1,tSense4Index} = ['\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3373-tSense_setup01\tsense' num2str(tSense4Index) 'Measurements3.txt'];
measurementFiles{2,tSense4Index} = ['\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3373-tSense_setup01\tsense' num2str(tSense4Index) 'Measurements4.txt'];
measurementFiles{3,tSense4Index} = ['\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3373-tSense_setup01\tsense' num2str(tSense4Index) 'Measurements5.txt'];
measurementFiles{4,tSense4Index} = ['\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3373-tSense_setup01\tsense' num2str(tSense4Index) 'Measurements6.txt'];
measurementFiles{5,tSense4Index} = ['\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3373-tSense_setup01\tsense' num2str(tSense4Index) 'Measurements7.txt'];
measurementFiles{6,tSense4Index} = ['\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3373-tSense_setup01\tsense' num2str(tSense4Index) 'Measurements7.txt'];

% Number of measurements and sensors
[numberOfMeasurements, numberOfSensors] = size(measurementFiles);
% For loop to import data into temperature matrix
for currentTSensor = 1: numberOfSensors
    % Auxiliar vector to import temperature
    measuredTemp = [];
    for currentMeasurement = 1 : numberOfMeasurements
        measuredTemp = [measuredTemp importfile(measurementFiles{currentMeasurement,currentTSensor})];
    end
    tMatrix(:,currentTSensor) = measuredTemp;
end


%% Processing
% Convert to Celsius if enabled flag
if converToCelsius
    tMatrix = tMatrix ./ conversionFactor;
end

% Calculate std of each temperateure sensor
stdTemp = std(tMatrix)
% Calculate the mean of each temperature sensor
meanTemp = mean(tMatrix)
% Get the tolerance per sensor
tempTolerance = stdTemp * sigmasToTake;
% Get the max temperature per sensor
maxTemp = meanTemp + tempTolerance;
% Get the min temperature per sensor
minTemp = meanTemp - tempTolerance;

% Values casted to int16
meanTemp16 = int16(meanTemp);
tempTolerance16 = int16(tempTolerance);
maxTemp16 = int16(maxTemp);
minTemp16 = int16(minTemp);


%% Plotting
% If converting to Celsius set the x axis accordingly
if converToCelsius
    myXlabel ='[\circC]';
else
    myXlabel ='[Temp Raw Register]';
end

figure();

sensor1 = 'Temperature sensor 1';
sensor2 = 'Temperature sensor 2';
sensor3 = 'Temperature sensor 3';
sensor4 = 'Temperature sensor 4';
subplot(5,1,1);grid on;hold on
    h(1) = histogram(tMatrix(:,tSense1Index),length(tMatrix(:,tSense1Index)));
    h(1).FaceColor = [0 0.4470 0.7410];
    plot(minTemp(1),0,'k*');
    plot(maxTemp(1),0,'r*');
    plot(meanTemp(1),0,'b*');
    e(1) = errorbar(meanTemp(1),max(h(1).Values),tempTolerance(1),'o','horizontal');
    plotQuatnizedValues(minTemp16,maxTemp16,meanTemp16,1);
    grid on;
    title(['Histogram ' sensor1 ' Values to set on Tsense unit tests TOLERANCE(' num2str(sigmasToTake) '*\sigma):' num2str(tempTolerance16(1)) myXlabel ', DEFAULT TEMPERATURE:' num2str(meanTemp16(1))]);
    legend({sensor1,'minTemp','maxTemp','meanTemp',['tempTolerance:' num2str(tempTolerance(1))],'minTemp16','maxTemp16','meanTemp16'},'Location','bestoutside','Orientation','vertical');
    xlabel(myXlabel);ylabel('Count');
    hold off;
subplot(5,1,2);grid on;;hold on
    h(2) = histogram(tMatrix(:,tSense2Index),length(tMatrix(:,tSense2Index)));
    h(2).FaceColor = [0.8500 0.3250 0.0980];
    plot(minTemp(2),0,'k*');
    plot(maxTemp(2),0,'r*');
    plot(meanTemp(2),0,'b*');
    e(2) = errorbar(meanTemp(2),max(h(2).Values),tempTolerance(2),'o','horizontal');
    plotQuatnizedValues(minTemp16,maxTemp16,meanTemp16,2);
    grid on;
    title(['Histogram ' sensor2 ' Values to set on Tsense unit tests TOLERANCE(' num2str(sigmasToTake) '*\sigma):' num2str(tempTolerance16(2)) myXlabel ', DEFAULT TEMPERATURE:' num2str(meanTemp16(2))]);
    legend({sensor2,'minTemp','maxTemp','meanTemp',['tempTolerance:' num2str(tempTolerance(2))],'minTemp16','maxTemp16','meanTemp16'},'Location','bestoutside','Orientation','vertical');
    xlabel(myXlabel);ylabel('Count')
    hold off;
subplot(5,1,3);grid on;hold on
    h(3) = histogram(tMatrix(:,tSense3Index),length(tMatrix(:,tSense3Index)));
    h(3).FaceColor = [0.9290 0.6940 0.1250];
    plot(minTemp(3),0,'k*');
    plot(maxTemp(3),0,'r*');
    plot(meanTemp(3),0,'b*');
    errorbar(meanTemp(3),max(h(3).Values),tempTolerance(3),'o','horizontal');
    plotQuatnizedValues(minTemp16,maxTemp16,meanTemp16,3);
    grid on;
    title(['Histogram ' sensor3 ' Values to set on Tsense unit tests TOLERANCE(' num2str(sigmasToTake) '*\sigma):' num2str(tempTolerance16(3)) myXlabel ', DEFAULT TEMPERATURE:' num2str(meanTemp16(3))]);
    legend({sensor3,'minTemp','maxTemp','meanTemp',['tempTolerance:' num2str(tempTolerance(3))],'minTemp16','maxTemp16','meanTemp16'},'Location','bestoutside','Orientation','vertical');
    xlabel(myXlabel);ylabel('Count')
    hold off;
subplot(5,1,4);grid on;hold on
    h(4) = histogram(tMatrix(:,tSense4Index),length(tMatrix(:,tSense4Index)));
    h(4).FaceColor = [0.4940 0.1840 0.5560];
    plot(minTemp(4),0,'k*');
    plot(maxTemp(4),0,'r*');
    plot(meanTemp(4),0,'b*');
    e(3) = errorbar(meanTemp(4),max(h(4).Values),tempTolerance(4),'o','horizontal');
    plotQuatnizedValues(minTemp16,maxTemp16,meanTemp16,4);
    grid on;
    title(['Histogram ' sensor4 ' Values to set on Tsense unit tests TOLERANCE(' num2str(sigmasToTake) '*\sigma):' num2str(tempTolerance16(4)) myXlabel ', DEFAULT TEMPERATURE:' num2str(meanTemp16(4))]);
    legend({sensor4,'minTemp','maxTemp','meanTemp',['tempTolerance:' num2str(tempTolerance(4))],'minTemp16','maxTemp16','meanTemp16'},'Location','bestoutside','Orientation','vertical');
    xlabel(myXlabel);ylabel('Count')
    hold off;
subplot(5,1,5);hold on;grid on;
    histogram(tMatrix(:,tSense1Index));
    histogram(tMatrix(:,tSense2Index));
    histogram(tMatrix(:,tSense3Index));
    histogram(tMatrix(:,tSense4Index));
    plot(minTemp,0,'k*');
    plot(maxTemp,0,'r*');
    plot(meanTemp,0,'b*');
    legend({sensor1,sensor2,sensor3,sensor4},'Location','bestoutside','Orientation','vertical');
    title( 'Temperature sensors histogram comparison overview');
    hold off;
    xlabel(myXlabel);ylabel('Count')   
%% Functions
function tsenseMeasurements = importfile(filename, dataLines)
%IMPORTFILE Import data from a text file
%  TSENSE2MEASUREMENTS3 = IMPORTFILE(FILENAME) reads data from text file
%  FILENAME for the default selection.  Returns the data as a cell array.
%
%  TSENSE2MEASUREMENTS3 = IMPORTFILE(FILE, DATALINES) reads data for the
%  specified row interval(s) of text file FILENAME. Specify DATALINES as
%  a positive scalar integer or a N-by-2 array of positive scalar
%  integers for dis-contiguous row intervals.
%
%  Example:
%  tsense2Measurements3 = importfile("\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3373-tSense_setup01\tsense2Measurements3.txt", [44, 44]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 07-Jan-2022 15:03:02

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [44, 44];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 27);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ["\t", " ", ",", ", ", ";", "[", "]"];

% Specify column names and types
opts.VariableNames = ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22", "VarName23", "VarName24", "VarName25", "VarName26", "VarName27"];
opts.SelectedVariableNames = ["VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22", "VarName23", "VarName24", "VarName25", "VarName26", "VarName27"];
opts.VariableTypes = ["char", "char", "char", "char", "char", "char", "char", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7"], "EmptyFieldRule", "auto");

% Import the data
tsenseMeasurements = readtable(filename, opts);

%% Convert to output type
tsenseMeasurements = table2cell(tsenseMeasurements);
numIdx = cellfun(@(x) ~isnan(str2double(x)), tsenseMeasurements);
tsenseMeasurements(numIdx) = cellfun(@(x) {str2double(x)}, tsenseMeasurements(numIdx));

tsenseMeasurements = cell2mat(tsenseMeasurements);
end

function plotQuatnizedValues(minTemp,maxTemp,meanTemp,idex)
    plot(minTemp(idex),0,'ko');
    plot(maxTemp(idex),0,'ro');
    plot(meanTemp(idex),0,'bo');
end