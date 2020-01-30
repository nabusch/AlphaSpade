clear; close all; clc

name = 'test';
log_dir = './Logfiles/';
log_name = [name '_Logfile.mat'];

% Load logfile.
load(fullfile(log_dir, log_name))
T = INFO.T;

% Remove trials that were not completed.
T(~[T.trial_completed]) = [];

% Evaluate responses;
target_present = [T.target] ~= 0;
is_correct = [T.correct] == 1;

target_l = [T.target] == -1;
target_0 = [T.target] ==  0;
target_r = [T.target] ==  1;

button_l = [T.button] == -1;
button_0 = [T.button] ==  0;
button_r = [T.button] ==  1;


p_ll = sum(target_l & button_l) / sum(target_l);
p_l0 = sum(target_l & button_0) / sum(target_l);
p_lr = sum(target_l & button_r) / sum(target_l);
p_0l = sum(target_0 & button_l) / sum(target_0);
p_00 = sum(target_0 & button_0) / sum(target_0);
p_0r = sum(target_0 & button_r) / sum(target_0);
p_rl = sum(target_r & button_l) / sum(target_r);
p_r0 = sum(target_r & button_0) / sum(target_r);
p_rr = sum(target_r & button_r) / sum(target_r);

%%

figure('color', 'w'); hold all
% line plot with all target present trials
plot([T(target_present).itrial], [T(target_present).contrast], '-k')

% only correct
plot([T(target_present & is_correct).itrial], ...
    [T(target_present & is_correct).contrast], 'go', 'MarkerFaceColor', 'auto')

% only error
plot([T(target_present & ~is_correct).itrial], ...
    [T(target_present & ~is_correct).contrast], 'ro', 'MarkerFaceColor', 'auto')

xlabel('Trials')
ylabel('Contrast')
title('Time course of Quest procedure')

%%
figure('color', 'w'); hold all
plot([p_ll p_l0 p_lr], '-o', 'MarkerFaceColor', 'auto')
plot([p_0l p_00 p_0r], '-o', 'MarkerFaceColor', 'auto')
plot([p_rl p_r0 p_rr], '-o', 'MarkerFaceColor', 'auto')
xlabel('Report')
ylabel('prop.')
title('What we presented and what people reported')
legend('left target', 'no target', 'right target', 'location', 'E')


set(gca, 'xtick', [1 2 3], 'xlim', [0.8 3.2], ...
    'xticklabels', {'left' 'nothing' 'right'})



