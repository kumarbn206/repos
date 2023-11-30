function [indexAllAverages,indexAvgTotal,indexAvgStageOne,indexAvgStageTwo]=obtainAverageIndexes(hpfRxIFCalibFullLog,iterAverage)

    if(nargin < 2)
        iterAverage = 4;
    end
    
    indexAvgStageOne.logical    = [];
    indexAvgStageOne.positional = [];
    indexAvgStageTwo.logical    = [];
    indexAvgStageTwo.positional = [];
    indexAvgTotal.logical       = [];
    indexAvgTotal.positional    = [];

    % Index with all averaged values stage1, stage2 and total
    indexAllAverages  = ( iterAverage == hpfRxIFCalibFullLog.Fine_tune_iteration );
    % Check that the log contains averaged elements, if not fail here
    if(~any(indexAllAverages))
        error('Input log does not have averaged values,because Fine tune iteration seems not to have value 4 as value ');
    else
        % Index with all averaged values stage1, stage2 and total
        indexAllAverages  = ( iterAverage == hpfRxIFCalibFullLog.Fine_tune_iteration );
        % First difference to identify only total averaged values
        firstDiffAllIndex = diff(indexAllAverages);
        % Index of stage1 and total averaged values are negative, index for
        % stage2 are filtered with first difference
        stageOneAndTotalIndex = firstDiffAllIndex < 0;
        % Positional index of stage1 and total averaged values
        posIndexStageOne = find(stageOneAndTotalIndex==1);
        % Odd positional indexes in posIndexStageOne are stage1 average results
        indexAvgStageOne.positional = posIndexStageOne(1:2:end);
        % Remove stage1 index from total
        indexAvgTotal.logical  = stageOneAndTotalIndex;
        indexAvgTotal.logical(indexAvgStageOne.positional) = 0;
        % Last element in log is always the total average
        indexAvgTotal.logical(end+1) = 1;
        indexAvgTotal.positional = find(indexAvgTotal.logical==1);
        % Index for stage2 are always located one positional index before total
        % average
        indexAvgStageTwo.positional = indexAvgTotal.positional-1;
    
        if(length(indexAvgStageTwo.positional) ~= length(indexAvgStageOne.positional))
            error(['Likely error in input file due to UART number of averages for stage1 differs from stage2. ' ...
                'Counted stage1 averages:' num2str(length(indexAvgStageOne.positional)) ' vs counted stages2 averages:' num2str(length(indexAvgStageTwo.positional))]);
        end
    
    
    end
end