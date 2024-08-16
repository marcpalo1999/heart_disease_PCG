function myscalogram(signal, fs, fmin, fmax, N, window, k, signaltype, windowtype)
% k input is a vector
%signaltype is a string for the title 
%Idem for signal type 
penval=1;
NFFT=N;


figure()
sgtitle(['Scalogram of ' signaltype ' signal with a ' windowtype ' envelope ']);

for element = 1:length(k)
    TFR=TFRscalogram(detrend(signal),fs,fmin,fmax,NFFT,k(element),window,[],0);
    SCAL=TFR.TFR;
    f=TFR.f;
    t=TFR.t;
    subplot(length(k),1,element)
    imagesc(t,f,SCAL)
    xlabel('t[s]'),ylabel('f[Hz]')
    tit= strcat(num2str(k(element)));
    title(['k =' tit])
    set(gca,'YDir','normal')
    set(gca,'XLim',[t(1) t(end)])
    YL=[0 fmax];
    set(gca,'YLim',YL)
end

end