function rip_methodsfigure

clear all
close all
clc

pa_datadir;
cd('Ripple');
subs = [1 2 4 5 6 8 9 10 13 14 15 16 17 18 19 21];
sub = subs(4);
[~,V,~] = mk_audiomotor_getdata_condition(sub,'left','left');

vel = unique(abs(V.v));
uperiod = 1./vel;

disp(vel);
disp(uperiod);
	Fs		= 48828.125; % Freq (Hz)

nvel = numel(vel)
nFreq	= 128;

md = 100;
durrip = 3000;
durstat = 1000;
nTime   = round( (durrip/1000)*Fs ); % # Samples for Rippled Noise
time	= ((1:nTime)-1)/Fs; % Time (sec)
nTime   = round( (durstat/1000)*Fs ); % # Samples for Rippled Noise
b = ones(1,nTime);

for ii = 1:nvel
	snd = pa_genripple(vel(ii),0,md,durrip,durstat);
	T			= 2*pi*vel(ii)*time;
	a		= 1+md/100*sin(T);
	a = [b a];
	a = a*0.3;
	t = (0:length(snd)-1)/Fs;
	subplot(211)
	plot(t,snd+2*ii,'k-','Color',[.7 .7 .7]);
	hold on
	plot(t,a+2*ii,'k-','LineWidth',2);
	drawnow
	
		snd = pa_genripple(-vel(ii),0,md,durrip,durstat);
	T			= 2*pi*vel(ii)*time;
	a		= 1-md/100*sin(T);
	a = [b a];
	a = a*0.3;
	t = (0:length(snd)-1)/Fs;
	subplot(212)
	plot(t,snd+2*ii,'k-','Color',[.7 .7 .7]);
	hold on
	plot(t,a+2*ii,'k-','LineWidth',2);
	drawnow
end
for ii = 1:2
	subplot(2,1,ii)
xlabel('Time (s)');
ylabel('Amplitude');
box off
ylim([0 22]);
set(gca,'YTick',[],'XTick',0:4);
pa_verline(1);
end
pa_datadir
print('-depsc','-painter',mfilename);

function mk_audiomotor_analysis
close all
clc

pa_datadir;
cd('Ripple');
subs = [1 2 4 5 6 8 9 10 13 14 15 16 17 18 19 21];
nsubs = numel(subs)
sub = subs(4);
[R,V,ND] = mk_audiomotor_getdata_condition(sub,'left','left');
% [R,V,ND] = mk_audiomotor_getdata_condition(sub,'right','right');

%% Plot effect of static duration
figure(1)
plot(R.dur,R.rt,'ko-')
set(gca, 'XTick',R.dur);
ylabel('Mean reaction Time (ms)','fontsize',16);
xlabel('Static Duration','fontsize',16);
title('Effect of static duration','fontsize',16);

%% Plot timecourse reaction time
figure(2)
subplot(211)
plot(R.x50,R.rt50,'k-');
% hold on
% plot(R.x50,smooth(R.rt50,50),'r-','LineWidth',2);
str = ['Modulationdepth = 50; RT = ' num2str(round(V.smu50)) ' \pm ' num2str(round(V.sse50)) ' ms'];
ylim([200 1200]);
ylabel('Reaction Time (ms)','fontsize',16);
xlabel('Trial number','fontsize',16);
title(str,'fontsize',16);
subplot(212)
plot(R.x100,R.rt100,'k-');
% hold on
% plot(R.x100,smooth(R.rt100,50),'r-','LineWidth',2);
str = ['Modulationdepth = 100; RT = ' num2str(round(V.smu100)) ' \pm ' num2str(round(V.sse100)) ' ms'];
ylim([200 1200]);
ylabel('Reaction Time (ms)','fontsize',16);
xlabel('Trial number','fontsize',16);
title(str,'fontsize',16);

%% Plot histogram of reaction time
figure(3)
subplot(121)
hist(R.rt50,0:10:10000);
axis square;
xlabel('Reaction time (ms)','fontsize',16);
ylabel('N','fontsize',16);
xlim([0 1000]);
title('Modulationdepth = 50','fontsize',16);
subplot(122)
hist(R.rt100,0:10:10000);
axis square;
xlabel('Reaction time (ms)','fontsize',16);
ylabel('N','fontsize',16);
xlim([0 1000]);
title('Modulationdepth = 100','fontsize',16);

%% Plot not detected
col = cool(4);

figure(4)
subplot(121)
plot(V.v, ND.ndt(1,:),'ko-','LineWidth',2,'MarkerFaceColor','w','Color',col(1,:))
hold on
plot(V.v, ND.ntr(1,:),'ro')
% set(gca, 'XTick',[-64 -42.667 -21.333 0 21.333 42.667 64],'XTickLabel',[vel(1) vel(3) vel(5) vel(7) vel(9) vel(11) vel(13)],'fontsize',14);
ylabel('Not detected','fontsize',16);
xlabel('Velocity (Hz)','fontsize',16);
axis square
title('Not Detected; Modulationdepth = 50;','fontsize',16);
subplot(122)
plot(V.v, ND.ndt(2,:),'ko-','LineWidth',2,'MarkerFaceColor','w','Color',col(2,:))
hold on
plot(V.v, ND.ntr(2,:),'ro')
% set(gca, 'XTick',[-64 -42.667 -21.333 0 21.333 42.667 64],'XTickLabel',[vel(1) vel(3) vel(5) vel(7) vel(9) vel(11) vel(13)],'fontsize',14);
ylabel('Not detected','fontsize',16);
xlabel('Velocity (Hz)','fontsize',16);
axis square
title('Not Detected; Modulationdepth = 100','fontsize',16);

%% Plot mean rt
figure(5)
errorbar(abs(1./V.v(1:10)),V.mu(1,1:10),V.se(1,1:10),'ko-','LineWidth',2,'MarkerFaceColor','w','Color',col(1,:));
hold on
errorbar(1./V.v(11:19),V.mu(1,11:19),V.se(1,11:19),'ko-','LineWidth',2,'MarkerFaceColor','w','Color',col(2,:));
hold on
errorbar(abs(1./V.v(1:10)),V.mu(2,1:10),V.se(2,1:10),'ko-','LineWidth',2,'MarkerFaceColor','w','Color',col(3,:));
hold on
errorbar(1./V.v(11:19),V.mu(2,11:19),V.se(2,11:19),'ko-','LineWidth',2,'MarkerFaceColor','w','Color',col(4,:));
% set(gca, 'XTick',[-64 -42.667 -21.333 0 21.333 42.667 64],'XTickLabel',[vel(1) vel(3) vel(5) vel(7) vel(9) vel(11) vel(13)],'fontsize',14);
ylabel('Reaction Time (ms)','fontsize',16);
xlabel('Modulation frequency (Hz)','fontsize',16);
legend({'md = 50, -', 'md = 50, +', 'md = 100, -', 'md = 100, +'},'Location','NW');
% axis square
% set(gca,'XScale','log');

vel = unique(abs(V.v));
uperiod = 1./vel;
[uperiod,indx] = sort(uperiod);
vel = vel(indx);
set(gca,'XTick',uperiod,'XTickLabel',vel);
ylim([0 1000]);

function [snd,Fs] = pa_genripple(vel,dens,md,durrip,durstat,varargin)
% [SND,FS] = PA_GENRIPPLE(VEL,DENS,MOD,DURDYN,DURSTAT)
%
% Generate a ripple stimulus with velocity (amplitude-modulation) VEL (Hz),
% density (frequency-modulation) DENS (cyc/oct), and a modulation depth MOD
% (0-1). Duration of the ripple stimulus is DURSTAT+DURRIP (ms), with the first
% DURSTAT ms no modulation occurring.
%
% These stimuli are parametrized naturalistic, speech-like sounds, whose
% envelope changes in time and frequency. Useful to determine
% spectro-temporal receptive fields.  Many scientists use speech as
% stimuli (in neuroimaging and psychofysical experiments), but as they are
% not parametrized, they are basically just using random stimulation (with
% random sentences).  Moving ripples are a complete set of orthonormal
% basis functions for the spectrogram.
%
% See also PA_GENGWN, PA_WRITEWAV

% 2011 Marc van Wanrooij
% e-mail: marcvanwanrooij@neural-code.com
%
% Acknowledgements:
% Original script from Huib Versnel and Rob van der Willigen
% Original fft-script from NLS tools (Powen Ru)

%% Initialization
if nargin<1
	vel = -4; % (Hz)
end
if nargin<2
	dens = 0; % (cyc/oct)
end
if nargin<3
	md = 100; % Percentage (0-100%)
end
if nargin<4
	durrip = 1000; %msec
end
if nargin<5
	durstat = 500; %msec
end

%% Optional arguments
dspFlag       = pa_keyval('display',varargin);
if isempty(dspFlag)
	dspFlag	= 0;
end
plee       = pa_keyval('play',varargin);
if isempty(plee)
	plee	= 'n';
end
Fs         = pa_keyval('freq',varargin);
if isempty(Fs)
	Fs		= 48828.125; % Freq (Hz)
end
meth        = pa_keyval('method',varargin);
if isempty(meth)
	meth			= 'time';
	% meth = 'fft' works slightly faster
end
if strcmp(meth,'fft') % fft method is not defined for negative densities
	if dens<0
		dens	= -dens;
		vel		= -vel;
	end
end
md			= md/100; % Gain (0-1)

%% According to Depireux et al. (2001)
nFreq	= 128;
FreqNr	= 0:1:nFreq-1;
% F0		= 2^(2*log2(250));
F0		= pa_oct2bw(250,0);
df		= 1/20;
Freq	= F0 * 2.^(FreqNr*df);
Oct		= FreqNr/20;                   % octaves above the ground frequency
Phi		= pi - 2*pi*rand(1,nFreq); % random phase
Phi(1)	= pi/2; % set first to 0.5*pi
% Phi = zeros(1,nFreq);

%% Sounds
switch meth
	case 'time'
		rip		= genrip(vel,dens,md,durrip,durstat,Fs,nFreq,Freq,Oct,Phi);
	case 'fft'
		rip		= genripfft(vel,dens,md,durrip,Fs,df);
end
if durstat>0 % if required, construct a static part of the noise, and prepend
	stat	= genstat(durstat,Fs,nFreq,Freq,Phi);
	% Normalize ripple power to static power
	nStat		= numel(stat);
	% 	rms_stat	= norm(stat/sqrt(nStat));
	% 	rms_rip		= norm(rip/sqrt(numel(rip)));
	% 	ratio		= rms_stat/rms_rip;
	% 	snd			= [stat ratio*rip];
	snd = [stat rip];
else
	nStat	= 0;
	snd		= rip;
end

%% Normalization
% Because max amplitude should not exceed 1
% So set max amplitude ~= 0.8 (44/55)
snd			= snd/55; % in 3 sets of 500 trials, mx was 3 x 44+-1

%% Graphics
if dspFlag
	plotspec(snd,Fs,nStat,Freq,durstat);
end

%% Play
if strcmpi(plee,'y');
	sndplay = pa_envelope(snd',round(10*Fs/1000));
	p		= audioplayer(sndplay,Fs);
	playblocking(p);
end

function plotspec(snd,Fs,nStat,Freq,durstat)
close all;
t = (1:length(snd))/Fs*1000;
subplot(221)
plot(t,snd,'k-')
ylabel('Amplitude (au)');
ylabel('Time (ms)');
xlim([min(t) max(t)]);
hold on

subplot(224)
pa_getpower(snd(nStat+1:end),Fs,'orientation','y');
set(gca,'YTick',[0.5 1 2 4 8 16]*1000);
set(gca,'YTickLabel',[0.5 1 2 4 8 16]);
ylim([min(Freq) max(Freq)])
ax = axis;
xlim(0.6*ax([1 2]));
set(gca,'YScale','log');

subplot(223)
nsamples	= length(snd);
t			= nsamples/Fs*1000;
dt			= 5;
nseg		= t/dt;
segsamples	= round(nsamples/nseg); % 12.5 ms * 50 kHz = 625 samples
noverlap	= round(0.7*segsamples); % 1/3 overlap
window		= segsamples+noverlap; % window size
nfft		= 10000;
spectrogram(snd,window,noverlap,nfft,Fs,'yaxis');
% spectrogram(snd)
% colorbar
cax = caxis;
caxis([0.7*cax(1) 1.1*cax(2)])
ylim([min(Freq) max(Freq)])
set(gca,'YTick',[0.5 1 2 4 8 16]*1000);
set(gca,'YTickLabel',[0.5 1 2 4 8 16]);
set(gca,'YScale','log');
drawnow

% figure
subplot(221)
[~,~,t,p] = spectrogram(snd,window,noverlap,nfft,Fs,'yaxis');
p = 10*log10(p);
p = smooth(sum(p,1),3);
p = p-min(p);
p = p/max(p);
hold on
plot(t*1000,p,'r-' );
pa_verline(durstat);

function snd = genstat(durstat,Fs,nFreq,Freq,Phi)
nTime	= round( (durstat/1000)*Fs ); % # Samples for Static Noise
time	= ((1:nTime)-1)/Fs; % Time (sec)


%% Modulate carrier, with static and dynamic part
snd		= 0;
for ii = 1:nFreq
	stat	= 1.*sin(2*pi*Freq(ii) .* time + Phi(ii));
	snd		= snd+stat;
end

%% This genrip uses matrix instead of for-loop, however uses too much memory
% function [snd,A] = genrip(vel,dens,md,durrip,durstat,Fs,nFreq,Freq,Oct,Phi)
% nTime   = round( (durrip/1000)*Fs ); % # Samples for Rippled Noise
% time	= ((1:nTime)-1)/Fs; % Time (sec)
%
% %% Generating the ripple
% % Create amplitude modulations completely dynamic without static
% T			= 2*pi*vel*time;
% F			= 2*pi*dens*Oct;
% [T,F]		= meshgrid(T,F);
% A			= 1+md*sin(T+F);
% A			= A';
%
% %% Modulate carrier
% snd		= 0; % 'initialization'
% for ii = 1:nFreq
% 	Phistat = 2*pi*Freq(ii).*durstat/1000 + Phi(ii); % phase after stationary period
% 	rip		= A(:,ii)'.*sin(2*pi*Freq(ii) .* time + Phistat);
% 	snd		= snd+rip;
% end


%% This genrip uses for-loop
function snd = genrip(vel,dens,md,durrip,durstat,Fs,nFreq,Freq,Oct,Phi)
nTime   = round( (durrip/1000)*Fs ); % # Samples for Rippled Noise
time	= ((1:nTime)-1)/Fs; % Time (sec)

%% Generating the ripple
% Create amplitude modulations completely dynamic without static
T			= 2*pi*vel*time;
F			= 2*pi*dens*Oct;

%% Modulate carrier
snd		= 0; % 'initialization'
for ii = 1:nFreq
	Phistat = 2*pi*Freq(ii).*durstat/1000 + Phi(ii); % phase after stationary period needs to be included
	a		= 1+md*sin(T+F(ii));
	rip		= a.*sin(2*pi*Freq(ii).* time + Phistat);
	snd		= snd+rip;
end

function [snd,A] = genripfft(vel,dens,md,durrip,Fs,df)
% Generate ripple in frequency domain

%%
Ph		= 0-pi/2;

%% excitation condition
durrip	= durrip/1000;	% ripple duration (s)
f0		= 250;	% lowest freq
BW		= 6.4;	% bandwidth, # of octaves
Fs		= round(Fs*2)/2; % should be even number
maxRVel	= max(abs(vel(:)),1/durrip);

%% Time axis
tStep		= 1/(4*maxRVel);
tEnvSize	= round((durrip/tStep)/2)*2; % guarantee even number for fft components
tEnv		= (0:tEnvSize-1)*tStep;

%% Frequency axis
oct			= (0:round(BW/df*2)/2-1)*df;
fr			= pa_oct2bw(f0,oct)';
fEnv		= log2(fr./f0);
fEnvSize	= length(fr);	% # of component

%% Compute the envelope profile
ripPhase	= Ph+pi/2;
fPhase		= 2*pi*dens*fEnv + ripPhase;
tPhase		= 2*pi*vel*tEnv;
A			= md*(sin(fPhase)*cos(tPhase)+cos(fPhase)*sin(tPhase));
A			= 1+A; % shift so background = 1 & profile is envelope

%% freq-domain AM
nTime		= durrip*Fs; % signal time (samples)

%% roll-off and phase relation
th			= 2*pi*rand(fEnvSize,1); % component phase, theta
S			= zeros(1, nTime); % memory allocation
tEnvSize2	= tEnvSize/2;
for ii = 1:fEnvSize
	f_ind				= round(fr(ii)*durrip);
	S_tmpA				= fftshift(fft(A(ii,:)))*exp(1i*th(ii))/tEnvSize*nTime/2;
	
	pad0left		= f_ind - tEnvSize2 - 1;
	pad0right		= nTime/2 - f_ind - tEnvSize2;
	if ((pad0left > 0) && (pad0right > 0) )
		S_tmpB = [zeros(1,pad0left),S_tmpA,zeros(1,pad0right)];
	elseif ((pad0left <= 0) && (pad0right > 0) )
		S_tmpB = [S_tmpA(1 - pad0left:end),zeros(1,pad0right)];
	elseif ((pad0left > 0) && (pad0right <= 0) )
		S_tmpB = [zeros(1,pad0left),S_tmpA(1:end+pad0right)];
	end
	S_tmpC	= [0, S_tmpB, 0, fliplr(conj(S_tmpB))];
	S		= S + S_tmpC; % don't really have to do it all--know from padzeros which ones to do...
end
snd = real(ifft(S));

