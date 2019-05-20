function [high_index, high_wave, low_index, low_wave] = DR_spike_sep_all_ch(sort_wave,wave_diff2_rms,tch,tsrt,tstp,thresh)
%DR_spike_sep_all_ch       Separates Spikes from Non-Spikes in Spike DR data
%
%   Usage:
%      [high_index, high_wave, low_index, low_wave] = DR_spike_sep_all_ch(sort_wave,wave_diff2_rms,tch,tsrt,tstp,thresh)
%
%   Description:
%       This script thresholds the windowed RMS data from DR_spike_RMS_calc.m to 
%       separate spikes from non-spikes. Outputs sorted waveforms for all
%       channels. 
%
%   Parameters:
%       sort_wave       A cell array containing sorted DR data in the format 
%                       sort_wave{chs,levels}(epoch,reps)
%       wave_diff2_rms  A cell array containing sorted RMS DR data 
%       tch             Channel to threshold
%       tsrt            Threshold start
%       tstp            Threshold stop
%       thresh          Threshold level
%
%   Return Values:
%       high_index      Index of popspikes
%       high_wave       A cell array containing popspike waveforms(levels,chs)
%       low_index       Index of non-popspikes
%       low_wave        A cell array containing non-popspike waveforms
%
%   Copyright (C) 2018 David Klorig
%   Author: David Klorig
%   Last modification: 2/6/2018

% Determine Data Structure
levels = size(sort_wave,2);
reps = size(sort_wave{1,1},2);
chs = size(sort_wave,1);


% Threshold Each Level (Single Threshold, 2nd Deriv, RMS)
low_wave = cell(levels,chs);
high_wave = cell(levels,chs);

low_index = zeros(levels,reps);
high_index = zeros(levels,reps);


for a = 1:levels
    for b = 1:reps
        if max(wave_diff2_rms{tch,a}(tsrt:tstp,b)) > thresh
            high_index(a,b) = 1;
        else
            low_index(a,b) = 1;
        end
    end
end

% Sort Waveforms by Pop Spike
for a = 1:levels
    for b = 1:chs
        low_wave{a,b} = sort_wave{b,a}(:,(low_index(a,:)>0));
        high_wave{a,b} = sort_wave{b,a}(:,(high_index(a,:)>0));
    end
end

end