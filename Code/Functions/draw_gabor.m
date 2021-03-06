function draw_gabor(T, P, win, gabor_id, gabor_rect)



propertiesMat = [P.gabor_params.phase, P.gabor_params.freq, ...
    P.gabor_params.sigma, P.gabor_params.contrast, ...
    P.gabor_params.aspectRatio, 0, 0, 0];

% Give the Gabor a random orientation on each trial.
rand_orientation = randi(360);

% Get the rect where the Gabor is supposed to be presented.
tar_x = P.screen.cx + T.target * (sind(P.stim.target_loc) * (P.stim.target_ecc * P.screen.pixperdeg));
tar_y = P.screen.cy - cosd(P.stim.target_loc) * (P.stim.target_ecc * P.screen.pixperdeg);

% Now add some displacement to the target location according to
% P.stim.loc_jitter. If this parameter is set to zero, the "displacement"
% will be zero too and have no effet.
jitter_deg    = randi(360);
jitter_length = P.screen.pixperdeg * P.stim.loc_jitter * rand;

tar_x = tar_x + sind(jitter_deg) * jitter_length;
tar_y = tar_y + cosd(jitter_deg) * jitter_length;

gabor_pos = CenterRectOnPoint(gabor_rect, tar_x, tar_y);

% Draw Gabor texture.
Screen('DrawTextures', win, gabor_id, [], gabor_pos, ...
    rand_orientation, [], [], [], [], ...
    kPsychDontDoRotation, propertiesMat');
