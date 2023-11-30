function GetStateRfe

% This function returns the RFE state.



disp(" ");

[ error, return_value ] = rfeabstract.rfe_getState;

disp("Get state:");



if return_value == 0
    
    disp("RFE State Busy");
    
elseif return_value == 1
    
    disp("RFE State Initialized");
    
elseif return_value == 2
    
    disp("RFE State Configured");
    
elseif return_value == 3
    
    disp("RFE State RadarCycleIdle ");
    
elseif return_value == 4
    
    disp("RFE State Test Continuous Wave Transmission ");
    
elseif return_value == 5
    
    disp("RFE State FusaError");
    
end

if (~error)
    disp("No Error")
else
    try
        errorsRfe.ThrowError(error)
    catch ME
        disp( ME.identifier + " Error Occured " + ME.message)
    end
end 
    


end 


