function make_background(P, win, noise_tex, do_fixation);

% Draw the background. Depending on parameters, the background might be
% empty or have a noise pattern. And if required, we draw a fixation
% marker.

if P.noise.do_noise
    Screen('DrawTexture', win, noise_tex, [], [], [], 0);
else
    Screen(win,'FillRect', P.stim.background_color);
end

if do_fixation
    my_optimal_fixationpoint(win, P.screen.cx, P.screen.cy, P.stim.fix_size, ...
        P.stim.fix_color, P.stim.background_color, P.screen.pixperdeg)
end
