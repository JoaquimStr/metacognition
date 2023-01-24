%% SECOND-LEVEL ANALYSES
% To be ran on a laptop. First-level results need to be retrieved from HPC
% (Joaquim's results folder).

% Original script from Johannes Fahrenfort (2018).
% Check ADAM toolbox documentation for all parameters.

% Here we compare PD or CF across states, but we might also compare PD and CF 
% inside one state (awake or drowsy) -- 2x2 design.

%% COMPUTE THE DIAGONAL DECODING RESULTS FOR PERCEPTUAL DECISIONS (PD: TONE OR CONE) OR CONFIDENCE DECISIONS (CF: HIGH OR LOW) \u2014 AWAKE AND DROWSY TRIALS
% Select PD for the diagonal decoding of tone/cone perceptual decisions and CF for the diagonal decoding of high/low confidence decisions.

cfg = [];                                                   % clear the config variable
cfg.startdir = 'C:\Metacognition_Project\RESULTS_LP';          % path to first level results 

% /!\ MCC = cluster-based at first, then FDR to test consistency:
cfg.mpcompcor_method = 'cluster-based';           % multiple comparison correction method
% cfg.mpcompcor_method = 'FDR';                     % multiple comparison correction method

cfg.timelim = [-200, 2000];                       % select both epochs
% cfg.tail = 'right';                               % we expect positive decoding (increases power) -- not for TG

cfg.reduce_dims = 'diag';                                   % train and test on the same points
mvpa_stats = adam_compute_group_MVPA(cfg);                  % select PD or CF when dialog pops up

%% PLOT THE DIAGONAL DECODING RESULTS FOR PD OR CF (AWAKE AND DROWSY)
cfg = [];                                    % clear the config variable
% cfg.plot_order = {'AWAKE', 'DROWSY'};        % specify plot order
cfg.singleplot = true;                       % all decoding accuracies in a single plot (or not, to change)
cfg.acclim = [.4 .8];                        % change the y-limits of the plot
adam_plot_MVPA(cfg, mvpa_stats);             % actual plotting

%% PLOT SINGLE SUBJECT RESULTS OF PD OR CF (AWAKE AND DROWSY)
% Useful to check what is happening under the hood.

cfg = [];                                                   % clear the config variable
cfg.startdir = 'C:\Metacognition_Project\RESULTS';          % path to first level results 
cfg.reduce_dims = 'diag';                                   % train and test on the same points

% Should we use a low-pass filter? If yes is 11 Hz a good threshold? See Grootswager (2017).
% cfg.splinefreq = 11;                                      % acts as an 11 Hz low-pass filter

cfg.plotsubjects = true;                                    % also plot individual subjects

% run subplots after above analysis to have exactly same analyses
% adam_compute_group_MVPA(cfg);                               % select PD or CF when dialog pops up

%% PLOT EARLY ACTIVATION PATTERNS FOR PD OR CF (AWAKE AND DROWSY)
% This is exploratory analysis. Time windows will have to be determined
% (literature and Cate's results AND/OR diagonal decoding results).

% Check time windows for which awake > drowsy and vice-versa.

cfg = [];                                    % clear the config variable
%cfg.plot_order = {'AWAKE', 'DROWSY'};        % specify plot order
cfg.mpcompcor_method = 'cluster_based';      % multiple comparison correction method (see above)
% cfg.mpcompcor_method = 'FDR';                % multiple comparison correction method (consistency)
cfg.plotweights_or_pattern = 'covpatterns';  % covariance activation pattern
% cfg.weightlim = [-1.2 1.2];                  % set common scale to all plots

% Determine which time window and why:

<<<<<<< HEAD
cfg.timelim = [100 1000];                     % time window to visualize
=======
cfg.timelim = [200 500];                     % time window to visualize
>>>>>>> 43825dfee7190583efa5f294c4238542ff6691d7

adam_plot_BDM_weights(cfg,mvpa_stats);       % actual plotting

%% PLOT LATE ACTIVATION PATTERNS FOR PD OR CF (AWAKE AND DROWSY)
% Exploratory analysis.

cfg = [];                                    % clear the config variable
% cfg.plot_order = {'AWAKE', 'DROWSY'};        % specify plot order
cfg.mpcompcor_method = 'cluster_based';      % multiple comparison correction method (see above)
% cfg.mpcompcor_method = 'FDR';                % multiple comparison correction method (consistency)
cfg.plotweights_or_pattern = 'covpatterns';  % covariance activation pattern
% cfg.weightlim = [-1.2 1.2];                  % set common scale to all plots

% DETERMINE WHICH TIME WINDOW AND WHY:
cfg.timelim = [800 1200];                    % time window to visualize 

adam_plot_BDM_weights(cfg,mvpa_stats);       % actual plotting

%% COMPUTE THE TEMPORAL GENERALIZATION MATRIX FOR PD OR CF
% Main confirmatory analysis.

cfg = [];                                                   % clear the config variable
cfg.startdir = 'C:\Metacognition_Project\RESULTS';          % path to first level results 
cfg.plot_dim = "time_time";                                 % default
cfg.mpcompcor_method = 'cluster-based';                               % multiple comparison correction method (see above)
% cfg.mpcompcor_method = 'FDR';                % multiple comparison correction method (consistency)
% cfg.tail = 'right';                                         % positive decoding

% Determine how many iterations:
cfg.iterations = 1000;                                      % reduce the number of iterations to save time

TG_awake = adam_compute_group_MVPA(cfg);                    % select PD or CF when dialog pops up
% TG_drowsy = adam_compute_group_MVPA(cfg);                   % select PD or CF when dialog pops up

%% PLOT THE TEMPORAL GENERALIZATION MATRIX FOR PD OR CF
cfg = [];                                                  % clear the config variable
% cfg.plot_order = {'AWAKE', 'DROWSY'};                    % specify plot order (here 2 separate plots)
adam_plot_MVPA(cfg, TG_awake);                     % actual plotting: AWAKE
% adam_plot_MVPA(cfg, TG_drowsy);                    % actual plotting: DROWSY

%% COMPUTE GENERALIZATION ACROSS TIME FOR THE EARLY TIME WINDOW FOR PD OR CF (CHECK TIME WINDOW)
% Check early ROI (to be determined with first decoding results).

cfg = [];                                                   % clear the config variable
cfg.startdir = 'C:\Metacognition_Project\RESULTS';          % path to first level results 
cfg.mpcompcor_method = 'cluster_based';                     % multiple comparison correction method (see above)
% cfg.mpcompcor_method = 'FDR';                % multiple comparison correction method (consistency)

% Determine early ROI:
cfg.trainlim = [300 1900];                                   % specify early interval in the training data

cfg.reduce_dims = 'avtrain';                                % average over that training interval
mvpa_stats_early_awake = adam_compute_group_MVPA(cfg);            % select PD or CF when dialog pops up
% mvpa_stats_early_drowsy = adam_compute_group_MVPA(cfg);           % select PD or CF when dialog pops up

%% PLOT GENERALIZATION ACROSS TIME FOR THE EARLY TIME WINDOW FOR PD OR CF
cfg = [];                                                  % clear the config variable
% cfg.plot_order = {'AWAKE', 'DROWSY'};                    % specify plot order
adam_plot_MVPA(cfg, mvpa_stats_early_awake);                     % actual plotting: AWAKE
% adam_plot_MVPA(cfg, mvpa_stats_early_drowsy);                    % actual plotting: DROWSY

%% COMPUTE GENERALIZATION ACROSS TIME FOR THE LATE TIME WINDOW FOR PD OR CF (CHECK TIME WINDOW)
% Check late ROI.

cfg = [];                                                   % clear the config variable
cfg.startdir = 'C:\Metacognition_Project\RESULTS';          % path to first level results 
cfg.mpcompcor_method = 'cluster_based';                     % multiple comparison correction method
% cfg.mpcompcor_method = 'FDR';                % multiple comparison correction method (consistency)

% Determine late ROI:
cfg.trainlim = [-200 2200];                                 % specify late interval in the training data

cfg.reduce_dims = 'avtrain';                                % average over that training interval
mvpa_stats_late_awake = adam_compute_group_MVPA(cfg);            % select PD or CF when dialog pops up
% mvpa_stats_late_drowsy = adam_compute_group_MVPA(cfg);           % select PD or CF when dialog pops up

%% PLOT GENERALIZATION ACROSS TIME FOR THE LATE TIME WINDOW FOR PD OR CF 
cfg = [];                                                  % clear the config variable
% cfg.plot_order = {'AWAKE', 'DROWSY'};                    % specify plot order
adam_plot_MVPA(cfg, mvpa_stats_late_awake);                     % actual plotting: AWAKE
% adam_plot_MVPA(cfg, mvpa_stats_late_drowsy);                    % actual plotting: DROWSY

%% COMPARE AWAKE TO DROWSY STATS FOR PD OR CF
% Not possible because different sizes?
% Maybe try to compare PD and CF inside alertness state instead? (see below)

% cfg = [];                                                                                  % clear the config variable
% cfg.mpcompcor_method = 'cluster_based';                                                    % multiple comparison correction method (see above)
% awake_vs_drowsy_stats = adam_compare_MVPA_stats(cfg,mvpa_awake_stats,mvpa_drowsy_stats);   % compute difference AWAKE/DROWSY

%% PLOT THE AWAKE - DROWSY DIFFERENCE
% Not possible because different sizes?

% cfg = [];                                         % clear the config variable
% cfg.plot_order = {'AWAKE', 'DROWSY'};             % specify plot order
% adam_plot_MVPA(cfg, awake_vs_drowsy_stats);       % actual plotting

%% COMPARE PD TO CF STATS
% inside alertness states

cfg = [];                                                                                  % clear the config variable
cfg.mpcompcor_method = 'cluster_based';                                                    % multiple comparison correction method (see above)
% cfg.mpcompcor_method = 'FDR';                % multiple comparison correction method (consistency)
PD_vs_CF_stats = adam_compare_MVPA_stats(cfg,mvpa_PD_stats,mvpa_CF_stats);                 % compute difference PD/CF

%% PLOT THE PD - CF DIFFERENCE
% for both awake and drowsy states

cfg = [];                                         % clear the config variable
cfg.plot_order = {'PD', 'CF'};                    % specify plot order
adam_plot_MVPA(cfg, PD_vs_CF_stats);              % actual plotting
