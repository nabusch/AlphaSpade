function LOG = load_logfiles(files, log_dir)

%%
n = length(files);
LOG = table;

for i = 1:n
    
    % --------------------------------------------------------------------
    % Load this participants data.
    % --------------------------------------------------------------------
    fprintf('Loading participant %d\n', i)
    load(fullfile(log_dir, files{i}));
    tmplog = table;
        
    % --------------------------------------------------------------------
    % Remove trials that were not completed.
    % --------------------------------------------------------------------
    INFO.T(~[INFO.T.trial_completed]) = []; 
    
    % --------------------------------------------------------------------   
    % Create a new column with this subject's name and a numeric index.
    % Then merge these columns with the rest of the subject's data.
    % --------------------------------------------------------------------
    tmplog.name = repmat(INFO.name, length(INFO.T), 1);
    tmplog.id   = repmat(i,         length(INFO.T), 1);
    tmplog = horzcat(tmplog, struct2table(INFO.T));
     
    % --------------------------------------------------------------------
    % Concatenate this subject with the long table of all subjects.
    % --------------------------------------------------------------------    
    LOG = vertcat(LOG, tmplog);
    
end
disp('All loaded.')

