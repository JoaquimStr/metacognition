function stat = SG_comparerp_metacog_for_Joaquim_JS(statmode,subjinfo,condlist, level_of_drowsiness,latency, varargin) % params, % ,varargin

% loadpaths % VN

% AK_comperp('trial',{'Super_MMNtime_resp_cond2_BT5' 'Super_MMNtime_resp_cond3_BT5'},{'cond2' 'cond3'}, [0 0.32])
% AK_comperp('cond',[1 2],{'Awake' 'Drowsy'},[0 0.100])
% SG_ft_compFFTfeatStratify('cond', [1 2], {'LA' 'RS'});
% SG_comparerp_metacog_for_Joaquim('cond', [1 2], {'HighConf_alert' 'LowConf_alert'}, 1, [-0.2 0.9]);

% Inputs used by Joaquim:
% SG_comparerp_metacog_for_Joaquim_JS('cond', [1 2], {'HighConf_alert' 'LowConf_alert'}, 1, [-0.2 2])
% SG_comparerp_metacog_for_Joaquim_JS('cond', [1 2], {'HighConf_drowsy' 'LowConf_drowsy'}, 2, [-0.2 2])
% SG_comparerp_metacog_for_Joaquim_JS('cond', [1 2], {'Alert_correct' 'Drowsy_correct'}, 1, [-0.2 2])

% maybe latency = [-0.2 RT]?

% level_of_drowsiness = 1 if Alert; = 2 if Drowsy

param = finputcheck(varargin, {
    'alpha' , 'real' , [], 0.05; ...
    'numrand', 'integer', [], 1000; ...
    'ttesttail', 'integer', [-1 0 1], 0; ...
    'testgfp', 'string', {'on' 'off'}, 'off';...
    'testcnv', 'string', {'on' 'off'}, 'off';...
    'testlat', 'string', {'on' 'off'}, 'off';...
    });

timeshift = 0; %seconds

% subjlists = {[102; 105; 106; 107; 108; 109; 111; 112; 113; 114; 116; 119; 120; 121; 123; 124; 125; 128; 129; 130; 131; 132; 133; 135; 136; 137; 139; 140; 141; 143; 145; 146], ...
%     [102; 105; 106; 107; 108; 109; 111; 112; 113; 114; 116; 119; 120; 121; 123; 124; 125; 128; 129; 130; 131; 132; 133; 135; 136; 137; 139; 140; 141; 143; 145; 146]};%{[134], [134]};
% %filepath = 'F:\unix\stani\ExpMetacogJoystick\Datasets3\';
% filepath = 'F:\unix\stani\ExpMetacogJoystick\Cate_backup_folder\All_subjects\';

% subjlists = {[102; 105; 106; 107; 111; 112; 113; 114], ...
%      [102; 105; 106; 107; 111; 112; 113; 114]};
subjlists = {[102; 105; 106; 107; 111; 112; 113; 114; 116; 117; 119; 120; 121; 123; 124; 125; 126; 127; 128; 131; 132; 133; 136; 137; 139; 140; 141; 143; 144; 146], ...
     [102; 105; 106; 107; 111; 112; 113; 114; 116; 117; 119; 120; 121; 123; 124; 125; 126; 127; 128; 131; 132; 133; 136; 137; 139; 140; 141; 143; 144; 146]};

% filepath = '/home/js2715/rds/rds-tb419-bekinschtein/Joaquim/DATA (see Yanzhis folder)/READY/FINAL_ANALYSES_MANUSCRIPT/PD/';
filepath = 'C:\Users\strei\OneDrive - University of Cambridge\EEG_metacognition\CF\';

%%%%%%%%%%%%%%%%%%%%%%%%""""""%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% For METACOG, perform within-subject statistics %%%%
%%%%%%%%%%%%%%%%%%%%%%%%""""""%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(statmode,'trial') && iscell(subjinfo) && length(subjinfo) == 2
    %%%% perform single-trial statistics
    subjlist = subjinfo;
    subjcond = condlist;

%I want to compare condition, nota. awake and drowsy sessions:
elseif strcmp(statmode,'cond') && isnumeric(subjinfo) && length(subjinfo) == 2
    %%%% perform within-subject statistics
    subjlist1 = subjlists{subjinfo(1)};
    subjlist2 = subjlists{subjinfo(2)};
    subjlist = subjlist1; % cat(2,subjlist1,subjlist2);
    subjcond = condlist; %repmat(condlist,length(subjlist),1);
    
elseif strcmp(statmode,'subj') && isnumeric(subjinfo) && length(subjinfo) == 2 || length(subjinfo) == 4
    %%%% perform across-subject statistics
    subjlist1 = subjlists{subjinfo(1)};
    subjlist2 = subjlists{subjinfo(2)};
    
    numsubj1 = length(subjlist1);
    numsubj2 = length(subjlist2);
    subjlist = cat(1,subjlist1,subjlist2);
    subjcond = cat(1,repmat(condlist(1),numsubj1,1),repmat(condlist(2),numsubj2,1));
    if length(condlist) == 4
        subjcond = cat(2,subjcond,cat(1,repmat(condlist(3),numsubj1,1),repmat(condlist(4),numsubj2,1)));
        subjlist3 = subjlists{subjinfo(3)};
        subjlist4 = subjlists{subjinfo(4)};
        subjlist = cat(2,subjlist,cat(1,subjlist3,subjlist4));
    end
else
    error('Invalid combination of statmode and subjlist!');
end


numsubj = size(subjlist,1);
numcond = size(subjcond,2);

conddata = cell(numsubj,numcond);
timelocked_data = cell(numsubj,numcond); % was freq_data = cell(numsubj,numcond); in MALib

%%%%%%%%%%%%%%%%%%%%%%%%""""""%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% SG: 07/06/22 For METACOG, perform within-subject statistics %%%%
%%%%%%%%%%%%%%%%%%%%%%%%""""""%%%%%%%%%%%%%%%%%%%%%%%%%%

%% load and prepare individual subject datasets
for s = 1:numsubj
    subj_data = load(strcat('C:\Users\strei\OneDrive - University of Cambridge\EEG_metacognition\CF\CLEAN_BEHAV\', num2str(subjlist(s)), '_behav_ready_W.mat'));
    subj_data_S = load(strcat('C:\Users\strei\OneDrive - University of Cambridge\EEG_metacognition\CF\CLEAN_BEHAV\', num2str(subjlist(s)), '_behav_ready_S.mat'));
    
    selected_accuracy_erp = subj_data.behav_data(:, 7);
%     selected_accuracy_erp_mat = load(strcat('C:\Users\strei\OneDrive - University of Cambridge\EEG_metacognition\CF\CLEAN_BEHAV\', num2str(subjlist(s)), '_behav_ready_W.mat'));
%     selected_accuracy_erp = selected_accuracy_erp_mat.selected_accuracy_erp;

%     selected_drowsiness_erp_mat = load(strcat('F:\unix\stani\ExpMetacogJoystick\Cate_backup_folder\All_subjects\selected_drowsiness_erp_S', num2str(subjlist(s)), '.mat'));
%     selected_drowsiness_erp = selected_drowsiness_erp_mat.selected_drowsiness_erp;

    selected_cr_erp = subj_data.behav_data(:, 13); % awake
    selected_cr_erp_S = subj_data_S.behav_data(:, 14); % drowsy
%     selected_cr_erp_mat = load(strcat('F:\unix\stani\ExpMetacogJoystick\Cate_backup_folder\All_subjects\selected_cr_', num2str(subjlist(s)), 'erp.mat'));
%     cr_varname = strcat('selected_cr_', num2str(subjlist(s)), 'erp');
%     selected_cr_erp = selected_cr_erp_mat.(cr_varname);
%     selected_difficulty_erp_mat = load(strcat('F:\unix\stani\ExpMetacogJoystick\Cate_backup_folder\All_subjects\selected_difficulty_erp_', num2str(subjlist(s)), '.mat'));
%     diff_varname = strcat('selected_difficulty_erp_', num2str(subjlist(s)));
%     selected_difficulty_erp = selected_difficulty_erp_mat.(diff_varname);

    selected_tonecone_erp = subj_data.behav_data(:, 8);
%     selected_tonecone_erp_mat = load(strcat('F:\unix\stani\ExpMetacogJoystick\Cate_backup_folder\All_subjects\selected_tonecone_erp_', num2str(subjlist(s)), '.mat'));
%     selected_tonecone_erp = selected_tonecone_erp_mat.selected_tonecone_erp;
    
    
%     correct_trials = find(selected_accuracy_erp(:,1)==1);
%     correct_drowsiness = selected_drowsiness_erp(correct_trials,1);
%     drowsy_correct_trials = find(correct_drowsiness(:,1)==level_of_drowsiness);
%     difficulty_in_drowsy_correct_trials = selected_difficulty_erp(drowsy_correct_trials,1);
%     logicalIndexes = difficulty_in_drowsy_correct_trials < 60 & difficulty_in_drowsy_correct_trials > 40;
%     hard_drowsy_correct_trials = find(logicalIndexes);
%     drowsy_correct_cr = selected_cr_erp(hard_drowsy_correct_trials,1);
%     drowsy_correct_cr = selected_cr_erp(drowsy_correct_trials,1);
%     drowsy_correct_tonecone = selected_tonecone_erp(drowsy_correct_trials,1);
    
    
    
%     EEG = pop_loadset('filename', sprintf('%s_clean_ready_eventcodes_W_2.set', num2str(subjlist(s))), 'filepath', filepath);
    EEG = pop_loadset('filename', sprintf('%s_clean_ready_eventcodes_S_2.set', num2str(subjlist(s))), 'filepath', filepath);
    % EEG = sortchan(EEG);
    % EEG = pop_select(EEG, 'trial', drowsy_correct_trials);
    
    % THIS ASSUMES THAT ALL DATASETS HAVE SAME NUMBER OF ELECTRODES
    chanlocs = EEG.chanlocs;
    
    % baseline correction 
%     bcwin = [-200 0];
%     bcwin = bcwin+(timeshift*1000);
%     EEG = pop_rmbase(EEG,bcwin);
    
%     conddata{s,1} = pop_select(EEG, 'trial', find(abs(drowsy_correct_cr(:,1))>median(abs(drowsy_correct_cr))));
%     conddata{s,2} = pop_select(EEG, 'trial', find(abs(drowsy_correct_cr(:,1))<median(abs(drowsy_correct_cr))));

%     conddata{s,1} = pop_select(EEG, 'trial', find(selected_cr_erp==1)); 
%     conddata{s,2} = pop_select(EEG, 'trial', find(selected_cr_erp==0)); 
    conddata{s,1} = pop_select(EEG, 'trial', find(selected_cr_erp_S==1)); 
    conddata{s,2} = pop_select(EEG, 'trial', find(selected_cr_erp_S==0)); 

%     conddata{s,1} = pop_select(EEG, 'trial', find(selected_cr_erp==1));
    
%% If comparing awake and drowsy

%     EEG = pop_loadset('filename', sprintf('%s_clean_ready_eventcodes_S_2.set', num2str(subjlist(s))), 'filepath', filepath);
%     % EEG = sortchan(EEG);
%     % EEG = pop_select(EEG, 'trial', drowsy_correct_trials);
%     
%     % THIS ASSUMES THAT ALL DATASETS HAVE SAME NUMBER OF ELECTRODES
%     chanlocs = EEG.chanlocs;
%     
%     % baseline correction 
% %     bcwin = [-200 0];
% %     bcwin = bcwin+(timeshift*1000);
% %     EEG = pop_rmbase(EEG,bcwin);
%     
% %     conddata{s,1} = pop_select(EEG, 'trial', find(abs(drowsy_correct_cr(:,1))>median(abs(drowsy_correct_cr))));
% %     conddata{s,2} = pop_select(EEG, 'trial', find(abs(drowsy_correct_cr(:,1))<median(abs(drowsy_correct_cr))));
%     conddata{s,2} = pop_select(EEG, 'trial', find(selected_cr_erp_S==1));

%%%%%%%%%%%%%%%%%%%%%%%%""""""%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% SG: 07/06/22 To randomly permute if uneven No trials /cond ?%%%% my problem is that
%%%% we may need more permutations or some form of stratification ????
        if (strcmp(statmode,'trial') || strcmp(statmode,'cond'))
            if conddata{s,1}.trials > conddata{s,2}.trials
%                 fprintf('Equalising trials in condition %s.\n',subjcond{s,1});
                randtrials = randperm(conddata{s,1}.trials);
                conddata{s,1} = pop_select(conddata{s,1},'trial',randtrials(1:conddata{s,2}.trials));
            elseif conddata{s,2}.trials > conddata{s,1}.trials
%                 fprintf('Equalising trials in condition %s.\n',subjcond{s,2});
                randtrials = randperm(conddata{s,2}.trials);
                conddata{s,2} = pop_select(conddata{s,2},'trial',randtrials(1:conddata{s,1}.trials));
            end
        end
%%%%%%%%%%%%%%%%%%%%%%%%""""""%%%%%%%%%%%%%%%%%%%%%%%%%%        
end



%% prepare for fieldtrip statistical analysis
cfg = [];
cfg.keeptrials = 'no'; %%%%%%originally 'yes'%%%%%%%%%
cfg.feedback = 'textbar';
for s = 1:size(conddata,1)
    for c = 1:size(conddata,2)
        if strcmp(param.testgfp,'on') && (strcmp(statmode, 'cond') || strcmp(statmode,'subj'))
            timelocked_data{s,c} = ft_timelockanalysis(cfg, convertoft(convertogfp(conddata{s,c})));
        else
            ftdata = convertoft(conddata{s,c});
            timelocked_data{s,c} = ft_timelockanalysis(cfg, ftdata);
        end
    end
end

%% perform fieldtrip statistics
cfg = [];
cfg.method = 'montecarlo';       % use the Monte Carlo ('montecarlo')or ('analytic') Method to calculate the significance probability
cfg.correctm = 'cluster';
cfg.clusterstatistic = 'maxsum'; % test statistic that will be evaluated under the permutation distribution.

cfg.tail = param.ttesttail;                    % -1, 1 or 0 (default = 0); one-sided or two-sided test
cfg.clustertail = param.ttesttail;
if param.ttesttail == 0
    cfg.alpha = param.alpha;               % alpha level of the permutation test
else
    cfg.alpha = param.alpha*2;
end
cfg.clusteralpha = param.alpha;         % alpha level of the sample-specific test statistic that will be used for thresholding

cfg.numrandomization = param.numrand;      % number of draws from the permutation distribution

if strcmp(param.testgfp,'off')
    % prepare_neighbours determines what sensors may form clusters
    cfg_neighb.method    = 'distance';
    cfg_neighb.neighbourdist = 4;
    cfg.neighbours       = ft_prepare_neighbours(cfg_neighb,convertoft(conddata{1,1}));
    cfg.minnbchan = 2;               % minimum number of neighborhood channels that is required for a selected

else
    cfg.neighbours = [];
    cfg.minnbchan = 0;               % minimum number of neighborhood channels that is required for a selected
end

if strcmp(statmode,'trial')
    
    %single-subject statistics: we will compare potentially different
    %number of trials in the two conditions for this subject.
    ttesttype = 'indepsamplesT';
    
    design = zeros(1,size(timelocked_data{1}.trial,1) + size(timelocked_data{2}.trial,1));
    design(1,1:size(timelocked_data{1}.trial,1)) = 1;
    design(1,size(timelocked_data{1}.trial,1)+1:end)= 2;
    cfg.ivar  = 1;                   % number or list with indices, independent variable(s)
    
    cond1data = timelocked_data{1};
    cond2data = timelocked_data{2};
    
elseif strcmp(statmode,'cond')
    
    %group statistics: we will perform within-subject comparison of subject
    %averages
    ttesttype = 'depsamplesT';
    
    cfg_ga = [];
    cfg_ga.keepindividual = 'yes';
    cond1data = ft_timelockgrandaverage(cfg_ga, timelocked_data{:,1});
    cond2data = ft_timelockgrandaverage(cfg_ga, timelocked_data{:,2});
    cond1data.avg = squeeze(mean(cond1data.individual,1));
    cond2data.avg = squeeze(mean(cond2data.individual,1));
    
    design = zeros(2,2*numsubj);
    design(1,:) = [ones(1,numsubj) ones(1,numsubj)+1];
    design(2,:) = [1:numsubj 1:numsubj];
    cfg.ivar     = 1;
    cfg.uvar     = 2;
    
elseif strcmp(statmode,'subj')
    
    %group statistics: we will perform across-subject comparison of subject
    %averages
    ttesttype = 'indepsamplesT';
    
    cfg_ga = [];
    cfg_ga.keepindividual = 'yes';
    cond1data = ft_timelockgrandaverage(cfg_ga, timelocked_data{1:numsubj1,1});
    cond2data = ft_timelockgrandaverage(cfg_ga, timelocked_data{numsubj1+1:end,1});
    
    if size(timelocked_data,2) > 1
        cond1sub = ft_timelockgrandaverage(cfg_ga, timelocked_data{1:numsubj1,2});
        cond2sub = ft_timelockgrandaverage(cfg_ga, timelocked_data{numsubj1+1:end,2});
        cond1data.individual = cond1data.individual - cond1sub.individual;
        cond2data.individual = cond2data.individual - cond2sub.individual;
    end
    
    cond1data.avg = squeeze(mean(cond1data.individual,1));
    cond2data.avg = squeeze(mean(cond2data.individual,1));
    
    design = zeros(1,numsubj);
    design(1,1:numsubj1) = 1;
    design(1,numsubj1+1:end)= 2;
    cfg.ivar  = 1;                   % number or list with indices, independent variable(s)
end

if (strcmp(statmode,'cond') || strcmp(statmode,'subj')) && (strcmp(param.testcnv,'on') || strcmp(param.testlat,'on'))
    timeidx = cond1data.time >= latency(1)+timeshift & cond1data.time <= latency(2)+timeshift;
    for ind = 1:size(cond1data.individual,1)
        for chan = 1:length(cond1data.label)
            if strcmp(param.testcnv,'on')
                summinfo = polyfit(cond1data.time(timeidx),squeeze(cond1data.individual(ind,chan,timeidx))',1);
            elseif strcmp(param.testlat,'on')
                summinfo = calclat(cond1data.time(timeidx),squeeze(cond1data.individual(ind,chan,timeidx))',50);
            end
            cond1data.individual(ind,chan,1) = summinfo(1);
        end
    end
    cond1data.time = 0;
    cond1data.individual = cond1data.individual(:,:,1);
    cond1data.avg = squeeze(mean(cond1data.individual,1))';
    
    timeidx = cond2data.time >= latency(1)+timeshift & cond2data.time <= latency(2)+timeshift;
    for ind = 1:size(cond2data.individual,1)
        for chan = 1:length(cond2data.label)
            if strcmp(param.testcnv,'on')
                summinfo = polyfit(cond2data.time(timeidx),squeeze(cond2data.individual(ind,chan,timeidx))',1);
            elseif strcmp(param.testlat,'on')
                summinfo = calclat(cond2data.time(timeidx),squeeze(cond2data.individual(ind,chan,timeidx))',50);
            end
            cond2data.individual(ind,chan,1) = summinfo(1);
        end
    end
    cond2data.time = 0;
    cond2data.individual = cond2data.individual(:,:,1);
    cond2data.avg = squeeze(mean(cond2data.individual,1))';
end

cfg.design = design;             % design matrix
cfg.statistic = ttesttype;

%% BE CAREFUL HERE
% cond2data.avg = cond2data.avg(1:92,1:1101); % adapted to have same number of values in both sessions

diffcond = cond1data;
diffcond.cond1avg = cond1data.avg;
diffcond.cond2avg = cond2data.avg;
diffcond.avg = cond1data.avg - cond2data.avg;


fprintf('\nComparing conditions using %d-tailed %s test\nat alpha of %.2f between %.2f-%.2f sec.\n\n', param.ttesttail, ttesttype, param.alpha, latency);
cfg.latency = latency + timeshift;            % time interval over which the experimental conditions must be compared (in seconds)

cfg.feedback = 'textbar';

[stat] = ft_timelockstatistics(cfg, cond1data, cond2data);
stat.chanlocs = chanlocs;

if strcmp(statmode,'trial')
    save2file = sprintf('%s_%s_%s_%s.mat',subjinfo{1},subjinfo{2},num2str(latency(1)),num2str(latency(2)));
else
    save2file = sprintf('%s_%s_%s-%s.mat',statmode,num2str(subjinfo),condlist{1},condlist{2});
end
stat.cfg = cfg;
stat.condlist = condlist;
stat.diffcond = diffcond;
stat.timeshift = timeshift;
stat.statmode = statmode;
stat.subjinfo = subjinfo;
stat.latency = latency;

[pos_elec, pos_time, neg_elec, neg_time, T0, T1, T2, T3, T4]= SG_timeloc_plotclusters_JS(stat);

stat.pos_elec=pos_elec;
stat.pos_time=pos_time;
stat.neg_elec=neg_elec;
stat.neg_time=neg_time;

stat.T0=T0;
stat.T1=T1;
stat.T2=T2;
stat.T3=T3;
stat.T4=T4;

if nargout == 0
    save(save2file, 'stat');
end

%%%%%%%%%%%%%%%%%%%%%%%%""""""%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% SG: 07/06/22 believe these are not in current use %%%%
%%%%%%%%%%%%%%%%%%%%%%%%""""""%%%%%%%%%%%%%%%%%%%%%%%%%%

% function EEG = convertogfp(EEG)
% 
% EEG.nbchan = 1;
% EEG.trials = 1;
% EEG.chanlocs = EEG.chanlocs(find(strcmp('Cz',{EEG.chanlocs.labels})));
% [~, EEG.data] = evalc('eeg_gfp(mean(EEG.data,3)'')''');

% function estlat = calclat(times,data,pcarea)
% %estlat = sum(abs(data));
% 
% totalarea = sum(abs(data));
% pcarea = totalarea * (pcarea/100);
% 
% curarea = 0;
% for t = 1:length(data)
%     curarea = curarea + abs(data(t));
%     if curarea >= pcarea
%         estlat = times(t);
%         return
%     end
% end
% estlat = times(end);
% end
