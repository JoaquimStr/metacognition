function [behav_data] = assess_drowsy(subject, behav_data)
%% this function is part of prepare()
% The drowsiness categorisation method can be changed here. For now only categories 
% from the micromeasures algorithm are used (high consistency with other methods).

drowsiness_data = load(strcat('s', subject, '_for_micromeasures_output_iaf.mat')); % load the corresponding file
stages = 'stages_clean'; % fetch data subfolder
drowsiness = drowsiness_data.(stages); % variable with level of drowsiness for each trial

% Adapt drowsiness data for subject 108.
if strcmp(subject, '108') 
    drowsiness(1:15) = [];  % the first 15 trials do not have behavioural data
end

behav_data(:, 13) = drowsiness'; % insert drowsiness column (13), varies with method picked