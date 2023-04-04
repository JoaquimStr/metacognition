function [behav_data] = reject_drowsy(subject, behav_data)
%% this function is part of prepare()
% Trials with drowsiness == 1 are rejected.

index_lowdrowsy = zeros(length(behav_data(:,1)), 1); % preallocation index variable
count_drowsy = 1; % count initiation

for trial = 1:length(behav_data(:,1))
% micromeasures: 1 = relaxed; 2 = mild drowsiness; 3 = severe drowsiness
    if behav_data(trial, 13) == 1 % we exclude relaxed trials
        index_lowdrowsy(count_drowsy) = trial; % add index low drowsiness trials (to exclude)
        count_drowsy = count_drowsy +1; % add 1 to the counter
    end
end
behav_data(index_lowdrowsy(1:count_drowsy-1), :) = []; % exclude trials with too low drowsiness

% Manually exclude participants with a too low number of drowsy trials:
if length(behav_data(:,1)) < 36 % how many drowsy trials do we want as a minimum? all above 50, except 117 (37)
    error('Participant %s must be excluded because there are only %d drowsy trials!', subject, length(behav_data(:,1)))
end