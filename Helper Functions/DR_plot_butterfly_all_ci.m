function fig = DR_plot_butterfly_all_ci( time, avg_wave, CI_lower, CI_upper, srt, stp, scale,titles, filename )
%DR_plot_butterfly_all  Generates a butterfly plot using avg DR data with all
%                       channels - with confidence intervals
%
%   Usage:
%      DR_plot_butterfly_all_ci( avg_wave, CI_lower, CI_upper, srt, stp, titles, filename )
%
%   Description:
%       This script generates a butterfly plot using DR data with all
%       channels -  confidence interval version
%
%   Parameters:
%       time        Time vector for plotting
%       avg_wave	A cell array containing average DR data in the format 
%                   sort_wave{chs,1}(epoch,levels)
%       CI_lower    CI lower bound
%       CI_upper    CI upper bound
%       srt         Start point (in samples)
%       stp         Stop point (in samples)
%       scale       Used to scale the amplitude of the output
%       titles      Channel titles (string array)
%       filename    The name of the plotted file 
%
%   Return Values:
%       fig         Figure handle
%
%
%   Copyright (C) 2015 David Klorig
%   Author: David Klorig
%   Last modification: 12/20/2015

% Plot Butterfly Overlay
chs = size(avg_wave,1);
levels = size(avg_wave{1,1},2);

colors = myColorMap('jet3',levels);

fig = figure('Position',[1 1 1900 1050],'Color',[0 0 0],'Name',strcat(filename,'_all_ci'));

for a = 1:chs
    h = subplot(chs/2,2,a);
    hold on
    for b = 1:levels
        ciplot2(CI_lower{a,1}(srt:stp,b)./scale,CI_upper{a,1}(srt:stp,b)./scale,time(1,srt:stp),colors(b,:));
        alpha(.3)  
        plot(time(1,srt:stp),avg_wave{a,1}(srt:stp,b)./scale,'color',colors(b,:));
    end
    hold off
    set(h,'ZColor',[1 1 1],'YColor',[1 1 1],...
    'XColor',[1 1 1],...
    'Color',[0 0 0]);
    axis tight

% colorbar('YTickLabel',...
%     {0.43,0.55,0.71,0.92,1.20,1.55,2.00,2.54,3.18,3.84,4.15},'FontSize',20);
    
    textx = get(gca,'XLim');
    texty = get(gca,'YLim');
    text(textx(1)*0.9,texty(1)*0.7,titles(a),'color','w','FontSize',16);
end

export_fig(strcat(filename,'_all_ci.png'),fig,'-nocrop');

end

