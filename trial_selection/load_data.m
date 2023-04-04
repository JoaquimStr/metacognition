function [rej_trials, eeg_file, behav_data] = load_data(subject, state)
%% part of prepare()
% this function loads the data needed for the prepare() function to run

% 1.1. Rejected trials, if there is a rejected file (sometimes missing because EEG data is OK, i.e., no noisy channels):

% -	Be careful sometimes rejected trials are in column b (excel files “Rejected_Trials”)

% if isfile(strcat('Rejected_', subject, '.xlsx'))
    rej_filenames = strcat('Rejected_', subject, '.xlsx');
    if strcmp(state, 'W')
        if isempty(xlsread(char(rej_filenames), strcat('W', subject, 'Trials'),'a2:a160'))
            rej_trials = xlsread(char(rej_filenames), strcat('W', subject, 'Trials'),'b2:b160'); 
        else
            rej_trials = xlsread(char(rej_filenames), strcat('W', subject, 'Trials'),'a2:a160'); 
        end
    else
        if isempty(xlsread(char(rej_filenames), strcat('S', subject, 'Trials'),'a2:a480'))
            rej_trials = xlsread(char(rej_filenames), strcat('S', subject, 'Trials'),'b2:b480'); 
        else
            rej_trials = xlsread(char(rej_filenames), strcat('S', subject, 'Trials'),'a2:a480'); 
        end 
    end
% else
%     rej_trials = 0;
% end

% 1.2. EEG data, we want 'clean' datasets but sometimes only 'epochs'
% available: NO, epochs files aren't good to use
% if isfile(strcat(state, subject, '_clean.set'))  
    eeg_file= strcat(state, subject, '_clean.set'); 
% else
%     eeg_file= strcat(state, subject, '_epochs.set'); % /!\ is it a problem to have them 'only' epoched?
% end

% 1.3. Behavioural data:
behav_data = load(strcat('behavioural_datamat_p', subject, '.mat'));
if strcmp(state, 'W')
    behav_data = behav_data.datamat_all_session1; % for awake session
else
    behav_data = behav_data.datamat_all_session2; % for drowsy session
end

%% Adapt rejection data from subjects 108:
% /!\ BEWARE: 497 trials instead of 480. 
% EEG and drowsiness data == 474 trials (see also rejection of 15 first trials below).
if strcmp(subject, '108') && strcmp(state, 'S')
     rej_trials(1:21, :) = rej_trials(1:21, :) - 17; 
end

