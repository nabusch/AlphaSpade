function T = show_stimuli(T, P, win, gabor_id, gabor_rect)


% --------------------------------------------------------
% Make the noise texture. We always generate the texture, even when no
% noise is presented (easier to communicate to the make_background
% function.
% --------------------------------------------------------
noise_img = (P.noise.noise_sd*randn(P.screen.height, P.screen.width) + P.noise.noise_mean);
noise_img(noise_img<0) = 0;
noise_img(noise_img>P.noise.noise_max) = P.noise.noise_max;
noise_tex = Screen('MakeTexture', win, noise_img);


% --------------------------------------------------------
% Prestimulus interval
% --------------------------------------------------------

% Calculate duration of prestimulus interval.
dur_predisplay = 0;
while dur_predisplay < P.paradigm.dur_prestim_min || dur_predisplay > P.paradigm.dur_prestim_max
    dur_predisplay = exprnd(P.paradigm.dur_prestim_mean);
end

make_background(P, win, noise_tex, 1);
Screen('DrawingFinished', win);
T.t_trial_on = Screen('Flip', win);

% Send trigger.
if P.setup.isEEG
    trig = 10 + T.target;
    SendTrigger(trig, P.trigger.trig_dur);
end


% --------------------------------------------------------
% Display
% --------------------------------------------------------
make_background(P, win, noise_tex, 1);

if T.target
    % Use the contrast recommended by Quest only when this is a real
    % experiment, but not for a simulation.
    if P.do_testrun == 0
        P.gabor_params.contrast = T.contrast;
    end
    
    draw_gabor(T, P, win, gabor_id, gabor_rect)
end

Screen('DrawingFinished', win);
T.t_target_on = Screen('Flip', win, T.t_trial_on + dur_predisplay);

% Send trigger.
if P.setup.isEEG
    trig = 20 + T.target;
    SendTrigger(trig, P.trigger.trig_dur);
end


% --------------------------------------------------------
% Turn off display
% --------------------------------------------------------
make_background(P, win, noise_tex, 1);
Screen('DrawingFinished', win);
T.t_target_off = Screen('Flip', win, T.t_target_on + P.paradigm.target_dur);
T.target_dur = T.t_target_off - T.t_target_on;


% --------------------------------------------------------
% Show response prompt.
% --------------------------------------------------------
make_background(P, win, noise_tex, 0);

Screen(win,'TextSize',15);
TextWidthAnswer  = RectWidth(Screen('TextBounds',  win, '?'));
TextHeightAnswer = RectHeight(Screen('TextBounds', win, '?'));
Screen(win, 'DrawText', '?', P.screen.cx-0.5*(TextWidthAnswer), ...
    P.screen.cy-0.5*TextHeightAnswer, P.stim.fix_color);
Screen('DrawingFinished', win);

T.t_prompt_on = Screen('Flip', win, T.t_target_off + P.paradigm.target_off_prompt_on_delay);

% Send trigger.
if P.setup.isEEG
    trig = 30 + T.target;
    SendTrigger(trig, P.trigger.trig_dur);
end

% Close the noise texture.
if P.noise.do_noise
    Screen('Close', noise_tex);
end

% --------------------------------------------------------
% And we are done here.
% --------------------------------------------------------


