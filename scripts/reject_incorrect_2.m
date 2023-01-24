function [behav_data] = reject_incorrect_2(behav_data, state)
%% this function is part of prepare()
% Type I incorrect trials do not equate Type II incorrect trials.
% (e.g., focusing decoding on confidence and keeping Type I incorrect trials -- which
% are Type II correct trials).

index_incorrect = behav_data(:,1)'; % preallocate index vector
position_incorrect = 1; % initialize position marker

if strcmp(state, 'W')
    column = 13;
else
    column = 14;
end

for trial = 1:length(behav_data(:,1))
    if behav_data(trial, 10) ~= behav_data(trial, 11) && behav_data(trial, column) == 1 % if columns 10 and 11 (i.e., stimulus and response) are different and confidence is high
        index_incorrect(position_incorrect) = trial;
        position_incorrect = position_incorrect + 1;
    elseif behav_data(trial, 10) == behav_data(trial, 11) && behav_data(trial, column) == 0 % if columns 10 and 11 (i.e., stimulus and response) are the same and confidence is low
        index_incorrect(position_incorrect) = trial;
        position_incorrect = position_incorrect + 1;
    end
end
behav_data(index_incorrect(1:position_incorrect-1), :) = []; % then delete trial