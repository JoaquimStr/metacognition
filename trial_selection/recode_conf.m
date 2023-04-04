function behav_data = recode_conf(behav_data, state)
%% this function is part of prepare()
% TO CHANGE: this part must be adapted based on the criteria picked to categorize
% confidence responses as high or low.

% For now we use the median as a delimiter, with the median numbers being
% part of the high confidence category. We might want to change this to
% make the two categories more distinguishable.

% First exclude all 0s/less than 0.05! (otherwise median is biased)
% Moving the joystick less than 0.05 is considered as a non-response.
index_low_joystick = behav_data(:,1)';
position = 1;
for trial = 1:length(behav_data(:,1))
    if abs(behav_data(trial, 4)) < 0.05 % check if ok in joystick value 
        index_low_joystick(position) = trial;
        position = position + 1;
    end
end
behav_data(index_low_joystick(1:position-1), :) = [];

% This part is of first IMPORTANCE; it determines our criterion to
% categorise confidence scores as high or low:
median_conf = median(abs(behav_data(:, 4))); % create median (objective criterion 0.5 = not enough low confidence awake trials)

index_conf = zeros(length(behav_data(:,1)), 1); % preallocation index
count = 1; % count initialisation

if strcmp(state, 'W') % one more column for drowsy session (drowsiness evaluation)
    column = 13;
else
    column = 14;
end

% problem with median: sometimes many trials == median;
% for now we integrate them in the high confidence category
for trial = 1:length(behav_data(:,1))
    if abs(behav_data(trial, 4)) < median_conf % inferior
        behav_data(trial, column) = 0; % 0 for low confidence
    elseif abs(behav_data(trial, 4)) >= median_conf % superior or EQUAL
        behav_data(trial, column) = 1; % 1 for high confidence
    else
        index_conf(count) = trial; % indexing trials in-between bounds, if there are any
        count = count +1; % add 1 to counter
    end
end

behav_data(index_conf(1:count-1), :) = []; % delete trials with joystick movement below abs(0.1) or between abs(0.4) and abs(0.6)
