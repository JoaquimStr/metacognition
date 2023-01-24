% function mean_step(params)

datafolder = 'C:\Metacognition_Project\DATA\behavioural data Cate';
cd(datafolder)

subjects   = {'105', '107', '108', '109', '112', '113', '114', '116', '119', ...
    '120', '121', '123', '129', '131', '132', '133', '134', '135', '136', ...
     '139', '140', '145', '146'}; 

mean_after_rej_a = 0;
mean_after_rej_s = 0;


for n = 1:23
    subject = subjects{n};
    
    behav = load(strcat("behavioural_datamat_p", subject, '.mat'));
    behav_a = behav.datamat_all_session1;
    behav_s = behav.datamat_all_session2;
    
    % step 1
    if isfile(strcat("Rejected_", subject, ".xlsx"))
        reject = strcat("Rejected_", subject, ".xlsx");
        rej_trials_a = xlsread(char(reject), strcat('W', subject, 'Trials'),'a2:a160');
        rej_trials_b = xlsread(char(reject), strcat('S', subject, 'Trials'),'a2:a480'); 

        behav_a = reject_EEG(subject, 'W', behav_a, rej_trials_a);
    
        behav_s= reject_EEG(subject, 'S', behav_s, rej_trials_b);
    end
    mean_after_rej_a = mean_after_rej_a + length(behav_a);
    mean_after_rej_s = mean_after_rej_s + length(behav_s);
end
    
    %% IF DROWSY SESSION
    
    % 3) ASSESS DROWSINESS
    if strcmp(state, 'S')
        cd(drowsiness_datafolder) % go to where the drowsiness data is
        behav_data = assess_drowsy(subject, behav_data);
    end
    
    % 4) REJECT LOW DROWSINESS TRIALS
    if strcmp(state, 'S')
        cd(drowsiness_datafolder)
        behav_data = reject_drowsy(subject, behav_data);
    end
    
    mean_after_drowsy = mean_after_drowsy + length(behav_a);
    
    %% THEN...
    
    % 3) REJECT INCORRECT TRIALS
    behav_data = reject_incorrect(behav_data);
    
    mean_after_inc = mean_after_inc + length(behav_a);
    
    % 4) REJECT TRIALS TOO LOW RT AND OUTLIERS
    behav_data = reject_RT(behav_data);
    
    mean_after_RT = mean_after_RT + length(behav_a);
    
    % 6) RECODE CONFIDENCE
    behav_data = recode_conf(behav_data, state);
    
    mean_after_conf = mean_after_conf + length(behav_a);
end