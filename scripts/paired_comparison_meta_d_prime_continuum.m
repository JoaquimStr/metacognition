server = 0;

if server == 0
    datafolder = 'C:\Users\strei\OneDrive - University of Cambridge\All_new';
    resultfolder = 'C:/Metacognition_project/HMETA';
    drowsiness_datafolder = 'C:\Metacognition_Project\DATA\DROWSINESS_DATA';
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

subjects   = {'105', '107', '108', '109', '112', '113', '114', '116', '119', ...
    '120', '121', '123', '129', '131', '132', '133', '134', '135', ...
    '136', '139', '140', '145', '146'};

% subject = params{1,1};

% state = 'W';
state = 'S';

addpath(scriptfolder)

group_nR_S1 = cell(1,23);
group_nR_S2 = cell(1,23);

for n = 1:23 %23-25-28
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
        behav_data = assess_drowsy(subject, behav_data);
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

group_W = fit_meta_d_mcmc_group(group_nR_S1, group_nR_S2);

group_S = fit_meta_d_mcmc_group(group_nR_S1, group_nR_S2);


corr = fit_meta_d_mcmc_groupCorr(nR_S1_W, nR_S2-W, nR_S1_S, nR_S2_S);


sampleDiff = group_W.mcmc.samples.mu_logMratio - group_S.mcmc.samples.mu_logMratio;
hdi = calc_HDI(sampleDiff(:));
fprintf(('\n Mratio session values = %.2f and %.2f'), exp(group_W.mcmc.samples.mu_logMratio), exp(group_S.mcmc.samples.mu_logMratio));
fprintf(['\n Estimated difference in Mratio between sessions: ', num2str(exp(group_W.mu_logMratio) - exp(group_S.mu_logMratio))])
fprintf(['\n HDI on difference in log(Mratio): ', num2str(hdi) '\n\n'])


% Plot each of the group distributions for Mratio:

plotSamples(exp(group_W.mcmc.samples.mu_logMratio))
plotSamples(exp(group_S.mcmc.samples.mu_logMratio))
plotSamples(sampleDiff)

%% for d'
d_W = [2.82067000000003	2.02722999999997	2.66945000000000	2.04775999999997	2.72485000000003	1.90138999999999	2.92641000000003	2.17542000000002	2.33624000000004	3.00547000000003	2.02312000000002	1.34275000000002	0.615140999999995	1.44677999999999	2.22136000000000	1.79410000000002	1.70182000000000	2.80816000000003	2.39222000000000	1.66526999999998	1.85733000000003	2.32991999999998	3.14813000000003];
d_S = [2.30420000000003	1.60797000000002	2.51462999999999	0.927396000000015	1.82310000000002	1.44399999999998	2.02265000000005	1.66640000000001	2.02396999999998	2.20260000000003	2.23492000000003	1.36498000000000	0.827062999999986	1.48551999999997	2.63326000000003	1.81495999999998	1.54510000000003	1.45727000000003	2.56201999999999	2.32969999999997	1.07797000000002	1.63105999999999	2.25900000000001];

mean(d_W)
mean(d_S)

[h,p,ci,stats] = ttest(d_W, d_S);

%% for Mratio
H_W = [0.329755690566667	0.416841155266667	0.372348256203334	0.382583772496667	0.282143865259000	0.682291440640000	0.321766183136667	0.420423799403333	0.572823450733333	0.562024894356667	0.281881334430667	0.492224515566667	0.388362498359333	0.847339452366667	0.323217529889000	0.298557301694333	0.426073905133333	0.303881230743333	0.333478229136667	0.284088365645000	0.438841660526667	0.657517020166667	0.282016930500000];
H_S = [0.277646324063333	0.437479256956667	0.413566245190000	0.872604542956667	0.664346046453333	0.585772904193333	0.328790811893333	0.422268041040000	0.255715356353333	0.288006238846667	0.461668519186667	0.888084876630000	0.667237692110000	0.478149583890000	0.508860119300000	0.498999574580000	0.328571294260000	0.597217387676667	0.202419234836667	0.279467517640000	0.485969232713333	0.463175613843333	0.928556495166667];

mean(H_W)
mean(H_S)