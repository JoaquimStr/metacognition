subjects   = {'105', '107', '108', '109', '112', '113', '114', '116', '119', ...
    '120', '121', '123', '129', '131', '132', '133', '134', '135', '136', ...
     '139', '140', '145', '146'}; 

state = 'W';
cd('C:\Metacognition_Project\FINAL CLEAN BEHAV')

total =0;
difficult = 0;
medium1 = 0;
medium2 = 0;
easy1 = 0;
easy2 = 0;

for n = 1:23
    subject = subjects{n};
    behav_data = load(strcat(subject, '_behav_ready_W.mat'));
    behav_data = behav_data.behav_data; % for awake session
    total = total + length(behav_data);
    for trial = 1:length(behav_data)
        if behav_data(trial, 3) == 45 || behav_data(trial, 3) == 55
            difficult = difficult + 1;
        elseif behav_data(trial, 3) == 35 
            medium1 = medium1 + 1;
        elseif behav_data(trial, 3) == 65
            medium2 = medium2 + 1;
        elseif behav_data(trial, 3) == 5 || behav_data(trial, 3) == 15 || behav_data(trial, 3) == 25
            easy1 = easy1 + 1;
        else
            easy2 = easy2 + 1;
        end
    end
end

behav_data = load(strcat('behavioural_datamat_p105.mat'));
behav_data = behav_data.datamat_all_session2; % for awake session
