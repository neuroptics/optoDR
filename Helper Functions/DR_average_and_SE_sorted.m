function [avg_wave, STE_wave, STE_lower, STE_upper ] = DR_average_and_SE_sorted( sort_wave )
%DR_average_and_SE_sorted   Calculates the mean and standard error upper
%                           and lower bounds for DR data (in the sort wave 
%                           format)
%
%   Usage:
%      [avg_wave, STE_wave, STE_lower, STE_upper ] = DR_average_and_SE_sorted( sort_wave )
%
%   Description:
%       This script calculates mean and estimates the 95% confidence interval 
%       for DR data in the sort_wave format (imported with "NS_import_waveforms_DR_sort.m")
%
%   Parameters:
%       sort_wave	A cell array containing sorted DR data in the format 
%                   sort_wave{chs,levels}(epoch,reps)
%
%   Return Values:
%       avg_wave   Mean waveform for each level (averages across reps)
%       STE_wave   Standard error for each level (averages across reps)
%       STE_lower  Lower bound of STE (for plotting)
%       STE_upper  Upper bound of STE (for plotting)
%
%
%   Copyright (C) 2015 David Klorig
%   Author: David Klorig
%   Last modification: 12/20/2015

% Calculate Averages and STE
chs = size(sort_wave,1);
levels = size(sort_wave,2);
epoch = size(sort_wave{1,1},1);
reps = size(sort_wave{1,1},2);

avg_wave = cell(chs,1);

for a = 1:chs
    avg_wave{a,1} = zeros(epoch,levels);
end

for a = 1:chs
    for b = 1:levels
        avg_wave{a,1}(:,b) = mean(sort_wave{a,b},2);
    end
end

% Calculate Confidence Intervals (standard error) - 95% CI

z = 1.96;

STE_wave = cell(chs,1);
STE_upper = cell(chs,1);
STE_lower = cell(chs,1);

for a = 1:chs
    STE_wave{a,1} = zeros(epoch,levels);
    STE_upper{a,1} = zeros(epoch,levels);
    STE_lower{a,1} = zeros(epoch,levels);
end

for a = 1:chs
    for b = 1:levels
        STE_wave{a,1}(:,b) = z*std(sort_wave{a,b},[],2)./sqrt(reps);
        STE_upper{a,1}(:,b) = avg_wave{a,1}(:,b) + STE_wave{a,1}(:,b);
        STE_lower{a,1}(:,b) = avg_wave{a,1}(:,b) - STE_wave{a,1}(:,b);
    end
end

end

