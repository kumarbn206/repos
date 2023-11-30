// Check error masked status registers for all IPs

sleep_rv(ISM.TX_ERR_MASKED_STATUS1,0xFFFFFF);
sleep_rv(ISM.TX_ERR_MASKED_STATUS2,0x7FFFFF);
sleep_rv(ISM.RX_ERR_MASKED_STATUS2,0xFFFFF);
sleep_rv(ISM.RX_ERR_MASKED_STATUS3,0xFFFFF);
sleep_rv(ISM.CHIRP_ERR_MASKED_STATUS,0x37FFFFFF);              // Please check all expected flags and update read bits accordingly.
sleep_rv(ISM.MCGEN_ADPLL_ERR_MASKED_STATUS1,0xFFFCFFFF);
sleep_rv(ISM.MCGEN_ADPLL_ERR_MASKED_STATUS2,0xFF);
sleep_rv(ISM.LO_SPIM_ISM_ERR_MASKED_STATUS,0xFFFFFFF);
sleep_rv(ISM.RXBIST_ERR_MASKED_STATUS,0x7FF);
sleep_rv(ISM.GB_GLDO_ERR_MASKED_STATUS,0x3FFFF);
sleep_rv(ISM.ATB_TE_RCOSC_ERR_MASKED_STATUS,0xFFFF7FF);
sleep_rv(ISM.LDO_DIG_LDO_PDC_ERR_MASKED_STATUS,0xFFFF);
sleep_rv(ISM.ADC_ERR_MASKED_STATUS5,0xFFFFFFF);
sleep_rv(ISM.PDC_ERR_MASKED_STATUS,0xFFFFFF);
sleep_rv(ISM.TEMPSENSOR_ERR_MASKED_STATUS1,0x3FFFFFC);
sleep_rv(ISM.TEMPSENSOR_ERR_MASKED_STATUS2,0xFF);
sleep_rv(ISM.M7_RFEACCESS_CMU_CSI2_PACKER_ERR_MASKED_STATUS,0x1FFFFFFF);
sleep_rv(ISM.MASTER_ERR_MASKED_STATUS1,0x3FFFFFFF);
sleep_rv(ISM.MASTER_ERR_MASKED_STATUS2,0x1FFF3A);
sleep_rv(ISM.MASTER_ERR_MASKED_STATUS3,0x3FFFFFFD);
sleep_rv(ISM.REG_CRC_ERR_MASKED_STATUS1,0x3FFCFFFF);
sleep_rv(ISM.REG_CRC_ERR_MASKED_STATUS2,0x7F);
sleep_rv(ISM.MOSI_CRC_ERR_MASKED_STATUS1,0x3FFCFFFF);
sleep_rv(ISM.MOSI_CRC_ERR_MASKED_STATUS2,0x7F);
sleep_rv(ISM.MISO_CRC_ERR_MASKED_STATUS1,0x3FFCFFFF);
sleep_rv(ISM.MISO_CRC_ERR_MASKED_STATUS2,0x7F);

