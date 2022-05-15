%% SIMPLE DATA LOGGER
clc
clear all; close all;
 %%  port numbers
    logFile.path = '';
    %logFile.name = ['mmwavelib_windowing16x32.log'];
    logFile.name = ['.log'];
    comPort.data = 4;From9thFloor
    comPort.status = 0;

%% INIT SERIAL PORTS
    %Init Ports
    connectedPorts = instrfind('Type','serial')   % see list of com ports
%%  Data Port Init  
    hDataPort = serial(['COM' num2str(comPort.data)],'BaudRate',921600);
    try 
        set(hDataPort,'InputBufferSize', 2^16);
        set(hDataPort,'Timeout',2); 
        fopen(hDataPort);        
        fprintf([['Serial-COM' num2str(comPort.data)] ' opened. \n']);
    catch ME
        fprintf(['Error: ' ['Serial-COM' num2str(comPort.data)] ' could not be opened! \n']);
        delete(hDataPort);
        hDataPort = -1;
    end
    

%% Init figure 

    bytesBuffer = zeros(1,hDataPort.InputBufferSize);
    bytesBufferLen = 0;

fid = fopen(logFile.name,'w');
tic
b=0;

while (b<25)    

    % get bytes from UART buffer or DATA file
%get num bytes at input buffer
numBytesToRead = get(hDataPort,'BytesAvailable') ;
if numBytesToRead, 
   %read in bytes at serial input buffer  
    [newBytes, byteCount] = fread(hDataPort, numBytesToRead, 'uint8');
    fwrite(fid,newBytes);  % Write binary data
end    
  
b=toc;
end   
fclose(fid);

fclose(hDataPort)
delete(hDataPort)
