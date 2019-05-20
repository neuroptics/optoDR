function [yfit, clow, chigh, ififty, rsquared] = DR_spike_curve_fit(high_index,modelfun,beta0)
%DR_spike_curve_fit       Fits Spike Curve Data typically using a boltzman
%                         using the NonLinearModel.Fit method
%
%   Usage:
%      [yfit, clow, chigh, ififty, aic] = DR_spike_curve_fit(high_index,modelfun,beta0)
%
%   Description:
%       This script takes spike count data and fits a boltzman sigmoid to
%       it.
%
%   Parameters:
%       high_index      Index of popspikes
%       modelfun        Model function to fit, typically: modelfun = 'y~(1/(1+exp((b1-x1)/b2)))';
%       beta0           Initial conditions for the model parameters,
%                       typically: beta0 = [15 0.5]; for level data
%
%   Return Values:
%       yfit            The fit curve
%       clow            Confidence interval, low
%       chigh           Confidence interval, high
%       ififty          I50 terms from the boltzman equation
%       rsquared        R-squared values (ordinary and adjusted)
%
%   Copyright (C) 2018 David Klorig
%   Author: David Klorig
%   Last modification: 2/10/2018

% Determine Data Structure
levels = size(high_index,1);
reps = size(high_index,2);


%Fit Settings
x = (1:levels)';
fine_x = (1:0.1:levels)';
%   modelfun = 'y~(1/(1+exp((b1-x1)/b2)))';
%   beta0 = [15 0.5];


y = sum(high_index,2);
mdl2 = NonLinearModel.fit(x,y./reps, modelfun, beta0 );
beta2 = mdl2.Coefficients.Estimate;
[yfit, ci2] = predict(mdl2,fine_x);
clow = ci2(:,1);
chigh = ci2(:,2);
ififty = beta2(1);
rsquared = mdl2.Rsquared;

end