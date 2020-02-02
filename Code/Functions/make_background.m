function make_background(P, win, noise_tex, do_fixation);

% Draw the background. Depending on parameters, the background might be
% empty or have a noise pattern. And if required, we draw a fixation
% marker.

if P.stim.do_noise
    Screen('DrawTexture', win, noise_tex, [], [], [], 0);
else
    Screen(win,'FillRect', P.stim.background_color);
end


if P.marker.do_marker
    diameter = 2*P.marker.radius;
    marker_rect = [0 0 diameter*P.screen.pixperdeg diameter*P.screen.pixperdeg];
    marker_rect_l = CenterRectOnPoint(marker_rect, P.screen.cx - ...
        P.screen.pixperdeg * P.stim.target_ecc, P.screen.cy);
    
    marker_rect_r = CenterRectOnPoint(marker_rect, P.screen.cx + ...
        P.screen.pixperdeg * P.stim.target_ecc, P.screen.cy);    
    
    Screen('FrameOval', win, P.marker.color, marker_rect_l, ...
        P.marker.thick, P.marker.thick);
    Screen('FrameOval', win, P.marker.color, marker_rect_r, ...
        P.marker.thick, P.marker.thick);
end

% Is it necessary to draw a fixation? Is is not based on a general setting
% in the P struct bacuase it might vary throughout the trial, e.g. when the
% response prompt is shown instead of fixation.
if do_fixation
    my_optimal_fixationpoint(win, P.screen.cx, P.screen.cy, P.stim.fix_size, ...
        P.stim.fix_color, P.stim.background_color, P.screen.pixperdeg)
end
