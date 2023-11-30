function [trace_data_x1,trace_data_y1]=fsw_spectrum_mode_data_read(fsw_address)
    
    instrreset;
    analyzer_handle=visadev(fsw_address);


    writeline(analyzer_handle, 'TRAC2:DATA? TRACE1');
    trace_data_y1 = readline(analyzer_handle);
    trace_data_y1 = strsplit(trace_data_y1, ',');
    trace_data_y1=(cellfun(@str2num,trace_data_y1));

    writeline(analyzer_handle, 'TRAC2:DATA:X? TRACE1');
    trace_data_x1 = readline(analyzer_handle);
    trace_data_x1 = strsplit(trace_data_x1, ',');
    trace_data_x1=(cellfun(@str2num,trace_data_x1));

end 