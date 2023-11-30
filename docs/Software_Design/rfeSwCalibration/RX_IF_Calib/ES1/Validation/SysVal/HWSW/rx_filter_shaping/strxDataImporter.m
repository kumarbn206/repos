%%
% Author : Javier Cuadros Linde, nxf59937
function [strxReadData,freqsIF] = strxDataImporter(singleFile,pathToData,freqSweepIF)

    % Scalte to KHz
    scaleMHz = 1e3;
    % Expect a .mat file
    dataSuffix = '.mat';
    % Variable name 
    dataName = 'ADCCGDataArray';

    if singleFile==true
        load([pathToData dataSuffix],'strxReadData');
        % Check whether we have empty cells, freqs not measured or
        % incomplete
        emptyCellsIdx = cellfun(@isempty,strxReadData);
        strxReadData(emptyCellsIdx) = [];
        freqsIF = [];
        for freqIdx = 1: length(strxReadData)
            freqsIF = [ freqsIF str2num(replace(strxReadData{freqIdx}.frequency,'Hz',''))]; 
        end
        
    else

        % Create the range of positive and negative frequencies
        freqsIF = freqSweepIF;
        % Preallocate the cell to store the data
        cellData = cell(size(freqsIF));
        % Main for loop to iterate over swept frequencies
        initFreqIndex = 1;
        for selectedFreq = initFreqIndex : length(freqsIF)
            % Create the full path to the data based on path, name and extension
            fullDataPath = [pathToData num2str(freqsIF(selectedFreq)) dataSuffix];
            % Load the data into the cell
            cellData{selectedFreq}                 = load(fullDataPath,dataName);
            cellData{selectedFreq}.frequency       = [num2str(freqsIF(selectedFreq) ./scaleMHz) 'KHz'];
    
        end
        % return the data
        strxReadData = cellData;
    end
end

