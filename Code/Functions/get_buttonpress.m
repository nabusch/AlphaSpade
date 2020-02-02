function [ Report, isQuit, secs ] = get_buttonpress(P)

%%
% WaitSecs(0.200);
Report = 0;
isQuit = 0;
keyIsDown = 0;

report_keys = [P.keys.lkey P.keys.nokey P.keys.rkey];

while Report==0
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyIsDown
        
        the_key = find(keyCode);
        if keyCode(P.keys.quitkey)
            Report = 99; isQuit = 1;
            return;
        elseif ismember(the_key, report_keys)            
            Report = find(the_key == report_keys);
        end     
    end
end

