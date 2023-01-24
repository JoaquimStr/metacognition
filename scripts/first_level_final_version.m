function first_level_final_version(params, response_type, state) 
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
    datafolder = [basefolder, 'rds/rds-tb419-bekinschtein/Joaquim/DATA (see Yanzhis folder)/READY/REPLICATION_INDICES_CATE2/FOUR/'];
    scriptfolder = [basefolder, 'metacognition/'];
    resultfolder = [basefolder, 'rds/rds-tb419-bekinschtein/Joaquim/RESULTS/REPLICATION_INDICES_CATE2/MY_PARTICIPANTS/DROWSY/'];
else
    basefolder = 'C:\Metacognition_Project\';
    datafolder = [basefolder, 'DATA'];
    scriptfolder = [basefolder, 'SCRIPTS'];
    resultfolder = [basefolder, 'RESULTS_LP'];
end

% 2) Find files

cd(datafolder) % go to data folder
filenames = {dir(sprintf('%s*eventCodes_S*.set',params{1,1}))}; % to change
filenames = {filenames{1,1}.name};

% to restrict/separate files:
% if server == 1
%     cd(datafolder) % go to data folder
%     filenames = {dir(sprintf('%s*eventCodes*.set',params{1,1}))};
%     filenames = {filenames{1,1}.name}; 
%     awake_filenames = file_list_restrict(filenames, 'W');     % only awake files 
%     drowsy_filenames = file_list_restrict(filenames, 'S');    % only drowsy files
% else
%     cd(datafolder)
%     filenames = {dir(sprintf('*eventCodes*.set'))};
%     filenames = {filenames{1,1}.name}; 
%     awake_filenames = file_list_restrict(filenames, 'W');     % only awake files 
%     drowsy_filenames = file_list_restrict(filenames, 'S');    % only drowsy files
% end
    
cd(scriptfolder); % go to scripts folder

% 3) EVENT CODES SPECIFICATION

% event code specifications for first-level decisions
% tone = 11; %[11,13]; % just one event code to maximize decoding power BUT 2 event codes needed when confidence scores (to correlate confidence and perceptual decisions)
% cone = 12; %[12,14]; 

% event code specifications for confidence decisions
low_confidence = 13; %[11,12];
high_confidence = 14; %[13,14];

% event codes for motor responses (sanity check)
% up = 15;
% down = 16;

% 4) GENERAL ANALYSIS CONFIGURATION SETTINGS
cfg = [];                                          % clear the config variable 
cfg.datadir = datafolder;                          % this is where the data files are
cfg.model = 'BDM';                                 % backward decoding ('BDM') or forward encoding ('FEM')
cfg.raw_or_tfr = 'raw';                            % classify raw or time frequency representations ('tfr')
cfg.nfolds = 10;                                   % the number of folds to use (TO CHANGE TO 1 IF ACROSS SUBJECTS)
cfg.class_method = 'AUC';             	           % the performance measure to use
cfg.crossclass = 'yes';                            % whether to compute temporal generalization
cfg.channelpool = 'ALL_NOSELECTION';               % the channel selection to use 

% we might want to use a larger Hz? Ask Andrés or Johannes!!!
cfg.resample = 64;                                % downsample (useful for temporal generalization); initial analysis 64Hz but Cate did 128Hz
cfg. save_confidence = 'yes';                      % we save confidence scores for post hoc analyses

% the baseline correction was changed from [-.1,0] to [-.25,0]; this might improve the data:
cfg.erp_baseline = [-.25,0];                       % baseline correction in sec. ('no' for no correction); see with Cate if baseine correction needed or not in the end

%% SPECIFIC SETTINGS FOR EACH OF THE FOUR FIRST LEVEL ANALYSES

if strcmp(response_type, 'CF') && strcmp(state, 'W')
    % AWAKE LOW VERSUS HIGH CONFIDENCE
%     cfg.filenames = awake_filenames;                                      % specifies filenames (awake in this case)
    cfg.filenames = filenames;
    cfg.class_spec{1} = cond_string(low_confidence);                       % the first stimulus class
    cfg.class_spec{2} = cond_string(high_confidence);                      % the second stimulus class
    cfg.outputdir = resultfolder;                % output location
    cfg.save_confidence = 'yes';
    adam_MVPA_firstlevel(cfg);                                             % run first level analysis
elseif strcmp(response_type, 'CF') && strcmp(state, 'S')
    % DROWSY LOW VERSUS HIGH CONFIDENCE
%     cfg.filenames = drowsy_filenames;                                    % specifies filenames (drowsy in this case)
    cfg.filenames = filenames;
    cfg.class_spec{1} = cond_string(low_confidence);                       % the first stimulus class
    cfg.class_spec{2} = cond_string(high_confidence);                      % the second stimulus class
    cfg.outputdir = resultfolder;                % output location
    cfg.save_confidence = 'yes';
    adam_MVPA_firstlevel(cfg);                                             % run first level analysis
elseif strcmp(response_type, 'PD') && strcmp(state, 'W')
    % AWAKE TONE VERSUS CONE
%     cfg.filenames = awake_filenames;                                      % specifies filenames (awake in this case)
    cfg.filenames = filenames;
    cfg.class_spec{1} = cond_string(tone);                                 % the first stimulus class
    cfg.class_spec{2} = cond_string(cone);                                 % the second stimulus class
    cfg.outputdir = [resultfolder, 'REPLICATION/AWAKE'];                   % output location
    cfg.save_confidence = 'yes';
    adam_MVPA_firstlevel(cfg);                                             % run first level analysis
elseif strcmp(response_type, 'PD') && strcmp(state, 'S')
    % DROWSY TONE VERSUS CONE
%     cfg.filenames = drowsy_filenames;                                     % specifies filenames (drowsy in this case)
    cfg.filenames = filenames;
    cfg.class_spec{1} = cond_string(tone);                                 % the first stimulus class
    cfg.class_spec{2} = cond_string(cone);                                 % the second stimulus class
    cfg.outputdir = [resultfolder, 'REPLICATION/DROWSY'];                  % output location
    cfg.save_confidence = 'yes';
    adam_MVPA_firstlevel(cfg);                                             % run first level analysis
end

%% The output can now be entered in the second_level script for final decoding analyses.
