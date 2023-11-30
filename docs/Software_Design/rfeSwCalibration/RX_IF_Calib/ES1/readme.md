# RFE SW RX IF CALIBRATION ES1 DOCS folder structure
This folder is intended to contain those documents related to the implementation of RFE SW CALIBRATION RX IF calibration for ES1.

Apart from the root directory, where it can be found
* _RX IF Filter calibration Results.pptx_ : first set of results before starting IP Val
* _Calibration_Hot_Fix_0.8.9+notes.pptx_ : presentation showing consumed timing and expecte sequence for each calibration item 
* Rxmodes.vsdx : schematic showing all the RX modes in system view and which mode enables what RX switch in HW.

The following sections briefly details the content of each folder for the RX IF ES1 docs

## AlgorithmDoc
Folder containing the presentation explaining the devising of the RX IF calibration algorithm.

## EA-DetailDesign
Folder containing all `.xml` units needed to be added to EA for documenting RX IF calibration.

## HW Docs
Folder containing Analog and Digital documentantion for ES1 needed to understand how RX HW works and its dependencies.

## IFCalibrErrorHistograms
Matlab scripts to import, arrange and parse memory data exported with Eclipse from M7 in order to show the BIST signals and the impact of number of samples to use. I.e. these scripts were used to generated the data showed in _RX IF Filter calibration Results.pptx_ 

## implementationFFTM7_Vs_Matlab
Matlab scripts to do pre-verification that FFT/DFT M7 implementation matches Matlab FFT/DFT with the required precision/accuracy level.

## mixerPole
Matlab script to plot results of impact of RX RF Mixer pole for LPF calibration. 

## RegisterMaps
Folder containing the register map from ES1 to implement RX IF calibration.

## RxIFLogParser
Folder containing set of Matlab scripts to parse RX IF Gain error, these will be updated on STRX-7831

## Validation
Folder containing files used during IP validation and system validation
### IpVal
Files showing the init sequence that IP val was using durin RX IF IP Val and the steps we took together to validate the IP.
### SysVal
Files holding the Sysval MAtlab scripts to perform RX IF characterization. This folder also have the scripts that JCL made for them for the plots.

## WDMA_issue
Matlb script to import memory data to spot WMDA misaligment issue.