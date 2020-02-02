clear; close all; clc

% Make sure you are really in the "Analyze_logfiles" subdirectory!
log_dir = '../Logfiles/';

% Automatically read all files with names of a specific pattern.
files = extractfield(dir([log_dir, '*_nikonoisejitter*']), 'name');

% Alternatively, list files explicitly.
% files = {
%     '2020-02-01_1718_niko_logfile'
%     '2020-02-01_1722_niko_logfile'
%     };

LOG = load_logfiles(files, log_dir);
RES = get_results(LOG);

%% Show performance in the detection task.
figure('color', 'w'); hold all

colors = lines;

plot([0.95 1.95 2.95], [RES.mn_p_ll RES.mn_p_l0 RES.mn_p_lr], '-', 'MarkerFaceColor', 'auto')
plot([1.00 2.00 3.00], [RES.mn_p_0l RES.mn_p_00 RES.mn_p_0r], '-', 'MarkerFaceColor', 'auto')
plot([1.05 2.05 3.05], [RES.mn_p_rl RES.mn_p_r0 RES.mn_p_rr], '-', 'MarkerFaceColor', 'auto')
legend('left target', 'no target', 'right target', 'location', 'NE')

boxplot([RES.p_ll' RES.p_l0' RES.p_lr'], 'labels', {'left', 'nothing', 'right'}, ...
    'colors', colors(1,:), 'PlotStyle','compact', 'positions', [0.95 1.95 2.95])

boxplot([RES.p_0l' RES.p_00' RES.p_0r'], 'labels', {'left', 'nothing', 'right'}, ...
    'colors', colors(2,:), 'PlotStyle','compact', 'positions', [1.00 2.00 3.00])

boxplot([RES.p_rl' RES.p_r0' RES.p_rr'], 'labels', {'left', 'nothing', 'right'}, ...
    'colors', colors(3,:), 'PlotStyle','compact', 'positions', [1.05 2.05 3.05])

xlabel('Report')
ylabel('prop.')
title('What we presented and what people reported')
set(gca, 'xtick', [1 2 3], 'xlim', [0.8 3.2], 'ylim', [0 1], ...
    'xticklabels', {'left' 'nothing' 'right'}, 'box', 'off')

%% Show time course of Quest procedure for all subjects.
figure('color', 'w'); hold all

colors = lines;

for i = 1:RES.n
    
    no = RES.contrast{i} == 0;
    ph(i) = plot(RES.trials{i}(~no), RES.contrast{i}(~no), '-', 'color', colors(i,:));
    
    % only errors
    plot(RES.trials{i}(~no & RES.iscorrect{i}), ...
        RES.contrast{i}(~no & RES.iscorrect{i}), 'ro', 'MarkerFaceColor', 'auto')
    
    legstr{i} = sprintf('%d', i); 
end

legend(ph, legstr)
xlabel('Trials')
ylabel('Contrast')
title('Time course of Quest procedure')


%%
