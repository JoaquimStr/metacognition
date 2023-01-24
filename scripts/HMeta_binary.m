% function meta_d = Hmeta(params,state)
% This function calculates the hierarchical meta-d' per subject and per
% state. It is based on Stephen Fleming's toolbox.

% For a tutorial, see https://github.com/metacoglab/HMeta-d/wiki/HMeta-d-tutorial

% reject_EEG()
% asses_drowsiness()?
% 
% load()

% nR_S1{subject} = [100 50 20 10 5 1];
% nR_S2{subject} = [ ];

% determining how many categories

server = 0;

if server == 0
    datafolder = 'C:\Users\strei\OneDrive - University of Cambridge\All_new';
    resultfolder = 'C:/Metacognition_project/FINAL CLEAN BEHAV';
    drowsiness_datafolder = 'C:\Metacognition_Project\DATA\DROWSINESS_DATA';
else
    datafolder = '/home/js2715/rds/rds-tb419-bekinschtein/Yanzhi/EXP_4_Metacognition';
    resultfolder = '/home/js2715/rds/rds-tb419-bekinschtein/Joaquim/RESULTS/BEHAVIOURAL/HMeta-d';
    drowsiness_datafolder = [datafolder, '/Analysis_Micromeasures/iaf/'];
    toolfolder = '/home/js2715/tools';
end

cd(datafolder)

% Hmeta_path = [toolfolder, '/HMeta-d-master'];
% genpath(Hmeta_path)

subjects   = {'105', '107', '108', '109', '112', '113', '114', '116', '119', ...
    '120', '121', '123', '129', '131', '132', '133', '134', '135', ...
    '136', '139', '140', '145', '146'};

% subject = params{1,1};

% state = 'W';
state = 'S';

for n = 1:23 %23-25-28
    cd(datafolder)
    subject = subjects{n};
    nR_S1 = zeros(1, 4);
    nR_S2 = zeros(1, 4);
    cd()
    [rej_trials, eeg_file, behav_data] = load_data(subject, state);
    behav_data = reject_EEG(subject, state, behav_data, rej_trials);
%     if strcmp(state, 'W')
%         behav_data = behav_data.datamat_all_session1;
%     else
%         behav_data = behav_data.datamat_all_session2;
%     end
    if strcmp(state, 'S')
        cd(drowsiness_datafolder) % go to where the drowsiness data is
        behav_data = assess_drowsy(subject, behav_data);
        behav_data = reject_drowsy(subject, behav_data);
    end
    confidence = abs(behav_data(:, 4));
    median_conf = median(confidence);
    % quantile_conf = quantile(confidence, 3);
    for trial = 1:length(behav_data)
        if behav_data(trial, 10) == 0 && behav_data(trial, 11) == 0 && confidence(trial) >= median_conf
            nR_S1(1) = nR_S1(1) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 0 && confidence(trial) < median_conf  
            nR_S1(2) = nR_S1(2) + 1; 
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 1 && confidence(trial) < median_conf  
            nR_S1(3) = nR_S1(3) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 1 && confidence(trial) >= median_conf  
            nR_S1(4) = nR_S1(4) + 1;
        % S2:
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 0 && confidence(trial) >= median_conf
            nR_S2(1) = nR_S2(1) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 0 && confidence(trial) < median_conf   
            nR_S2(2) = nR_S2(2) + 1;  
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 1 && confidence(trial) < median_conf    
            nR_S2(3) = nR_S2(3) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 1 && confidence(trial) >= median_conf  
            nR_S2(4) = nR_S2(4) + 1;
        end
    end
%     cd(toolfolder)
    meta_d = fit_meta_d_mcmc(nR_S1, nR_S2);
    cd(resultfolder)
    save(strcat(subjects{n}, '_meta_d_', state), 'meta_d')
end
