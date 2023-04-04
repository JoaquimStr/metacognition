server = 0;

if server == 0
    datafolder = 'C:\Users\strei\OneDrive - University of Cambridge\All_new';
    resultfolder = 'C:/Metacognition_project/HMETA/30participants';
%     drowsiness_datafolder = 'C:\Metacognition_Project\DATA\DROWSINESS_DATA';
    drowsiness_datafolder = 'C:\Users\strei\OneDrive - University of Cambridge\drowsiness';
    scriptfolder ='C:\Metacognition_Project\SCRIPTS\metacognition';
else
    datafolder = '/home/js2715/rds/rds-tb419-bekinschtein/Yanzhi/EXP_4_Metacognition';
    resultfolder = '/home/js2715/rds/rds-tb419-bekinschtein/Joaquim/RESULTS/BEHAVIOURAL/HMeta-d';
    drowsiness_datafolder = [datafolder, '/Analysis_Micromeasures/iaf/'];
    toolfolder = '/home/js2715/tools';
end

cd(datafolder)

% Hmeta_path = [toolfolder, '/HMeta-d-master'];
% genpath(Hmeta_path)
% 
% subjects   = {'105', '107', '108', '109', '112', '113', '114', '116', '119', ...
%     '120', '121', '123', '129', '131', '132', '133', '134', '135', ...
%     '136', '139', '140', '145', '146'};


% subjects   = {'102', '105', '106', '107', '111', '112', '113', '114', '116', '117', ...
%     '119', '120', '121', '123', '124', '125', '126', '127', '128', '131', ...
%      '132', '133', '136', '137', '139', '140', '141', '143', '144', '146'}; 

subjects   = {'102', '105', '106', '107', '111', '112', '113', '114', '116', '117', ...
    '119', '120', '121', '123', '124', '125', '126', '127', '128', '131', ...
     '132', '133', '136', '137', '139', '140', '141', '143', '144', '146'}; 

% subject = params{1,1};

% state = 'W';
state = 'S';

addpath(scriptfolder)

group_nR_S1 = cell(1,30);
group_nR_S2 = cell(1,30);

for n = 1:30 %23-25-28
    cd(datafolder)
    params = subjects(n);
    subject = params{1,1};
    nR_S1 = zeros(1, 40);
    nR_S2 = zeros(1, 40);
    [rej_trials, eeg_file, behav_data] = load_data(subject, state);
    behav_data = reject_EEG(subject, state, behav_data, rej_trials);
%     if strcmp(state, 'W')
%         behav_data = behav_data.datamat_all_session1;
%     else
%         behav_data = behav_data.datamat_all_session2;
%     end
    if strcmp(state, 'S')
        cd(drowsiness_datafolder) % go to where the drowsiness data is
        behav_data = assess_drowsy(subject, behav_data, rej_trials);
        behav_data = reject_drowsy(subject, behav_data);
    end
    confidence = abs(behav_data(:, 4));
    median_conf = median(confidence);
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
    group_nR_S1{n} = nR_S1;
    group_nR_S2{n} = nR_S2;
end


%%

% group_W = fit_meta_d_mcmc_group(group_nR_S1, group_nR_S2);

group_S = fit_meta_d_mcmc_group(group_nR_S1, group_nR_S2);

%%
plotSamples(exp(fit.mcmc.samples.mu_logMratio))

%%
corr = fit_meta_d_mcmc_groupCorr(group_nR_S1_W, group_nR_S2_W, group_nR_S1_S, group_nR_S2_S);

%%
sampleDiff = group_W.mcmc.samples.mu_logMratio - group_S.mcmc.samples.mu_logMratio;
hdi = calc_HDI(sampleDiff(:));
fprintf(('\n Mratio session values = %.2f and %.2f'), exp(group_W.mcmc.samples.mu_logMratio), exp(group_S.mcmc.samples.mu_logMratio));
fprintf(['\n Estimated difference in Mratio between sessions: ', num2str(exp(group_W.mu_logMratio) - exp(group_S.mu_logMratio))])
fprintf(['\n HDI on difference in log(Mratio): ', num2str(hdi) '\n\n'])


% Plot each of the group distributions for Mratio:

plotSamples(exp(group_W.mcmc.samples.mu_logMratio))
plotSamples(exp(group_S.mcmc.samples.mu_logMratio))
plotSamples(sampleDiff)

% calc_HDI(exp(fit.mcmc.samples.mu_logMratio(:)))

%% for d'
d_W = [3.15070000000003	2.82067000000003	2.88581999999997	2.02722999999997	1.99678999999997	2.72485000000003	1.90138999999999	2.92641000000003	2.17542000000002	2.88806999999998	2.33624000000004	3.80776999999992	2.02312000000002	1.34275000000002	1.16695000000002	2.25453000000000	1.78820999999999	1.95604000000002	3.35833000000002	1.44677999999999	2.22136000000000	1.79410000000002	2.39222000000000	3.11371000000005	1.66526999999998	1.85733000000003	1.77020999999997	1.31784000000000	2.19260000000002	3.14813000000003];
d_S = [2.47727000000001	2.60062000000002	2.52223999999997	1.79623999999996	2.45038000000003	2.50091000000002	1.65724999999998	1.96308999999998	1.74406999999998	2.19338999999996	2.03511000000002	2.53281000000001	2.10418000000002	1.48082999999998	0.816166999999984	1.16389000000002	1.87543000000004	1.40765000000002	2.17882000000004	1.74525999999997	2.47101000000002	1.84249000000000	2.37750000000004	2.19156999999997	2.36025999999997	0.891155000000018	1.27659000000001	1.11785999999999	2.61205000000001	2.66424999999998];

mean_d_W = mean(d_W);
mean_d_S = mean(d_S);
save
[h,p,ci,stats] = ttest(d_W, d_S);

%% for Mratio
H_W = [0.421925700713333	0.367489811906667	0.219719691714333	0.470417545916666	0.467124867343333	0.309166626086667	0.790253389366667	0.347543259923000	0.479219755743333	0.433166859746667	0.665150672510000	0.544692335366667	0.296122196490333	0.549396486700000	0.340789295020000	0.581937315833333	0.562934961986667	0.313184900956900	0.239071882569333	1.03515862293667	0.356500767980000	0.329625037490000	0.371137247436667	0.609658750200000	0.298691959195667	0.486194604863667	0.649251214123333	0.436462293071667	0.465418445753333	0.310062065896667];
H_S = [0.304890799156667	0.336923871400000	0.415074965476667	0.428342738073334	0.384780697706333	0.747763159066667	0.589239563993333	0.330276238860000	0.555362000410000	0.274252335886667	0.245295999283333	0.289192560733333	0.486669864440000	0.901259742533334	0.408415785980000	0.491690766800000	0.365364220703333	0.326987227770000	0.367259465023333	0.341331486576667	0.479512257646667	0.462767011663333	0.281817194560000	0.576354203600000	0.290398576146667	0.384501888283333	0.716151915613333	0.323809058326000	0.367998456149000	0.675312205833333];

mean_H_W = mean(H_W);
mean_H_S = mean(H_S);

%% for meta-d'
meta_W = [1.32936130523751	1.03656748775079	0.634071480743052	0.953644561608628	0.932750263862479	0.842432681092262	1.50257989200788	1.01705407127128	1.04250424103917	1.25101621262855	1.55395160714479	2.07406313383909	0.599090738163528	0.737702132516435	0.397684067823596	1.31199513666572	1.00664592837417	0.612602193667741	0.802882275389074	1.49764679249230	0.791916545960054	0.591380279760816	0.887841946062942	1.89830054708527	0.497402758889761	0.903023825451450	1.14931099175325	0.575187468301565	1.02047648415877	0.976115691511283];
meta_S = [0.755296830026837	0.876210958440274	1.04691868092385	0.769406359836828	0.942858926045659	1.87008836214143	0.976517267427940	0.648361981743670	0.968590204055057	0.601542331010445	0.499204341101509	0.732469809750996	1.02404099535737	1.33461246453562	0.333335486795932	0.572273966570861	0.685215020433666	0.460283571170448	0.800192267582153	0.595712190262783	1.18487958376750	0.852643591319575	0.670020380066412	1.26312058198363	0.685416143335921	0.342650780253141	0.914232373952833	0.361973193940298	0.961230367384000	1.79920054439144];

mean_meta_W = mean(meta_W);
mean_meta_S = mean(meta_S);

%% assess different hierarchical models
% https://github.com/metacoglab/HMeta-d/wiki/HMeta-d-tutorial
fit.mcmc.dic