% jjb_stats_ttest
% What we're testing here is if the sample that we've obtained (x), comes
% from a population with mean that is zero.  
% Our null hypothesis: That the sample comes from a normal distribution
% with mean 0 (null = no effect)

% Make x, knowing that it's coming from a distribution with a mean that is
% not zero (mean = 0.1):
x = normrnd(0.1,1,100,1);

% Run t-test to check null hypothesis:
[h, p, ci] = ttest(x,0); 
% h=1 means reject null hypothesis; h=0 means can't reject null hypoth
% p is probability of making a type 1 error (rejecting Ho when it's true)
% p is equivalent to the probability that the sample really could come from
% a population with mean 0, simply by chance)
% ci is 95% confidence intervals on mean.

%%% Results:
%%% h = 0 (can't reject null hypothesis)
%%% p = 0.078 - 7.8% chance of making a mistake if we reject null hypoth
%%% ci = [-.017; 0.3185] - 95% confidence intervals on the actual mean of sample.
%%% Therefore, we can't say that x is not from a pop with mean 0

%%%%%%%%%%%%%%%%% Test 2: Increase Sample Size: %%%%%%%%%%%%%%%%%%%%%%%
% This time, increase to 1000 observations:
y = normrnd(0.1,1,1000,1);

% Run t-test to check null hypothesis:
[h2, p2, ci2] = ttest(y,0); 

%%% Results:
%%% h2 = 1 (can reject null hypothesis - sample not from pop with mean=0)
%%% p2 = 0.0011 - 0.1% chance of making a mistake if we reject null hypoth
%%% ci2 = [0.042; 0.1651] - 95% confidence intervals on the actual mean of sample.
%%% Therefore, we can say that x is not from a pop with mean 0
