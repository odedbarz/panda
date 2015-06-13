   function prioranalyse002_figures
  
close all
clear all     
        % RG1, RG2, RGcomb, JR1, JR2, HH, RO, TH, MW, CK, BK, DM, LJ
   
        
        fnames = {'JR-RG-2012-02-23-0001';'TH-RG-2012-03-09-0001';'RG-JR-2012-02-29-0001';...
                  'RG-RO-2012-03-13-0001';'RG-MW-2012-03-21-0001';...
% 				  'RG-TH-2012-03-15-00001';...
                  'RG-BK-2012-03-21-0001';'RG-CK-2012-03-22-0001';'RG-DM-2012-03-26-0001'};
        
        for ii = 1:length(fnames)
            fname = fnames{ii};
            pa_datadir(['\Prior\' fname(1:end-5)]);
            load(fname); %load fnames(ii) = load('fnames(ii)');
            SupSac      = pa_supersac(Sac,Stim,2,1);
     

%  % Stimulus-Response Plot
        figure(1)
        subplot(3,4,ii)
        pa_loc(SupSac(:,24),SupSac(:,9));
 % Target-Response Overview
        figure(2)
        subplot(3,3,ii)
        pa_bubbleplot(SupSac(:,23),SupSac(:,24),12);
        hold on
        plot(SupSac(:,8),SupSac(:,9),'r.')
        axis([-90 90 -90 90])
        xlabel('Azimuth (deg)')
        ylabel('Elevation (deg)')


%% Elevation

%% Weighted regression
X           = SupSac(:,1);
Y           = SupSac(:,24);
Z           = SupSac(:,9);
sigma       = 5;

% function [Gain,Mu] = getdynamics(X,Y,Z,sigma)

XI              = X;
[Gain,se,xi]    = pa_weightedregress(X,Y,Z,sigma*2,XI);
n       = 400; % 
x       = 1:n;
freq	= 0.002;
sd		= 40*sin(2*pi*freq*x+0.5*pi).^2+5;
sd      = sd/max(sd);

Yb              = abs(Y);
mx              = max(X);
[Mu,sei,xi]    = pa_weightedmean(X,Yb,sigma,XI,'nboot',10);

figure(3)
subplot(3,3,ii)
plot(x,sd,'r','LineWidth',2);
hold on
pa_errorpatch(xi,Gain,se);
% plot(X,abs(Y)./45,'k-','Color',[.7 .7 .7]);
% pa_errorpatch(xi, Mu/20, sei(:,1)/100,'b');
xlim([1 mx])

% [Gain,Mu]   = getdynamics(X,Y,Z,sigma);
title ('Elevation')


% figure
% plot(Gain,Mu,'k.');
% axis square;
% title ('Elevation')
   end

% %%
% sel = isnan(Mu) | isnan(Gain);
% Mu      = Mu(~sel);
% Gain    = Gain(~sel);
% 
% [C,lags] = xcorr(Mu,Gain,100,'coeff');
% [ACm,lags] = xcorr(Mu,Mu,100,'coeff');
% [ACg,lags] = xcorr(Gain,Gain,100,'coeff');
% 
% figure
% 
% subplot(221);
% plot(lags,ACm,'k.-');
% pa_verline;
% xlabel('Lag (# trials)');
% ylabel('Cross-correlation');
% 
% subplot(222);
% plot(lags,ACg,'k.-');
% pa_verline;
% xlabel('Lag (# trials)');
% ylabel('Cross-correlation');
% 
% subplot(212)
% [mx,indx] = max(C);
% plot(lags,C,'k.-');
% pa_verline;
% pa_verline(lags(indx),'r--');
% xlabel('Lag (# trials)');
% ylabel('Cross-correlation');
% title ('Elevation')
% M = lags(indx)
% %% Azimuth 
% 
% %% Weighted regression
% X           = SupSac(:,1);
% Y           = SupSac(:,23);
% Z           = SupSac(:,8);
% sigma       = 5;
% [Gain,Mu]   = getdynamics(X,Y,Z,sigma);
% title ('Azimuth')
% 
% 
% figure 
% plot(Gain,Mu,'k.');
% axis square;
% title ('Azimuth')
% %%
% sel = isnan(Mu) | isnan(Gain);
% Mu      = Mu(~sel);
% Gain    = Gain(~sel);
% 
% [C,lags] = xcorr(Mu,Gain,100,'coeff');
% [ACm,lags] = xcorr(Mu,Mu,100,'coeff');
% [ACg,lags] = xcorr(Gain,Gain,100,'coeff');
% 
% figure 
% subplot(221);
% plot(lags,ACm,'k.-');
% pa_verline;
% xlabel('Lag (# trials)');
% ylabel('Cross-correlation');
% 
% subplot(222);
% plot(lags,ACg,'k.-');
% pa_verline;
% xlabel('Lag (# trials)');
% ylabel('Cross-correlation');
% 
% subplot(212)
% [mx,indx] = max(C);
% plot(lags,C,'k.-');
% pa_verline;
% pa_verline(lags(indx),'r--');
% xlabel('Lag (# trials)');
% ylabel('Cross-correlation');
% title ('Azimuth')
% K = lags(indx)


% % function [Gain,Mu] = getdynamics(X,Y,Z,sigma)
% 
% XI              = X;
% [Gain,se,xi]    = rg_weightedregress(X,Y,Z,sigma*2,XI,'wfun','half');
% n       = 400; % 
% x       = 1:n;
% freq	= 0.01;
% sd		= 40*sin(2*pi*freq*x+0.5*pi).^2+5;
% sd      = sd/max(sd);
% 
% Yb              = abs(Y);
% mx              = max(X);
% [Mu,sei,xi]    = rg_weightedmean(X,Yb,sigma,XI,'nboot',10);
% 
% figure
% subplot(4,4,ii)
% plot(x,sd,'r','LineWidth',2);
% hold on
% pa_errorpatch(xi,Gain,se);
% % plot(X,abs(Y)./45,'k-','Color',[.7 .7 .7]);
% % pa_errorpatch(xi, Mu/20, sei(:,1)/100,'b');
% xlim([1 mx])

