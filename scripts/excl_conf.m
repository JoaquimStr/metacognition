function [behav_data] = excl_conf(behav_data, state, subject)
%% this function is part of prepare()

index_conf = behav_data(:,1)'; % preallocate index vector
position_conf = 1; % initialize position marker

if strcmp('W', state)
    column = 13;
else
    column = 14;
end

for trial = 1:length(behav_data(:,1))
    if behav_data(trial, column) == 1
        index_conf(position_conf) = trial;
        position_conf = position_conf + 1;
    end
end
behav_data(index_conf(1:position_conf-1), :) = []; % then delete trial


% vector = [9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9 ,9, 6, 6, 6];

% if str2num(subject) < 140
%     num = 9;
% else
%     num = 6;
% end
% 
% for trial = 1:num %199/23
%     random_vector = randi(length(behav_data));
%     behav_data(random_vector, :) = []; % then delete trial
% end


% vector2 = [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3 ,3, 2, 2, 1];

if str2num(subject) < 140
    num = 3;
elseif str2num(subject) < 146
    num = 2;
else
    num = 1;
end

for trial = 1:num %65/23 ~2
    random_vector = randi(length(behav_data));
    behav_data(random_vector, :) = []; % then delete trial
end



% for trial = 1:length(behav_data(:,1))
%     if behav_data(trial, column) == 0
%         index_conf(position_conf) = trial;
%         position_conf = position_conf + 1;
%     end
% end
% behav_data(index_conf(1:position_conf-1), :) = []; % then delete trial

