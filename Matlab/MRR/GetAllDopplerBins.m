function dstPingPong = GetAllDopplerBins(rangeIdx,rxAntIdx)

global numDopplerBins radarcube


d4=1; % Fast=1, Slow =2;

%dstPingPong=complex(zeros(1,numDopplerBins));


dstPingPong=squeeze(radarcube(1:numDopplerBins,rxAntIdx,d4,rangeIdx));

% for k=1:1:numDopplerBins
%         
%     dstPingPong(k)=radarcube(k,rxAntIdx,d4,randeIdx);
%         
% end



end



