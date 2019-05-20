%Optogenetic Dose Response (optoDR) - Main Script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This script imports and analyses optogenetic dose response data.
%It uses a spreadsheet to organize files and their associated analysis parameters called a "Manifest". 
%An example manifest is provided ("Example_Manifest.xlsx") in the main folder. 

%   Copyright (C) 2018 David Klorig
%   Author: David Klorig
%   Last modification: 6/14/2018

%v1.0





%% Open Manifest
%%%%%%%%%%%%%%%%

%Run this to read in file info from the manifest spreadsheet

clear;
close all;

%Import Manifest
manifest = 'Example_Manifest';
ext = '.xlsx';

master = table2struct(readtable([manifest,ext],'Sheet','master'));

%Reformat Manifest (fix readtable mistakes)
time_format = 'HH:MM';

for a = 1:size(master,1)
    master(a).file_time = datestr(master(a).date_time,time_format); % fix time
    master(a).import_chs = str2num(master(a).import_chs);
    master(a).ch_map = str2num(master(a).ch_map);
    master(a).lvls = str2num(master(a).lvls);
end

%Load From and Save Extracted Data To
extract_path = 'C:\Users\xxxxxxx\Documents\MATLAB\optoDR_for_eNeuro\'; %change this to the folder location (PC)
%extract_path = '/Users/xxxxxxx/Documents/MATLAB/optoDR_for_eNeuro/'; %change this to the folder location (for mac and linux)


%% Import Raw Data (optional, skip if running example)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% reimport = 0; %overwrite files that have already been imported?
% 
% errors = optoDR_import(extract_path,master,reimport);


%% Plot Dose Response Curves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Mean peri-stimulus LFP w/ 95% confidence intervals 


for p = 1:length(master)
    load([extract_path,master(p).rec_name,'.mat']);
    
    time = -master(p).pre:1/master(p).fs:(master(p).epoch-master(p).pre)-(1/master(p).fs);
    srt = 0.03*master(p).fs;
    stp = 0.1*master(p).fs;
    titles = cellstr(char('PFC','AM','DG','CA3','Ent','Sub','CA1-L','CA1-R'));
    
    [avg_wave, ~, CI_lower, CI_upper ] = DR_average_and_SE_sorted(sep_wave);
    
    fig = DR_plot_butterfly_all_ci( time, avg_wave, CI_lower, CI_upper, srt, stp,master(p).gain,titles,master(p).rec_name);
    
    pause(3);
    close(fig);
end

%The next section will make it clear why averages are misleading for this
%data set.


%% Detect Epileptiform Discharges
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


close all hidden

%set(0,'DefaultFigureVisible','off'); %uncomment for batch run

%Initialize
pop_spike_ratio = cell(length(master),1);
high_index_all = cell(length(master),1);
bolt_ififty_all = cell(length(master),1);
bolt_rsquared_all = cell(length(master),1);
bin_ififty_all = cell(length(master),1);
bin_rsquared_all = cell(length(master),1);
bins_all = cell(length(master),1);

%Main Loop
p = 1;
%for p = 1:length(master)  %uncomment for batch run

%Load file (extracted epochs)
load([extract_path,master(p).rec_name,'.mat']);

%Import Analysis Parameters
chs = master(p).chs;
levels = master(p).levels;
reps = master(p).reps;
epoch = master(p).epoch;
fs = master(p).fs;
%time = master(p).time;
first_pulse = master(p).first_pulse;
pulse_int = master(p).pulse_int;

%Set RMS window size (10ms works best in most cases)
rmswind = 0.01*fs;
master(p).rmswind = rmswind;

%Calculate Sliding Window RMS of the 2nd Derivative
[wave_diff2, wave_diff2_rms, sorted_max_rms] = DR_spike_RMS_calc(wave_filt,rmswind);

%Threshold RMS and Separate Epileptiform Discharges
[high_index, high_wave, low_index, low_wave] = DR_spike_sep_all_ch(wave_filt,wave_diff2_rms,master(p).tch,master(p).tsrt,master(p).tstp,master(p).th);

%Calculate Ratios
high_ct = sum(high_index,2);
pop_spike_ratio{p,1} = high_ct/reps;
high_index_all{p,1} = high_index;

%Curve Fitting
%%%%%%%%%%%%%%

% Fit Boltzman and Calculate I50 (all reps)
modelfun = 'y~(1/(1+exp((b1-x1)/b2)))';
beta0 = [15 0.5];

warning off
[bolt_yfit, bolt_clow, bolt_chigh, bolt_ififty, bolt_rsquared] = DR_spike_curve_fit(high_index,modelfun,beta0);
warning on

bolt_ififty_all{p,1} = bolt_ififty;
bolt_rsquared_all{p,1} = bolt_rsquared;


%Curve Fit on Binned Data (I50 over time)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bin_size = 6; %Number of presentation blocks to bin

%Bin Data and Fit Curves
warning off
[bin_yfit, bin_clow, bin_chigh, bin_ififty, bin_rsquared, bins] = DR_spike_curve_fit_bin(high_index,bin_size,modelfun,beta0);
warning on

%Generate X-values (time)
xvals = (first_pulse+(levels*bin_size*pulse_int):(levels*bin_size*pulse_int):first_pulse+(bins*bin_size*levels*pulse_int))./60; %x-axis in time (minutes)

%Check for bad fits (can occur when no spikes are detected or when all traces are marked as spikes, 
% usually an indication that the threshold settings are incorrect)
if max(bin_ififty<=0) || max(bin_rsquared<=0) || max(isnan(bin_ififty)>0) || max(isnan(bin_rsquared)>0)
    %disp(['Error: Bad Fit',' I50: ',num2str(min(bin_ififty)),' R^2:',num2str(min(bin_rsquared))]);
    bad_fit{p,2} = [' Error: Bad Fit',' I50: ',num2str(min(bin_ififty)),' R^2:',num2str(min(bin_rsquared))];
    disp([master(p).rec_name,bad_fit{p,2}]);
    
    bin_ififty(bin_ififty>25) = NaN;
    bin_ififty(bin_ififty<=0) = NaN;
    bin_ififty(bin_rsquared<0) = NaN;
    bin_rsquared(isinf(bin_rsquared)) = NaN; %in case of a really bad fit remove spurious points
    %bin_rsquared(isnan(bin_rsquared)) = 0;
    
    
    bin_ififty_all{p,1} = bin_ififty;
    bin_rsquared_all{p,1} = bin_rsquared;
    bins_all{p,1} = bins;
    
else
    
    bin_ififty_all{p,1} = bin_ififty;
    bin_rsquared_all{p,1} = bin_rsquared;
    bins_all{p,1} = bins;
    
end

disp(strcat('Analyzed: ',master(p).rec_name));


%% Plot Raw Data - All on one plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Plots raw traces, all channels and all levels (color-coded). 

%Initialize figure
fig = figure('Position',[1 50 1900 950],'Color',[0 0 0],'Name',master(p).rec_name);

axes('ZColor',[1 1 1],'YColor',[1 1 1],...
    'XColor',[1 1 1],...
    'Color',[0 0 0],'FontSize',32,'LineWidth',2);

%Manually set subplot vectors
row = 1;
column = 8;
row_space = 0.04;
col_space = 0.015;

pos_vect2 = manual_subplot_tight( row,column,row_space,col_space);

%Set color scheme
colors = jet(levels);

%Specify time window for plotting
srt = 0.04*fs; %Time 0 is 0.05*fs
stp = 0.1*fs;

%Set Y-axis Scaling
step = zeros(chs,1);
for a = 1:chs
    step(a,1) = (max(max(wave_filt{a,levels}(srt:stp,:))) - min(min(wave_filt{a,levels}(srt:stp,:))))/2;
end
step2 = max(step);

xmin = -0.01;
xmax = 0.05;
ymin = step2/2;
ymax = (step2*levels)+step2;


%Plot all

h = zeros(chs,1);

for a = 1:chs
    h(a,1) = subplot('Position',pos_vect2{a,1});
    
    hold on
    for b = 1:levels
        for c = 1:reps
            plot(time(1,srt:stp),wave_filt{a,b}(srt:stp,c)+(step2*b),'color',colors(b,:));
        end
    end
    hold off
    
    %Settings
    axis([xmin xmax ymin ymax]);
    set(h(a,1),'ZColor',[1 1 1],'YColor',[1 1 1],...
        'XColor',[1 1 1],...
        'Color',[0 0 0]);
end

%Save figure using "export_fig"
export_fig(strcat(master(p).rec_name,'_raw_filt_all_',num2str(reps),'_reps.png'),fig,'-nocrop');


%% Plot RMS and Threshold Summary
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Plots the sliding windown RMS of the 2nd derivative for the selected
%channel (master.tch). This plot is useful for selecting threshold time
%window (master.tsrt:master.tstp) and the threshold (master.th).


fig = figure('Position',[1 50 950 950],'Color',[0 0 0],'Name',strcat(master(p).rec_name));

titles = cellstr(char('PFC','AM','DG','CA3','Ent','Sub','CA1-L','CA1-R'));

colors = jet(levels);

% Subplot "tight" position vectors
row_space = 0.05;
col_space = 0.03;
switch levels
    case 10
        row = 4;
        column = 3;
    case 20
        row = 7;
        column = 3;
end

[pos_vect ] = manual_subplot_tight2(row,column,row_space,col_space);

%Plot time window (zoom in on the response)
srt = 0.04*fs; %0 is 0.05*fs
stp = 0.1*fs;

xmin = time(1,srt);
xmax = time(1,stp);
ymin = 0;

temp = zeros(1,levels);
for a = 1:levels
    temp(1,a) = max(max(wave_diff2_rms{master(p).tch,a}(srt:stp,:)));
end
ymax = max(temp);


for a = 1:levels
    h(a,1) = subplot('Position',pos_vect{a,1});
    
    hold on
    
    %Plot RMS
    for b = 1:reps
        plot(time(1,srt:stp),wave_diff2_rms{master(p).tch,a}(srt:stp,b),'color',colors(a,:));
    end
    
    %Plot Threshold
    plot(time(1,srt:stp),master(p).th*ones(size(time(1,srt:stp))),'w');
    
    %Plot Threshold Time Window
    thplt1 = time(1,master(p).tsrt);
    thplt2 = time(1,master(p).tstp);
    line([thplt1 thplt1],[ymin ymax],'Color',[1 1 1]);
    line([thplt2 thplt2],[ymin ymax],'Color',[1 1 1]);
    
    hold off
    
    %Format
    axis([xmin xmax ymin ymax]);
    set(h(a,1),'ZColor',[1 1 1],'YColor',[1 1 1],...
        'XColor',[1 1 1],...
        'Color',[0 0 0]);
    
    textx = get(gca,'XLim');
    texty = get(gca,'YLim');
    text(((textx(2)-textx(1))*0.05)+textx(1),((texty(2)-texty(1))*0.95)+texty(1),titles(master(p).tch),'color','w','FontSize',16);
end

%Save Figure using "export_fig"
export_fig(strcat(master(p).rec_name,'_RMS_thresh_summary_',num2str(reps),'_reps.png'),fig,'-nocrop');



%% Plot Sorted Max RMS Value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Plots the max sliding windown RMS of the 2nd derivative, sorted by increasing magnitude, within the
%specified time window (tsrt:tstp). This plot is useful for selecting the
%threshold (typically just above the inflection point). 

colors = jet(levels);

fig = figure('Position',[1 1 950 1050],'Color',[0 0 0],'Name',strcat(master(p).rec_name));

titles = cellstr(char('PFC','AM','DG','CA3','Ent','Sub','CA1-L','CA1-R'));

colors = jet(levels);

for a = 1:chs
    h = subplot(4,2,a);
    
    hold on
    for b = 1:levels
        plot(sorted_max_rms{a,b},'color',colors(b,:))
    end
    if master(p).tch == a
        plot(master(p).th*ones(1,reps),'w');
    end
    hold off
    
    axis tight
    set(h,'ZColor',[1 1 1],'YColor',[1 1 1],...
        'XColor',[1 1 1],...
        'Color',[0 0 0]);
    xlabel('Sorted Reps');
    ylabel('RMS');
    
    textx = get(gca,'XLim');
    texty = get(gca,'YLim');
    text(((textx(2)-textx(1))*0.05)+textx(1),((texty(2)-texty(1))*0.95)+texty(1),titles(a),'color','w','FontSize',16);
    
end

export_fig(strcat(master(p).rec_name,'_RMS_sorted_thresh_',num2str(reps),'_reps.png'),fig,'-nocrop');


%% Plot Separated Raw Traces
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Plot all levels of the thresholding channel (master.tch). This plot is useful for varifying discharge separation.  


fig = figure('Position',[1 50 950 950],'Color',[0 0 0],'Name',master(p).rec_name);

axes('ZColor',[1 1 1],'YColor',[1 1 1],...
    'XColor',[1 1 1],...
    'Color',[0 0 0],'FontSize',32,'LineWidth',2);

% Subplot "tight" position vectors
row_space = 0.02;
col_space = 0.02;
switch levels
    case 10
        row = 4;
        column = 3;
    case 20
        row = 7;
        column = 3;
end

[pos_vect ] = manual_subplot_tight2(row,column,row_space,col_space);

srt = 0.05*fs;
stp = 0.09*fs;
scale_factor = 0.5;

xmin = 0;
xmax = 0.04;

if isempty(high_wave{max(levels),1}) < 1
    ymin = min(min(high_wave{max(levels),master(p).tch}(srt:stp,:)))-250;
    ymax = max(max(high_wave{max(levels),master(p).tch}(srt:stp,:)))+1000;
else
    ymin = min(min(low_wave{max(levels),master(p).tch}(srt:stp,:)))-250;
    ymax = max(max(low_wave{max(levels),master(p).tch}(srt:stp,:)))+1000;
end


shift = 0;

h = zeros(levels,1);

for a = 1:levels
    %h(a,1) = subplot(4,5,a);
    h(a,1) = subplot('Position',pos_vect{a,1});
    hold on
    if isempty(high_wave{a,master(p).tch}) < 1
        max_waves = length(high_wave{a,master(p).tch}(1,:));
        colors = autumn(max_waves);
        for c = 1:max_waves
            plot(time(1,srt:stp),high_wave{a,master(p).tch}(srt:stp,c)+shift,'color',colors(c,:));
        end
    end
    if isempty(low_wave{a,master(p).tch}) < 1
        max_waves = length(low_wave{a,master(p).tch}(1,:));
        colors = winter(max_waves);
        for c = 1:max_waves
            plot(time(1,srt:stp),low_wave{a,master(p).tch}(srt:stp,c),'color',colors(c,:));
        end
    end
    
    hold off
    axis([xmin xmax ymin ymax]);
    set(h(a,1),'ZColor',[1 1 1],'YColor',[1 1 1],...
        'XColor',[1 1 1],...
        'Color',[0 0 0]);
end

export_fig(strcat(master(p).rec_name,'_PS_sep_plot_ch',num2str(master(p).tch),'_',num2str(reps),'_reps.png'),fig,'-nocrop');


%% Plot Fit Summary
%%%%%%%%%%%%%%%%%%%

%Plots intensity level vs probability of discharge, non-linear curve fitting, and I50

fig = figure('Position',[1 1 800 800],'Color',[1 1 1]);

xmin = 1;
xmax = levels;
ymin = 0;
ymax = 1;

y = sum(high_index,2);
x = (1:levels)';
fine_x = (1:0.1:levels)';

hold on
plot(x, y./reps,'o');

plot(fine_x,bolt_yfit,'-','LineWidth',2,'Color','b');
plot(fine_x,bolt_clow,'--','LineWidth',1,'Color','b');
plot(fine_x,bolt_chigh,'--','LineWidth',1,'Color','b');

plot(x,ones(size(x)).*0.5,'k','LineStyle','--');
line([bolt_ififty bolt_ififty],[0 1],'LineStyle','--','Color',[0 0 0]);
hold off
axis([xmin xmax ymin ymax]);

textx = get(gca,'XLim');
texty = get(gca,'YLim');
text(((textx(2)-textx(1))*0.05)+textx(1),((texty(2)-texty(1))*0.95)+texty(1),master(p).rec_name,'color','k','FontSize',16,'Interpreter','none');
text(((textx(2)-textx(1))*0.05)+textx(1),((texty(2)-texty(1))*0.9)+texty(1),['r^2 = ',num2str(bolt_rsquared.Adjusted)],'color','k','FontSize',16,'Interpreter','tex');
text(((textx(2)-textx(1))*0.05)+textx(1),((texty(2)-texty(1))*0.85)+texty(1),['I50 = ',num2str(bolt_ififty)],'color','k','FontSize',16,'Interpreter','none');

export_fig(strcat(master(p).rec_name,'_curves_summary_',num2str(reps),'_reps.png'),fig,'-nocrop');


%% Curve Fit on Binned Data (I50 over time)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Breaks recording session into bins of randomized stimulus blocks and
%fits intermediate curves. Plots I50 and r-squared values over time.


warning off
[bin_yfit, bin_clow, bin_chigh, bin_ififty, bin_rsquared, bins] = DR_spike_curve_fit_bin(high_index,bin_size,modelfun,beta0);
warning on

xvals = (first_pulse+(levels*bin_size*pulse_int):(levels*bin_size*pulse_int):first_pulse+(bins*bin_size*levels*pulse_int))./60; %x-axis in time (minutes)

if max(bin_ififty<=0) || max(bin_rsquared<=0) || max(isnan(bin_ififty)>0) || max(isnan(bin_rsquared)>0)
    
    disp(['Error: Bad Fit',' I50: ',num2str(min(bin_ififty)),' R^2:',num2str(min(bin_rsquared))]); 
    
else
    
    % Plot Level Over Time
    fig = figure('Position',[10 50 1900 600],'Color',[0 0 0]);
    
    axes('ZColor',[1 1 1],'YColor',[1 1 1],...
        'XColor',[1 1 1],...
        'Color',[0 0 0],'FontSize',32,'LineWidth',2);
    
    %xvals = (first_pulse+(levels*bin_size*pulse_int):(levels*bin_size*pulse_int):first_pulse+(bins*bin_size*levels*pulse_int))./60; %x-axis in time (minutes)
    
    xmin = xvals(1);
    xmax = xvals(size(xvals,2));
    ymin = min(bin_ififty)-(min(bin_ififty)*0.1);
    ymax = max(bin_ififty)+(max(bin_ififty)*0.1);
    
    h = subplot(2,1,1);
    plot(xvals,bin_ififty,'color','w','LineWidth',1.5);
    set(h,'ZColor',[1 1 1],'YColor',[1 1 1],...
        'XColor',[1 1 1],...
        'Color',[0 0 0]);
    axis([xmin xmax ymin ymax]);
    title([master(p).rec_name,' Bin Size: ',num2str(bin_size)],'color','w','FontSize',12,'FontWeight','bold','Interpreter','none');
    
    ymin = min(bin_rsquared)-(min(bin_rsquared)*0.1);
    ymax = max(bin_rsquared)+(max(bin_rsquared)*0.1);
    ymin(ymin<0||isnan(ymin)) = 0;
    ymax(ymax>1) = 1;
    
    h = subplot(2,1,2);
    plot(xvals,bin_rsquared,'color','w','LineWidth',1.5);
    set(h,'ZColor',[1 1 1],'YColor',[1 1 1],...
        'XColor',[1 1 1],...
        'Color',[0 0 0]);
    axis([xmin xmax ymin ymax]);
    title('r-squared (adj)','color','w','FontSize',12,'FontWeight','bold','Interpreter','none');
    
    export_fig(strcat(master(p).rec_name,'_I50_Bin_',num2str(bin_size),'.png'),fig,'-nocrop');
end

%% Uncomment for batch run

%end
%set(0,'DefaultFigureVisible','on');



