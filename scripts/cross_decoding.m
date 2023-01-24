function cross_decoding(params) 
%% FIRST-LEVEL ANALYSES
% To be ran on server with the outputs from the prepare_data_final_version() function.

% Original script from Johannes Fahrenfort (2018).

% cfg.anti_alias = 'no'; FOR TIMING EFFECTS (see doc)

% cfg.bintrain = to average training events?

%% GENERAL SPECIFICATIONS OF THE EXPERIMENT

% 1) Folders location

server = 1; % 1 = running on server, other = running on laptop

if server == 1
    basefolder = '/home/js2715/';
    datafolder = [basefolder, 'rds/rds-tb419-bekinschtein/Joaquim/DATA (see Yanzhis folder)/READY/merged for cross-decoding'];
    scriptfolder = [basefolder, 'metacognition/'];
    resultfolder = [basefolder, 'rds/rds-tb419-bekinschtein/Joaquim/RESULTS/'];
else
    basefolder = 'C:\Metacognition_Project\';
    datafolder = [basefolder, 'DATA'];
    scriptfolder = [basefolder, 'SCRIPTS'];
    resultfolder = [basefolder, 'RESULTS_LP'];
end

% 2) Find files

cd(datafolder) % go to data folder
% PD_file = [state, '_merged_CLEAN_PD'];
% CF_file = [state, '_merged_CLEAN_CF'];

% PD_file = {dir(sprintf('%s_merged_CLEAN_PD.set',params{1,1}))};
% PD_file = {PD_file{1,1}.name};
% 
% CF_file = {dir(sprintf('%s_merged_CLEAN_CF.set',params{1,1}))};
% CF_file = {CF_file{1,1}.name};

    
cd(scriptfolder); % go to scripts folder

% 3) EVENT CODES SPECIFICATION

% event code specifications for first-level decisions
% tone = 11;
% cone = 12; 

% event code specifications for confidence decisions
% low_confidence = 13;
% high_confidence = 14;

% 4) GENERAL ANALYSIS CONFIGURATION SETTINGS
cfg = [];                                          % clear the config variable 
cfg.datadir = datafolder;                          % this is where the data files are
cfg.model = 'BDM';                                 % backward decoding ('BDM') or forward encoding ('FEM')
cfg.raw_or_tfr = 'raw';                            % classify raw or time frequency representations ('tfr')
cfg.nfolds = 1;                                   % the number of folds to use (TO CHANGE TO 1 IF ACROSS SUBJECTS)
cfg.class_method = 'AUC';             	           % the performance measure to use
cfg.crossclass = 'yes';                            % whether to compute temporal generalization
cfg.channelpool = 'ALL_NOSELECTION';               % the channel selection to use 
cfg.resample = 64;                                 % downsample (useful for temporal generalization)
cfg. save_confidence = 'yes';                      % we save confidence scores for post hoc analyses

% the baseline correction was changed from [-.1,0] to [-.25,0]; this might improve the data:
% cfg.erp_baseline = [-.25,0];                       % baseline correction in sec. ('no' for no correction)

%% SPECIFIC SETTINGS FOR EACH OF THE FOUR FIRST LEVEL ANALYSES

% AWAKE PD VS CF
% cfg.filenames = [PD_file; CF_file];
cfg.filenames = filenames;
class1.train = [11, 12]; class1.test = [13];
class2.train = 13; class2.test = 14;
% class2.train = [22 32 42 52 62 72 82 92 102 112 122 132 142 152 162 172 182 192 202 212 222 232 242 252]; class2.test = 12;
% cfg.class_spec{1} = cond_string(low_confidence);                       % the first stimulus class
% cfg.class_spec{2} = cond_string(high_confidence);                      % the second stimulus class
cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
cfg.outputdir = [resultfolder, 'CROSS-DECODING/AWAKE'];                 % output location
cfg.save_confidence = 'yes';
adam_MVPA_firstlevel(cfg);                                             % run first level analysis

%% The output can now be entered in the second_level script for final decoding analyses.
