function psdparameters=psdpar(Pxx,f,showfigure)

%  function psdparameters=psdpar(Pxx,f)
%
% Performs the calculation of the parameters of the PSD characterized by its vectors Pxx and f. 
%
% The PSD parameters obtained are:
% 
% - the median or central frequency (fmedian)
% - the average frequency (fmean),
% - the peak frequency (fpeak)
% - the frequency of the first quartile (fq25),
% - the frequency of the third quartile (fq75) 
% - the frequency with 95% of the energy (fmax95)
% - the standard deviation of the Pxx (fstd)
% - the interquartile range (fiqr)
% - the standardised Shannon entropy of distribution (hShannon)
% - the coefficient of skewness/asymmetry (cAssymmetry)
% - the Kurtosis/tailedness coefficient (cKurtosis)
% 

if nargin<1,
    NFFT=pow2(12);
    f=(0:NFFT)/NFFT*0.5;
    Pxx=f.*exp(-20*f);    
elseif nargin<2,
    NFFT=length(Pxx);
    f=(0:NFF^T)/NFFT*0.5;
end
if nargin<3,showfigure=1;end

Pxx=Pxx(:)';f=f(:)';
%========================================================
% Peak frequency (maximum of the PSD):
[maximo,posmaximo]=max(Pxx);
fpeak=f(posmaximo);
%========================================================
% Mean frequency:
sumfPxx=sum(f.*Pxx);
sumPxx=sum(Pxx);
fmean=sumfPxx/sumPxx;
%========================================================
% Median or central frequency:
normalized_cumsumPxx=cumsum(Pxx)/sumPxx;
[minimo,posminimo]=min(abs(normalized_cumsumPxx-0.5));
fmedian50=f(posminimo);
%========================================================
% Frequency of the first quartile:
[minimo,posminimo]=min(abs(normalized_cumsumPxx-0.25));
fq25=f(posminimo);
%========================================================
% Frequency of the third quartile:
[minimo,posminimo]=min(abs(normalized_cumsumPxx-0.75));
fq75=f(posminimo);
%========================================================
% Maximum frequency (90%):
[minimo,posminimo]=min(abs(normalized_cumsumPxx-0.95));
fmax95=f(posminimo);
%========================================================
% DISPERSION PARAMETERS:
% Standard deviation of the PSD:
sumf2Pxx=sum(((f-fmean).^2).*Pxx);
fstd=sqrt(sumf2Pxx/sumPxx);
%========================================================
% Interquartilic range:
fiqr=fq75-fq25;
%========================================================
% "SHAPE" PARAMETERS:
% Shannon entropy  
% (1 if flat distribution, 0 if "impulse" distribution):
p=Pxx/sumPxx;
h=-sum(p(p>0).*log(p(p>0)));
hShannon=h/log(length(p));
%========================================================
% Skewness/asymmetry coeficient:
% (0 if it is symmetric, positive if it is skewed at low frequencies
%     and negative if it is skewed at low frequencies; 
%     the value will be higher if the PSD is very skewed)
sumf3Pxx=sum(((f-fmean).^3).*Pxx);
mm3=sumf3Pxx/sumPxx;
cAsymmetry=mm3/(fstd^3);
%========================================================
% Kurtosis/tailedness coeficient:
sumf4Pxx=sum(((f-fmean).^4).*Pxx);
mm4=sumf4Pxx/sumPxx;
cKurtosis=mm4/(fstd^4)-3;
%========================================================

psdparameters.fpeak=fpeak;
psdparameters.fmean=fmean;
psdparameters.fmedian50=fmedian50;
psdparameters.fq25=fq25;
psdparameters.fq75=fq75;
psdparameters.fmax95=fmax95;
psdparameters.fstd=fstd;
psdparameters.fiqr=fiqr;
psdparameters.hShannon=hShannon;
psdparameters.cAsymmetry=cAsymmetry;
psdparameters.cKurtosis=cKurtosis;

if showfigure,
    APPLICATION='Chapter 4.3: PSD parameters';
    [existFlag,figNumber]=figflag(APPLICATION);
    if ~existFlag,
        figNumber=figure('Name',APPLICATION,'NumberTitle','off')
    else,
        figure(figNumber),clf
    end
    
    plot(f,Pxx,'k')
    set(gca,'XLim',f([1 end]))
    title('PSD parameters')
    xlabel('f(Hz)')
    ylabel('Pxx(f) [V^2s]')
    
    YL=get(gca,'YLim');
    hold on
    plot(fpeak*[1 1],YL,'--r')
    plot(fmean*[1 1],YL,'--g')
    plot(fmedian50*[1 1],YL,'--b')
    plot(fq25*[1 1],YL,'-.k')
    plot(fq75*[1 1],YL,'-.k')
    plot(fmax95*[1 1],YL,'--k')
    plot(fstd/2*[-1 1]+fmean,YL(1)+0.5*range(YL)*[1 1],'-og')
    plot([fq25 fq75],YL(1)+0.25*range(YL)*[1 1],'-^k')
    plot(f(1),Pxx(1),'dk','Visible','off')
    plot(f(1),Pxx(1),'sk','Visible','off')
    plot(f(1),Pxx(1),'pk','Visible','off')
    hold off
    legendtext=['Pxx(f)'];
    addtext=['Peak frequency: ' num2str(fpeak) ' Hz'];
    legendtext=str2mat(legendtext,addtext);
    addtext=['Mean frequency: ' num2str(fmean) ' Hz'];
    legendtext=str2mat(legendtext,addtext);
    addtext=['Median frequency: ' num2str(fmedian50) ' Hz'];
    legendtext=str2mat(legendtext,addtext);
    addtext=['Frequency of the first quartile: ' num2str(fq25) ' Hz'];
    legendtext=str2mat(legendtext,addtext);
    addtext=['Frequency of the third quartile: ' num2str(fq75) ' Hz'];
    legendtext=str2mat(legendtext,addtext);
    addtext=['Maximum frequency (95%): ' num2str(fmax95) ' Hz'];
    legendtext=str2mat(legendtext,addtext);
    addtext=['Standard deviation of the PSD: ' num2str(fstd) ' Hz'];
    legendtext=str2mat(legendtext,addtext);
    addtext=['Interquartilic range (fq75-f25): ' num2str(fiqr) ' Hz'];
    legendtext=str2mat(legendtext,addtext);
    addtext=['Normalized Shannon entropy: ' num2str(hShannon)];
    legendtext=str2mat(legendtext,addtext);
    addtext=['Skewness coef.: ' num2str(cAsymmetry)];
    legendtext=str2mat(legendtext,addtext);
    addtext=['Kurtosis coef.: ' num2str(cKurtosis)];
    legendtext=str2mat(legendtext,addtext);
    legend(legendtext,'FontSize',12)
end

