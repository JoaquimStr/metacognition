function [behav_data] = reject_RT(behav_data)
%% this function is part of prepare()

index_RT = behav_data(:,1)'; % preallocate index vector
position_RT = 1; % initialize position marker
median_RT = median(behav_data(:,6));

for trial = 1:length(behav_data(:,1))
    if behav_data(trial, 6) < .2 || behav_data(trial, 6) > (mean(behav_data(:, 6)) + 3*std(behav_data(:, 6))) % a lot of outliers with drowsy sessions
        index_RT(position_RT) = trial;
        position_RT = position_RT + 1;
    end
%      if behav_data(trial, 6) < median_RT
%         index_RT(position_RT) = trial;
%         position_RT = position_RT + 1;
%      end
%      if behav_data(trial, 6) >= median_RT
%         index_RT(position_RT) = trial;
%         position_RT = position_RT + 1;
%     end
end
behav_data(index_RT(1:position_RT-1), :) = []; % then delete trial

% select only high or low RT: