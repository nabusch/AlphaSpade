# AlphaSpade

## Logfiles
I store all information about an experiment in a struct called `INFO` with subfields:
- `P` the **p** arameters, i.e. info on stimulus size, duration, screen size etc.
- `T` the **t** rials, i.e. which condition happened on which trial, what was the response etc.
- `Q` the **Q** uest, i.e. parameters and logfile for the staircase procedure.

## Trigger logic
Although I have not implemented the function for actually sending triggers, I do put together the codes that should be sent as triggers. We want to mark the following events with triggers:
- 10: trial onset;
- 20: stimulus onset;
- 30: onset of the response probe;
- 100 + key: button press.

The numbers indicate the trigger values to which we add the code indicating for this trial where (if any) a target is presented:
- -1: target left;
-  0: no target;
-  1: right target.

Thus, trigger code 19 indicates stimulus onset of a left target; code 9 is onset of a trial on which no target will be presented.

Subjects are to press one of three different button for "I saw left (-1)", "saw nothing (0)" or "saw right (1)". Thus, trigger code 99 indicates that the subject reported "saw left".


## Do not frustrate -- simulate!
For testing the code without requiring a person to watch boring stimuli and press buttons, the experiment can be run at one of three levels of "realness", controlled by the parameter `P.do_testrun`.:
- 0: this is not a drill, show real stimuli and collect real button presses;
- 1: simulation, show real stimuli, but don't wait for button presses. Responses are simulated according to the Quest procedure. Useful for testing stimulus presentation.
- 2: simulation, don't show stimuli and simulate responses. Useful for testing the code, triggers, etc.


## Things you have to adjust on your system
- System-specific performance check for Psychtoolbox.
- M/EEG triggers.
- In `get_params.m`:
  - Include your computer in the list of machines and modify the settings for screen number (i.e. how many monitors are attached), screen size, and the distance from participant to monitor.
  - If your screen is calibrated and you use a color lookup table, provide the path to the CLUT.


## Things you may want to adjust
- In the main file: variable `name`; this is the name of the subject and determines filename of the logfile. Use `name = 'test'` if you do not care for a logfile and do not want to be bugged by warnings that such alogfile already exists.
- In `get_params.m`:
  - `P.do_testrun` allows you to simulate an experiment without having a subject.
  - `P.paradigm.n_trials` defines the number of trials in the experiment. Note: the number refers to an entire set of all conditions in the design. For example, if you have three conditions (say, left stimulus, right stimulus, no stimulus) then `n_trials = 10` gives you 10 * 3 trials.
  - `P.trigger.trig_start` and `P.trigger.trig_stop`: maybe unnecessary on your system, but our system is set up to automatically start/stop the EEG recording when it receives these triggers.


## Not yet implemented, ToDo list
- [] function for sending triggers.
- [] PTB performance checks.
- [] eye tracker integration, if necessary.
- [] whatever response device you use.
