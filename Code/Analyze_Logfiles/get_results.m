function RES = get_results(LOG)

%%
RES = [];

ids = unique(LOG.id);
n = length(ids);

RES.n = n;

for i = 1:n
    
    fprintf('Processing participant %d\n', i)
    
    trials = LOG.id == ids(i);
    L = LOG(trials,:);
    
    % Evaluate responses;
    target_present = [L.target] ~= 0;
    is_correct = [L.correct] == 1;
    
    target_l = [L.target] == -1;
    target_0 = [L.target] ==  0;
    target_r = [L.target] ==  1;
    
    button_l = [L.button] == -1;
    button_0 = [L.button] ==  0;
    button_r = [L.button] ==  1;
    
    RES.p_ll(i) = sum(target_l & button_l) / sum(target_l);
    RES.p_l0(i) = sum(target_l & button_0) / sum(target_l);
    RES.p_lr(i) = sum(target_l & button_r) / sum(target_l);
    RES.p_0l(i) = sum(target_0 & button_l) / sum(target_0);
    RES.p_00(i) = sum(target_0 & button_0) / sum(target_0);
    RES.p_0r(i) = sum(target_0 & button_r) / sum(target_0);
    RES.p_rl(i) = sum(target_r & button_l) / sum(target_r);
    RES.p_r0(i) = sum(target_r & button_0) / sum(target_r);
    RES.p_rr(i) = sum(target_r & button_r) / sum(target_r);
    
    % These variables will be used to plot the Quest time course.
    RES.contrast{i}  = L.contrast;
    RES.iscorrect{i} = is_correct;
    RES.trials{i}    = L.trial;
end

RES.mn_p_ll = mean(RES.p_ll);
RES.mn_p_l0 = mean(RES.p_l0);
RES.mn_p_lr = mean(RES.p_lr);
RES.mn_p_0l = mean(RES.p_0l);
RES.mn_p_00 = mean(RES.p_00);
RES.mn_p_0r = mean(RES.p_0r);
RES.mn_p_rl = mean(RES.p_rl);
RES.mn_p_r0 = mean(RES.p_r0);
RES.mn_p_rr = mean(RES.p_rr);

disp('All processed.')
