function [OutputStruct] = ConfigureRfe(InputStruct)

config_filename = InputStruct.config_filename;
dynamic_table_filename = InputStruct.dynamic_table_filename;

[ error ] = rfeabstract.rfe_configure(config_filename, dynamic_table_filename);

OutputStruct.error = error;

if (~error)
    disp('RFE Configured');
       
else
    try
        errorsRfe.ThrowError(error)
    catch ME
        disp( ME.identifier + " Error Occured " + ME.message)
    end
end