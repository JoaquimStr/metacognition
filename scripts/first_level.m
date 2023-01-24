function first_level(params, response_type)
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
    datafolder = [basefolder, 'rds/rds-tb419-bekinschtein/Joaquim/DATA (see Yanzhis folder)/READY/new_index/'];
    scriptfolder = [basefolder, 'metacognition/'];
    resultfolder = [basefolder, 'rds/rds-tb419-bekinschtein/Joaquim/RESULTS/new_index/kfold'];
% elseif server == 2 % motor
%     basefolder = 'C:\Metacognition_Project\';
%     datafolder = [basefolder, 'DATA\motor'];
%     scriptfolder = [basefolder, 'SCRIPTS'];
%     resultfolder = [basefolder, 'RESULTS_LP\motor'];
else
    basefolder = 'C:\Metacognition_Project\';
    datafolder = [basefolder, 'RESULTS_LP\NEW_INDEX'];
    scriptfolder = [basefolder, 'SCRIPTS'];
    resultfolder = datafolder;
end

% 2) Find files

if server == 1
    cd(datafolder) % go to data folder
    filenames = {dir(sprintf('%s*eventCodes*.set',params{1,1}))};
    filenames = {filenames{1,1}.name}; 
    
    awake_filenames = file_list_restrict(filenames, 'W');     % only awake files 
    drowsy_filenames = file_list_restrict(filenames, 'S');    % only drowsy files

else
    cd(datafolder)
    filenames = {dir(sprintf('*eventCodes*.set'))};
    filenames = {filenames{1,1}.name}; 

    awake_filenames = file_list_restrict(filenames, 'W');     % only awake files 
    drowsy_filenames = file_list_restrict(filenames, 'S');    % only drowsy files
end
    
cd(scriptfolder); % go to scripts folder

% 3) EVENT CODES SPECIFICATION
% event code specifications for confidence decisions
low_confidence = [11, 12];               % specifies event codes of low confidence decisions
high_confidence = [13, 14];              % specifies event codes of high confidence decisions

% event code specifications for first-level decisions
tone = [11, 13];                         % specifies event codes of tone responses
cone = [12, 14];                         % specifies event codes of cone responses

% event codes for motor responses
% up = 15;
% down = 16;

% 4) GENERAL ANALYSIS CONFIGURATION SETTINGS
cfg = [];                                          % clear the config variable 
cfg.datadir = datafolder;                          % this is where the data files are
cfg.model = 'BDM';                                 % backward decoding ('BDM') or forward encoding ('FEM')
cfg.raw_or_tfr = 'raw';                            % classify raw or time frequency representations ('tfr')
cfg.nfolds = 10;                                   % the number of folds to use 
cfg.class_method = 'AUC';             	           % the performance measure to use
cfg.crossclass = 'yes';                            % whether to compute temporal generalization
cfg.channelpool = 'ALL_NOSELECTION';               % the channel selection to use 
cfg.resample = 64;                                 % downsample (useful for temporal generalization)

% the baseline correction was changed from [-.1,0] to [-.25,0]; this might improve the data:
% cfg.erp_baseline = [-.25,0];                       % baseline correction in sec. ('no' for no correction)

%% SPECIFIC SETTINGS FOR EACH OF THE FOUR FIRST LEVEL ANALYSES

if strcmp(response_type, 'CF')
    % AWAKE LOW VERSUS HIGH CONFIDENCE
    cfg.filenames = awake_filenames;                                       % specifies filenames (awake in this case)
    cfg.class_spec{1} = cond_string(low_confidence);                       % the first stimulus class
    cfg.class_spec{2} = cond_string(high_confidence);                      % the second stimulus class
    cfg.outputdir = [resultfolder, '/CF/AWAKE/new_index'];               % output location
    adam_MVPA_firstlevel(cfg);                                             % run first level analysis
    
    % DROWSY LOW VERSUS HIGH CONFIDENCE
    cfg.filenames = drowsy_filenames;                                      % specifies filenames (awake in this case)
    cfg.class_spec{1} = cond_string(low_confidence);                       % the first stimulus class
    cfg.class_spec{2} = cond_string(high_confidence);                      % the second stimulus class
    cfg.outputdir = [resultfolder, '/CF/DROWSY/new_index'];              % output location
    adam_MVPA_firstlevel(cfg);                                             % run first level analysis
else
    % AWAKE TONE VERSUS CONE
    cfg.filenames = awake_filenames;                                       % specifies filenames (awake in this case)
    cfg.class_spec{1} = cond_string(tone);                                 % the first stimulus class
    cfg.class_spec{2} = cond_string(cone);                                 % the second stimulus class
    cfg.outputdir = [resultfolder, '/PD/AWAKE/new_index'];               % output location
    adam_MVPA_firstlevel(cfg);                                             % run first level analysis
    
    % DROWSY TONE VERSUS CONE
    cfg.filenames = drowsy_filenames;                                      % specifies filenames (drowsy in this case)
    cfg.class_spec{1} = cond_string(tone);                                 % the first stimulus class
    cfg.class_spec{2} = cond_string(cone);                                 % the second stimulus class
    cfg.outputdir = [resultfolder, '/PD/DROWSY/new_index'];              % output location
    adam_MVPA_firstlevel(cfg);                                             % run first level analysis
end

% % AWAKE UP VERSUS DOWN
% cfg.filenames = awake_filenames;                                       % specifies filenames (awake in this case)
% cfg.class_spec{1} = cond_string(up);                                   % the first stimulus class
% cfg.class_spec{2} = cond_string(down);                                 % the second stimulus class
% cfg.outputdir = [resultfolder, '/PD/AWAKE/easy_only'];                     % output location
% adam_MVPA_firstlevel(cfg);                                             % run first level analysis
% 
% % DROWSY UP VERSUS DOWN
% cfg.filenames = drowsy_filenames;                                      % specifies filenames (drowsy in this case)
% cfg.class_spec{1} = cond_string(up);                                   % the first stimulus class
% cfg.class_spec{2} = cond_string(down);                                 % the second stimulus class
% cfg.outputdir = [resultfolder, '/PD/DROWSY/easy_only'];                    % output location
% adam_MVPA_firstlevel(cfg);                                             % run first level analysis

%% The output can now be entered in the second_level script for final decoding analyses.