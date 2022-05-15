clc;clear all; close all;
%fname = 'xwr18xx_processed_stream_2022_02_17T12_58_39_243.dat';
%fname = 'mm_demo_try1.log';
fname='From9thFloor.log';

%fname='RadarCube_Counting.log';
fid = fopen(fname,'r');
a= fread(fid);
fclose(fid)

%% Output text file
RadarCubeCtr=1;


% Parse
indStart = findsubarr(a',[2 1 4 3 6 5 8 7]);

BatchCounter=0;

for i=1:length(indStart),

    SIdx=indStart(i);

    %read version
    version(i) = getUint32(a(SIdx-1+9:SIdx-1+12));

    %skip 44;
    index=SIdx+44;
    %Read length of payload in bytes

    payloadLength=getUint32(a(index:1:index+3));
    index=index+4; 
    
    if(version(i)==BatchCounter)
        %Print remaining to a file
        for k=1:1:payloadLength
            
            MaRadarCubeRaw(RadarCubeCtr)=a(index);            
            index=index+1;
            RadarCubeCtr=RadarCubeCtr+1;
        end
        
        BatchCounter=BatchCounter+1;
        
        if(BatchCounter>31)            
            break;            
        end
        
    end


end



%Convert to complex (4 bytes per complex)
N=length(MaRadarCubeRaw)/4;
i=1;
for k=1:1:N
    
    a=MaRadarCubeRaw(i);
    b=MaRadarCubeRaw(i+1);
    fReal=getInt16([a b]);
    
    a=MaRadarCubeRaw(i+2);
    b=MaRadarCubeRaw(i+3);
    fImag=getInt16([a b]);
    i=i+4;
    
    RadarCubeCpx(k)=fReal + 1i*fImag;
    
end

%Overwrite so that other files can use the same variable name
MaRadarCubeRaw=RadarCubeCpx;

save('MaRadarCubeRaw.mat','MaRadarCubeRaw')

%save MaRadarCubeRaw to a .mat file


%end


