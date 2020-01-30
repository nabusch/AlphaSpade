function [P] = get_params



%% ------------------------------------------------------------------------
% Set the computer-specific parameters.
%  ------------------------------------------------------------------------
computername = getenv('COMPUTERNAME');
switch computername
    case 'X1YOGA'        
        thescreen = max(Screen('Screens'));
        myres = Screen('Resolution', thescreen);
        
        P.screen.screen_num   = thescreen;% 0 is you have only one screen (like a laptop) 1 or 2 if you have multiple screens one is usually the matlab screen
        P.screen.size         = [36 27]; %screen size in centimeters.
        P.screen.viewdist     = 55; % distance between subject and monitor
        
        P.setup.isEEG         = 0;
        P.setup.skipsync      = 1;
        P.setup.useCLUT       = 0;
        P.setup.CLUTfile      = 'inverse_CLUT 26 April 2012, 16-48.mat';
        
        
    case 'BUSCH02'        
        thescreen = max(Screen('Screens'));
        myres = Screen('Resolution', thescreen);
        
        P.screen.screen_num   = thescreen;%max(nscreens); 0 is you have only one screen (like a laptop) 1 or 2 if you have multiple screens one is usually the matlab screen
        P.screen.size         = [36 27]; %screen size in centimeters.
        P.screen.viewdist     = 55; % distance between subject and monitor
        
        P.setup.isEEG         = 0;
        P.setup.skipsync      = 1;
        P.setup.useCLUT       = 0;
        P.setup.CLUTfile      = 'inverse_CLUT 26 April 2012, 16-48.mat';
end

P.screen.width        = myres.width;
P.screen.height       = myres.height;
P.screen.rate         = myres.hz;
P.screen.frameint     = 1/P.screen.rate; % duration of a single frame in secs
P.screen.buffer       = 0.5 * P.screen.frameint; % request a flip slightly earlier than necessary to make sure that the flip comes at the required time.

% if==0, du a real experiment.
% if==1, show stimuli, but do not wait for button presses.
% if==2, completely bypass one_trial, do not show stimuli, and simulate
% behavior.
P.do_testrun = 2;

% Note: from this line onwards, variables coding the size of things
% indicate size in degrees visual angle. Internally, the functions
% executing stimulus genration and presentation will recompute these sizes
% into pixels.



%% ------------------------------------------------------------------------
%  Parameters of the screen.
%  Calculate size of a pixel in visual angles.
% ------------------------------------------------------------------------
P.screen.cx = round(P.screen.width/2); % x coordinate of screen center
P.screen.cy = round(P.screen.height/2); % y coordinate of screen center

[P.screen.pixperdeg, P.screen.degperpix] = VisAng(P);
P.screen.pixperdeg = mean(P.screen.pixperdeg);
P.screen.degperpix = mean(P.screen.degperpix);

P.screen.white = WhiteIndex(P.screen.screen_num);
P.screen.black = BlackIndex(P.screen.screen_num);



%% -----------------------------------------------------------------------
% Parameters of the display and stimuli
% ------------------------------------------------------------------------
P.stim.background_color = [70 70 70];
P.stim.target_size = [];
P.stim.target_ecc = [];

P.GaborParameters.amp      = 0.1;        % amplitude; -amp/2:+amp/2, so 1 means full contrast
P.GaborParameters.frq      = 2.5/P.screen.pixperdeg;      % spatial frequency [cycles/deg]    - a big number gives you
P.GaborParameters.pha      = pi;     % phase [radians]
P.GaborParameters.siz      = P.stim.target_size * P.screen.pixperdeg;      % extent of the stimulus from center to border [deg]
P.GaborParameters.siz      = ceil(P.GaborParameters.siz);
P.GaborParameters.sig      = 0.2*P.GaborParameters.siz;      % std.dev. of Gaussian envelope [deg]
P.GaborParameters.fNyquist = 0.5;
P.GaborParameters.Tilt     = 5; %10 original % orientation [radians] - 0 and pi are vertical, pi/2 and 3*pi/2 are horizontal



%% -----------------------------------------------------------------------
% Parameters of the paradigm, procedure & timing
%  -----------------------------------------------------------------------
P.paradigm.n_trials  = 100; % per permutation of all conditions
P.paradigm.break_after_x_trials = 30;    % Present a break after so many trials.
P.paradigm.target = [-1 0 1]; 
P.paradigm.conditions = {
'hit_LL'  'fal_0L'  'err_RL';
'mis_L0'  'crj_00'  'mis_R0';
'err_LR'  'fal_0R'  'hit_RR'    
};


%% -----------------------------------------------------------------------
% Trigger parameters
%  -----------------------------------------------------------------------
P.trigger.trig_dur   = 0.005;
P.trigger.trig_start = 250;
P.trigger.trig_stop  = 251;



%% ------------------------------------------------------------------------
%  Define relevant buttons
%  ------------------------------------------------------------------------
KbName('UnifyKeyNames');
P.keys.quitkey = KbName('ESCAPE');
P.key.lkey  = KbName('LeftArrow');
P.key.rkey  = KbName('RightArrow');
P.key.nokey = KbName('UpArrow');



%% -----------------------------------------------------------------------
% Parameters of the Quest
% ------------------------------------------------------------------------
P.quest.guess      = log10(0.2);
P.quest.std        = 8; % a priori standard deviation of the guess. manual suggests to be generous here
P.quest.pthreshold = 0.6; % threshold criterior for response = 1
P.quest.beta       = 3.5; % slope of psychometric function
P.quest.delta      = 0.05; % p of response = 0 for visible stimuli
P.quest.gamma      = 0; % chance level (for invisible stimuli)

