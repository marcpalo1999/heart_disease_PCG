function [Pxx_w]=mypwelchD(signal, t, fs, d, titulo)

D=d*fs;


figure(), clf
sgtitle(titulo)
for element =1:length(D)
NFFT=2^12;
S=D(element)-1;
[Pxx_w,f_w]=pwelch(detrend(signal),D(element),S,NFFT,fs,'onesided'); %Power per frequency

subplot(2,2,element)
hold on
title(['Window size ' num2str(D(element)/fs) '[s]'])
plot(f_w,Pxx_w)
xlabel('f'),ylabel('V^2/Hz')
xlim([0 250])
hold off

end 

end