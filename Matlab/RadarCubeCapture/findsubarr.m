function [inds]=findsubarr(arr,pattern);
% Returns indices of pattern matches in arr
% both 1 d

n=length (arr);
m=length(pattern);
inds=[];
for i=1:n-m+1,
    if sum(arr(i:i+m-1)==pattern)==m,
        inds=[inds i];
    end
end
