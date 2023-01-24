function behav_data = easy_only(behav_data)
%% this function is part of prepare()

index_difficult = behav_data(:,1)';
position_dif = 1;

for trial = 1:length(behav_data(:,1))
    if behav_data(trial, 3) == 35 || behav_data(trial, 3) == 45 || behav_data(trial, 3) == 55 || behav_data(trial, 3) == 65 
        index_difficult(position_dif) = trial;
        position_dif = position_dif + 1;
    end
end

% for trial = 1:length(behav_data(:,1))
%     if behav_data(trial, 3) == 5 || behav_data(trial, 3) == 15 || behav_data(trial, 3) == 25 || behav_data(trial, 3) == 35 || behav_data(trial, 3) == 65 || behav_data(trial, 3) == 75 || behav_data(trial, 3) == 85 || behav_data(trial, 3) == 95 
%         index_difficult(position_dif) = trial;
%         position_dif = position_dif + 1;
%     end
% end

% for trial = 1:length(behav_data(:,1))
%     if behav_data(trial, 3) == 5 || behav_data(trial, 3) == 15 || behav_data(trial, 3) == 25 || behav_data(trial, 3) == 75 || behav_data(trial, 3) == 85 || behav_data(trial, 3) == 95 
%         index_difficult(position_dif) = trial;
%         position_dif = position_dif + 1;
%     end
% end

behav_data(index_difficult(1:position_dif-1), :) = [];