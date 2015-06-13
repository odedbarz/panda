function gendouble2dexp
close all
% Author MW
% Copyright 2007

%% Initialization
home;
disp('>> GENERATING EXPERIMENT <<');
showexp             = 1;

expfile = 'double_bzz_2d_1.exp';
Fs          = 48828.125;

datdir				= 'DAT';
int					= 54;
minled              = 100;
maxled              = 300;
minsnd              = 100;
maxsnd				= 100;
Nrep				= 2;
dT	= [-2 -.5 0 .5 2]; % ms
dT = 0;
dT	= round(dT*Fs/1000); %samples

p		= [12 8 20 30 31]';
[P1,P2] = meshgrid(p,p);
P1		= P1(:);
P2		= P2(:);

P1		= meshgrid(P1,dT);
[P2,dT] = meshgrid(P2,dT);

P1		= P1(:);
dT		= dT(:);
P2		= P2(:);

sel		= P1==P2;
Psingle = P1(sel);
dTsingle = dT(sel);

P1		= P1(~sel);
P2		= P2(~sel);
dT		= dT(~sel);

sel = dTsingle==0;
Psingle = Psingle(sel);
dTsingle = dTsingle(sel);
P1 = [P1;Psingle];
P2 = [P2;Psingle];
dT = [dT;dTsingle];

T		= zeros(size(P1));
% Replicate
T		= repmat(T,Nrep,1);
P1		= repmat(P1,Nrep,1);
P2		= repmat(P2,Nrep,1);
dT		= repmat(dT,Nrep,1);

% Randomize
indx    = randperm(length(T));
T		= T(indx);
P1		= P1(indx);
P2		= P2(indx);
dT		= dT(indx);


%% Write
marc
writeexp4(expfile,datdir,T,P1,P2,dT);
%% Show the exp-file in Wordpad
if ispc && showexp
	dos(['"C:\Program Files\Windows NT\Accessories\wordpad.exe" ' expfile ' &']);
end

function writeexp4(expfile,datdir,T,P1,P2,dT)
% Save known trial-configurations in exp-file
%
%WRITEEXP WRITEEXP(FNAME,DATDIR,THETA,PHI,ID,INT,LEDON,SNDON)
%
% WRITEEXP(FNAME,THETA,PHI,ID,INT,LEDON,SNDON)
%
% Write exp-file with file-name FNAME.
%
%
% See also GENEXPERIMENT
%
% Author: Marcw
expfile		= fcheckext(expfile,'.exp');
ntrials     = size(T,1);
minled = 100;
maxled = 300;
%% Header of exp-file
ITI			= [0 0];
Ntrls		= ntrials;
Rep			= 1;
Rnd			= 2;
Mtr			= 'n';

%%
fid				= fopen(expfile,'w');
writeheader(fid,datdir,ITI,Ntrls,Rep,Rnd,Mtr)

%% Body of exp-file
% Create a trial for
for i               = 1:ntrials		% each location
	ledon = rndval(minled,maxled,1);
	writetrl(fid,i);
	writeled(fid,'LED',0,12,1,0,0,1,ledon); % fixation LED
	writetrg(fid,1,2,0,0,1);		% Button trigger after LED has been fixated
	writeacq(fid,1,ledon);	% Data Acquisition immediately after fixation LED exinction
	
	if P1(i)~=P2(i)
		if dT(i)>=0
			int = getint(P1(i));
			writesnd(fid,'SND1',T(i),P1(i),100+P1(i),int,1,ledon+100); % Sound on
			
			int = getint(P2(i));
			writesnd2(fid,'SND2',T(i),P2(i),200+P2(i),int,1,ledon+100,dT(i)); % Sound on
		else
			int = getint(P1(i));
			writesnd2(fid,'SND2',T(i),P1(i),100+P1(i),int,1,ledon+100,-dT(i)); % Sound on
			
			int = getint(P2(i));
			writesnd(fid,'SND1',T(i),P2(i),200+P2(i),int,1,ledon+100); % Sound on
		end
	else
		int = getint(P1(i));
		writesnd(fid,'SND1',T(i),P1(i),300+P1(i),int,1,ledon+100); % Sound on
		
		writesnd(fid,'SND2',T(i),1,100,0,1,ledon+100); % Sound on
	end
	fprintf(fid,'%s\n','INP1');
	fprintf(fid,'%s\n','INP2');
end
fclose(fid);

function int = getint(loc)
switch loc
	case 12
		int = 54;
	case 8
		int = 56.4450;
	case 20
		int = 53.9945;
	case 30
		int = 64.8689;
	case 31
		int = 61.4274;
end



function writesnd2(fid,SND,X,Y,ID,Int,EventOn,Onset,Offset)
% WRITESND(FID,SND,X,Y,ID,INT,EVENTON,ONSET)
%
% Write a SND-stimulus line in an exp-file with file identifier FID.
%
% SND		- 'SND1' or 'SND2'
% X			- SND theta angle
% Y			- SND phi number (1-29 and 101-129)
% ID		- Sound ID/attribute (000-999)
% INT		- SND Intensity (0-100)
% EVENTON	- The Event that triggers the onset of the SND (0 - start of
% trial)
% ONSET		- The Time after the On Event (msec)
%
% See also GENEXPERIMENT, FOPEN, and the documentation of the Auditory
% Toolbox
fprintf(fid,'%s\t%d\t%d\t%d\t%.1f\t%d\t%d\t%d\n',SND,X,Y,ID,Int,EventOn,Onset,Offset);
