function pa_nirs_parameters
%% Analysis
% for A,V, AV experiments by Luuk vd Rijt 13-11-2013
% with 4x1 channel (split), right (Tx1 and 2, Rx1) and left (Tx3 and 4, Rx2) recordings

close all;
clear all;
clc
%% To Do
% Stim
% Oxy-Deoxy
% Left-Right

%% Load preprocessed data
% obtained with PA_NIRS_PREPROCESS
% d = 'Z:\Student\Luuk van de Rijt\Data\Raw data\LR-1701';
% cd(d);
% fname = 'LR-1701-2013-09-30-';
% d = 'E:\DATA\NIRS\LuukGuus\LR-1714';
% cd(d);
% fname = 'LR-1714-2013-10-23-';
d = 'Z:\Student\Luuk van de Rijt\Data\Raw data\LR-1703';
fname = 'LR-1703-2013-10-14-';
% d = 'Z:\Student\Luuk van de Rijt\Data\Raw data\LR-1710';
% fname = 'LR-1710-2013-10-18-';
% d = 'E:\DATA\NIRS\Hai Yin\HH-01-2011-11-16';
% fname = 'OG-HH-01-2011-11-16-';
% d = 'E:\DATA\NIRS\Hai Yin\HH-02-2011-11-29';
% fname = 'OG-HH-02-2011-11-29-';
% d = 'E:\DATA\NIRS\Hai Yin\HH-03-2011-12-14';
% fname = 'OG-HH-03-2011-12-14-';
% d = 'E:\DATA\NIRS\Hai Yin\HH-04-2012-02-13';
% fname = 'OG-HH-04-2012-02-13-';
% d = 'E:\DATA\NIRS\Hai Yin\HH-05-2012-01-17';
% fname = 'OG-HH-05-2012-01-17-';
% load(fname)
cd(d);

CHAN = struct([]);
chanlabel = {'OHb';'HHb'};

mx = NaN(3*4,3); % by default, 3 files/blocks, 4 channels
k = 0;
for fIdx = 1
    load([fname '000' num2str(fIdx) '.mat']); nirs = data;
	nirs.label
    idx(1)		= find(strncmp(nirs.label,'Rx1a - Tx1 O2Hb',15));  % Oxy-hemoglobin channel 1
    idx(2)		= find(strncmp(nirs.label,'Rx1b - Tx2 O2Hb',15));  % Oxy-hemoglobin channel 2
    
    idx(3)		= find(strncmp(nirs.label,'Rx1a - Tx1 HHb',14));  % Oxy-hemoglobin channel 1
    idx(4)		= find(strncmp(nirs.label,'Rx1b - Tx2 HHb',14));  % Oxy-hemoglobin channel 2
    
    %% Ref vs Sig
    for chanIdx = 1:2
        chan	= nirs.processed;
        chanRef	= chan(idx(1+(chanIdx-1)*2),:);
        chanSig	= chan(idx(2+(chanIdx-1)*2),:);
        idx(1+(chanIdx-1)*2)
        figure(1)
        subplot(221)
        plot(chanRef+chanIdx,'k-')
        hold on
        plot(chanSig+chanIdx,'r-')
        axis square
        box off
        
        subplot(222)
        plot(chanRef,chanSig,'k.')
        axis square
        box off
        pa_unityline;

        
        %% Reference channel subtraction
        b		= regstats(chanSig,chanRef,'linear','r');
        chanSig = b.r;

		    subplot(223)
%         plot(chanRef,'k-')
        hold on
        plot(chanSig+chanIdx,'k-')
        axis square
        box off
        %% Onsets Stimulus 1
        
        %% Stimulus 1
        blockAV			= getblock(nirs,chanSig,'AV');
		[chanIdx fIdx]
        CHAN(chanIdx).block(fIdx).AV	= blockAV';
        
        blockA			= getblock(nirs,chanSig,'A'); % due to error V=A
        CHAN(chanIdx).block(fIdx).A	= blockA';
        
        blockV			= getblock(nirs,chanSig,'V'); % due to error V=A
        CHAN(chanIdx).block(fIdx).V	= blockV';
        
        k = k+1;
        mx(k,1) =  size(CHAN(chanIdx).block(fIdx).AV,1);
        mx(k,2) =  size(CHAN(chanIdx).block(fIdx).A,1);
        mx(k,3) =  size(CHAN(chanIdx).block(fIdx).V,1);
        
    end
end

mx = max(mx(:));
%% Check size
tmp = NaN(mx,4); % by default 4 events per stimulus modality per block
for chanIdx = 1:2
    for fIdx = 1
        sz = size(CHAN(chanIdx).block(fIdx).AV,1);
        if sz<mx
            disp(['Event duration error: ' num2str(mx-sz) ' samples missing in AV'])
            a = tmp;
            a(1:sz,:) = CHAN(chanIdx).block(fIdx).AV;
            CHAN(chanIdx).block(fIdx).AV = a;
        end
        
        sz = size(CHAN(chanIdx).block(fIdx).A,1);
        if sz<mx
            disp(['Event duration error: ' num2str(mx-sz) ' samples missing in A'])
            a = tmp;
            a(1:sz,:) = CHAN(chanIdx).block(fIdx).A;
            CHAN(chanIdx).block(fIdx).A = a;
        end
        
        sz = size(CHAN(chanIdx).block(fIdx).V,1);
        if sz<mx
            disp(['Event duration error: ' num2str(mx-sz) ' samples missing in V'])
            a = tmp;
            a(1:sz,:) = CHAN(chanIdx).block(fIdx).V;
            CHAN(chanIdx).block(fIdx).V = a;
        end
    end
end

%% Some useful parameters
mod     = {'V','AV','A'};
% col = ['r';'b';'g'];
col     = pa_statcolor(3,[],[],[],'def',1);
param   = struct([]);
for jj = 1:2
    h = NaN(3,1);
    for ii = 1:3
        block				= [CHAN(jj).block.(char(mod(ii)))]'; % Dynamic field names!!
        fd					= nirs.fsdown;
        mu					= nanmean(block);
        sd					= nanstd(block);
        t					= (1:length(mu))/fd;
        n					= size(block,1);
        param(ii).chan(jj).mu		= mu;
        param(ii).chan(jj).sd		= sd;
        param(ii).chan(jj).se		= sd./sqrt(n);
        param(ii).chan(jj).time		= t;
        [param(ii).chan(jj).max,param(ii).chan(jj).maxt]	= max(mu);
        param(ii).chan(jj).maxt		= param(ii).chan(jj).maxt/fd-10; % remove first 10 ms = 100 samples before stimulus onset
        param(ii).chan(jj).modality	= mod{ii};
        
        figure(666)
        subplot(2,2,jj)
        hold on
        h(ii) = pa_errorpatch(param(ii).chan(jj).time,param(ii).chan(jj).mu,param(ii).chan(jj).se,col(ii,:));
    end
    xlim([min(t) max(t)]);
    ylim([-0.2 0.4]);
    box off
    axis square
    set(gca,'TickDir','out');
    pa_verline(10,'k:');
    pa_verline(30,'k:');
    pa_horline(0,'k:');
    xlabel('Time (s)');
    ylabel('OHb'); % What is the correct label/unit
    legend(h,mod,'Location','NW');
    title(chanlabel{jj});
    % figure;
    % plot(t,block','k-','Color',[.7 .7 .7])
end

%% Save
save([fname 'param'],'param');

%%


function MU = getblock(nirs,chanSig,mod)
fs			= nirs.fsample;
fd			= nirs.fsdown;
onSample	= ceil([nirs.event.sample]*fd/fs); % onset and offset of stimulus
offSample	= onSample(2:2:end); % offset
onSample	= onSample(1:2:end); % onset
stim		= {nirs.event.stim}; % stimulus modality - CHECK HARDWARE WHETHER THIS IS CORRECT


selOn		= strcmp(stim,mod);
selOff		= selOn(2:2:end);
selOn		= selOn(1:2:end);
Aon			= onSample(selOn);
Aoff		= offSample(selOff);
mx			= min((Aoff - Aon)+1)+200;
nStim		= numel(Aon);
MU = NaN(nStim,mx);
for stmIdx = 1:nStim
    idx				= Aon(stmIdx)-100:Aoff(stmIdx)+100; % extra 100 samples before and after
    idx				= idx(1:mx);
    MU(stmIdx,:)	= chanSig(idx);
end
MU = bsxfun(@minus,MU,MU(:,100)); % remove the 100th sample, to set y-origin to stimulus onset

