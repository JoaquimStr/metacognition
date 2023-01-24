function [behav_data] = reject_EEG(subject, state, behav_data, rej_trials)
%% this function is part of prepare()

if isfile(strcat('Rejected_', subject, '.xlsx'))
    behav_data(rej_trials, :) = [];
end

%% Adapt behavioural data from subjects 113:
% For some trials, EEG data is missing.
if strcmp(subject, '113') && strcmp(state, 'S') % trials 190 and 208 do not have EEG data (30 and 48 in drowsy session) -- mismatch with drowsiness data.
    behav_data(30, :) = [];
    behav_data(48, :) = [];
end

%% Rename trials to have the same indexing as EEG data

for trial = 1:length(behav_data(:, 2))
    behav_data(trial, 2) = trial;
end
