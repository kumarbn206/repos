function StartProxyRfe(InputStruct)

Proxy_loc = InputStruct.Proxy_loc;
Proxyfilename = strcat(Proxy_loc,'\StartProxy.bat &');

addpath(genpath(Proxy_loc));

disp('Run RFE Proxy');
system(Proxyfilename);

end