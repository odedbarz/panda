%
%                          MONKEY RECORDING
%
clear all;
rippleBusy =  0;
rippleNew  =  0;
maxStim    = 20;
maxParam   = 12;
cmd        =  0;
busy       =  0;
ready      =  0;
values     = zeros(1,10);
results    = zeros(1,10);
curTrial   = zeros(maxStim,maxParam);
maxSnd     = 400000;
rippleSound= zeros(1,maxSnd);
%
% ripple parameters
% 1-	velocity   = velocity - modulation frequency
% 2-	modulation = modulation depth
% 3-	density    = density
% 4-	durStat    = duration of static part sound
% 5-	durDyn     = duration of dynamic part sound
% 6-	F0         = F0
% 7-	nTones     = number of tones
% 8-	nOct       = number of octaves (components = nTones*nOctaves
% 9-	PhiF0      = pahse F0 (radials)
%10-	statDyn    = 1-dynamic follows static
%11-	freeze     = 1-keep component phases
%12-	rate       = 48828.125 Hz.
%
rippleParams = zeros(1,12);
rippleParams( 1) = 10.0;
rippleParams( 2) = 50.0;
rippleParams( 3) = 0.1;
rippleParams( 4) = 500.0;
rippleParams( 5) = 500.0;
rippleParams( 6) = 250.0;
rippleParams( 7) = 10.0;
rippleParams( 8) = 6.0;
rippleParams( 9) = pi/2.0;
rippleParams(10) = 1.0;
rippleParams(11) = 0.0;
rippleParams(12) = 48828.125;
%
loadGlobals();     % constants
fsm();             % finite state machine
ripple();          %
Monkey();          % gui
