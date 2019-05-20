function [wave_diff2, wave_diff2_rms, sorted_max_rms] = DR_spike_RMS_calc(sort_wave,rmswind)
%DR_spike_RMS_calc   Calculates the 2nd derivative and windowed RMS of
%                    popspikes
%
%   Usage:
%      [wave_diff2, wave_diff2_rms, sorted_max_rms] = DR_spike_RMS_calc(sort_wave,rmswind)
%
%   Description:
%       This script calculates the 2nd derivative of popspike data and uses a
%       sliding window RMS to detect complex high-amplitude and high-frequency
%       activity. 
%
%   Parameters:
%       sort_wave       A cell array containing sorted DR data in the format 
%                       sort_wave{chs,levels}(epoch,reps)
%       rmswind         The size of the sliding RMS window in samples (usually 0.01*fs)
%
%   Return Values:
%       wave_diff2      2nd derivative of the data (for plotting)
%       wave_diff2_rms  Sliding window RMS of the data (for spike detection
%                       and plotting)
%       sorted_max_rms  The sorted max RMS in each epoch (used to set
%                       detection thresholds)
%
%
%   Copyright (C) 2018 David Klorig
%   Author: David Klorig
%   Last modification: 2/6/2018

% Determine Data Structure
chs = size(sort_wave,1);
levels = size(sort_wave,2);
epoch = size(sort_wave{1,1},1);
reps = size(sort_wave{1,1},2);


% Calculate 2nd Derivative and RMS
wave_diff2 = cell(chs, levels);
wave_diff2_rms = cell(chs, levels);
max_rms = cell(chs, levels);
max_rms_ind = cell(chs, levels);
sorted_max_rms = cell(chs, levels);

for a = 1:chs
    for b = 1:levels
        wave_diff2{a,b} = zeros(epoch,reps);
        wave_diff2_rms{a,b} = zeros(epoch,reps);
        max_rms{a,b} = zeros(1,reps);
        max_rms_ind{a,b} = zeros(1,reps);
        sorted_max_rms{a,b} = zeros(1,reps);
    end
end


for a = 1:chs
    for b = 1:levels
        for c = 1:reps
            wave_diff2{a,b}(:,c) = vertcat(diff(diff(sort_wave{a,b}(:,c))),[0;0]);
            wave_diff2_rms{a,b}(:,c) = fastrms(wave_diff2{a,b}(:,c),rmswind);
            [max_rms{a,b}(1,c) , max_rms_ind{a,b}(1,c)] = max(wave_diff2_rms{a,b}(:,c));
        end
        sorted_max_rms{a,b} = sort(max_rms{a,b}(1,:));
    end
end

end