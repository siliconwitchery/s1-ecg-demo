figure();
subplot(2,2,1)
[f, P] = fft_plot(rest1);
plot(f, P)
title('Amplitude Spectrum of raw signal')
xlabel('f (Hz)')
ylabel('|P1(f)|')
subplot(2,2,2)
plot(rest1);

subplot(2,2,3)
filtered = notch_filt(rest1);
[f, P] = fft_plot(filtered);
plot(f, P)
title('Amplitude Spectrum of filtered signal')
xlabel('f (Hz)')
ylabel('|P1(f)|')
subplot(2,2,4)
plot(filtered);