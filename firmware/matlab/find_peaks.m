function [peaks, idx] = find_peaks(u)
peaks = zeros(3,1);
idx = zeros(3,1);
[peaks, idx] = findpeaks(u, 'Npeaks', 3, 'MinPeakDistance', 3);
end