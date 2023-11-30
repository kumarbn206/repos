% addpath('..\clients\Matlab')
function SyncRfe()

disp('Initializing:');
initialized = false;
count=0;
while (~initialized)
    error = rfeabstract.rfe_sync;
    if error ~= 3
        initialized = true;
    else
        initialized = false;
    end
    
    if count> 20
        try
            errorsRfe.ThrowError(error)
        catch ME
            disp( ME.identifier + " Error Occured " + ME.message)
        end
        
        ResetRfe();
        
    end
end
disp('RFE Initialized!');

end