function [s,t,fs,player]=leerwav(recordName)

if nargin<1
recordName = uigetfile('*.wav');
end

info=audioinfo(recordName);
fs=info.SampleRate;
N=info.TotalSamples;
nBits=info.BitsPerSample;

s=audioread(recordName);

s=resample(s,1000,fs);
fs=fs*1000/fs;
N=length(s);

figure(1)
t=(0:N-1)/fs;
plot(t,s)
axis tight
xlabel('t(s)')
title(recordName)


player=audioplayer(s,fs,nBits);
play(player)

