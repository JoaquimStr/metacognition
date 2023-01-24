%% Original script from Lanfranco et al. (2021)

%% COMPUTE THE DIAGONAL DECODING RESULTS
cfg = []; 
cfg.startdir = 'C:\Metacognition_Project\RESULTS_LP';  
cfg.mpcompcor_method = 'cluster_based'; 
% cfg.mpcompcor_method = 'FDR';
cfg.reduce_dims = 'diag'; 
% cfg.channelpool = 'ALL_NO_SELECTION'; 
cfg.timelim = [-200 2000];
mvpa_stats = adam_compute_group_MVPA(cfg);

%% PLOT THE DIAGONAL DECODING RESULTS FOR EEG COMPARISONS: EACH COMPARISON
cfg = [];                            
cfg.singleplot = true;       
cfg.acclim = [.45 .80];      
cfg.channelpool = 'ALL';      
adam_plot_MVPA(cfg, mvpa_stats);    

%% COMPUTE THE TEMPORAL GENERALIZATION MATRIX
cfg = [];                       
cfg.startdir = 'C:\Metacognition_Project\RESULTS_LP'; 
cfg.mpcompcor_method = 'cluster_based'; 
% cfg.mpcompcor_method = 'FDR';
cfg.iterations = 1000;        
% cfg.channelpool = 'ALL_NO_SELECTION';   
cfg.timelim = [-200 4000];
mvpa_eeg_stats = adam_compute_group_MVPA(cfg);

%%
adam_plot_MVPA(cfg, mvpa_eeg_stats);                    % actual plotting: DROWSY