classdef errorsRfe
% Handles RFE errors.
% At first access it will load a csv file of the format "code, id, message" into a map object.
% This object can then be used to Throw an error with the id and message relating to the code.
% See example usage: example_errorsRfe.m

    properties (Constant)
        ERROR_FILE_PATH = 'Rfe Errors - CODE_ID_MSG.csv'
    end


    methods (Static)
        function ThrowError(error_code)
            % Throws a constructed MExeption if the error_code is not 0
            persistent error_map;
            if isempty(error_map) % at first access it will load the map
                error_map = errorsRfe.SetErrorMapData;
            end

            if error_code
                id_and_msg = error_map(error_code);
                ME = MException("RfeError:" + id_and_msg(1), id_and_msg(2));
                throw(ME)        
            end
        end

        function DisplayError(error_code)
            % Displays the error id and message if the error_code is not 0
            % Does not throw an error
            try
                errorsRfe.ThrowError(error_code);
            catch ME
                disp( ME.identifier + " -- " + ME.message)
            end
        end
    end


    methods (Static, Access = private)
        function error_map = SetErrorMapData
            error_table = readtable(errorsRfe.ERROR_FILE_PATH);
            error_table.COM = num2cell([string(error_table.ID), string(error_table.MSG)],2);
            error_map = containers.Map(error_table.CODE, error_table.COM);
        end
    end
end
