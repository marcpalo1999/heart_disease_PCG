function [Pxx_w]=mypwelchS(signal, t, fs, d, s, titulo)
%A vector of S should be introduced and a number for d. S should be the
%proportion from 0 to 1 of D that will be overlapped
D=d*fs;
S = s*D;

figure()
sgtitle(titulo)
for element =1:length(S)
NFFT=2^12;

[Pxx_w,f_w]=pwelch(detrend(signal),D,S(element),NFFT,fs,'onesided'); %Power per frequency

subplot(2,2,element)
hold on
title(['Overlapping of ' num2str(s(element)*100) '% over ' num2str(d) '[s] of window'])
plot(f_w,Pxx_w)
xlabel('f'),ylabel('V^2/Hz')
xlim([0 250])
hold off

end 

end

