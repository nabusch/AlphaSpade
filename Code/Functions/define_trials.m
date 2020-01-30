function INFO = define_trials(INFO)

%% Define what happens on each trial by permuting all experimental factors.

P = INFO.P; % just for shorthand.
sides = [-1 1];

%%
itrial = 0;
for irepeat = 1:P.paradigm.n_trials
    for itarg = 1:length(P.paradigm.target)
        itrial = itrial + 1;
        T(itrial).target = P.paradigm.target(itarg);
        
        
        % Initalize other parameter values that do not need
        % counterbalancing.
        T(itrial).button = [];
        T(itrial).correct = [];
        T(itrial).report = [];
        T(itrial).rt = [];
        T(itrial).t_trial_on = [];
        T(itrial).t_display_on = [];
        T(itrial).t_display_off = [];
        T(itrial).dur_display = [];
        T(itrial).thresh_estimate = [];
        T(itrial).thresh_sd = [];        
    end
end

INFO.T = Shuffle(T);
%% Done.