function A42_Prediction
close all
clear all

% Analysis step by step

% Output:
% g     = offset and gain (el)
% g2    = offset and gain (az)
% gain  = elevation gain
% gain2 = azimuth gain
% s     = residuen (el)
% s2    = residuen (az)

% Figure 1
% Raw data (stimulus-response plots) without any correction


% Figure 3
% Individual gains per subject
% 1 az, 2 el not normalized
% 3 az, 4 el normalized

% Figure 4
% Averaged gains
% 1 az, 2 el not normalized
% 3 az, 4 el normalized

%cc

subjects	= {'JB';'RG';'PR';'SM'};
nsubjects	= length(subjects);
gain		= NaN(nsubjects,3);     % Elevation gain
gain2       = gain;                       % Azimuth gain
s           = NaN(nsubjects,3);               % Residuen el
s2          = s;                             % Residuen az
% RT = NaN(nsubjects,4)
for ii = 1      
    subject = subjects{ii};
   [az,el] = getdist(subject); 
end


%%
ncond = 3;
cond = {'10';'20';'30'};
for jj = 1:ncond
	x = az(jj).tar;
	y = el(jj).tar;
	
	uxy = unique([x y],'rows');
	nx = size(uxy,1);
	N = NaN(nx,1);
	
	figure(666)
	subplot(1,3,jj)
	hold on
	for ii = 1:nx
		sel = x==uxy(ii,1) & y == uxy(ii,2);
		N(ii) = sum(sel);
	end
	N = ceil(5*N./max(N));
	for ii =1:nx
		plot(uxy(ii,1),uxy(ii,2),'ko','MarkerFaceColor','k','MarkerSize',N(ii),'LineWidth',2);
	end
	axis([-60 60 -60 60]);
	axis square;
	xlabel('Target azimuth');
	ylabel('Target elevation');
	set(gca,'XTick',-60:30:60,'YTick',-60:30:60);
	title(cond{jj});
end

pa_datadir;
print('-depsc','-painter',mfilename);


function [az,el] = getdist(subject)

switch subject
    case 'JB'
        fnames = {'RG-JB-2013-04-24-0001';'RG-JB-2013-04-24-0002';'RG-JB-2013-04-24-0003';'RG-JB-2013-04-24-0004';...
            };
        conditions = [3 1 2 3];
     case 'RG'
        fnames = {'JB-RG-2013-04-24-0001';'JB-RG-2013-04-24-0003';'JB-RG-2013-04-24-0004'; 'JB-RG-2013-04-25-0001';...      
            };
        conditions = [3 3 2 1];
        
     case 'PR'
        fnames = {'JB-PR-2013-04-25-0001';'JB-PR-2013-04-25-0002';'JB-PR-2013-04-25-0003'; 'JB-PR-2013-04-25-0004';...      
            };
        conditions = [3 1 2 3];
        
     case 'SM'
        fnames = {'JB-SM-2013-04-26-0001';'JB-SM-2013-04-26-0002';'JB-SM-2013-04-26-0003'; 'JB-SM-2013-04-26-0004';...      
            };
        conditions = [2 3 1 3];    
end

%% Pool data                    % Per subject 1:2
ncond = 3;
az = struct([]);
el = struct([]);

for ii = 1:ncond                % per condition 1:4
    sel         = conditions == ii;
    condfnames  = fnames(sel);
    nsets       = length(condfnames);
    SS			= [];
    for jj = 1:nsets
        fname		= condfnames{jj};
		dname = ['E:\DATA\Studenten\Jochem\' fname(1:end-5)];
        cd(dname);
        load(fname);
        SupSac  = pa_supersac(Sac,Stim,2,1);           %% pa_supersacr is supposed to add missing trials as 0/0 response trials automatically to SUPSAC
        SS		= [SS;SupSac]; %#ok<AGROW>          % Erstellte riesige SS pro condition, wo alle data-sets per condition und subject enthalten sind. zb MW, cond 20
    end
    
    
	az(ii).tar = SS(:,23);
	el(ii).tar = SS(:,24);
	

end
