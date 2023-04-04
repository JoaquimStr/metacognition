%% Original script from Lanfranco et al. (2021)

%% COMPUTE THE DIAGONAL DECODING RESULTS
cfg = []; 
cfg.startdir = 'C:\Metacognition_Project\NewPreprocessing_ERP_behaviour'; 
cfg.mpcompcor_method = 'cluster_based'; 
% cfg.mpcompcor_method = 'FDR';
cfg.reduce_dims = 'diag'; 
cfg.channelpool = 'ALL_NOSELECTION'; 
cfg.read_confidence = true;
cfg.timelim = [-200 2000]; % to change awake-drowsy to have the same length
mvpa_pd_awake = adam_compute_group_MVPA(cfg);

%% have the drowsy session as long as the awake session (equalize number of time points); 142 time points for drowsy and 141 for wake session
mvpa_pd_drowsy.ClassOverTime(142, :) = [];
mvpa_pd_drowsy.StdError(142, :) = [];
mvpa_pd_drowsy.pVals(142, :) = [];
mvpa_pd_drowsy.pValsUncorrected(:, 142) = [];
mvpa_pd_drowsy.indivClassOverTime(:, 142) = [];

mvpa_cf_drowsy.ClassOverTime(142, :) = [];
mvpa_cf_drowsy.StdError(142, :) = [];
mvpa_cf_drowsy.pVals(142, :) = [];
mvpa_cf_drowsy.pValsUncorrected(:, 142) = [];
mvpa_cf_drowsy.indivClassOverTime(:, 142) = [];

%% PLOT THE DIAGONAL DECODING RESULTS FOR EEG COMPARISONS: EACH COMPARISON
cfg = [];                            
cfg.singleplot = true;       
cfg.acclim = [.45 .80];      
% cfg.channelpool = 'ALL';      
adam_plot_MVPA(cfg, mvpa_pd_awake); % BE CAREFUL: I changed downsamplefactor from adam_plot_MVPA from 1 to 0!!!!!!!!!!!!!!!!!!!

%% save trustworthiness scores for mixed effects model
confscore = mvpa_scores.indivConf;
cd('C:\Metacognition_Project\LME\data')
save('confscore_d', 'confscore')

%% COMPUTE THE TEMPORAL GENERALIZATION MATRIX
cfg = [];                       
cfg.startdir = 'C:\Metacognition_Project\NewPreprocessing_ERP_behaviour'; 
cfg.mpcompcor_method = 'cluster_based'; 
% cfg.mpcompcor_method = 'FDR';
cfg.iterations = 1000;        
% cfg.channelpool = 'ALL_NO_SELECTION';   
cfg.timelim = [-200 1200];
mvpa_pd_tg = adam_compute_group_MVPA(cfg);

%% PLOT THE TEMPORAL GENERALIZATION MATRIX
cfg = [];                            
cfg.singleplot = true;       
cfg.acclim = [.40 .60]; 
adam_plot_MVPA(cfg, mvpa_pd_tg);                    % actual plotting


%% The following sections are not useful for the final cross-decoding analysis

%% COMPUTE GENERALIZATION ACROSS TIME FOR THE EARLY TIME WINDOW FOR PD OR CF (CHECK TIME WINDOW)
% Check early ROI (to be determined with first decoding results).

cfg = [];                                                   % clear the config variable
cfg.startdir = 'C:\Metacognition_Project\RESULTS';          % path to first level results 
cfg.mpcompcor_method = 'cluster_based';                     % multiple comparison correction method (see above)
% cfg.mpcompcor_method = 'FDR';                % multiple comparison correction method (consistency)

% Determine early ROI:
% cfg.trainlim = [300 600]; 
cfg.trainlim = [1000 1500];                                   % specify early interval in the training data

cfg.reduce_dims = 'avtrain';                                % average over that training interval
mvpa_stats_early_awake = adam_compute_group_MVPA(cfg);            % select PD or CF when dialog pops up
% mvpa_stats_early_drowsy = adam_compute_group_MVPA(cfg);           % select PD or CF when dialog pops up

%% PLOT GENERALIZATION ACROSS TIME FOR THE EARLY TIME WINDOW FOR PD OR CF
cfg = [];                                                  % clear the config variable
% cfg.plot_order = {'AWAKE', 'DROWSY'};                    % specify plot order
adam_plot_MVPA(cfg, mvpa_stats_early_awake);                     % actual plotting: AWAKE
% adam_plot_MVPA(cfg, mvpa_stats_early_drowsy);                    % actual plotting: DROWSY

%% PLOT EARLY ACTIVATION PATTERNS FOR PD OR CF (AWAKE AND DROWSY)
% This is exploratory analysis. Time windows will have to be determined
% (literature and Cate's results AND/OR diagonal decoding results).

% Check time windows for which awake > drowsy and vice-versa.

cfg = [];                                    % clear the config variable
% cfg.plot_order = {'AWAKE', 'DROWSY'};        % specify plot order
cfg.mpcompcor_method = 'cluster_based';      % multiple comparison correction method (see above)
cfg.plotweights_or_pattern = 'covpatterns';  % covariance activation pattern
% cfg.weightlim = [-1.2 1.2];                  % set common scale to all plots

% Determine which time window based on temporal generalization pattern:

cfg.timelim = [1000 1500];                     % time window to visualize

adam_plot_BDM_weights(cfg,mvpa_pd_stats);       % actual plotting

%% PLOT LATE ACTIVATION PATTERNS FOR PD OR CF (AWAKE AND DROWSY)
% Exploratory analysis.

cfg = [];                                    % clear the config variable
% cfg.plot_order = {'AWAKE', 'DROWSY'};        % specify plot order
cfg.mpcompcor_method = 'cluster_based';      % multiple comparison correction method (see above)
cfg.plotweights_or_pattern = 'covpatterns';  % covariance activation pattern
% cfg.weightlim = [-1.2 1.2];                  % set common scale to all plots

% DETERMINE WHICH TIME WINDOW AND WHY:
cfg.timelim = [1000 1500];                    % time window to visualize 

adam_plot_BDM_weights(cfg,outstat_conf);       % actual plotting

%% COMPARE PD TO CF STATS
% inside alertness states

cfg = [];                                                                                  % clear the config variable
cfg.mpcompcor_method = 'cluster_based';                                                    % multiple comparison correction method (see above)
% cfg.mpcompcor_method = 'FDR';                % multiple comparison correction method (consistency)
PD_vs_CF_stats = adam_compare_MVPA_stats(cfg,mvpa_PD_stats,mvpa_CF_stats);                 % compute difference PD/CF

%% PLOT THE PD - CF DIFFERENCE
% for both awake and drowsy states

cfg = [];                                         % clear the config variable
% cfg.plot_order = {'PD', 'CF'};                    % specify plot order
adam_plot_MVPA(cfg, PD_vs_CF_stats);              % actual plotting

%% COMPARE PD TO CF STATS
% inside alertness states

cfg = [];                                                                                  % clear the config variable
cfg.mpcompcor_method = 'cluster_based';                                                    % multiple comparison correction method (see above)
% cfg.mpcompcor_method = 'FDR';                % multiple comparison correction method (consistency)
awake_vs_drowsy_stats = adam_compare_MVPA_stats(cfg,mvpa_awake_stats,mvpa_drowsy_stats);                 % compute difference PD/CF

%% PLOT THE PD - CF DIFFERENCE
% for both awake and drowsy states

cfg = [];                                         % clear the config variable
% cfg.plot_order = {'PD', 'CF'};                    % specify plot order
adam_plot_MVPA(cfg, awake_vs_drowsy_stats);              % actual plotting

%% CORRELATE CONFIDENCE SCORES WITH BEHAVIOURAL DATA

cfg = [];  
adam_correlate_CONF_stats(cfg)
