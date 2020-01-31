
%% -----------------------------------------------------------------------
% Start here.
% ------------------------------------------------------------------------
clear
close all
addpath('./Functions');

name  ='test';

% Initialize the INFO struct. This is basically our logfile.
INFO.name = name;
now_is_the_time = datestr(now, 'yyyy-mm-dd_HHMM');
INFO.logfilename = fullfile('./Logfiles', [
    now_is_the_time, ...
    '_', name, ...
    '_logfile.mat'
    ]);

INFO.tStart = now_is_the_time;

% Load the parameters. All the specific setting about stimulus size,
% duration etc. is in the INFO.P struct.
INFO.P = get_params;



%% -----------------------------------------------------------------------
% Test if logfile exists for this subject.
% If yes, confirm to overwrite or quit.
% ------------------------------------------------------------------------
switch name
    case 'test'
        isQuit = 0; % logfile will be automatically overwritten
    otherwise
        isQuit = test_logfile(INFO);
end

if isQuit
    close_and_cleanup(P)
    return
end



%% -----------------------------------------------------------------------
% Define what do do on each trial.
% ------------------------------------------------------------------------
INFO = define_trials(INFO);
% t=struct2table(INFO.T);



%% -----------------------------------------------------------------------
% Define the Quest structure.
% ------------------------------------------------------------------------
INFO.Q = get_quest(INFO.P);



%% -----------------------------------------------------------------------
% Open the display and set priority.
% ------------------------------------------------------------------------
if INFO.P.do_testrun < 2
    PsychDefaultSetup(1);
    Screen('Preference', 'SkipSyncTests', INFO.P.setup.skipsync);
    Screen('Resolution', INFO.P.screen.screen_num, INFO.P.screen.width, ...
        INFO.P.screen.height, INFO.P.screen.rate);
    
    win = PsychImaging('Openwindow', ...
        INFO.P.screen.screen_num, INFO.P.stim.background_color);
    
    Priority(MaxPriority(win));
    
    if INFO.P.setup.useCLUT
        addpath('./CLUT');
        load(INFO.P.setup.CLUTfile);
        Screen('LoadNormalizedGammaTable',win,inverseCLUT);
    end
    
    HideCursor
end



%% ------------------------------------------------------------------------
% Open EEG trigger port if required.
% ------------------------------------------------------------------------
if INFO.P.setup.isEEG
    OpenTriggerPort;
    SendTrigger(INFO.P.trigger.trig_start, INFO.P.trigger.trig_dur);
end



%% ----------------------------------------------------------------------
% Run across trials.
%----------------------------------------------------------------------
fprintf('\nNow running %d trials.\n\n', length(INFO.T));
isQuit = false;
tic;

for itrial = 1:length(INFO.T)
    
    INFO.T(itrial).itrial = itrial;
    
    %-------------------------------------------------
    % Present a break if necessary.
    %-------------------------------------------------
    if ~INFO.P.do_testrun
        if(mod(itrial, INFO.P.paradigm.break_after_x_trials) == 1 || itrial == 1)
            present_pause(win, INFO, itrial)
        end
    end
    
    %-------------------------------------------------
    % Let Quest make a recommendation for the contrast to use on this
    % trial.
    %-------------------------------------------------
    if INFO.T(itrial).target
        INFO.T(itrial).contrast = 10^QuestQuantile(INFO.Q);
    else
        INFO.T(itrial).contrast = 0;
    end
    
    if INFO.T(itrial).contrast > 1; INFO.T(itrial).contrast = 1; end
    
    %-------------------------------------------------
    % Present the trial or simulate the trial.
    %-------------------------------------------------
    fprintf('Trial #%2.2d of %d. Target: %d; Contrast: %2.2f.', ...
        itrial, length(INFO.T), INFO.T(itrial).target, INFO.T(itrial).contrast);
    
    switch INFO.P.do_testrun
        case 2
            % do nothing, just simulation.
        otherwise
            % really present stimuli on the screen.
            INFO = one_trial_loop(INFO, win, itrial);
    end
    
    %-------------------------------------------------
    % Get the behavioral response for this trial.
    %-------------------------------------------------
    [INFO, isQuit] = get_response(INFO, itrial);
    
    fprintf(' Report: %s\n', INFO.T(itrial).report);
    
    %-------------------------------------------------
    % Update Quest with results from this trial, but only if there was a target.
    %-------------------------------------------------
    if INFO.T(itrial).target
        INFO.Q = QuestUpdate(INFO.Q, log10(INFO.T(itrial).contrast), INFO.T(itrial).correct);
    end
    INFO.T(itrial).thresh_estimate = QuestMean(INFO.Q);
    INFO.T(itrial).thresh_sd       = QuestSd(INFO.Q);
    
    %
    %-------------------------------------------------
    % Save results for this trial or quit the experiment.
    %-------------------------------------------------
    if isQuit==1
        close_and_cleanup(INFO.P)
        break
    else
        INFO.T(itrial).trial_completed = 1;
        INFO.ntrials = itrial;
        INFO.tTotal  = toc;
        INFO.tFinish = {datestr(clock)};
    end
    
    % Do not save data now if this is a testrun; this would slow down too
    % much.
    if INFO.P.do_testrun == 2
        continue
    else
        save(INFO.logfilename, 'INFO');
    end
end



%% --------------------------------------------------------------------
% After last trial, close everything and exit.
%----------------------------------------------------------------------
save(INFO.logfilename, 'INFO');WaitSecs(2);
close_and_cleanup(INFO.P)
sca
fprintf('\nDONE!\n\n');
%% DONE!
