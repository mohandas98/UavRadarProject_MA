function [y] = getInt16(data)
%       This function coverts 2 bytes to a 16-bit unsigned integer.

    y =  (data(1) +  data(2)*256 );     
    y(y>32767)=y(y>32767)-65536;
    