function [TFR,fridge,tridge,lridge] = myridges(signal,fs,fmin,fmax,N,k,envelope,freqband,numridge)
%   Example:
%       myridges(y,fs, 0.01, 50, 1024, 20/pi, 1, [0 fm/2])

TFR = TFRscalogram(detrend(signal),fs,fmin,fmax,N,k,envelope,freqband,0);
% Get info from TFR struct 
f_scal = TFR.f;
t_scal = TFR.t;
SCAL = TFR.TFR;

% Parameter Ridges
deltaf=diff(f_scal(1:2));
fdetection=50; %no ridges will be detected between +-fdetection Hz
nfb=ceil(fdetection/deltaf);

penval=0;
if numridge >= 2
    [fridge,iridge,lridge] = tfridge(SCAL,f_scal,penval,'NumRidges',numridge,'NumFrequencyBins',nfb);
else 
    [fridge,iridge,lridge] = tfridge(SCAL,f_scal,penval,'NumFrequencyBins',nfb);
end
% Visualization
subplot(2,1,1)
imagesc(t_scal,f_scal,SCAL) %plot Scalogram 
set(gca,'YDir','normal')
set(gca,'XLim',[t_scal(1) t_scal(end)])
YL = [0 300];
hold on   
plot(t_scal,fridge,'w'),xlabel('t[s]'),ylabel('f[Hz]'),title('Exponential envelope - Frequency of  the main ridge')
set(gca,'YLim',YL)
hold off

subplot(2,1,2)
plot(t_scal,SCAL(lridge)),xlabel('t[s]'),ylabel('[V^2/Hz]'),title('Exponential envelope - Peak value of the main ridge')
end