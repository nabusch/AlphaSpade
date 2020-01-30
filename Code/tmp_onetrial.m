% --------------------------------------------------------
% Send trigger indicating onset of response display.
% --------------------------------------------------------
if P.setup.isEEG
    SendTrigger(30 + T.target, P.trigger.trig_dur);
end