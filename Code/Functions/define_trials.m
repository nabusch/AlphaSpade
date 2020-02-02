function INFO = define_trials(INFO)

%% Define what happens on each trial by permuting all experimental factors.

P = INFO.P; % just for shorthand.
sides = [-1 1];

%%
itrial = 0;
for irepeat = 1:P.paradigm.n_trials
    for itarg = 1:length(P.paradigm.target)
        itrial = itrial + 1;
        
        T(itrial).trial = [];
        T(itrial).target = P.paradigm.target(itarg);      
        
        % Initalize other parameter values that do not need
        % counterbalancing. This is useful for having the struct fields in
        % a meaningful order; it facilitates reading the logfile table.
        T(itrial).contrast = [];
        T(itrial).button = [];
        T(itrial).correct = [];
        T(itrial).report = [];
        T(itrial).rt = [];
        T(itrial).t_trial_on = [];
        T(itrial).t_target_on = [];
        T(itrial).t_target_off = [];
        T(itrial).target_dur = [];
        T(itrial).t_prompt_on = [];
        T(itrial).thresh_estimate = [];
        T(itrial).thresh_sd = [];    
        T(itrial).trial_completed = [];
    end
end

INFO.T = Shuffle(T);
%% Done.