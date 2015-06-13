function BernTwoMetropolis
% BERNTWOMETROPOLIS
%
% Use this program as a template for experimenting with the Metropolis
% algorithm applied to two parameters called theta1,theta2 defined on the
% domain (0,1)x(0,1).
%
% Original in R:	Kruschke, J. K. (2011). Doing Bayesian Data Analysis:
%					A Tutorial with R and BUGS. Academic Press / Elsevier.
% Modified to Matlab code: Marc M. van Wanrooij

close all
% Specify the length of the trajectory, i.e., the number of jumps to try.
trajLength		= ceil(1000/.9); % arbitrary large number
% Initialize the vector that will store the results.
trajectory		= zeros(trajLength,2);
% Specify where to start the trajectory
trajectory(1,:)	= [0.5, 0.5]; % arbitrary start values of the two param's
% Specify the burn-in period.
burnIn			= ceil(0.1*trajLength); % arbitrary number
% Initialize accepted, rejected counters, just to monitor performance.
nAccepted = 0;
nRejected = 0;
% Specify the seed, so the trajectory can be reproduced.
s = RandStream('mt19937ar','Seed',47405);
RandStream.setGlobalStream(s);
% Specify the covariance matrix for multivariate normal proposal distribution.
nDim		= 2;
sd1			= 0.2; 
sd2			= 0.2;
covarMat	= [sd1^2, 0.00; 0.00 , sd2^2];

%% Now generate the random walk. stepIdx is the step in the walk.
for stepIdx = 1:trajLength-1
	currentPosition		= trajectory(stepIdx,:);
	% Use the proposal distribution to generate a proposed jump.
	% The shape and variance of the proposal distribution can be changed
	% to whatever you think is appropriate for the target distribution.
	proposedJump = mvnrnd(zeros(1,nDim),covarMat);
	% Compute the probability of accepting the proposed jump.
	probAccept = min(1,targetRelProb(currentPosition + proposedJump)./targetRelProb(currentPosition));
	% Generate a random uniform value from the interval (0,1) to
	% decide whether or not to accept the proposed jump.
	if rand(1)<probAccept
		% accept the proposed jump
		trajectory(stepIdx+1,:) = currentPosition + proposedJump;
		% increment the accepted counter, just to monitor performance
		if stepIdx>burnIn
			nAccepted = nAccepted+1;
		end
	else
		% reject the proposed jump, stay at current position
		trajectory(stepIdx+1,:) = currentPosition;
		% increment the rejected counter, just to monitor performance
		if stepIdx>burnIn
			nRejected = nRejected+1;
		end
	end
end


% End of Metropolis algorithm.
%% Begin making inferences by using the sample generated by the Metropolis algorithm.
% Extract just the post-burnIn portion of the trajectory.
acceptedTraj = trajectory((burnIn+1):size(trajectory,1),:);
% Compute the mean of the accepted points.
meanTraj =  mean(acceptedTraj);
% Compute the standard deviations of the accepted points.
sdTraj = std(acceptedTraj);

%% Display the sampled points
figure
plot( acceptedTraj(:,1) ,acceptedTraj(:,2), 'ko-','MarkerFaceColor','w','Color',[.7 .7 1]);

xlim([-0.1,1.1]);
ylim([-0.1,1.1]);
xlabel('\theta_1');
ylabel('\theta_2');
axis square;
box off
set(gca,'TickDir','out');
% Display means and rejected/accepted ratio in plot.
if meanTraj(1)>0.5
	xpos = 0;
	xadj = 'left';
else
	xpos = 1;
	xadj = 'right';
end
if meanTraj(2)>0.5
	ypos = 0;
	yadj = 'bottom';
else
	ypos = 1;
	yadj = 'top';
end
str = ['$M=' num2str(meanTraj(1),3) ', ' num2str(meanTraj(2),3) '; N_{pro} = ' num2str(size(acceptedTraj,1))  ', \frac{N_{acc}}{N_{pro}} = ' num2str(nAccepted/size(acceptedTraj,1),3) '$'];
text( xpos , ypos ,str,'HorizontalAlignment',xadj,'VerticalAlignment',yadj,'Interpreter','Latex','FontSize',13);


%% Evidence for model, p(D).
% Compute a,b parameters for beta distribution that has the same mean
% and stdev as the sample from the posterior. This is a useful choice
% when the likelihood function is binomial.
a =   meanTraj.*((meanTraj.*(1-meanTraj)./sdTraj.^2) - ones(1,nDim));
b = (1-meanTraj).*((meanTraj.*(1-meanTraj)./sdTraj.^2) - ones(1,nDim));
% For every theta value in the posterior sample, compute
% dbeta(theta,a,b) / likelihood(theta)*prior(theta)
% This computation assumes that likelihood and prior are properly normalized,
% i.e., not just relative probabilities.
wtd_evid = zeros(1,size(acceptedTraj,1));
for idx = 1:size(acceptedTraj,1)
	wtd_evid(idx) = betapdf(acceptedTraj(idx,1),a(1),b(1)).*betapdf(acceptedTraj(idx,2),a(2),b(2))./(likelihood(acceptedTraj(idx,:)).*prior(acceptedTraj(idx,:)));
end
pdata = 1/mean(wtd_evid);
% Display p(D) in the graph
str = ['p(D) = ' num2str(pdata,3)];
text(xpos,ypos+(.12*(-1).^(ypos)),str,'HorizontalAlignment',xadj,'VerticalAlignment',yadj,'FontSize',13);

% Estimate highest density region by evaluating posterior at each point.
npts		= size(acceptedTraj,1);
postProb	= zeros(1,npts);
for ptIdx = 1:npts
    postProb(ptIdx) = targetRelProb(acceptedTraj(ptIdx,:));
end
% Determine the level at which credmass points are above:
credmass = 0.95;
waterline = quantile(postProb,1-credmass);

% Display highest density region in new graph
figure
sel = postProb<waterline;
plot(acceptedTraj(sel,1),acceptedTraj(sel,2),'bo','Color',[.7 .7 1],'MarkerFaceColor','w');
hold on
plot(acceptedTraj(~sel,1),acceptedTraj(~sel,2),'bo','Color',[.7 .7 1],'MarkerFaceColor',[.7 .7 1]);

title([num2str(credmass*100) '% HD region']);
xlim([-0.1,1.1]);
ylim([-0.1,1.1]);
xlabel('\theta_1');
ylabel('\theta_2');
axis square;
box off
set(gca,'TickDir','out');

function p = likelihood(theta)
% Define the likelihood function.
% The input argument is a vector: theta = c( theta1 , theta2 )
% Data are constants, specified here:
z1 = 5;
N1 = 7;
z2 = 2;
N2 = 7;
p = theta(1).^z1.*(1-theta(1)).^(N1-z1).* theta(2).^z2.*(1-theta(2)).^(N2-z2);

function p = prior(theta)
% Define the prior density function.
% The input argument is a vector: theta = c( theta1 , theta2 )
% Here's a beta-beta prior:
a1 = 3;
b1 = 3;
a2 = 3;
b2 = 3;
p = betapdf(theta(1),a1,b1).*betapdf(theta(2),a2,b2);

function p = targetRelProb(theta)
% Define the relative probability of the target distribution, as a function
% of theta.  The input argument is a vector: theta = c( theta1 , theta2 ).
% For our purposes, the value returned is the UNnormalized posterior prob.
if all(theta >= 0) && all(theta<= 1.0)
	p =  likelihood(theta).*prior(theta);
else
	% This part is important so that the Metropolis algorithm
	% never accepts a jump to an invalid parameter value.
	p = 0;
end
