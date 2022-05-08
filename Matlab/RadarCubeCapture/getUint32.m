function [y] = getUint32(data)
%       This function coverts 4 bytes to a 32-bit unsigned integer.

    y =  (data(1) +  data(2)*256 + data(3)*65536 + data(4)*16777216);