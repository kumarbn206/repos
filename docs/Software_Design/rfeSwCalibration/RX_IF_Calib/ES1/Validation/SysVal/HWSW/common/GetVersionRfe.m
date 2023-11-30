function [OutputStruct] = GetVersionRfe(InputStruct)

[error_code, hw_type, hw_variant, hw_version, fw_variant, fw_version_released, fw_version_major, fw_version_minor, fw_version_patch, fw_hash] = rfeabstract.rfe_getVersion;

OutputStruct.error = error_code;
OutputStruct.hwType = hw_type;
OutputStruct.hw_variant = hw_variant;
OutputStruct.hw_version = hw_version;
OutputStruct.fw_variant = fw_variant;
OutputStruct.fw_version_released = fw_version_released;
OutputStruct.fw_version_major = fw_version_major;
OutputStruct.fw_version_minor = fw_version_minor;
OutputStruct.fw_version_patch = fw_version_patch;
OutputStruct.fw_hash = fw_hash;

if (~error_code)
    if (fw_version_released)
        fprintf("RFE FW Version: %u.%u.%u.%u\n", fw_version_major, fw_version_minor, fw_version_patch,(fw_hash) );
    else
        fprintf("RFE FW Version: %08x\n", fw_hash );
    end
else
    return
end

