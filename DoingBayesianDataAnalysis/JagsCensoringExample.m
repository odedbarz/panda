function BernBetaMuKappaJags
% BERNBETAKAPPUMUJAGS
%
% Bernouilli likelihood with hierarchical prior
%
% Original in R:	Kruschke, J. K. (2011). Doing Bayesian Data Analysis:
%					A Tutorial with R and BUGS. Academic Press / Elsevier.
% Modified to Matlab code: Marc M. van Wanrooij

%% Clean
close all hidden
clear all hidden
clc

% This program illustrates estimation of parameters for right-censored data in 
% JAGS.  To produce the graphics at the end, you must have plotPost.R and 
% HDIofMCMC.R in the same folder as this program (and tell R that this is the 
% working directory). Run the program as-is to see that JAGS produces good 
% estimates of the true underlying parameter values, even for censored data. 

% To see what happens when you do *not* tell JAGS that the data are censored, 
% just comment out the follow four lines (and run it again).
% In the model specification:
%   isCensored[i] ~ dinterval( y[i] , censorLimitVec[i] )
% In the dataList:
%   , isCensored = as.numeric(isCensored) % JAGS dinterval needs 0,1 not T,F
%   , censorLimitVec = censorLimitVec
% In the initsList:
%   , y=yInit 
% Notice that the resulting estimated parameters are way too low!

%------------------------------------------------------------------------------
% THE MODEL.

str = ['model {\r\n',...
  '\tfor ( i in 1:N ) {\r\n',...
    '\t\tisCensored[i] ~ dinterval( y[i] , censorLimitVec[i] )\r\n',...
    '\t\ty[i] ~ dnorm( mu , tau ) \r\n',...
  '\t}\r\n',...
  '\ttau <- 1/pow(sigma,2)\r\n',...
  '\tsigma ~ dunif(0,100)\r\n',...
  '\tmu ~ dnorm(0,1E-6)\r\n',...
'\t}\r\n',...
'\t # close quote for modelstring\r\n'];

% Write the modelString to a file, using Matlab commands:
fid			= fopen('model.txt','w');
fprintf(fid,str);
fclose(fid);

%------------------------------------------------------------------------------
% THE DATA.
% For real data, censored values should be recorded as NA, not as the censoring 
% limit, and the indicator value isCensored should be set to TRUE.

% Generate some random data:
% set.seed(47405)
y				= randn(500,1);
desiredMean		= 100;
desiredSD		= 15;
actualMean		= mean(y); 
actualSD		= std(y);
y				= desiredSD*(y-actualMean)/actualSD + desiredMean;
N				= length(y);
% Now artificially right-censor the data. 
% First, construct the censoring limits. There is a censoring limit defined
% for every observation, put in the vector censorLimitVec.
censorLimit			= mean(y)+std(y); % cuts at +1SD
censorLimitVec		= repmat(censorLimit,N,1);
% Define indicator vector for which observations are censored:
isCensored = y > censorLimitVec; % Note that this has T,F logical values.
% Now cut the data above the censor limits. For real data, censored values
% should be recorded as NA, not as the censor limit, and the indicator value
% isCensored should be set to TRUE.
y(isCensored) = NaN;


% Specify the data in a form that is compatible with model, as a list:
dataStruct.y = y;
dataStruct.N = N;
dataStruct.isCensored = double(isCensored); % JAGS dinterval needs 0,1 not T,F
dataStruct.censorLimitVec = censorLimitVec;
% double(isCensored)
% return
%% INTIALIZE THE CHAINS.
nChains = 3;
initsStruct = struct([]);
for ii = 1:nChains
	initsStruct(ii).sigma	= 15;
	initsStruct(ii).mu		= 100;
	% intial values of censored data:
	yInit				= NaN(length(y),1);
	yInit(isCensored)	= censorLimitVec(isCensored)+1;
	initsStruct(ii).y = yInit;
	[y yInit]
end
return
%% RUN THE CHAINS
% 
% parameters = c( 'mu' , 'sigma' )
% adaptSteps = 1000 % overkill, just shows general form
% burnInSteps = 2000 % overkill, just shows general form
% nChains = 3 
% numSavedSteps=50000
% thinSteps=1
% nIter = ceiling( ( numSavedSteps * thinSteps ) / nChains )

%% RUN THE CHAINS
parameters		= {'mu','sigma'};		% The parameter(s) to be monitored.
% adaptSteps		= 1000;			% Number of steps to 'tune' the samplers.
burnInSteps		= 2000;			% Number of steps to 'burn-in' the samplers.
numSavedSteps	= 50000;		% Total number of steps in chains to save.
thinSteps		= 1;			% Number of steps to 'thin' (1=keep every step).
nIter			= ceil((numSavedSteps*thinSteps )/nChains); % Steps per chain.
doparallel		= 0; % do not use parallelization

fprintf( 'Running JAGS...\n' );
% [samples, stats, structArray] = matjags( ...
samples = matjags( ...
	dataStruct, ...                     % Observed data
	fullfile(pwd, 'model.txt'), ...    % File that contains model definition
	initsStruct, ...                          % Initial values for latent variables
	'doparallel' , doparallel, ...      % Parallelization flag
	'nchains', nChains,...              % Number of MCMC chains
	'nburnin', burnInSteps,...              % Number of burnin steps
	'nsamples', nIter, ...           % Number of samples to extract
	'thin', thinSteps, ...                      % Thinning parameter
	'dic', 1, ...                       % Do the DIC?
	'monitorparams', parameters, ...     % List of latent variables to monitor
	'savejagsoutput' , 1 , ...          % Save command line output produced by JAGS?
	'verbosity' , 1 , ...               % 0=do not produce any output; 1=minimal text output; 2=maximum text output
	'cleanup' , 0 );                    % clean up of temporary files?

% keyboard
% % Create, initialize, and adapt the model:
% jagsModel = jags.model( 'model.txt' , data=dataList , inits=initsList , 
%                         n.chains=nChains , n.adapt=adaptSteps )
% % Burn-in:
% cat( 'Burning in the MCMC chain...\n' )
% update( jagsModel , n.iter=burnInSteps )
% % The saved MCMC chain:
% cat( 'Sampling final MCMC chain...\n' )
% codaSamples = coda.samples( jagsModel , variable.names=parameters , 
%                             n.iter=nIter , thin=thinSteps )
% % resulting codaSamples object has these indices: 
% %   codaSamples[[ chainIdx ]][ stepIdx , paramIdx ]
% 
% %------------------------------------------------------------------------------
% % EXAMINE THE RESULTS
% 
% checkConvergence = FALSE
% if ( checkConvergence ) {
%   openGraph(width=7,height=7)
%   autocorr.plot( codaSamples[[1]] , ask=FALSE ) 
%   show( gelman.diag( codaSamples ) )
%   effectiveChainLength = effectiveSize( codaSamples ) 
%   show( effectiveChainLength )
% }
% 
% 
% % Convert coda-object codaSamples to matrix object for easier handling.
% % But note that this concatenates the different chains into one long chain.
% % Result is mcmcChain[ stepIdx , paramIdx ]
% mcmcChain = as.matrix( codaSamples )
% 
% openGraph(width=10,height=3.0)
% layout(matrix(1:3,nrow=1))
% par( mar=c(3.5,1.5,3.0,0.5) , mgp=c(2,0.7,0) )
% % plot the data:
% xLim = desiredMean+c(-3.5*desiredSD,3.5*desiredSD)
% xBreaks = seq( xLim[1] , xLim[2] , desiredSD/2 )
% xGrid = seq( xLim[1] , xLim[2] , length=201 )  
% histInfo = hist( y , main='Data' , xlab='y' , freq=F ,
%                  xlim=xLim , breaks=c(min(y,na.rm=T),xBreaks) , 
%                  col='grey' , border='white' )
% lines( xGrid , dnorm( xGrid , mean=desiredMean , sd=desiredSD )/pnorm(1) , lwd=3 ) 
% abline(v=censorLimit,lty='dotted',col='red')
% % plot the posterior:
% histInfo = plotPost( mcmcChain[,'mu'] , main='Mu' , xlab=expression(mu) , 
%                      showMode=FALSE )
% histInfo = plotPost( mcmcChain[,'sigma'] , main='Sigma' , xlab=expression(sigma) , 
%                      showMode=TRUE )
% % save plot:
% saveGraph( file=fileNameRoot , type='eps' )
% saveGraph( file=fileNameRoot , type='jpg' )
%   