function [behav_data] = assess_drowsy(subject, behav_data, rej_trials)
%% this function is part of prepare()
% The drowsiness categorisation method can be changed here. For now only categories 
% from the micromeasures algorithm are used (high consistency with other methods).

if isfile(strcat('S', subject, '_drowsiness.mat'))
    drowsiness_data = load(strcat('S', subject, '_drowsiness.mat')); % load the corresponding file
    stages = 'drowsiness'; % fetch data subfolder
    drowsiness = drowsiness_data.(stages); % variable with level of drowsiness for each trial
    drowsiness = drowsiness(behav_data(:,2)'); % then delete trial
    behav_data(:, 13) = drowsiness'; % insert drowsiness column (13), varies with method picked
elseif isfile(strcat('s', subject, '_for_micromeasures_stani.mat'))
    drowsiness_data = load(strcat('s', subject, '_for_micromeasures_stani.mat')); % load the corresponding file
    stages = 'drowsiness'; % fetch data subfolder
    drowsiness = drowsiness_data.(stages); % variable with level of drowsiness for each trial
    behav_data(:, 13) = drowsiness'; % insert drowsiness column (13), varies with method picked
else
    drowsiness_data = load(strcat('s', subject, '_for_micromeasures_output_iaf.mat')); % load the corresponding file
    stages = 'stages_clean'; % fetch data subfolder
    drowsiness = drowsiness_data.(stages); % variable with level of drowsiness for each trial
    behav_data(:, 13) = drowsiness'; % insert drowsiness column (13), varies with method picked
end
    

% % Adapt drowsiness data for subject 108.
% if strcmp(subject, '108') 
%     drowsiness(1:15) = [];  % the first 15 trials do not have behavioural data
% end
% 
% % 6 of the new participants' drowsiness assessment were 480 trials long, I
% % had to shorten them using rejected trials + new indexing: 117, 126, 127, 140, 141, 144
% 
% if  strcmp(subject, '144') % || strcmp(subject, '140') % strcmp(subject, '126') || strcmp(subject, '127') || 
%     drowsiness(rej_trials) = [];  % the first 15 trials do not have behavioural data
% end
