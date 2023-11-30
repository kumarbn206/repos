# RFE SW Tsense ES1 DOCS folder structure
This folder is intended to contain those documents related to the implementation of RFE Tsense driver for ES1.

Apart from the root directory, the following sections briefly details the content of each folder for the Tsense ES1 docs

## Auxiliary Doc
Folder containing the requirements used for the development of the Tsense driver

## EA-SW-Unit-DD
Folder containing the EA backs up of the Tsense DD

## Auxiliary Doc
Folder containing old designs of Tsense at the beginning of STRX project. It also contains the requirements coming from DOORS used to devise Tsense SW unit.

## HW Docs
Folder containing Analog and Digital documentantion for ES1 needed to understand how Tsense HW works.
Important to mention is  `amos_c028hpcp_tdc1dg10k_dts.pdf` which is the datasheet for Tsense HW.

## RegisterMaps
Folder containing the register map from ES1 to implement Tsense SW unit.

## tSenseFixedPointFunctionality
Folder containing matlab scripts which were used to develop Fixed Point algorithm implemeted by driver `function rfeHwTense_getRawTemp()` 