function [ window target_tex ] = makeGaborpatch(t, Info, P, window )

 %%%%
        % Make Gabor Patch.
        P.GaborParameters.ori = Info.T(t).Orientation * ((P.GaborParameters.Tilt/360)*2*pi); % LEFT
        P.GaborParameters.amp = Info.T(t).Contrast;
        
        Gabor = P.MaxIntense * getGaborPatch(P.GaborParameters);
        
        % Take only the bright parts of the Gabor.
        Gabor(Gabor<P.BgColor) = P.BgColor;
        Info.T(t).minRGB = min(Gabor(:));
        Info.T(t).maxRGB = max(Gabor(:));
        
        % Make noisy gabor patch.
        
        target_tex = Screen('MakeTexture', window, Gabor);
        
        
        % Calculate target positions.
        target_pos = Info.T(t).StimulusSide;
        distractor_pos = 3-target_pos;
        gabor_pos(1,:) = CenterRectOnPoint([1 1 size(Gabor)], P.CenterX-P.Eccentricity, P.CenterY); %#ok<*AGROW>
        gabor_pos(2,:) = CenterRectOnPoint([1 1 size(Gabor)], P.CenterX+P.Eccentricity, P.CenterY); %#ok<*AGROW>
        
        my_fixationpoint(window, P.CenterX, P.CenterY, 5, P.StuffColor, 0)
        Screen(window,'DrawTexture',target_tex,[], gabor_pos(target_pos,:));
        Screen('DrawingFinished', window);
        
end

