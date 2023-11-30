# RFE FW Memory Map

## RFE-M7 ITCM
Address range: 0x00000000 - 0x0001FFF
Size: 128 kiB = 131.072 bytes  

## RFE-M7 DTCM
Address range: 0x20000000 - 0x200007FFF
Size: 32 kiB = 32.768 bytes  

| Section Name                                  | Base Address | Size [bytes] |
| --------------------------------------------  | ------------ | ------------ |
| Configuration                                 | 0x20000000   | 1024         |
| Dynamic Table                                 | 0x20000400   | 8420         |
| FFT In-Out                                    | 0x200024E4   | 8192         |
| Twiddles                                      | 0x200044E4   | 1108         |
| Global variables                              | 0x20004938   | 2048         |
| Reserved                                      | 0x20005138   | 3784         |
| Static constants                              | 0x20006000   | 4092         |
| Reserved                                      | 0x20006FFC   | 2052         |
| Stack Guard region (bottom of the stack)      | 0x20007800   | 32           |
| Stack (grows down to base)                    | 0x20007820   | 2000         |
| Error status                                  | 0x20007FF0   | 4            |
| Reserved                                      | 0x20007FF4   | 4            |
| End of test and M3SA handshake                | 0x20007FF8   | 8            |
| If changed, needs M3SA Update (DO NOT MODIFY) |              |              |

## System Ram
Address range: 0x33E00000 - 0x34000000  
Size: 2 MiB = 2.097.152 bytes  

### RFE Server-Client Communication Area
Default address range: 0x33FFFC00 - 0x33FFFE20 (User configurable in RFE Driver)  
Size: 544 bytes

| Parameter                  | Relative Base Address | Size [bytes] |
| -------------------------- | --------------------- | ------------ |
| Command buffer             | 0x00000000            | 256          |
| Response buffer            | 0x00000100            | 256          |
| Shared data buffer         | 0x00000200            | 32           |

### RFE Sync Area
Address range: 0x33FFFF80 - 0x34000000  
Size: 128 bytes

| Parameter                  | Base Address | Size [bytes] |
| -------------------------- | ------------ | ------------ |
| Unused                     | 0x33FFFF80   | 112          |
| RFE_ROLE                   | 0x33FFFFF0   | 4            |
| CLK_PLL_STATUS_ADDRESS     | 0x33FFFFF4   | 4            |
| RFE_STATE_ADDRESS          | 0x33FFFFF8   | 4            |
| BASE_ADDRESS_PTR           | 0x33FFFFFC   | 4            |

### Validation Hook Protocol Area (only for rfeFuSaSysValFw)
*This area is only reserved in rfeFuSaSysValFw, not in product rfeFw.*
Address range: 0x33FFF400 - 0x33FFFC00  
Size: 2048 bytes

| Parameter                  | Base Address | Size [bytes] |
| -------------------------- | ------------ | ------------ |
| fccu_status_data           | 0x33FFF400   | 384          |
| HOOK_DTCM_DATA_ADDRESS     | 0x33FFFBFC   | 4            |

### Adaptations for OC SHARK PoC (only for rfeOcSharkPocFw)
#### RFE Server-Client Communication Area
Address range: Fixed location at the beginning of RFE-M7 DTCM
Size: 544 bytes

| Parameter                  | Base Address | Size [bytes] |
| -------------------------- | ------------ | ------------ |
| Command buffer             | 0x20000000   | 256          |
| Response buffer            | 0x20000100   | 256          |
| Shared data buffer         | 0x20000200   | 32           |

#### RFE-M7 DTCM
Address range: 0x20000000 - 0x200008000  
Size: 32 kiB = 32.768 bytes  

| Section Name                                  | Base Address | Size [bytes] |
| --------------------------------------------  | ------------ | ------------ |
| RFE Server-Client Communication Area          | 0x20000000   | 544          |
| Dynamic Table                                 | 0x20000220   | 8420         |
| ... Remaining RFE FW DATA ...                 | 0x20002308   | ...          |

