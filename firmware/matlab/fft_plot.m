function [f, P1] = fft_plot(X)
Fs = 1000;
L = length(X);
Y = fft(X);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
if (P1(1) > 30) 
    P1(1) = 30.0;
f = Fs*(0:(L/2))/L;
end