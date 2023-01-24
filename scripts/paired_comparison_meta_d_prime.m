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

nR_S1 = cell(1,23);
nR_S2 = cell(1,23);

for n = 1:23 %23-25-28
    cd(datafolder)
    params = subjects(n);
    subject = params{1,1};
    S1_ind = zeros(1, 4);
    S2_ind = zeros(1, 4);
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
            S1_ind(1) = S1_ind(1) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 0 && confidence(trial) < median_conf  
            S1_ind(2) = S1_ind(2) + 1; 
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 1 && confidence(trial) < median_conf  
            S1_ind(3) = S1_ind(3) + 1;
        elseif behav_data(trial, 10) == 0 && behav_data(trial, 11) == 1 && confidence(trial) >= median_conf  
            S1_ind(4) = S1_ind(4) + 1;
        % S2:
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 0 && confidence(trial) >= median_conf
            S2_ind(1) = S2_ind(1) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 0 && confidence(trial) < median_conf   
            S2_ind(2) = S2_ind(2) + 1;  
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 1 && confidence(trial) < median_conf    
            S2_ind(3) = S2_ind(3) + 1;
        elseif behav_data(trial, 10) == 1 && behav_data(trial, 11) == 1 && confidence(trial) >= median_conf  
            S2_ind(4) = S2_ind(4) + 1;
        end
    end
    nR_S1{n} = S1_ind;
    nR_S2{n} = S2_ind;
end


%%

group_W = fit_meta_d_mcmc_group(nR_S1, nR_S2);

group_S = fit_meta_d_mcmc_group(nR_S1, nR_S2);

% could also check correlation:
% corr = fit_meta_d_mcmc_groupCorr(nR_S1_W, nR_S2, nR_S1_S, nR_S2_S);


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
d_W = [2.74324999999999	2.01635000000004	2.97546999999998	1.88165000000002	2.95715000000003	1.99250000000002	3.17219999999998	2.08955999999995	2.94986999999995	3.11801000000003	2.65936000000006	1.47047999999997	2.01492000000003	2.45902999999999	2.91818000000000	2.56309000000006	2.02359000000001	2.33161000000000	3.11496000000000	2.57874999999999	2.13232999999996	2.53305000000000	3.24184999999999];
d_S = [2.10917999999997	1.11999000000000	2.21444000000000	0.664348000000009	1.09447000000000	1.12983000000000	2.26451999999999	1.75176000000004	1.74811000000000	2.19324000000002	2.31559000000000	0.865429999999980	0.806525999999992	1.02755999999999	2.69079000000006	0.999216000000019	1.84592999999997	0.771337000000009	2.79854999999998	2.49668999999996	1.11144000000000	0.999169000000023	1.06583999999999];

mean(d_W)
mean(d_S)

[h,p,ci,stats] = ttest(d_W, d_S);

%% for Mratio
H_W = [0.274400083760000	0.293034092253333	0.300079560590000	0.282709159956667	0.264809678693333	0.304551768640000	0.258414103676667	0.275191423523333	0.266793965293333	0.338840976703333	0.276406646170000	0.343167897150000	0.276328274196667	0.321808578844667	0.302710124146667	0.266245150986667	0.281064214526667	0.342631399993334	0.291528446476667	0.268278413083333	0.272697322280000	0.285847153936667	0.292907391536667];
H_S = [0.482020466866667	0.452541949306667	0.741720312366667	0.785387227246667	0.669812987133333	0.871400355833333	0.656428814966667	0.416977343653333	0.563947505133333	0.414432142830000	0.485500091433333	0.677807230600000	0.535690058000000	1.17015599336667	0.619505190133333	0.889412838333333	0.403859098266667	0.676645766640000	0.435130135416667	0.371231171543333	0.710290060866667	1.25638574976667	0.668320013173333];

mean(H_W)
mean(H_S)