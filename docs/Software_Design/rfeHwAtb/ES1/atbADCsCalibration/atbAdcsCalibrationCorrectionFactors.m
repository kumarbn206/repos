%% House keepingdiv2Mode
clear all;
% close all;
clc;

%% Import data
fileName = "\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3418\adcCalibrationMeasurements4.txt"; % This is single shot measurement
fileName = "\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3418\adcCalibrationMeasurements5ContinuousMode.txt";
fileName = "\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3418\adcCalibrationMeasurements5MonoMode.txt";
% fileName = "\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3418\adcCalibrationMeasurements6MonoMode2p5MSps.txt";
% fileName = "\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3418\adcCalibrationMeasurements6ContinuousMode2p5MSps.txt";
adcMeasurementsNonCalibrated = importAdcForCalibrationMeasurements(fileName);
adcCorrection= importAdcCorrectionFactors(fileName);
averagedSamples = getAveragedSamples(fileName);
%% Variables

% Measurements were differential?
differentialInput = false;


%% Calculations 
div2Mode = false;
corrected400mV = rfeHwAtb_funcAtbAdcSamplesToVoltageConvert(adcMeasurementsNonCalibrated.adcMeasurements400mV.averagedATBxADCsample,differentialInput,div2Mode,adcCorrection.Normal.gainFactor,adcCorrection.Normal.offsetFactor);
corrected600mV = rfeHwAtb_funcAtbAdcSamplesToVoltageConvert(adcMeasurementsNonCalibrated.adcMeasurements600mV.averagedATBxADCsample,differentialInput,div2Mode,adcCorrection.Normal.gainFactor,adcCorrection.Normal.offsetFactor);

div2Mode = true;
corrected400mVDiv2 = rfeHwAtb_funcAtbAdcSamplesToVoltageConvert(adcMeasurementsNonCalibrated.adcMeasurements400mVDiv2.averagedATBxADCsample,differentialInput,div2Mode,adcCorrection.Div2.gainFactor,adcCorrection.Div2.offsetFactor);
corrected900mVDiv2 = rfeHwAtb_funcAtbAdcSamplesToVoltageConvert(adcMeasurementsNonCalibrated.adcMeasurements900mVDiv2.averagedATBxADCsample,differentialInput,div2Mode,adcCorrection.Div2.gainFactor,adcCorrection.Div2.offsetFactor);


%%  Errors
expected400mV = 400.*ones(size(adcMeasurementsNonCalibrated.adcMeasurements400mV.averagedATBxADCsample));
expected600mV = 600.*ones(size(adcMeasurementsNonCalibrated.adcMeasurements600mV.averagedATBxADCsample));
expected900mV = 900.*ones(size(adcMeasurementsNonCalibrated.adcMeasurements900mVDiv2.averagedATBxADCsample));

errors400 = calculateErrors(expected400mV, corrected400mV);
errors600 = calculateErrors(expected600mV, corrected600mV);

errors400Div2 = calculateErrors(expected400mV, corrected400mVDiv2);
errors900Div2 = calculateErrors(expected900mV, corrected900mVDiv2);

%% Plots

myLegend400mV = {'target:400mV','nonCalibADC1@0.4V','CalibADC1@0.4V'};
myLegend600mV = {'target:600mV','nonCalibADC1@0.6V','CalibADC1@0.6V'};

myLegend400mVDiv2 = {'target:400mV','nonCalibADC1@0.4VDiv2','CalibADC1@0.4VDiv2'};
myLegend900mVDiv2 = {'target:900mV','nonCalibADC1@0.9VDiv2','CalibADC1@0.9VDiv2'};

myLegendAveraged = ['averaged ' num2str(averagedSamples)  ' Samples'];

if(contains(extractAfter(fileName,'STRX-3418\'),'Mono'))
    myTitle = 'Mono:';
else
    myTitle = 'Continuous:';
end

% Normal mode
figure('Name',strjoin(['Normal mode for file' extractAfter(fileName,'STRX-3418\')]));
s(1)=subplot(3,2,1); hold on; grid on;
    plot(expected400mV,'r-*');
    p(1)=plot(adcMeasurementsNonCalibrated.adcMeasurements400mV.bandGapVoltage,'-o','Color',[0.4940 0.1840 0.5560]);
    p(3)=plot(corrected400mV,'-+','Color',p(1).Color);
    title([myTitle 'Measured voltage normal mode on, offset:' num2str(adcCorrection.Normal.offsetFactor) ',gain:' num2str(adcCorrection.Normal.gainFactor)]);
    legend(myLegend400mV,'location','best');
    ylabel('Voltage[mV]');xlabel('sample');
    hold off;
s(2)=subplot(3,2,2); hold on; grid on;
    plot(expected600mV,'r-*');
    p(2)=plot(adcMeasurementsNonCalibrated.adcMeasurements600mV.bandGapVoltage,'-o','Color',[0.9290 0.6940 0.1250]);
    p(4)=plot(corrected600mV,'-+','Color',p(2).Color);
    title([myTitle 'Measured voltage normal mode on, offset:' num2str(adcCorrection.Normal.offsetFactor) ',gain:' num2str(adcCorrection.Normal.gainFactor)]);
    legend(myLegend600mV,'location','best');
    ylabel('Voltage[mV]');xlabel('sample')
    hold off;
s(3)=subplot(3,2,3); hold on; grid on;
    yyaxis left
        p(5)=plot(errors400.absError,'-o');
        ylabel('AbsError[mV]');
    yyaxis right
        p(6)=plot(errors400.relError,'-o');
        ylabel('relError[%]');        
    title([myTitle 'Error measured voltage normal mode on, offset:' num2str(adcCorrection.Normal.offsetFactor) ',gain:' num2str(adcCorrection.Normal.gainFactor)]);
    legend({'absError','relError'},'location','best');
    xlabel('sample')
    hold off;
 s(4)=subplot(3,2,4); hold on; grid on;
    yyaxis left
        p(7)=plot(errors600.absError,'-o');
        ylabel('AbsError[mV]');
    yyaxis right
        p(8)=plot(errors600.relError,'-o');
        ylabel('relError[%]');   
    title([myTitle 'Error measured voltage normal mode on, offset:' num2str(adcCorrection.Normal.offsetFactor) ',gain:' num2str(adcCorrection.Normal.gainFactor)]);
    legend({'absError','relError'},'location','best');
    xlabel('sample')
    hold off;
s(5)=subplot(3,2,5); hold on; grid on;
    p(9)=plot(adcMeasurementsNonCalibrated.adcMeasurements400mV.adcObs1Data,'-s');
    p(10)=plot(adcMeasurementsNonCalibrated.adcMeasurements400mV.averagedATBxADCsample,'-d');
    title([myTitle 'ADC codes for 400mV normal mode on']);
    legend({'adcObs1Data',myLegendAveraged},'location','best');
    ylabel('ADC code');xlabel('sample')
    hold off;
s(6)=subplot(3,2,6); hold on; grid on;
    p(11)=plot(adcMeasurementsNonCalibrated.adcMeasurements600mV.adcObs1Data,'-s','Color',p(9).Color);
    p(12)=plot(adcMeasurementsNonCalibrated.adcMeasurements600mV.averagedATBxADCsample,'-d','Color',p(10).Color);
    title([myTitle 'ADC codes for 600mV normal mode on']);
    legend({'adcObs1Data',myLegendAveraged},'location','best');
    ylabel('ADC code');xlabel('sample')
    hold off;

% Div2 mode
figure('Name',strjoin(['Div2 mode for file' extractAfter(fileName,'STRX-3418\')]));
s(7)=subplot(3,2,1); hold on; grid on;
    plot(expected400mV,'r-*');
    p2(1)=plot(adcMeasurementsNonCalibrated.adcMeasurements400mVDiv2.bandGapVoltage,'-o','Color',[0.4940 0.1840 0.5560]);
    p2(3)=plot(corrected400mVDiv2,'-+','Color',p2(1).Color);
    title([myTitle 'Measured voltage Div2 mode on, offset:' num2str(adcCorrection.Div2.offsetFactor) ',gain:' num2str(adcCorrection.Div2.gainFactor)]);
    legend(myLegend400mVDiv2,'location','best');
    ylabel('Voltage[mV]');xlabel('sample')
    hold off;
s(8)=subplot(3,2,2); hold on; grid on;
    plot(expected900mV,'r-*');
    p2(2)=plot(adcMeasurementsNonCalibrated.adcMeasurements900mVDiv2.bandGapVoltage,'-o','Color',[0.9290 0.6940 0.1250]);
    p2(4)=plot(corrected900mVDiv2,'-+','Color',p2(2).Color);
    title([myTitle 'Measured voltage Div2 mode on, offset:' num2str(adcCorrection.Div2.offsetFactor) ',gain:' num2str(adcCorrection.Div2.gainFactor)]);
    legend(myLegend900mVDiv2,'location','best');
    ylabel('Voltage[mV]');xlabel('sample')
    hold off;
s(9)=subplot(3,2,3); hold on; grid on;
    yyaxis left
        p2(5)=plot(errors400Div2.absError,'-o');
        ylabel('AbsError[mV]');
    yyaxis right
        p2(6)=plot(errors900Div2.relError,'-o');
        ylabel('relError[%]'); 
    title([myTitle 'Error measured voltage Div2 mode on, offset:' num2str(adcCorrection.Div2.offsetFactor) ',gain:' num2str(adcCorrection.Div2.gainFactor)]);
    legend({'absError','relError'},'location','best');
    xlabel('sample')
    hold off;
 s(10)=subplot(3,2,4); hold on; grid on;
    yyaxis left
        p2(7)=plot(errors400Div2.absError,'-o');
        ylabel('AbsError[mV]');
    yyaxis right
        p2(8)=plot(errors900Div2.relError,'-o');
        ylabel('relError[%]'); 
    title([myTitle 'Error measured voltage Div2 mode on, offset:' num2str(adcCorrection.Div2.offsetFactor) ',gain:' num2str(adcCorrection.Div2.gainFactor)]);
    legend({'absError','relError'},'location','best');
    xlabel('sample')
    hold off;
s(11)=subplot(3,2,5); hold on; grid on;
    p2(9)=plot(adcMeasurementsNonCalibrated.adcMeasurements400mVDiv2.adcObs1Data,'-s');
    p2(10)=plot(adcMeasurementsNonCalibrated.adcMeasurements400mVDiv2.averagedATBxADCsample,'-d');
    title([myTitle 'ADC codes for 400mV Div2 mode on']);
    legend({'adcObs1Data',myLegendAveraged},'location','best');
    ylabel('ADC code');xlabel('sample')
    hold off;
s(12)=subplot(3,2,6); hold on; grid on;
    p2(11)=plot(adcMeasurementsNonCalibrated.adcMeasurements900mVDiv2.adcObs1Data,'-s','Color',p(9).Color);
    p2(12)=plot(adcMeasurementsNonCalibrated.adcMeasurements900mVDiv2.averagedATBxADCsample,'-d','Color',p(10).Color);
    title([ myTitle 'ADC codes for 900mV Div2 mode on']);
    legend({'adcObs1Data',myLegendAveraged},'location','best');
    ylabel('ADC code');xlabel('sample')
    hold off;

%% Axis links

linkaxes(s,'x');
    
%% Functions

function errors = calculateErrors(expectedInput, measuredInput)
    errors.absError = abs( expectedInput - measuredInput );
    errors.relError = (errors.absError ./ measuredInput)*100;
end

function voltageCorrected = rfeHwAtb_funcAtbAdcSamplesToVoltageConvert(adcCode,differentialMeasurement, div2ModeOn ,gainFactor,offsetFactor)
    RFE_HW_ATB_IP_ADC_NORMAL_GAIN_MODE_DYNAMIC_RANGE = 1024;
    RFE_HW_ATB_DEFAULT_ATB_ADC_REFERENCE_VOLTAGE_mV = 800; %[mV]
    
    if (differentialMeasurement)
        voltageCorrected = ( ( adcCode ./ RFE_HW_ATB_IP_ADC_NORMAL_GAIN_MODE_DYNAMIC_RANGE ) * gainFactor + offsetFactor - 1.0 ) * RFE_HW_ATB_DEFAULT_ATB_ADC_REFERENCE_VOLTAGE_mV;
    else
        voltageCorrected = ( ( adcCode ./  RFE_HW_ATB_IP_ADC_NORMAL_GAIN_MODE_DYNAMIC_RANGE ) * gainFactor + offsetFactor ) .* RFE_HW_ATB_DEFAULT_ATB_ADC_REFERENCE_VOLTAGE_mV;
    end
    
    if ( div2ModeOn )
    
        voltageCorrected = 2 .* voltageCorrected;
    end

end

function adcMeasurementsNonCalibrated = importAdcForCalibrationMeasurements(filename, dataLines)
%IMPORTFILE Import data from a text file
%  ADCCALIBRATIONMEASUREMENTS = IMPORTFILE(FILENAME) reads data from
%  text file FILENAME for the default selection.  Returns the data as a
%  cell array.
%
%  ADCCALIBRATIONMEASUREMENTS = IMPORTFILE(FILE, DATALINES) reads data
%  for the specified row interval(s) of text file FILENAME. Specify
%  DATALINES as a positive scalar integer or a N-by-2 array of positive
%  scalar integers for dis-contiguous row intervals.
%
%  Example:
%  adcCalibrationMeasurements = importfile("\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3418\adcCalibrationMeasurements.txt", [27, 30]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 01-Mar-2022 10:11:39

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [27, 45];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 15);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ["\t", ",", "[", "]"];

% Specify column names and types
opts.VariableNames = ["Var1", "Var2", "Var3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18"];
opts.SelectedVariableNames = ["VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18"];
opts.VariableTypes = ["char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char","char", "char", "char"];

% Specify file level properties
opts.ImportErrorRule = "omitrow";
opts.MissingRule = "omitrow";
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18"], "EmptyFieldRule", "auto");

% Import the data
adcCalibrationMeasurements = readtable(filename, opts);

%% Convert to output type
adcCalibrationMeasurements = table2cell(adcCalibrationMeasurements);
numIdx = cellfun(@(x) ~isnan(str2double(x)), adcCalibrationMeasurements);
adcCalibrationMeasurements(numIdx) = cellfun(@(x) {str2double(x)}, adcCalibrationMeasurements(numIdx));

adcCalibrationMeasurements(numIdx==0) = num2cell(hex2dec((replace(adcCalibrationMeasurements(numIdx==0),' ',''))));


startMeasurementRow = 0;
startMeasurementColumn = 4;

adcMeasurements400mV.bandGapVoltage = cell2mat(adcCalibrationMeasurements(startMeasurementRow+1,startMeasurementColumn:end));
adcMeasurements400mV.averagedATBxADCsample = cell2mat(adcCalibrationMeasurements(startMeasurementRow+2,startMeasurementColumn:end));
adcMeasurements400mV.adcObs1Data = cell2mat(adcCalibrationMeasurements(startMeasurementRow+3,startMeasurementColumn:end));
adcMeasurements400mV.bandGapVoltageFromAdcObs1Data = cell2mat(adcCalibrationMeasurements(startMeasurementRow+4,startMeasurementColumn:end));

adcMeasurements600mV.bandGapVoltage = cell2mat(adcCalibrationMeasurements(startMeasurementRow+5,startMeasurementColumn:end));
adcMeasurements600mV.averagedATBxADCsample = cell2mat(adcCalibrationMeasurements(startMeasurementRow+6,startMeasurementColumn:end));
adcMeasurements600mV.adcObs1Data = cell2mat(adcCalibrationMeasurements(startMeasurementRow+7,startMeasurementColumn:end));
adcMeasurements600mV.bandGapVoltageFromAdcObs1Data = cell2mat(adcCalibrationMeasurements(startMeasurementRow+8,startMeasurementColumn:end));

adcMeasurements400mVDiv2.bandGapVoltage = cell2mat(adcCalibrationMeasurements(startMeasurementRow+9,startMeasurementColumn:end));
adcMeasurements400mVDiv2.averagedATBxADCsample = cell2mat(adcCalibrationMeasurements(startMeasurementRow+10,startMeasurementColumn:end));
adcMeasurements400mVDiv2.adcObs1Data = cell2mat(adcCalibrationMeasurements(startMeasurementRow+11,startMeasurementColumn:end));
adcMeasurements400mVDiv2.bandGapVoltageFromAdcObs1Data = cell2mat(adcCalibrationMeasurements(startMeasurementRow+12,startMeasurementColumn:end));

adcMeasurements900mVDiv2.bandGapVoltage = cell2mat(adcCalibrationMeasurements(startMeasurementRow+13,startMeasurementColumn:end));
adcMeasurements900mVDiv2.averagedATBxADCsample = cell2mat(adcCalibrationMeasurements(startMeasurementRow+14,startMeasurementColumn:end));
adcMeasurements900mVDiv2.adcObs1Data = cell2mat(adcCalibrationMeasurements(startMeasurementRow+15,startMeasurementColumn:end));
adcMeasurements900mVDiv2.bandGapVoltageFromAdcObs1Data = cell2mat(adcCalibrationMeasurements(startMeasurementRow+16,startMeasurementColumn:end));

adcMeasurementsNonCalibrated.adcMeasurements400mV = adcMeasurements400mV;
adcMeasurementsNonCalibrated.adcMeasurements600mV = adcMeasurements600mV;
adcMeasurementsNonCalibrated.adcMeasurements400mVDiv2 = adcMeasurements400mVDiv2;
adcMeasurementsNonCalibrated.adcMeasurements900mVDiv2 = adcMeasurements900mVDiv2;
end

function adcCorrection= importAdcCorrectionFactors(filename, dataLines)
%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 18);

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [17, 22];
end

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ["\t", ",", "[", "]"];

% Specify column names and types
opts.VariableNames = ["Var1", "Var2", "Var3", "Var4", "rfeHwAtb_atb_t", "atbIpInUse0x00000018ff0000000000000c0000000000000022", "atbOperationMode0x00000001", "atbSettings0xbd83c3c43f20a0a03a7f01003f7f0100000000000000000100", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18"];
opts.SelectedVariableNames = ["rfeHwAtb_atb_t", "atbIpInUse0x00000018ff0000000000000c0000000000000022", "atbOperationMode0x00000001", "atbSettings0xbd83c3c43f20a0a03a7f01003f7f0100000000000000000100"];
opts.VariableTypes = ["char", "char", "char", "char", "char", "char", "double", "double", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "rfeHwAtb_atb_t", "atbIpInUse0x00000018ff0000000000000c0000000000000022", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "rfeHwAtb_atb_t", "atbIpInUse0x00000018ff0000000000000c0000000000000022", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["atbOperationMode0x00000001", "atbSettings0xbd83c3c43f20a0a03a7f01003f7f0100000000000000000100"], "ThousandsSeparator", ",");

% Import the data
adcCorrectionFactors = table2cell(readtable(filename, opts));

% row index where the gainFactor will be in the cell array
gainFactorIndex = 2;
% colunm index where the gainFactor will be in the cell array
correctionFactorColunms = 4;

adcCorrection.Normal.gainFactor = adcCorrectionFactors{gainFactorIndex,correctionFactorColunms};
adcCorrection.Normal.offsetFactor = adcCorrectionFactors{gainFactorIndex+1,correctionFactorColunms};

adcCorrection.Div2.gainFactor = adcCorrectionFactors{gainFactorIndex+3,correctionFactorColunms};
adcCorrection.Div2.offsetFactor = adcCorrectionFactors{gainFactorIndex+4,correctionFactorColunms};
end
function averagedSamples = getAveragedSamples(filename, dataLines)
%IMPORTFILE Import data from a text file
%  ADCCALIBRATIONMEASUREMENTS5CONTINUOUSMODE = IMPORTFILE(FILENAME)
%  reads data from text file FILENAME for the default selection.
%  Returns the data as a table.
%
%  ADCCALIBRATIONMEASUREMENTS5CONTINUOUSMODE = IMPORTFILE(FILE,
%  DATALINES) reads data for the specified row interval(s) of text file
%  FILENAME. Specify DATALINES as a positive scalar integer or a N-by-2
%  array of positive scalar integers for dis-contiguous row intervals.
%
%  Example:
%  adcCalibrationMeasurements5ContinuousMode = importfile("\\wiv0327.nxdi.nl-cdc01.nxp.com\STRX\Javier\bringUpScript\STRX-3418\adcCalibrationMeasurements5ContinuousMode.txt", [12, 12]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 03-Mar-2022 13:17:12

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [12, 12];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 19);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ["\t", " ", "[", "]"];

% Specify column names and types
opts.VariableNames = ["Var1", "Var2", "Var3", "Var4", "Var5", "atbIpInUse0x00000018ff0000000000000c0000000000000022", "atbOperationMode0x00000001", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19"];
opts.SelectedVariableNames = ["atbIpInUse0x00000018ff0000000000000c0000000000000022", "atbOperationMode0x00000001"];
opts.VariableTypes = ["char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var5", "atbIpInUse0x00000018ff0000000000000c0000000000000022", "atbOperationMode0x00000001", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var5", "atbIpInUse0x00000018ff0000000000000c0000000000000022", "atbOperationMode0x00000001", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19"], "EmptyFieldRule", "auto");

% Import the data
averagedSamplesCell = table2cell(readtable(filename, opts));
% row index where the avaraged samples will be in the cell array
averageIndex = 2;
averagedSamples = averagedSamplesCell{1,averageIndex};

end