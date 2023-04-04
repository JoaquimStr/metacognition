function [behav_data] = reject_incorrect(behav_data)
%% this function is part of prepare()
% We want to keep only correct trials for decoding analyses.
% We might change this later, as Type I incorrect trials do not equate Type
% II incorrect trials.
% (e.g., focusing decoding on confidence and keeping Type I incorrect trials -- which
% are Type II correct trials).

index_incorrect = behav_data(:,1)'; % preallocate index vector
position_incorrect = 1; % initialize position marker

for trial = 1:length(behav_data(:,1))
    if behav_data(trial, 10) ~= behav_data(trial, 11) % if columns 10 and 11 (i.e., stimulus and response) are different
        index_incorrect(position_incorrect) = trial;
        position_incorrect = position_incorrect + 1;
    end
end
behav_data(index_incorrect(1:position_incorrect-1), :) = []; % then delete trial