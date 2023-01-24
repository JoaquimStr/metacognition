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

%state = 'W';
state = 'S';

for n = 1:23 %23-25-28
    cd(datafolder)
    subject = subjects{n};
    nR_S1 = zeros(1, 40);
    nR_S2 = zeros(1, 40);
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
    quantile_conf = quantile(confidence, 20);
    for trial = 1:length(behav_data)
        if behav_data(trial, 10) == 0 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(19) 
            nR_S1(1) = nR_S1(1) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(18) && confidence(trial) < quantile_conf(19)  
            nR_S1(2) = nR_S1(2) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(17) && confidence(trial) < quantile_conf(18)  
            nR_S1(3) = nR_S1(3) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(16) && confidence(trial) < quantile_conf(17)  
            nR_S1(4) = nR_S1(4) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(15) && confidence(trial) < quantile_conf(16)  
            nR_S1(5) = nR_S1(5) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(14) && confidence(trial) < quantile_conf(15)  
            nR_S1(6) = nR_S1(6) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(13) && confidence(trial) < quantile_conf(14)  
            nR_S1(7) = nR_S1(7) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(12) && confidence(trial) < quantile_conf(13)  
            nR_S1(8) = nR_S1(8) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(11) && confidence(trial) < quantile_conf(12)  
            nR_S1(9) = nR_S1(9) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(10) && confidence(trial) < quantile_conf(11)  
            nR_S1(10) = nR_S1(10) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(9) && confidence(trial) < quantile_conf(10)  
            nR_S1(11) = nR_S1(11) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(8) && confidence(trial) < quantile_conf(9)  
            nR_S1(12) = nR_S1(12) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(7) && confidence(trial) < quantile_conf(8)  
            nR_S1(13) = nR_S1(13) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(6) && confidence(trial) < quantile_conf(7)  
            nR_S1(14) = nR_S1(14) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(5) && confidence(trial) < quantile_conf(6)  
            nR_S1(15) = nR_S1(15) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(4) && confidence(trial) < quantile_conf(5)  
            nR_S1(16) = nR_S1(16) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(3) && confidence(trial) < quantile_conf(4)  
            nR_S1(17) = nR_S1(17) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(2) && confidence(trial) < quantile_conf(3)  
            nR_S1(18) = nR_S1(18) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(1) && confidence(trial) < quantile_conf(2)  
            nR_S1(19) = nR_S1(19) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 0 && confidence(trial) < quantile_conf(1)  
            nR_S1(20) = nR_S1(20) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 1 && confidence(trial) < quantile_conf(1)  
            nR_S1(21) = nR_S1(21) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(1) && confidence(trial) < quantile_conf(2)  
            nR_S1(22) = nR_S1(22) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(2) && confidence(trial) < quantile_conf(3)   
            nR_S1(23) = nR_S1(23) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(3) && confidence(trial) < quantile_conf(4)   
            nR_S1(24) = nR_S1(24) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(4) && confidence(trial) < quantile_conf(5)  
            nR_S1(25) = nR_S1(25) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(5) && confidence(trial) < quantile_conf(6)  
            nR_S1(26) = nR_S1(26) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(6) && confidence(trial) < quantile_conf(7)   
            nR_S1(27) = nR_S1(27) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(7) && confidence(trial) < quantile_conf(8)  
            nR_S1(28) = nR_S1(28) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(8) && confidence(trial) < quantile_conf(9)   
            nR_S1(29) = nR_S1(29) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(9) && confidence(trial) < quantile_conf(10) 
            nR_S1(30) = nR_S1(30) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(10) && confidence(trial) < quantile_conf(11) 
            nR_S1(31) = nR_S1(31) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(11) && confidence(trial) < quantile_conf(12)  
            nR_S1(32) = nR_S1(32) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(12) && confidence(trial) < quantile_conf(13)  
            nR_S1(33) = nR_S1(33) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(13) && confidence(trial) < quantile_conf(14)  
            nR_S1(34) = nR_S1(34) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(14) && confidence(trial) < quantile_conf(15)  
            nR_S1(35) = nR_S1(35) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(15) && confidence(trial) < quantile_conf(16) 
            nR_S1(36) = nR_S1(36) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(16) && confidence(trial) < quantile_conf(17)  
            nR_S1(37) = nR_S1(37) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(17) && confidence(trial) < quantile_conf(18)
            nR_S1(38) = nR_S1(38) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(18) && confidence(trial) < quantile_conf(19) 
            nR_S1(39) = nR_S1(39) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(19)  
            nR_S1(40) = nR_S1(40) + 1;
        % S2:
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(19) 
            nR_S2(1) = nR_S2(1) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(18) && confidence(trial) < quantile_conf(19)  
            nR_S2(2) = nR_S2(2) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(17) && confidence(trial) < quantile_conf(18)  
            nR_S2(3) = nR_S2(3) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(16) && confidence(trial) < quantile_conf(17)  
            nR_S2(4) = nR_S2(4) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(15) && confidence(trial) < quantile_conf(16)  
            nR_S2(5) = nR_S2(5) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(14) && confidence(trial) < quantile_conf(15)  
            nR_S2(6) = nR_S2(6) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(13) && confidence(trial) < quantile_conf(14)  
            nR_S2(7) = nR_S2(7) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(12) && confidence(trial) < quantile_conf(13)  
            nR_S2(8) = nR_S2(8) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(11) && confidence(trial) < quantile_conf(12)  
            nR_S2(9) = nR_S2(9) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(10) && confidence(trial) < quantile_conf(11)  
            nR_S2(10) = nR_S2(10) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(9) && confidence(trial) < quantile_conf(10)  
            nR_S2(11) = nR_S2(11) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(8) && confidence(trial) < quantile_conf(9)  
            nR_S2(12) = nR_S2(12) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(7) && confidence(trial) < quantile_conf(8)  
            nR_S2(13) = nR_S2(13) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(6) && confidence(trial) < quantile_conf(7)  
            nR_S2(14) = nR_S2(14) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(5) && confidence(trial) < quantile_conf(6)  
            nR_S2(15) = nR_S2(15) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(4) && confidence(trial) < quantile_conf(5)  
            nR_S2(16) = nR_S2(16) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(3) && confidence(trial) < quantile_conf(4)  
            nR_S2(17) = nR_S2(17) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(2) && confidence(trial) < quantile_conf(3)  
            nR_S2(18) = nR_S2(18) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 0 && confidence(trial) > quantile_conf(1) && confidence(trial) < quantile_conf(2)  
            nR_S2(19) = nR_S2(19) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 0 && confidence(trial) < quantile_conf(1)  
            nR_S2(20) = nR_S2(20) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 1 && confidence(trial) < quantile_conf(1)  
            nR_S2(21) = nR_S2(21) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(1) && confidence(trial) < quantile_conf(2)  
            nR_S2(22) = nR_S2(22) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(2) && confidence(trial) < quantile_conf(3)   
            nR_S2(23) = nR_S2(23) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(3) && confidence(trial) < quantile_conf(4)   
            nR_S2(24) = nR_S2(24) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(4) && confidence(trial) < quantile_conf(5)  
            nR_S2(25) = nR_S2(25) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(5) && confidence(trial) < quantile_conf(6)  
            nR_S2(26) = nR_S2(26) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(6) && confidence(trial) < quantile_conf(7)   
            nR_S2(27) = nR_S2(27) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(7) && confidence(trial) < quantile_conf(8)  
            nR_S2(28) = nR_S2(28) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(8) && confidence(trial) < quantile_conf(9)   
            nR_S2(29) = nR_S2(29) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(9) && confidence(trial) < quantile_conf(10) 
            nR_S2(30) = nR_S2(30) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(10) && confidence(trial) < quantile_conf(11) 
            nR_S2(31) = nR_S2(31) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(11) && confidence(trial) < quantile_conf(12)  
            nR_S2(32) = nR_S2(32) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(12) && confidence(trial) < quantile_conf(13)  
            nR_S2(33) = nR_S2(33) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(13) && confidence(trial) < quantile_conf(14)  
            nR_S2(34) = nR_S2(34) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(14) && confidence(trial) < quantile_conf(15)  
            nR_S2(35) = nR_S2(35) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(15) && confidence(trial) < quantile_conf(16) 
            nR_S2(36) = nR_S2(36) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(16) && confidence(trial) < quantile_conf(17)  
            nR_S2(37) = nR_S2(37) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(17) && confidence(trial) < quantile_conf(18)
            nR_S2(38) = nR_S2(38) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(18) && confidence(trial) < quantile_conf(19) 
            nR_S2(39) = nR_S2(39) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 1 && confidence(trial) > quantile_conf(19)  
            nR_S2(40) = nR_S2(40) + 1;
        end
    end
%     median_conf = median(confidence);
%     % quantile_conf = quantile(confidence, 3);
%     for trial = 1:length(behav_data)
%         if behav_data(trial, 10) == 0 && behav_data(trial, 11) == 0 && confidence(trial) >= median_conf
%             nR_S1(1) = nR_S1(1) + 1;
%         elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 0 && confidence(trial) < median_conf  
%             nR_S1(2) = nR_S1(2) + 1; 
%         elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 1 && confidence(trial) < median_conf  
%             nR_S1(3) = nR_S1(3) + 1;
%         elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 1 && confidence(trial) >= median_conf  
%             nR_S1(4) = nR_S1(4) + 1;
%         % S2:
%         elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 0 && confidence(trial) >= median_conf
%             nR_S2(1) = nR_S2(1) + 1;
%         elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 0 && confidence(trial) < median_conf   
%             nR_S2(2) = nR_S2(2) + 1;  
%         elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 1 && confidence(trial) < median_conf    
%             nR_S2(3) = nR_S2(3) + 1;
%         elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 1 && confidence(trial) >= median_conf  
%             nR_S2(4) = nR_S2(4) + 1;
%         end
%     end
%     cd(toolfolder)
    meta_d = fit_meta_d_mcmc(nR_S1, nR_S2);
    cd(resultfolder)
    save(strcat(subjects{n}, '_meta_d_', state), 'meta_d')
    cd(datafolder)
end

% integrate to fleming's 

