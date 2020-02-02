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
        P.screen.size         = [47 30];%[36 27]; %screen size in centimeters.
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
P.do_testrun = 1;

% Note: from this line onwards, variables coding the size of things
% indicate size in degrees visual angle. Internally, the functions
% executing stimulus genration and presentation will recompute these sizes
% into pixels.



%% ------------------------------------------------------------------------
%  Parameters of the screen.
% ------------------------------------------------------------------------
P.screen.cx = round(P.screen.width/2); % x coordinate of screen center
P.screen.cy = round(P.screen.height/2); % y coordinate of screen center

P.screen.white = WhiteIndex(P.screen.screen_num);
P.screen.black = BlackIndex(P.screen.screen_num);

%  Calculate size of a pixel in visual angles.
[P.screen.pixperdeg, P.screen.degperpix] = vis_ang(P);
P.screen.pixperdeg = mean(P.screen.pixperdeg);
P.screen.degperpix = mean(P.screen.degperpix);



%% -----------------------------------------------------------------------
% Parameters of the display and stimuli
% ------------------------------------------------------------------------

% ........................................................................
% Stuff we show in the background.
% ........................................................................
P.stim.background_color = [0 0 0];

% ........................................................................
% Background noise.
% ........................................................................
P.stim.do_noise   = 1;
P.stim.noise_mean = 5;
P.stim.noise_max  = 3*P.noise.noise_mean;
P.stim.noise_sd   = 5;

% ........................................................................
% Fixation marker.
% ........................................................................
P.stim.fix_size = 0.4;
P.stim.fix_color = [45 45 45];

% ........................................................................
% Target stimuli.
% ........................................................................
P.stim.target_size = 0.3; % in degree % 0.25
P.stim.target_ecc  = 10; % in degree
P.stim.target_loc  = 90; % in degrees, not radians.
% 135: 17:30 o'clock
%  90: exactly on horizon

% ........................................................................
% Present stimuli at random location within a radius from the base
% eccentricity. Set this parameter to zero if stimuli should be fixed at
% the position determined by P.stim.target_ecc and P.stim.target_loc
% ........................................................................
P.stim.loc_jitter = 1; 

% ........................................................................
% Gabor paramters. The code is based on
% https://peterscarfe.com/gabordemo.html
% ........................................................................
P.gabor_params.size = ceil(P.stim.target_size * P.screen.pixperdeg);
P.gabor_params.sigma = P.gabor_params.size / 5; % Sigma of Gaussian
P.gabor_params.orientation = 0;
P.gabor_params.contrast = 0.8;
P.gabor_params.aspectRatio = 1.0;
P.gabor_params.phase = 270; % at 270, we see two equally bright stripes.
numCycles = 2;
P.gabor_params.freq = numCycles / P.gabor_params.size;
P.gabor_params.backgroundOffset = [P.stim.background_color 0.0];%[0.5 0.5 0.5 0.0];
P.gabor_params.disableNorm = 1;
P.gabor_params.preContrastMultiplier = 1;

% ........................................................................
% Draw circles as markers around the target locations.
% ........................................................................
P.marker.do_marker = 1;
P.marker.thick     = 3; % this is pixels, not degrees!
P.marker.color     = 11;
P.marker.radius    = P.stim.loc_jitter + 0.75; % make the markers a little wider than the actual target area.



%% -----------------------------------------------------------------------
% Parameters of the paradigm, procedure & timing
%  -----------------------------------------------------------------------
P.paradigm.n_trials  = 20; % per permutation of all conditions
P.paradigm.break_after_x_trials = 30; % Present a break after so many trials.
P.paradigm.target = [-1 0 1]; 
P.paradigm.conditions = {
'hit_LL'  'fal_0L'  'err_RL';
'mis_L0'  'crj_00'  'mis_R0';
'err_LR'  'fal_0R'  'hit_RR'    
};

P.paradigm.target_dur = 0.040;
P.paradigm.target_off_prompt_on_delay = 0.500;

% Timing of the prestimulus screen.
P.paradigm.dur_prestim_mean = 1.8;
P.paradigm.dur_prestim_min  = 1.200;
P.paradigm.dur_prestim_max  = 3.500;



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
P.keys.lkey    = KbName('LeftArrow');
P.keys.rkey    = KbName('RightArrow');
P.keys.nokey   = KbName('UpArrow');



%% -----------------------------------------------------------------------
% Parameters of the Quest
% ------------------------------------------------------------------------
P.quest.guess      = log10(0.9);
P.quest.std        = 8; % a priori standard deviation of the guess. manual suggests to be generous here
P.quest.pthreshold = 0.6; % threshold criterior for response = 1
P.quest.beta       = 3.5; % slope of psychometric function
P.quest.delta      = 0.05; % p of response = 0 for visible stimuli
P.quest.gamma      = 0; % chance level (for invisible stimuli)



