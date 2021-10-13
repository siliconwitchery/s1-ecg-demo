function y = notch_filt(x)
%DOFILTER Filters input x and returns output y.

% MATLAB Code
% Generated by MATLAB(R) 9.10 and DSP System Toolbox 9.12.
% Generated on: 23-Aug-2021 14:18:28

persistent Hd;

if isempty(Hd)
    
    N     = 10;    % Order
    F0    = 69;    % Center frequency
    BW    = 8;     % Bandwidth
    Apass = 1;     % Passband Ripple (dB)
    Astop = 30;    % Stopband Attenuation (dB)
    Fs    = 1000;  % Sampling Frequency
    
    h = fdesign.notch('N,F0,BW,Ap,Ast', N, F0, BW, Apass, Astop, Fs);
    
    Hd = design(h, 'ellip', ...
        'SOSScaleNorm', 'Linf');
    
    
    
    set(Hd,'PersistentMemory',true);
    
end

y = filter(Hd,x);

