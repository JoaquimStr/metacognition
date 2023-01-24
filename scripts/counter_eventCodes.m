% check difficulty high vs low confidence

subjects   = {'105', '107', '108', '109', '112', '113', '114', '116', '119', ...
    '120', '121', '123', '129', '131', '132', '133', '134', '135', '136', ...
     '139', '140', '145', '146'}; %'114','136','121','140',

tone = 0;
cone = 0;
low = 0;
high = 0;

for subj = 1:23 %23
    subject = subjects{subj};
    behav_data = load(strcat(subject,'_behav_ready_S.mat'));
    behav_data = behav_data.behav_data;
    for trial = 1:length(behav_data)
        if behav_data(trial, 10) == 0 
            tone = tone + 1;
        elseif behav_data(trial, 10) == 1
            cone = cone + 1;
        end
        if behav_data(trial, 14) == 0 
            low = low + 1;
        elseif behav_data(trial, 14) == 1
            high = high + 1;
        end
    end
end