function output = PerformWindowing(input,win)

% Description : Multiplies a 16 bit complex vector with a 32 bit real
% symmetric window vector, The result is stored as a 32 bit complex vector,
% with swapped Re/Im order compared with the input signal.
% The math is as follows: output_real[n]=round(input_real[n]*window[n]/2^15); 
% output_imag[n]=round(input_imag[n]*window[n]/2^15)

%input is complex
input=input.';
output=(input.*win)./(2^15);


end

