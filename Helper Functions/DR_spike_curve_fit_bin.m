function [yfit, clow, chigh, ififty, rsquared, bins] = DR_spike_curve_fit_bin(high_index,bin_size,modelfun,beta0)
%DR_spike_curve_fit_bin       Fits Binned Spike Curve Data typically using a boltzman
%                             using the NonLinearModel.Fit method
%
%   Usage:
%      [yfit, clow, chigh, ififty, rsquared, bins] = DR_spike_curve_fit_bin(high_index,bin_size,modelfun,beta0)
%
%   Description:
%       This script takes spike count data, separates into bins, and fits a boltzman sigmoid to
%       each bin.
%
%   Parameters:
%       high_index      Index of popspikes
%       bin_size        Bin size in blocks
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
%       bins            Number of bins
%
%   Copyright (C) 2018 David Klorig
%   Author: David Klorig
%   Last modification: 2/10/2018

% Determine Data Structure
levels = size(high_index,1);
reps = size(high_index,2);

bins = floor(reps/bin_size);

bins_counts = zeros(levels,bins);

ind = 1:bin_size:reps;

for a = 1:bins
    bins_counts(:,a) = sum(high_index(:,ind(a):ind(a)+bin_size-1),2);
end
bins_ratio = bins_counts./bin_size;

%Fit Settings
x = (1:levels)';
fine_x = (1:0.1:levels)';
%   modelfun = 'y~(1/(1+exp((b1-x1)/b2)))';
%   beta0 = [15 0.5];

yfit = zeros(size(fine_x,1),bins);
clow = zeros(size(fine_x,1),bins);
chigh= zeros(size(fine_x,1),bins);
ififty = zeros(1,bins);
rsquared = zeros(1,bins);

for a = 1:bins
    mdl2 = NonLinearModel.fit(x,bins_ratio(:,a), modelfun, beta0 );
    beta2 = mdl2.Coefficients.Estimate;
    [yfit(:,a), ci2] = predict(mdl2,fine_x);
    clow(:,a) = ci2(:,1);
    chigh(:,a) = ci2(:,2);
    ififty(1,a) = beta2(1);
    rsquared(1,a) = mdl2.Rsquared.Adjusted;
end


end