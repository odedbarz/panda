function A4_Gain3Ranges_CombinedLJ

%Elevation
%Step 4 Gain
%Plot gain differences
% 10 degree responses in condition 10, 30 and 50
% 30 degree responses in condition 30 and 50

close all
clear all
            pa_datadir RG-LJ-2011-12-14



        fnames   = {'SS10LJ'; 'SS30LJ'; 'SS50LJ'};
% end

h1 = plotgain(fnames,10);

h2 = plotgain(fnames(2:3),30);
set(h2,'Color',[.3 .3 .3]);


xlabel('Target range (deg)');
ylabel('Gain');
legend([h1;h2],'10 deg','30 deg','50 deg','Location','SE');


function h = plotgain(fnames,rng)

ncond   = size(fnames,1);
width   = 1:length(fnames);
B       = NaN(ncond,1);
SE      = NaN(ncond,1);
for ii = 1:ncond
    fname   = fnames{ii};
    pa_datadir RG-LJ-2011-12-14
    load(fname); % Load file
%     fname= str2double(fname);
    SupSac  = SSLJ;
    width(ii) = max(SupSac(:,24));
    sel     = abs(SupSac(:,24))<=rng;
    SupSac  = SupSac(sel,:);
    y       = SupSac(:,9);
    x       = SupSac(:,24);
    stats   = regstats(y,x,'linear','all');
    b       = stats.beta;
    B(ii)   = b(2);
    se      = stats.tstat.se;
    SE(ii)  = se(2);
end

% subplot(221)
% 
h = errorbar(width,B,SE,'ko-');
hold on
set(h,'MarkerFaceColor','w','LineWidth',2);
hold on
% ylim([0.5 1.5])

% saveas (h, 'gain', 'bmp')

saveas (h, 'GainLJ', 'm')