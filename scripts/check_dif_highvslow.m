% check difficulty high vs low confidence

subjects   = {'105', '107', '108', '109', '112', '113', '114', '116', '119', ...
    '120', '121', '123', '129', '131', '132', '133', '134', '135', '136', ...
     '139', '140', '145', '146'}; %'114','136','121','140',

easy_counter = 0;
medium_counter = 0;
difficult_counter = 0;

for subj = 1:23 %23
    subject = subjects{subj};
    behav_data = load(strcat(subject,'_behav_ready_S.mat'));
    behav_data = behav_data.behav_data;
    for trial = 1:length(behav_data)
        if behav_data(trial, 3) == 5 || behav_data(trial, 3) == 15 || behav_data(trial, 3) == 25 || behav_data(trial, 3) == 75 || behav_data(trial, 3) == 85 || behav_data(trial, 3) == 95
            easy_counter = easy_counter + 1;
        elseif behav_data(trial, 3) == 35 || behav_data(trial, 3) == 65 
            medium_counter = medium_counter + 1;
        elseif behav_data(trial, 3) == 45 || behav_data(trial, 3) == 55 
            difficult_counter = difficult_counter + 1;
        end
    end
end