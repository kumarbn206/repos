function [PCBLossRow,PCBLossCol] = PCBLossSel(RFLOFreq,TXRXCh)
% Function to determine the row and column for the WG PCB Losses
% RFLOFreq    - LO/RF Frequency in GHz at which the measurement is performed
% TXRXCh      - TX/RX Channel to be measured

switch TXRXCh

    case "TXRX1"
        PCBLossCol = 2;
    case "TXRX2"
        PCBLossCol = 3;
    case "TXRX3"
        PCBLossCol = 4;
    case "TXRX4"
        PCBLossCol = 5;

end

switch RFLOFreq

    case 76
        PCBLossRow = 2;
    case 76.5
        PCBLossRow = 3;
    case 77
        PCBLossRow = 4;
    case 77.5
        PCBLossRow = 5;
    case 78
        PCBLossRow = 6;
    case 78.5
        PCBLossRow = 7;
    case 79
        PCBLossRow = 8;
    case 79.5
        PCBLossRow = 9;
    case 80
        PCBLossRow = 10;
    case 80.5
        PCBLossRow = 11;
    case 81
        PCBLossRow = 12;
end

end