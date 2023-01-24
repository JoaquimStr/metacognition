%% PREPARE DIFFICULTY

subjects   = {'105', '107', '108', '109', '111', '112', '113', '114', '116', '119', ...
    '120', '121', '123', '128', '129', '131', '132', '133', '134', '135', ...
    '136', '139', '140', '145', '146'};

state = 'W';
% state = 'S';

difficulty = zeros(1,10000);

datafolder = 'C:/Metacognition_Project/FINALL/behaviour_for_regression';
cd(datafolder)

first = 1;

for n = 1:23
    subject = subjects{n};
    behav_data = load(strcat(subject, '_behav_ready_', state, '.mat'));
    behav_data = behav_data.behav_data;
    morphed = behav_data(:, 3);
    difficulty(first:(first + length(morphed) - 1)) = morphed';
    first = first + length(morphed) + 1;
end

index = difficulty == 0;
difficulty(index) = [];


for trial = 1:length(difficulty)
        if difficulty(trial) == 5 || difficulty(trial) == 15 || difficulty(trial) == 25 || difficulty(trial) == 75 || difficulty(trial) == 85 || difficulty(trial) == 95
            difficulty(trial) = 1;
        elseif difficulty(trial) == 35 || difficulty(trial) == 65
            difficulty(trial) = 2;
        elseif difficulty(trial) == 45 || difficulty(trial) == 55
            difficulty(trial) = 3;
        end
end

% easy1 = difficulty(difficulty == 5 | difficulty == 15 | difficulty == 25);
% easy2 = difficulty(difficulty == 75 | difficulty == 85 | difficulty == 95);
% medium1 = difficulty(difficulty == 35);
% medium2 = difficulty(difficulty == 65);
% difficult = difficulty(difficulty == 45 | difficulty == 55);


%% PREPARE CONFIDENCE
datafolder = 'C:/Metacognition_Project/FINALL/behaviour_for_regression';
cd(datafolder)

for n = 1:23
    subject = subjects{n};
    behav_data = load(strcat(subject, '_behav_ready_', state, '.mat'));
    behav_data = behav_data.behav_data;
    joystick = behav_data(:, 4);
    joystick = abs(joystick);
    confidence(first:(first + length(joystick) - 1)) = joystick';
    first = first + length(joystick) + 1;
end

index = confidence == 0;
confidence(index) = [];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% CORRELATION WITH DIFFICULTY LEVEL

stat1 = mvpa_cf_drowsy;

% subjects   = {'102', '105', '106', '107', '108', '109', '112', '113', '114', '116', '119', ...
%     '120', '121', '123', '124', '129', '130', '131', '132', '133', '134', '135', ...
%      '139', '140', '143', '145', '146'}; % 109, 136, 145, '146'

subjects   = {'105', '107', '108', '109', '112', '113', '114', '116', '119', ...
    '120', '121', '123', '129', '131', '132', '133', '134', '135', '136', ...
     '139', '140', '145', '146'}; % 109, 136, 145


% state = 'W';
state = 'S';

datafolder = 'C:/Metacognition_Project/LME/data';
cd(datafolder)

for n = 1:23 %23, 27
    subject = subjects{n};
    behav_data = load(strcat(subject, '_behav_ready_', state, '.mat'));
    behav_data = behav_data.behav_data;
    difficulty = behav_data(:, 3);
    for trial = 1:length(difficulty)
        stat2(n).scores(trial) = difficulty(trial);
        if difficulty(trial) == 5 || difficulty(trial) == 95 || difficulty(trial) == 15 || difficulty(trial) == 85 || difficulty(trial) == 25 || difficulty(trial) == 75
            stat2(n).scores(trial) = 1; 
%         elseif difficulty(trial) == 15 || difficulty(trial) == 85
%             stat2(n).scores(trial) = 2;
%         elseif difficulty(trial) == 25 || difficulty(trial) == 75
%             stat2(n).scores(trial) = 3;
        elseif difficulty(trial) == 35 || difficulty(trial) == 65
            stat2(n).scores(trial) = 2; 
        elseif difficulty(trial) == 45 || difficulty(trial) == 55
            stat2(n).scores(trial) = 3; 
        end     
        stat2(n).trial_index(trial) = trial; % behav_data(trial, 2);
    end
    stat2(n).dimord = 'rpt';
%     stat2(n).scores = stat2(n).scores(stat1.indivConf(n).trial_index);
%     stat2(n).trial_index = stat2(n).trial_index(stat1.indivConf(n).trial_index); 
    stat2(n).scores = stat2(n).scores';
    stat2(n).trial_index = stat2(n).trial_index';
end

%%
cfg = [];
cfg.corr_method         = 'Spearman';
cfg.mpcompcor_method    = 'cluster_based';
outstat_cf_drowsy = adam_correlate_CONF_stats(cfg,stat1,stat2); % :)

%%

outstat_cf_drowsy.ClassOverTime(142, :) = [];
outstat_cf_drowsy.StdError(142, :) = [];
outstat_cf_drowsy.pVals(142, :) = [];
outstat_cf_drowsy.indivClassOverTime(:, 142) = [];

outstat_pd_drowsy.ClassOverTime(142, :) = [];
outstat_pd_drowsy.StdError(142, :) = [];
outstat_pd_drowsy.pVals(142, :) = [];
outstat_pd_drowsy.indivClassOverTime(:, 142) = [];

%%
cfg = [];                            
cfg.singleplot = true;       
% cfg.acclim = [.45 .80];      
% cfg.channelpool = 'ALL';  
adam_plot_MVPA(cfg, outstat_cf_awake, outstat_cf_drowsy)

%% CORRELATION WITH JOYSTICK

stat1 = mvpa_pd_awake;

% subjects   = {'105', '107', '108', '109', '112', '113', '114', '116', '119', ...
%     '120', '121', '123', '129', '131', '133', '134', '135', ...
%      '139', '140', '145', '146'}; %'132' '136'

% subjects   = {'102', '105', '106', '107', '108', '109', '112', '113', '114', '116', '119', ...
%     '120', '121', '123', '124', '129', '130', '131', '132', '133', '134', '135', ...
%      '139', '140', '143', '145', '146'}; % 109, 136, 145, '146'

subjects   = {'105', '107', '108', '109', '112', '113', '114', '116', '119', ...
    '120', '121', '123', '129', '131', '132', '133', '134', '135', '136', ...
     '139', '140', '145', '146'}; % 109, 136, 145

state = 'W';
% state = 'S';

% datafolder = 'C:/Metacognition_Project/DATA/high_conf_behav';
% cd(datafolder)

datafolder = 'C:/Metacognition_Project/LME/data';
cd(datafolder)

for n = 1:23 %23, 27, 28
    subject = subjects{n};
    behav_data = load(strcat(subject, '_behav_ready_', state, '.mat'));
    behav_data = behav_data.behav_data;
    confidence = abs(behav_data(:, 4));
    median_conf = median(confidence);
    quantile_conf = quantile(confidence, 20);
    for trial = 1:length(confidence)
%         if confidence(trial) < median_conf
%             stat3(n).scores(trial) = 0;
%         elseif confidence(trial) >= median_conf
%             stat3(n).scores(trial) = 1;
%         end

        stat3(n).scores(trial) = confidence(trial);

%         if confidence(trial) <= median_conf
%               stat3(n).scores(trial) = 0;
%         elseif confidence(trial) <= quantile_conf(11) && confidence(trial) > quantile_conf(10)
%             stat3(n).scores(trial) = 1;
%         elseif confidence(trial) <= quantile_conf(12) && confidence(trial) > quantile_conf(11)
%             stat3(n).scores(trial) = 2;
%         elseif confidence(trial) <= quantile_conf(13) && confidence(trial) > quantile_conf(12)
%             stat3(n).scores(trial) = 3;
%         elseif confidence(trial) <= quantile_conf(14) && confidence(trial) > quantile_conf(13)
%             stat3(n).scores(trial) = 4;
%         elseif confidence(trial) <= quantile_conf(15) && confidence(trial) > quantile_conf(14)
%             stat3(n).scores(trial) = 5;
%         elseif confidence(trial) <= quantile_conf(16) && confidence(trial) > quantile_conf(15)
%             stat3(n).scores(trial) = 6;
%         elseif confidence(trial) <= quantile_conf(17) && confidence(trial) > quantile_conf(16)
%             stat3(n).scores(trial) = 7;
%         elseif confidence(trial) <= quantile_conf(18) && confidence(trial) > quantile_conf(17)
%             stat3(n).scores(trial) = 8;
%         elseif confidence(trial) <= quantile_conf(19) && confidence(trial) > quantile_conf(18)
%             stat3(n).scores(trial) = 9;
%         elseif confidence(trial) > quantile_conf(19) 
%             stat3(n).scores(trial) = 10;
%         end

%         if confidence(trial) <= quantile_conf(1)
%             stat3(n).scores(trial) = 1;
%         elseif confidence(trial) <= quantile_conf(2) && confidence(trial) > quantile_conf(1)
%             stat3(n).scores(trial) = 2;
%         elseif confidence(trial) <= quantile_conf(3) && confidence(trial) > quantile_conf(2)
%             stat3(n).scores(trial) = 3;
%         elseif confidence(trial) <= quantile_conf(4) && confidence(trial) > quantile_conf(3)
%             stat3(n).scores(trial) = 4;
%         elseif confidence(trial) <= quantile_conf(5) && confidence(trial) > quantile_conf(4)
%             stat3(n).scores(trial) = 5;
%         elseif confidence(trial) <= quantile_conf(6) && confidence(trial) > quantile_conf(5)
%             stat3(n).scores(trial) = 6;
%         elseif confidence(trial) <= quantile_conf(7) && confidence(trial) > quantile_conf(6)
%             stat3(n).scores(trial) = 7;
%         elseif confidence(trial) <= quantile_conf(8) && confidence(trial) > quantile_conf(7)
%             stat3(n).scores(trial) = 8;
%         elseif confidence(trial) <= quantile_conf(9) && confidence(trial) > quantile_conf(8)
%             stat3(n).scores(trial) = 9;
%         elseif confidence(trial) <= quantile_conf(10) && confidence(trial) > quantile_conf(9)
%             stat3(n).scores(trial) = 10;
%         elseif confidence(trial) <= quantile_conf(11) && confidence(trial) > quantile_conf(10)
%             stat3(n).scores(trial) = 11;
%         elseif confidence(trial) <= quantile_conf(12) && confidence(trial) > quantile_conf(11)
%             stat3(n).scores(trial) = 12;
%         elseif confidence(trial) <= quantile_conf(13) && confidence(trial) > quantile_conf(12)
%             stat3(n).scores(trial) = 13;
%         elseif confidence(trial) <= quantile_conf(14) && confidence(trial) > quantile_conf(13)
%             stat3(n).scores(trial) = 14;
%         elseif confidence(trial) <= quantile_conf(15) && confidence(trial) > quantile_conf(14)
%             stat3(n).scores(trial) = 15;
%         elseif confidence(trial) <= quantile_conf(16) && confidence(trial) > quantile_conf(15)
%             stat3(n).scores(trial) = 16;
%         elseif confidence(trial) <= quantile_conf(17) && confidence(trial) > quantile_conf(16)
%             stat3(n).scores(trial) = 17;
%         elseif confidence(trial) <= quantile_conf(18) && confidence(trial) > quantile_conf(17)
%             stat3(n).scores(trial) = 18;
%         elseif confidence(trial) <= quantile_conf(19) && confidence(trial) > quantile_conf(18)
%             stat3(n).scores(trial) = 19;
%         elseif confidence(trial) > quantile_conf(19) 
%             stat3(n).scores(trial) = 20;
%         end
        stat3(n).trial_index(trial) = trial; % behav_data(trial, 2);
    end
    stat3(n).dimord = 'rpt';
    % stat3(n).scores = stat3(n).scores(stat1.indivConf(n).trial_index);
    % stat3(n).trial_index = stat3(n).trial_index(stat1.indivConf(n).trial_index); 
    stat3(n).scores = stat3(n).scores';
    stat3(n).trial_index = stat3(n).trial_index';
end

%%
cfg = [];
cfg.corr_method         = 'Spearman';
cfg.mpcompcor_method    = 'cluster_based';
outstat_pd_awake = adam_correlate_CONF_stats(cfg,stat1,stat3); % :)

%%

outstat_cf_drowsy.ClassOverTime(142, :) = [];
outstat_cf_drowsy.StdError(142, :) = [];
outstat_cf_drowsy.pVals(142, :) = [];
outstat_cf_drowsy.indivClassOverTime(:, 142) = [];

outstat_pd_drowsy.ClassOverTime(142, :) = [];
outstat_pd_drowsy.StdError(142, :) = [];
outstat_pd_drowsy.pVals(142, :) = [];
outstat_pd_drowsy.indivClassOverTime(:, 142) = [];

%%
cfg = [];                            
cfg.singleplot = true;       
% cfg.acclim = [.45 .80];      
% cfg.channelpool = 'ALL';  
adam_plot_MVPA(cfg, outstat_pd_awake, outstat_pd_drowsy)

%% CORRELATION WITH REACTION TIME

stat1 = mvpa_pd_drowsy;

subjects   = {'105', '107', '108', '109', '112', '113', '114', '116', '119', ...
    '120', '121', '123', '129', '131', '132', '133', '134', '135', '136', ...
     '139', '140', '145', '146'}; % 109, 136, 145

% state = 'W';
state = 'S';

datafolder = 'C:/Metacognition_Project/LME/data';
cd(datafolder)

for n = 1:23
    subject = subjects{n};
    behav_data = load(strcat(subject, '_behav_ready_', state, '.mat'));
    behav_data = behav_data.behav_data;
    RT = behav_data(:, 6);
    for trial = 1:length(RT)
        stat4(n).scores(trial) = RT(trial);    
        stat4(n).trial_index(trial) = trial;
    end
    stat4(n).dimord = 'rpt';
    stat4(n).scores = stat4(n).scores(stat1.indivConf(n).trial_index);
    stat4(n).trial_index = stat4(n).trial_index(stat1.indivConf(n).trial_index); 
    stat4(n).scores = stat4(n).scores';
    stat4(n).trial_index = stat4(n).trial_index';
end


%%
cfg = [];
cfg.corr_method         = 'Spearman';
cfg.mpcompcor_method    = 'cluster_based';
outstat_pd_drowsy = adam_correlate_CONF_stats(cfg,stat1,stat4); % :)

%%

outstat_cf_drowsy.ClassOverTime(142, :) = [];
outstat_cf_drowsy.StdError(142, :) = [];
outstat_cf_drowsy.pVals(142, :) = [];
outstat_cf_drowsy.indivClassOverTime(:, 142) = [];

outstat_pd_drowsy.ClassOverTime(142, :) = [];
outstat_pd_drowsy.StdError(142, :) = [];
outstat_pd_drowsy.pVals(142, :) = [];
outstat_pd_drowsy.indivClassOverTime(:, 142) = [];

%%
cfg = [];                            
cfg.singleplot = true;       
% cfg.acclim = [.45 .80];      
% cfg.channelpool = 'ALL';  
adam_plot_MVPA(cfg, outstat_cf_awake, outstat_cf_drowsy)

%% difficulty x joystick x RT
cfg = [];
cfg.corr_method         = 'Pearson';
cfg.mpcompcor_method    = 'cluster_based';
outstat_rt = adam_correlate_CONF_stats(cfg,stat1,stat3, stat4); % :)

%%
cfg = [];                            
cfg.singleplot = true;       
% cfg.acclim = [.45 .80];      
% cfg.channelpool = 'ALL';  
adam_plot_MVPA(cfg, outstat_rt)

%% AWAKE AND DROWSY

stat1 = mvpa_awake;
stat2 = mvpa_drowsy;

% for n = 1:23
%     subject = subjects{n};
%     stat2 = mvpa_drowsy;
%     trust = mvpa_drowsy.indivConf(subject).scores;
%     for trial = 1:length(RT)
%         stat4(n).scores(trial) = trust(trial);    
%         stat4(n).trial_index(trial) = trial;
%     end
%     stat4(n).dimord = 'rpt';
%     stat4(n).scores = stat4(n).scores(stat1.indivConf(n).trial_index);
%     stat4(n).trial_index = stat4(n).trial_index(stat1.indivConf(n).trial_index); 
%     stat4(n).scores = stat4(n).scores';
%     stat4(n).trial_index = stat4(n).trial_index';
% end

cfg = [];
cfg.corr_method         = 'Pearson';
cfg.mpcompcor_method    = 'cluster_based';
outstat = adam_correlate_CONF_stats(cfg,stat1,stat2);


%% PD AND CF
% just reprepare confidence scores

stat1 = mvpa_pd_awake;
stat2 = mvpa_cf_awake;

stat3 = mvpa_pd_drowsy;
stat4 = mvpa_cf_drowsy;

% for n = 1:23
%     trust = mvpa_cf.indivConf(n).scores(:, 1, 1);
%     for trial = 1:length(trust)
%         stat2(n).scores(trial) = trust(trial);    
%         stat2(n).trial_index(trial) = trial;
%     end
%     stat2(n).dimord = 'rpt';
%     stat2(n).scores = stat2(n).scores(stat1.indivConf(n).trial_index);
%     stat2(n).trial_index = stat2(n).trial_index(stat1.indivConf(n).trial_index); 
%     stat2(n).scores = stat2(n).scores';
%     stat2(n).trial_index = stat2(n).trial_index';
% end

cfg = [];
cfg.corr_method         = 'Spearman';
cfg.mpcompcor_method    = 'cluster_based';
outstat_awake = adam_correlate_CONF_stats(cfg,stat1,stat2);
outstat_drowsy = adam_correlate_CONF_stats(cfg,stat3,stat4);

outstat_drowsy.ClassOverTime(142, :) = [];
outstat_drowsy.StdError(142, :) = [];
outstat_drowsy.pVals(142, :) = [];
outstat_drowsy.indivClassOverTime(:, 142) = [];

cfg = [];                            
cfg.singleplot = true;
adam_plot_MVPA(cfg, outstat_awake, outstat_drowsy)