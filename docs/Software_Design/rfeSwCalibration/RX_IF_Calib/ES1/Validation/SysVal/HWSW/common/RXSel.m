function [RXChSel] = RXSel(RXChMeas)
% Function used to select the RX channel used for measurements
% RXChMeas - RX channel selection as a string
% RXChSel  - RX channel selection as a number used for indexing arrays

% RX Channel selection for measurement
switch RXChMeas

    case "RX1 "

        % Index for the line loss cell selection 
        RXChSel  = 1;

    case "RX2 "

        % Index for the line loss cell selection 
        RXChSel  = 2;

    case "RX3 "

        % Index for the line loss cell selection 
        RXChSel  = 3;

    case "RX4 "

        % Index for the line loss cell selection 
        RXChSel  = 4;

end




end