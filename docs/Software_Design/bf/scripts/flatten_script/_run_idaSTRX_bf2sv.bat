@ECHO OFF
REM  ----------------------------------------------------------------------------
REM					 Copyright Message
REM  ----------------------------------------------------------------------------
REM
REM  CONFIDENTIAL and PROPRIETARY
REM  COPYRIGHT (c) NXP B.V. 2020
REM
REM  All rights are reserved. Reproduction in whole or in part is
REM  prohibited without the written consent of the copyright owner.
REM
REM  CoReUse 5.0 information header.
REM
REM  ----------------------------------------------------------------------------
REM					Design Information
REM  ----------------------------------------------------------------------------
REM
REM  Organisation	   : BL RFP
REM
REM  File			   : _run_idaSTRX_bf2sv.bat
REM  Date			   : Date: Tue Nov 30 22:25:49 2021
REM  Revision		   : Revision: 1.0
REM
REM  Description	   :
REM
REM  Author		       : Salvatore Drago
REM  Project		   : STRX-Onechip
REM
REM  ----------------------------------------------------------------------------
REM					 Revision History
REM  ----------------------------------------------------------------------------
REM  $Log: _run_idaSTRX_bf2sv.bat.rca $
REM  
REM   Revision: 1.3 Wed Dec  1 20:45:25 2021 nlv17256
REM   Salvo: fixing some typo
REM  
REM   Revision: 1.2 Wed Dec  1 08:16:54 2021 nlv17256
REM   Salvo added idaSTRX_Init.bf
REM  
REM   Revision: 1.1 Tue Nov 30 22:25:49 20211 nlv17256
REM   Salvo: first version of utility 
REM  
REM  ----------------------------------------------------------------------------



TITLE STRX flatten bitfield scripts
ECHO convertion on going ...
REM call python idaSTRX_bf2sv_local.py .\..\..\ .\..\..\idaStrxExamples\sv_library\ .\idaStrxExamples\idaStrxSx_76G_CW_to_RFATB.bf
call python idaSTRX_bf2sv.py .\..\..\ .\..\..\idaStrxTopLevel\sv_library\ .\idaStrxTopLevel\idaSTRX_Init.bf
@ECHO ON
pause