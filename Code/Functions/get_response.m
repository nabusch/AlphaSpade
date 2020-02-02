function [INFO, isQuit] = get_response(INFO, itrial)

P = INFO.P; % just for shorthand
T = INFO.T(itrial);
isQuit = 0;


switch INFO.P.do_testrun
    case 0
        % Really ask the subject for a button press.
        % They can say "left", "right", "saw nothing".
        [T.button, isQuit, secs] = get_buttonpress(P);
        
        % Calcualte response time.
        if P.do_testrun == 0
            T.rt = secs - (T.t_target_on + T.t_trial_on);
        end
        
    otherwise
        % Simulate a response. For simplicity, the simulated response
        % is either "1 = yes, I saw it" and that will be always
        % at the correct location, or "0: saw nothing".
        response = QuestSimulate(INFO.Q, log10(T.contrast), ...
            INFO.P.quest.guess);
        
        if response == 1 && T.target == -1 % left hit
            T.button = 1;
        elseif response == 1 && T.target == 1 % right hit
            T.button = 3;
        elseif response == 1 && T.target == 0 % false alarm
            T.button = 1 + 2*round(rand); % make left/right false alarms at random
        elseif response == 0
            T.button = 2;
        end
end

if isQuit
    return
end

% So far the button presses are called 1/2/3. We recode them to -1/0/+1, so
% that they use the same scheme as the variable coding target location.
T.button = P.paradigm.target(T.button);

% Send trigger.
if P.setup.isEEG
    trig = 100 + T.button;
    SendTrigger(trig, P.trigger.trig_dur);
end

% Code correctness.
if T.button == T.target
    T.correct = 1;
else
    T.correct = 0;
end

T.report = P.paradigm.conditions{2+T.button, 2+T.target};

% Now assign the shorthand T back to INFO.T
INFO.T(itrial) = T;

% DONE.