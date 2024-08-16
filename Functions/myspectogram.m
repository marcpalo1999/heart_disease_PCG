function myspectogram(signal,fs,t,D, type, umbral, penval, Nridges, fdetection, reassign, signaltype, windowtype)

NFFT=2^max([10 nextpow2(D)]);




figure()

sgtitle(['Spectrogram of ' signaltype ' signal with a ' windowtype ' window ']);
subplot(length(D)+1,1,1)
plot(t,signal)
xlim([t(1) t(end)])

for i =1:(length(D))

S= 0.5*D(i);

if type == 0
    window=hamming(D(i));
end
if type == 1
    window=rectwin(D(i));
end


if umbral ~= 0 && reassign ==1 %Both cases are met
[STFT,f,tSTFT,SPEC]=spectrogram (signal,window,S,NFFT,fs,'reassigned','MinThreshold',umbral);
elseif umbral ~= 0 && reassign ==0 %Only umbral
[STFT,f,tSTFT,SPEC]=spectrogram (signal,window,S,NFFT,fs,'MinThreshold',umbral);
elseif umbral == 0 && reassign ==1 %Only reassigned
[STFT,f,tSTFT,SPEC]=spectrogram (signal,window,S,NFFT,fs,'reassigned');
elseif umbral == 0 && reassign ==0 %none
[STFT,f,tSTFT,SPEC]=spectrogram (signal,window,S,NFFT,fs);
end

subplot(length(D)+1,1,i+1)
imagesc(t,f,SPEC) %Genera una images escalada entre 0 i e maximo de el SPEC
hold on
title(['D = ' num2str(D(i)/fs) 'seconds'])
ylabel('f[Hz]')
set(gca,'YDir','normal')
set(gca,'XLim',[t(1) t(end)])
hold off
%YL=[0 0.5];
%set(gca,'YLim',YL)

end

end