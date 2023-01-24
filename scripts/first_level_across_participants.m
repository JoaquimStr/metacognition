function first_level_across_participants(params, response_type)
%% FIRST-LEVEL ANALYSES
% To be ran on server with the outputs from the prepare_data_final_version() function.

% Original script from Johannes Fahrenfort (2018).

% cfg.anti_alias = 'no'; FOR TIMING EFFECTS (see doc)

% cfg.bintrain = to average training events?

% run different conditions in //

%% GENERAL SPECIFICATIONS OF THE EXPERIMENT

% 1) Folders location

server = 1; % 1 = running on server, other = running on laptop

if server == 1
    basefolder = '/home/js2715/';
    datafolder = [basefolder, 'rds/rds-tb419-bekinschtein/Joaquim/DATA (see Yanzhis folder)/READY/new_index/across'];
    scriptfolder = [basefolder, 'metacognition/'];
    resultfolder = [basefolder, 'rds/rds-tb419-bekinschtein/Joaquim/RESULTS/'];
else
    basefolder = 'C:\Metacognition_Project\';
    datafolder = [basefolder, 'DATA\across\merged'];
    scriptfolder = [basefolder, 'SCRIPTS\metacognition'];
    resultfolder = [basefolder, 'RESULTS_LP'];
end

% 2) Find files

if server == 1
    cd(datafolder) % go to data folder
    filenames = {dir(sprintf('*%s*.set',params{1,1}))};
    filenames = {filenames{1,1}.name}; 
%     name = ['eventCodes_', ];
%     filenames = file_list_restrict(filenames, name);     % only awake or drowsy files 
%     drowsy_filenames = file_list_restrict(filenames, 'S');    % only drowsy files

else
    cd(datafolder)
    filenames = {dir(sprintf('*eventCodes*.set'))};
    filenames = {filenames{1,1}.name}; 

%     awake_filenames = file_list_restrict(filenames, 'W');     % only awake files 
%     drowsy_filenames = file_list_restrict(filenames, 'S');    % only drowsy files
end
    
cd(scriptfolder); % go to scripts folder

% 3) EVENT CODES SPECIFICATION
% event code specifications for confidence decisions
low_confidence = [11, 12, 21, 22, 31, 32, 41, 42, 51, 52, 61, 62, 71, 72, 81, 82, 91, 92, 101, 102, ...
    111, 112, 121, 122, 131, 132, 141, 142, 151, 152, 161, 162, 171, 172, 181, 182, 191, 192, 201, 202, ...
    211, 212, 221, 222, 231, 232, 241, 242, 251, 252, 261, 262]; % specifies event codes of low confidence decisions
high_confidence = [13, 14, 23, 24, 33, 34, 43, 44, 53, 54, 63, 64, 73, 74, 83, 84, 93, 94, 103, 104, ...
    113, 114, 123, 124, 133, 134, 143, 144, 153, 154, 163, 164, 173, 174, 183, 184, 193, 194, 203, 204, ...
    213, 214, 223, 224, 233, 234, 243, 244, 253, 254, 263, 264]; % specifies event codes of high confidence decisions

% event code specifications for first-level decisions
tone = [11, 13, 21, 23, 31, 33, 41, 43, 51, 53, 61, 63, 71, 73, 81, 83, 91, 93, 101, 103, ...
    111, 113, 121, 123, 131, 133, 141, 143, 151, 153, 161, 163, 171, 173, 181, 183, 191, 193, 201, 203, ...
    211, 213, 221, 223, 231, 233, 241, 243, 251, 253, 261, 263]; % specifies event codes of tone responses
cone = [12, 14, 22, 24, 32, 34, 42, 44, 52, 54, 62, 64, 72, 74, 82, 84, 92, 94, 102, 104, ...
    112, 114, 122, 124, 132, 134, 142, 144, 152, 154, 162, 164, 172, 174, 182, 184, 192, 194, 202, 204, ...
    212, 214, 222, 224, 232, 234, 242, 244, 252, 254, 262, 264];%  specifies event codes of cone responses

% Event codes per subject:
SUBJ_1 = [11, 12, 13, 14];
SUBJ_2 = [21, 22, 23, 24];
SUBJ_3 = [31, 32, 33, 34];
SUBJ_4 = [41, 42, 43, 44];
SUBJ_5 = [51, 52, 53, 54];
SUBJ_6 = [61, 62, 63, 64];
SUBJ_7 = [71, 72, 73, 74];
SUBJ_8 = [81, 82, 83, 84];
SUBJ_9 = [91, 92, 93, 94];
SUBJ_10 = [101, 102, 103, 104];
SUBJ_11 = [111, 112, 113, 114];
SUBJ_12 = [121, 122, 123, 124];
SUBJ_13 = [131, 132, 133, 134];
SUBJ_14 = [141, 142, 143, 144];
SUBJ_15 = [151, 152, 153, 154];
SUBJ_16 = [161, 162, 163, 164];
SUBJ_17 = [171, 172, 173, 174];
SUBJ_18 = [181, 182, 183, 184];
SUBJ_19 = [191, 192, 193, 194];
SUBJ_20 = [201, 202, 203, 204];
SUBJ_21 = [211, 212, 213, 214];
SUBJ_22 = [221, 222, 223, 224];
SUBJ_23 = [231, 232, 233, 234];
SUBJ_24 = [241, 242, 243, 244];
SUBJ_25 = [251, 252, 253, 254];
SUBJ_26 = [261, 262, 263, 264];

% event codes for motor responses
% up = 15;
% down = 16;

% 4) GENERAL ANALYSIS CONFIGURATION SETTINGS
cfg = [];                                          % clear the config variable 
cfg.datadir = datafolder;                          % this is where the data files are
cfg.model = 'BDM';                                 % backward decoding ('BDM') or forward encoding ('FEM')
cfg.raw_or_tfr = 'raw';                            % classify raw or time frequency representations ('tfr')
cfg.nfolds = 1;                                    % the number of folds to use 
cfg.class_method = 'AUC';             	           % the performance measure to use
cfg.crossclass = 'yes';                            % whether to compute temporal generalization
cfg.balance_events = 'yes';     % for within-class balancing
cfg.balance_classes = 'yes';    % for cross-class balancing
cfg.channelpool = 'ALL_NOSELECTION';               % the channel selection to use 
cfg.resample = 64;                                 % downsample (useful for temporal generalization) % 128 Hz?

% the baseline correction was changed from [-.1,0] to [-.25,0] (in sec.); this might improve the data:
% cfg.erp_baseline = [-.25,0];                       % baseline correction in sec. ('no' for no correction)

%% SPECIFIC SETTINGS FOR EACH OF THE FOUR FIRST LEVEL ANALYSES

if strcmp(response_type, 'CF')
    % LOW VERSUS HIGH CONFIDENCE(AWAKE AND DROWSY in //)
    % class 1 == low confidence
    % class 2 == high confidence
    
    cfg.filenames = filenames;                                  % specifies filenames (awake in this case)
    cfg.outputdir = [resultfolder, 'CF/new_index/across'];               % output location
    
    % % Subject 1 *****************************************************************
    % class1.train = [21 22 31 32]; class1.test = [11 12];
    % class2.train = [23 24 33 34]; class2.test = [13 14];
    % cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    % cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    % adam_MVPA_firstlevel(cfg);
    % % Subject 2 *****************************************************************
    % class1.train = [11 12 31 32]; class1.test = [21 22];
    % class2.train = [13 14 33 34]; class2.test = [23 24];
    % cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    % cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    % adam_MVPA_firstlevel(cfg);
    % % Subject 3 *****************************************************************
    % class1.train = [11 12 21 22]; class1.test = [31 32];
    % class2.train = [13 14 23 24]; class2.test = [33 34];
    % cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    % cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    % adam_MVPA_firstlevel(cfg);


    % Subject 1 *****************************************************************
    class1.train = [21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 121 122 131 132 141 142 151 152 161 162 171 172 181 182 191 192 201 202 211 212 221 222 231 232 241 242 251 252 261 262 271 272 281 282 291 292]; class1.test = [11 12];
    class2.train = [23 24 33 34 43 44 53 54 63 64 73 74 83 84 93 94 103 104 113 114 123 124 133 134 143 144 153 154 163 164 173 174 183 184 193 194 203 204 213 214 223 224 233 234 243 244 253 254 263 264 273 274 283 284 293 294]; class2.test = [13 14];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 2 *****************************************************************
    class1.train = [11 12 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 121 122 131 132 141 142 151 152 161 162 171 172 181 182 191 192 201 202 211 212 221 222 231 232 241 242 251 252 261 262 271 272 281 282 291 292]; class1.test = [21 22];
    class2.train = [13 14 33 34 43 44 53 54 63 64 73 74 83 84 93 94 103 104 113 114 123 124 133 134 143 144 153 154 163 164 173 174 183 184 193 194 203 204 213 214 223 224 233 234 243 244 253 254 263 264 273 274 283 284 293 294]; class2.test = [23 24];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 3 *****************************************************************
    class1.train = [11 12 21 22 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 121 122 131 132 141 142 151 152 161 162 171 172 181 182 191 192 201 202 211 212 221 222 231 232 241 242 251 252 261 262 271 272 281 282 291 292]; class1.test = [31 32];
    class2.train = [13 14 23 24 43 44 53 54 63 64 73 74 83 84 93 94 103 104 113 114 123 124 133 134 143 144 153 154 163 164 173 174 183 184 193 194 203 204 213 214 223 224 233 234 243 244 253 254 263 264 273 274 283 284 293 294]; class2.test = [33 34];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 4 *****************************************************************
    class1.train = [11 12 21 22 31 32 51 52 61 62 71 72 81 82 91 92 101 102 111 112 121 122 131 132 141 142 151 152 161 162 171 172 181 182 191 192 201 202 211 212 221 222 231 232 241 242 251 252 261 262 271 272 281 282 291 292]; class1.test = [41 42];
    class2.train = [13 14 23 24 33 34 53 54 63 64 73 74 83 84 93 94 103 104 113 114 123 124 133 134 143 144 153 154 163 164 173 174 183 184 193 194 203 204 213 214 223 224 233 234 243 244 253 254 263 264 273 274 283 284 293 294]; class2.test = [43 44];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 5 *****************************************************************
    class1.train = [11 12 21 22 31 32 41 42 61 62 71 72 81 82 91 92 101 102 111 112 121 122 131 132 141 142 151 152 161 162 171 172 181 182 191 192 201 202 211 212 221 222 231 232 241 242 251 252 261 262 271 272 281 282 291 292]; class1.test = [51 52];
    class2.train = [13 14 23 24 33 34 43 44 63 64 73 74 83 84 93 94 103 104 113 114 123 124 133 134 143 144 153 154 163 164 173 174 183 184 193 194 203 204 213 214 223 224 233 234 243 244 253 254 263 264 273 274 283 284 293 294]; class2.test = [53 54];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 6 *****************************************************************
    class1.train = [11 12 21 22 31 32 41 42 51 52 71 72 81 82 91 92 101 102 111 112 121 122 131 132 141 142 151 152 161 162 171 172 181 182 191 192 201 202 211 212 221 222 231 232 241 242 251 252 261 262 271 272 281 282 291 292]; class1.test = [61 62];
    class2.train = [13 14 23 24 33 34 43 44 53 54 73 74 83 84 93 94 103 104 113 114 123 124 133 134 143 144 153 154 163 164 173 174 183 184 193 194 203 204 213 214 223 224 233 234 243 244 253 254 263 264 273 274 283 284 293 294]; class2.test = [63 64];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 7 *****************************************************************
    class1.train = [11 12 21 22 31 32 41 42 51 52 61 62 81 82 91 92 101 102 111 112 121 122 131 132 141 142 151 152 161 162 171 172 181 182 191 192 201 202 211 212 221 222 231 232 241 242 251 252 261 262 271 272 281 282 291 292]; class1.test = [71 72];
    class2.train = [13 14 23 24 33 34 43 44 53 54 63 64 83 84 93 94 103 104 113 114 123 124 133 134 143 144 153 154 163 164 173 174 183 184 193 194 203 204 213 214 223 224 233 234 243 244 253 254 263 264 273 274 283 284 293 294]; class2.test = [73 74];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 8 *****************************************************************
    class1.train = [11 12 21 22 31 32 41 42 51 52 61 62 71 72 91 92 101 102 111 112 121 122 131 132 141 142 151 152 161 162 171 172 181 182 191 192 201 202 211 212 221 222 231 232 241 242 251 252 261 262 271 272 281 282 291 292]; class1.test = [81 82];
    class2.train = [13 14 23 24 33 34 43 44 53 54 63 64 73 74 93 94 103 104 113 114 123 124 133 134 143 144 153 154 163 164 173 174 183 184 193 194 203 204 213 214 223 224 233 234 243 244 253 254 263 264 273 274 283 284 293 294]; class2.test = [83 84];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 9 *****************************************************************
    class1.train = [11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 101 102 111 112 121 122 131 132 141 142 151 152 161 162 171 172 181 182 191 192 201 202 211 212 221 222 231 232 241 242 251 252 261 262 271 272 281 282 291 292]; class1.test = [91 92];
    class2.train = [13 14 23 24 33 34 43 44 53 54 63 64 73 74 83 84 103 104 113 114 123 124 133 134 143 144 153 154 163 164 173 174 183 184 193 194 203 204 213 214 223 224 233 234 243 244 253 254 263 264 273 274 283 284 293 294]; class2.test = [93 94];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 10 *****************************************************************
    class1.train = [11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 111 112 121 122 131 132 141 142 151 152 161 162 171 172 181 182 191 192 201 202 211 212 221 222 231 232 241 242 251 252 261 262 271 272 281 282 291 292]; class1.test = [101 102];
    class2.train = [13 14 23 24 33 34 43 44 53 54 63 64 73 74 83 84 93 94 113 114 123 124 133 134 143 144 153 154 163 164 173 174 183 184 193 194 203 204 213 214 223 224 233 234 243 244 253 254 263 264 273 274 283 284 293 294]; class2.test = [103 104];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 11 *****************************************************************
    class1.train = [11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 121 122 131 132 141 142 151 152 161 162 171 172 181 182 191 192 201 202 211 212 221 222 231 232 241 242 251 252 261 262 271 272 281 282 291 292]; class1.test = [111 112];
    class2.train = [13 14 23 24 33 34 43 44 53 54 63 64 73 74 83 84 93 94 103 104 123 124 133 134 143 144 153 154 163 164 173 174 183 184 193 194 203 204 213 214 223 224 233 234 243 244 253 254 263 264 273 274 283 284 293 294]; class2.test = [113 114];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 12 *****************************************************************
    class1.train = [11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 131 132 141 142 151 152 161 162 171 172 181 182 191 192 201 202 211 212 221 222 231 232 241 242 251 252 261 262 271 272 281 282 291 292]; class1.test = [121 122];
    class2.train = [13 14 23 24 33 34 43 44 53 54 63 64 73 74 83 84 93 94 103 104 113 114 133 134 143 144 153 154 163 164 173 174 183 184 193 194 203 204 213 214 223 224 233 234 243 244 253 254 263 264 273 274 283 284 293 294]; class2.test = [123 124];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 13 *****************************************************************
    class1.train = [11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 121 122 141 142 151 152 161 162 171 172 181 182 191 192 201 202 211 212 221 222 231 232 241 242 251 252 261 262 271 272 281 282 291 292]; class1.test = [131 132];
    class2.train = [13 14 23 24 33 34 43 44 53 54 63 64 73 74 83 84 93 94 103 104 113 114 123 124 143 144 153 154 163 164 173 174 183 184 193 194 203 204 213 214 223 224 233 234 243 244 253 254 263 264 273 274 283 284 293 294]; class2.test = [133 134];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 14 *****************************************************************
    class1.train = [11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 121 122 131 132 151 152 161 162 171 172 181 182 191 192 201 202 211 212 221 222 231 232 241 242 251 252 261 262 271 272 281 282 291 292]; class1.test = [141 142];
    class2.train = [13 14 23 24 33 34 43 44 53 54 63 64 73 74 83 84 93 94 103 104 113 114 123 124 133 134 153 154 163 164 173 174 183 184 193 194 203 204 213 214 223 224 233 234 243 244 253 254 263 264 273 274 283 284 293 294]; class2.test = [143 144];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 15 *****************************************************************
    class1.train = [11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 121 122 131 132 141 142 161 162 171 172 181 182 191 192 201 202 211 212 221 222 231 232 241 242 251 252 261 262 271 272 281 282 291 292]; class1.test = [151 152];
    class2.train = [13 14 23 24 33 34 43 44 53 54 63 64 73 74 83 84 93 94 103 104 113 114 123 124 133 134 143 144 163 164 173 174 183 184 193 194 203 204 213 214 223 224 233 234 243 244 253 254 263 264 273 274 283 284 293 294]; class2.test = [153 154];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 16 *****************************************************************
    class1.train = [11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 121 122 131 132 141 142 151 152 171 172 181 182 191 192 201 202 211 212 221 222 231 232 241 242 251 252 261 262 271 272 281 282 291 292]; class1.test = [161 162];
    class2.train = [13 14 23 24 33 34 43 44 53 54 63 64 73 74 83 84 93 94 103 104 113 114 123 124 133 134 143 144 153 154 173 174 183 184 193 194 203 204 213 214 223 224 233 234 243 244 253 254 263 264 273 274 283 284 293 294]; class2.test = [163 164];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 17 *****************************************************************
    class1.train = [11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 121 122 131 132 141 142 151 152 161 162 181 182 191 192 201 202 211 212 221 222 231 232 241 242 251 252 261 262 271 272 281 282 291 292]; class1.test = [171 172];
    class2.train = [13 14 23 24 33 34 43 44 53 54 63 64 73 74 83 84 93 94 103 104 113 114 123 124 133 134 143 144 153 154 163 164 183 184 193 194 203 204 213 214 223 224 233 234 243 244 253 254 263 264 273 274 283 284 293 294]; class2.test = [173 174];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 18 *****************************************************************
    class1.train = [11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 121 122 131 132 141 142 151 152 161 162 171 172 191 192 201 202 211 212 221 222 231 232 241 242 251 252 261 262 271 272 281 282 291 292]; class1.test = [181 182];
    class2.train = [13 14 23 24 33 34 43 44 53 54 63 64 73 74 83 84 93 94 103 104 113 114 123 124 133 134 143 144 153 154 163 164 173 174 193 194 203 204 213 214 223 224 233 234 243 244 253 254 263 264 273 274 283 284 293 294]; class2.test = [183 184];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 19 *****************************************************************
    class1.train = [11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 121 122 131 132 141 142 151 152 161 162 171 172 181 182 201 202 211 212 221 222 231 232 241 242 251 252 261 262 271 272 281 282 291 292]; class1.test = [191 192];
    class2.train = [13 14 23 24 33 34 43 44 53 54 63 64 73 74 83 84 93 94 103 104 113 114 123 124 133 134 143 144 153 154 163 164 173 174 183 184 203 204 213 214 223 224 233 234 243 244 253 254 263 264 273 274 283 284 293 294]; class2.test = [193 194];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 20 *****************************************************************
    class1.train = [11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 121 122 131 132 141 142 151 152 161 162 171 172 181 182 191 192 211 212 221 222 231 232 241 242 251 252 261 262 271 272 281 282 291 292]; class1.test = [201 202];
    class2.train = [13 14 23 24 33 34 43 44 53 54 63 64 73 74 83 84 93 94 103 104 113 114 123 124 133 134 143 144 153 154 163 164 173 174 183 184 193 194 213 214 223 224 233 234 243 244 253 254 263 264 273 274 283 284 293 294]; class2.test = [203 204];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 21 *****************************************************************
    class1.train = [11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 121 122 131 132 141 142 151 152 161 162 171 172 181 182 191 192 201 202 221 222 231 232 241 242 251 252 261 262 271 272 281 282 291 292]; class1.test = [211 212];
    class2.train = [13 14 23 24 33 34 43 44 53 54 63 64 73 74 83 84 93 94 103 104 113 114 123 124 133 134 143 144 153 154 163 164 173 174 183 184 193 194 203 204 223 224 233 234 243 244 253 254 263 264 273 274 283 284 293 294]; class2.test = [213 214];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 22 *****************************************************************
    class1.train = [11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 121 122 131 132 141 142 151 152 161 162 171 172 181 182 191 192 201 202 211 212 231 232 241 242 251 252 261 262 271 272 281 282 291 292]; class1.test = [221 222];
    class2.train = [13 14 23 24 33 34 43 44 53 54 63 64 73 74 83 84 93 94 103 104 113 114 123 124 133 134 143 144 153 154 163 164 173 174 183 184 193 194 203 204 213 214 233 234 243 244 253 254 263 264 273 274 283 284 293 294]; class2.test = [223 224];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 23 *****************************************************************
    class1.train = [11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 121 122 131 132 141 142 151 152 161 162 171 172 181 182 191 192 201 202 211 212 221 222 241 242 251 252 261 262 271 272 281 282 291 292]; class1.test = [231 232];
    class2.train = [13 14 23 24 33 34 43 44 53 54 63 64 73 74 83 84 93 94 103 104 113 114 123 124 133 134 143 144 153 154 163 164 173 174 183 184 193 194 203 204 213 214 223 224 243 244 253 254 263 264 273 274 283 284 293 294]; class2.test = [233 234];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 24 *****************************************************************
    class1.train = [11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 121 122 131 132 141 142 151 152 161 162 171 172 181 182 191 192 201 202 211 212 221 222 231 232 251 252 261 262 271 272 281 282 291 292]; class1.test = [241 242];
    class2.train = [13 14 23 24 33 34 43 44 53 54 63 64 73 74 83 84 93 94 103 104 113 114 123 124 133 134 143 144 153 154 163 164 173 174 183 184 193 194 203 204 213 214 223 224 233 234 253 254 263 264 273 274 283 284 293 294]; class2.test = [243 244];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 25 *****************************************************************
    class1.train = [11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 121 122 131 132 141 142 151 152 161 162 171 172 181 182 191 192 201 202 211 212 221 222 231 232 241 242 261 262 271 272 281 282 291 292]; class1.test = [251 252];
    class2.train = [13 14 23 24 33 34 43 44 53 54 63 64 73 74 83 84 93 94 103 104 113 114 123 124 133 134 143 144 153 154 163 164 173 174 183 184 193 194 203 204 213 214 223 224 233 234 243 244 263 264 273 274 283 284 293 294]; class2.test = [253 254];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 26 *****************************************************************
    class1.train = [11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 121 122 131 132 141 142 151 152 161 162 171 172 181 182 191 192 201 202 211 212 221 222 231 232 241 242 251 252 271 272 281 282 291 292]; class1.test = [261 262];
    class2.train = [13 14 23 24 33 34 43 44 53 54 63 64 73 74 83 84 93 94 103 104 113 114 123 124 133 134 143 144 153 154 163 164 173 174 183 184 193 194 203 204 213 214 223 224 233 234 243 244 253 254 273 274 283 284 293 294]; class2.test = [263 264];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 27 *****************************************************************
    class1.train = [11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 121 122 131 132 141 142 151 152 161 162 171 172 181 182 191 192 201 202 211 212 221 222 231 232 241 242 251 252 261 262 281 282 291 292]; class1.test = [271 272];
    class2.train = [13 14 23 24 33 34 43 44 53 54 63 64 73 74 83 84 93 94 103 104 113 114 123 124 133 134 143 144 153 154 163 164 173 174 183 184 193 194 203 204 213 214 223 224 233 234 243 244 253 254 263 264 283 284 293 294]; class2.test = [273 274];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 28 *****************************************************************
    class1.train = [11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 121 122 131 132 141 142 151 152 161 162 171 172 181 182 191 192 201 202 211 212 221 222 231 232 241 242 251 252 261 262 271 272 291 292]; class1.test = [281 282];
    class2.train = [13 14 23 24 33 34 43 44 53 54 63 64 73 74 83 84 93 94 103 104 113 114 123 124 133 134 143 144 153 154 163 164 173 174 183 184 193 194 203 204 213 214 223 224 233 234 243 244 253 254 263 264 273 274 293 294]; class2.test = [283 284];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 29 *****************************************************************
    class1.train = [11 12 21 22 31 32 41 42 51 52 61 62 71 72 81 82 91 92 101 102 111 112 121 122 131 132 141 142 151 152 161 162 171 172 181 182 191 192 201 202 211 212 221 222 231 232 241 242 251 252 261 262 271 272 281 282]; class1.test = [291 292];
    class2.train = [13 14 23 24 33 34 43 44 53 54 63 64 73 74 83 84 93 94 103 104 113 114 123 124 133 134 143 144 153 154 163 164 173 174 183 184 193 194 203 204 213 214 223 224 233 234 243 244 253 254 263 264 273 274 283 284]; class2.test = [293 294];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
else

    % TONE VERSUS CONE (AWAKE AND DROWSY IN //)
    % class 1 == tone
    % class 2 == cone
    
    cfg.filenames = filenames;                                       % specifies filenames (awake in this case)
    cfg.outputdir = [resultfolder, 'PD/new_index/across'];              % output location
    
    % % Subject 1 *****************************************************************
    % class1.train = [21 23 31 33]; class1.test = [11 13];
    % class2.train = [22 24 32 34]; class2.test = [12 14];
    % cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    % cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    % adam_MVPA_firstlevel(cfg);
    % % Subject 2 *****************************************************************
    % class1.train = [11 13 31 33]; class1.test = [21 23];
    % class2.train = [12 14 32 34]; class2.test = [22 24];
    % cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    % cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    % adam_MVPA_firstlevel(cfg);
    % % Subject 3 *****************************************************************
    % class1.train = [11 13 21 23]; class1.test = [31 33];
    % class2.train = [12 14 22 24]; class2.test = [32 34];
    % cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    % cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    % adam_MVPA_firstlevel(cfg);
    
    
    % Subject 1 *****************************************************************
    class1.train = [21 23 31 33 41 43 51 53 61 63 71 73 81 83 91 93 101 103 111 113 121 123 131 133 141 143 151 153 161 163 171 173 181 183 191 193 201 203 211 213 221 223 231 233 241 243 251 253 261 263 271 273 281 283 291 293]; class1.test = [11 13];
    class2.train = [22 24 32 34 42 44 52 54 62 64 72 74 82 84 92 94 102 104 112 114 122 124 132 134 142 144 152 154 162 164 172 174 182 184 192 194 202 204 212 214 222 224 232 234 242 244 252 254 262 264 272 274 282 284 292 294]; class2.test = [12 14];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 2 *****************************************************************
    class1.train = [11 13 31 33 41 43 51 53 61 63 71 73 81 83 91 93 101 103 111 113 121 123 131 133 141 143 151 153 161 163 171 173 181 183 191 193 201 203 211 213 221 223 231 233 241 243 251 253 261 263 271 273 281 283 291 293]; class1.test = [21 23];
    class2.train = [12 14 32 34 42 44 52 54 62 64 72 74 82 84 92 94 102 104 112 114 122 124 132 134 142 144 152 154 162 164 172 174 182 184 192 194 202 204 212 214 222 224 232 234 242 244 252 254 262 264 272 274 282 284 292 294]; class2.test = [22 24];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 3 *****************************************************************
    class1.train = [11 13 21 23 41 43 51 53 61 63 71 73 81 83 91 93 101 103 111 113 121 123 131 133 141 143 151 153 161 163 171 173 181 183 191 193 201 203 211 213 221 223 231 233 241 243 251 253 261 263 271 273 281 283 291 293]; class1.test = [31 33];
    class2.train = [12 14 22 24 42 44 52 54 62 64 72 74 82 84 92 94 102 104 112 114 122 124 132 134 142 144 152 154 162 164 172 174 182 184 192 194 202 204 212 214 222 224 232 234 242 244 252 254 262 264 272 274 282 284 292 294]; class2.test = [32 34];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 4 *****************************************************************
    class1.train = [11 13 21 23 31 33 51 53 61 63 71 73 81 83 91 93 101 103 111 113 121 123 131 133 141 143 151 153 161 163 171 173 181 183 191 193 201 203 211 213 221 223 231 233 241 243 251 253 261 263 271 273 281 283 291 293]; class1.test = [41 43];
    class2.train = [12 14 22 24 32 34 52 54 62 64 72 74 82 84 92 94 102 104 112 114 122 124 132 134 142 144 152 154 162 164 172 174 182 184 192 194 202 204 212 214 222 224 232 234 242 244 252 254 262 264 272 274 282 284 292 294]; class2.test = [42 44];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 5 *****************************************************************
    class1.train = [11 13 21 23 31 33 41 43 61 63 71 73 81 83 91 93 101 103 111 113 121 123 131 133 141 143 151 153 161 163 171 173 181 183 191 193 201 203 211 213 221 223 231 233 241 243 251 253 261 263 271 273 281 283 291 293]; class1.test = [51 53];
    class2.train = [12 14 22 24 32 34 42 44 62 64 72 74 82 84 92 94 102 104 112 114 122 124 132 134 142 144 152 154 162 164 172 174 182 184 192 194 202 204 212 214 222 224 232 234 242 244 252 254 262 264 272 274 282 284 292 294]; class2.test = [52 54];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 6 *****************************************************************
    class1.train = [11 13 21 23 31 33 41 43 51 53 71 73 81 83 91 93 101 103 111 113 121 123 131 133 141 143 151 153 161 163 171 173 181 183 191 193 201 203 211 213 221 223 231 233 241 243 251 253 261 263 271 273 281 283 291 293]; class1.test = [61 63];
    class2.train = [12 14 22 24 32 34 42 44 52 54 72 74 82 84 92 94 102 104 112 114 122 124 132 134 142 144 152 154 162 164 172 174 182 184 192 194 202 204 212 214 222 224 232 234 242 244 252 254 262 264 272 274 282 284 292 294]; class2.test = [62 64];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 7 *****************************************************************
    class1.train = [11 13 21 23 31 33 41 43 51 53 61 63 81 83 91 93 101 103 111 113 121 123 131 133 141 143 151 153 161 163 171 173 181 183 191 193 201 203 211 213 221 223 231 233 241 243 251 253 261 263 271 273 281 283 291 293]; class1.test = [71 73];
    class2.train = [12 14 22 24 32 34 42 44 52 54 62 64 82 84 92 94 102 104 112 114 122 124 132 134 142 144 152 154 162 164 172 174 182 184 192 194 202 204 212 214 222 224 232 234 242 244 252 254 262 264 272 274 282 284 292 294]; class2.test = [72 74];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 8 *****************************************************************
    class1.train = [11 13 21 23 31 33 41 43 51 53 61 63 71 73 91 93 101 103 111 113 121 123 131 133 141 143 151 153 161 163 171 173 181 183 191 193 201 203 211 213 221 223 231 233 241 243 251 253 261 263 271 273 281 283 291 293]; class1.test = [81 83];
    class2.train = [12 14 22 24 32 34 42 44 52 54 62 64 72 74 92 94 102 104 112 114 122 124 132 134 142 144 152 154 162 164 172 174 182 184 192 194 202 204 212 214 222 224 232 234 242 244 252 254 262 264 272 274 282 284 292 294]; class2.test = [82 84];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 9 *****************************************************************
    class1.train = [11 13 21 23 31 33 41 43 51 53 61 63 71 73 81 83 101 103 111 113 121 123 131 133 141 143 151 153 161 163 171 173 181 183 191 193 201 203 211 213 221 223 231 233 241 243 251 253 261 263 271 273 281 283 291 293]; class1.test = [91 93];
    class2.train = [12 14 22 24 32 34 42 44 52 54 62 64 72 74 82 84 102 104 112 114 122 124 132 134 142 144 152 154 162 164 172 174 182 184 192 194 202 204 212 214 222 224 232 234 242 244 252 254 262 264 272 274 282 284 292 294]; class2.test = [92 94];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 10 *****************************************************************
    class1.train = [11 13 21 23 31 33 41 43 51 53 61 63 71 73 81 83 91 93 111 113 121 123 131 133 141 143 151 153 161 163 171 173 181 183 191 193 201 203 211 213 221 223 231 233 241 243 251 253 261 263 271 273 281 283 291 293]; class1.test = [101 103];
    class2.train = [12 14 22 24 32 34 42 44 52 54 62 64 72 74 82 84 92 94 112 114 122 124 132 134 142 144 152 154 162 164 172 174 182 184 192 194 202 204 212 214 222 224 232 234 242 244 252 254 262 264 272 274 282 284 292 294]; class2.test = [102 104];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 11 *****************************************************************
    class1.train = [11 13 21 23 31 33 41 43 51 53 61 63 71 73 81 83 91 93 101 103 121 123 131 133 141 143 151 153 161 163 171 173 181 183 191 193 201 203 211 213 221 223 231 233 241 243 251 253 261 263 271 273 281 283 291 293]; class1.test = [111 113];
    class2.train = [12 14 22 24 32 34 42 44 52 54 62 64 72 74 82 84 92 94 102 104 122 124 132 134 142 144 152 154 162 164 172 174 182 184 192 194 202 204 212 214 222 224 232 234 242 244 252 254 262 264 272 274 282 284 292 294]; class2.test = [112 114];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 12 *****************************************************************
    class1.train = [11 13 21 23 31 33 41 43 51 53 61 63 71 73 81 83 91 93 101 103 111 113 131 133 141 143 151 153 161 163 171 173 181 183 191 193 201 203 211 213 221 223 231 233 241 243 251 253 261 263 271 273 281 283 291 293]; class1.test = [121 123];
    class2.train = [12 14 22 24 32 34 42 44 52 54 62 64 72 74 82 84 92 94 102 104 112 114 132 134 142 144 152 154 162 164 172 174 182 184 192 194 202 204 212 214 222 224 232 234 242 244 252 254 262 264 272 274 282 284 292 294]; class2.test = [122 124];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 13 *****************************************************************
    class1.train = [11 13 21 23 31 33 41 43 51 53 61 63 71 73 81 83 91 93 101 103 111 113 121 123 141 143 151 153 161 163 171 173 181 183 191 193 201 203 211 213 221 223 231 233 241 243 251 253 261 263 271 273 281 283 291 293]; class1.test = [131 133];
    class2.train = [12 14 22 24 32 34 42 44 52 54 62 64 72 74 82 84 92 94 102 104 112 114 122 124 142 144 152 154 162 164 172 174 182 184 192 194 202 204 212 214 222 224 232 234 242 244 252 254 262 264 272 274 282 284 292 294]; class2.test = [132 134];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 14 *****************************************************************
    class1.train = [11 13 21 23 31 33 41 43 51 53 61 63 71 73 81 83 91 93 101 103 111 113 121 123 131 133 151 153 161 163 171 173 181 183 191 193 201 203 211 213 221 223 231 233 241 243 251 253 261 263 271 273 281 283 291 293]; class1.test = [141 143];
    class2.train = [12 14 22 24 32 34 42 44 52 54 62 64 72 74 82 84 92 94 102 104 112 114 122 124 132 134 152 154 162 164 172 174 182 184 192 194 202 204 212 214 222 224 232 234 242 244 252 254 262 264 272 274 282 284 292 294]; class2.test = [142 144];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 15 *****************************************************************
    class1.train = [11 13 21 23 31 33 41 43 51 53 61 63 71 73 81 83 91 93 101 103 111 113 121 123 131 133 141 143 161 163 171 173 181 183 191 193 201 203 211 213 221 223 231 233 241 243 251 253 261 263 271 273 281 283 291 293]; class1.test = [151 153];
    class2.train = [12 14 22 24 32 34 42 44 52 54 62 64 72 74 82 84 92 94 102 104 112 114 122 124 132 134 142 144 162 164 172 174 182 184 192 194 202 204 212 214 222 224 232 234 242 244 252 254 262 264 272 274 282 284 292 294]; class2.test = [152 154];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 16 *****************************************************************
    class1.train = [11 13 21 23 31 33 41 43 51 53 61 63 71 73 81 83 91 93 101 103 111 113 121 123 131 133 141 143 151 153 171 173 181 183 191 193 201 203 211 213 221 223 231 233 241 243 251 253 261 263 271 273 281 283 291 293]; class1.test = [161 163];
    class2.train = [12 14 22 24 32 34 42 44 52 54 62 64 72 74 82 84 92 94 102 104 112 114 122 124 132 134 142 144 152 154 172 174 182 184 192 194 202 204 212 214 222 224 232 234 242 244 252 254 262 264 272 274 282 284 292 294]; class2.test = [162 164];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 17 *****************************************************************
    class1.train = [11 13 21 23 31 33 41 43 51 53 61 63 71 73 81 83 91 93 101 103 111 113 121 123 131 133 141 143 151 153 161 163 181 183 191 193 201 203 211 213 221 223 231 233 241 243 251 253 261 263 271 273 281 283 291 293]; class1.test = [171 173];
    class2.train = [12 14 22 24 32 34 42 44 52 54 62 64 72 74 82 84 92 94 102 104 112 114 122 124 132 134 142 144 152 154 162 164 182 184 192 194 202 204 212 214 222 224 232 234 242 244 252 254 262 264 272 274 282 284 292 294]; class2.test = [172 174];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 18 *****************************************************************
    class1.train = [11 13 21 23 31 33 41 43 51 53 61 63 71 73 81 83 91 93 101 103 111 113 121 123 131 133 141 143 151 153 161 163 171 173 191 193 201 203 211 213 221 223 231 233 241 243 251 253 261 263 271 273 281 283 291 293]; class1.test = [181 183];
    class2.train = [12 14 22 24 32 34 42 44 52 54 62 64 72 74 82 84 92 94 102 104 112 114 122 124 132 134 142 144 152 154 162 164 172 174 192 194 202 204 212 214 222 224 232 234 242 244 252 254 262 264 272 274 282 284 292 294]; class2.test = [182 184];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 19 *****************************************************************
    class1.train = [11 13 21 23 31 33 41 43 51 53 61 63 71 73 81 83 91 93 101 103 111 113 121 123 131 133 141 143 151 153 161 163 171 173 181 183 201 203 211 213 221 223 231 233 241 243 251 253 261 263 271 273 281 283 291 293]; class1.test = [191 193];
    class2.train = [12 14 22 24 32 34 42 44 52 54 62 64 72 74 82 84 92 94 102 104 112 114 122 124 132 134 142 144 152 154 162 164 172 174 182 184 202 204 212 214 222 224 232 234 242 244 252 254 262 264 272 274 282 284 292 294]; class2.test = [192 194];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 20 *****************************************************************
    class1.train = [11 13 21 23 31 33 41 43 51 53 61 63 71 73 81 83 91 93 101 103 111 113 121 123 131 133 141 143 151 153 161 163 171 173 181 183 191 193 211 213 221 223 231 233 241 243 251 253 261 263 271 273 281 283 291 293]; class1.test = [201 203];
    class2.train = [12 14 22 24 32 34 42 44 52 54 62 64 72 74 82 84 92 94 102 104 112 114 122 124 132 134 142 144 152 154 162 164 172 174 182 184 192 194 212 214 222 224 232 234 242 244 252 254 262 264 272 274 282 284 292 294]; class2.test = [202 204];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 21 *****************************************************************
    class1.train = [11 13 21 23 31 33 41 43 51 53 61 63 71 73 81 83 91 93 101 103 111 113 121 123 131 133 141 143 151 153 161 163 171 173 181 183 191 193 201 203 221 223 231 233 241 243 251 253 261 263 271 273 281 283 291 293]; class1.test = [211 213];
    class2.train = [12 14 22 24 32 34 42 44 52 54 62 64 72 74 82 84 92 94 102 104 112 114 122 124 132 134 142 144 152 154 162 164 172 174 182 184 192 194 202 204 222 224 232 234 242 244 252 254 262 264 272 274 282 284 292 294]; class2.test = [212 214];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 22 *****************************************************************
    class1.train = [11 13 21 23 31 33 41 43 51 53 61 63 71 73 81 83 91 93 101 103 111 113 121 123 131 133 141 143 151 153 161 163 171 173 181 183 191 193 201 203 211 213 231 233 241 243 251 253 261 263 271 273 281 283 291 293]; class1.test = [221 223];
    class2.train = [12 14 22 24 32 34 42 44 52 54 62 64 72 74 82 84 92 94 102 104 112 114 122 124 132 134 142 144 152 154 162 164 172 174 182 184 192 194 202 204 212 214 232 234 242 244 252 254 262 264 272 274 282 284 292 294]; class2.test = [222 224];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 23 *****************************************************************
    class1.train = [11 13 21 23 31 33 41 43 51 53 61 63 71 73 81 83 91 93 101 103 111 113 121 123 131 133 141 143 151 153 161 163 171 173 181 183 191 193 201 203 211 213 221 223 241 243 251 253 261 263 271 273 281 283 291 293]; class1.test = [231 233];
    class2.train = [12 14 22 24 32 34 42 44 52 54 62 64 72 74 82 84 92 94 102 104 112 114 122 124 132 134 142 144 152 154 162 164 172 174 182 184 192 194 202 204 212 214 222 224 242 244 252 254 262 264 272 274 282 284 292 294]; class2.test = [232 234];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 24 *****************************************************************
    class1.train = [11 13 21 23 31 33 41 43 51 53 61 63 71 73 81 83 91 93 101 103 111 113 121 123 131 133 141 143 151 153 161 163 171 173 181 183 191 193 201 203 211 213 221 223 231 233 251 253 261 263 271 273 281 283 291 293]; class1.test = [241 243];
    class2.train = [12 14 22 24 32 34 42 44 52 54 62 64 72 74 82 84 92 94 102 104 112 114 122 124 132 134 142 144 152 154 162 164 172 174 182 184 192 194 202 204 212 214 222 224 232 234 252 254 262 264 272 274 282 284 292 294]; class2.test = [242 244];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 25 *****************************************************************
    class1.train = [11 13 21 23 31 33 41 43 51 53 61 63 71 73 81 83 91 93 101 103 111 113 121 123 131 133 141 143 151 153 161 163 171 173 181 183 191 193 201 203 211 213 221 223 231 233 241 243 261 263 271 273 281 283 291 293]; class1.test = [251 253];
    class2.train = [12 14 22 24 32 34 42 44 52 54 62 64 72 74 82 84 92 94 102 104 112 114 122 124 132 134 142 144 152 154 162 164 172 174 182 184 192 194 202 204 212 214 222 224 232 234 242 244 262 264 272 274 282 284 292 294]; class2.test = [252 254];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 26 *****************************************************************
    class1.train = [11 13 21 23 31 33 41 43 51 53 61 63 71 73 81 83 91 93 101 103 111 113 121 123 131 133 141 143 151 153 161 163 171 173 181 183 191 193 201 203 211 213 221 223 231 233 241 243 251 253 271 273 281 283 291 293]; class1.test = [261 263];
    class2.train = [12 14 22 24 32 34 42 44 52 54 62 64 72 74 82 84 92 94 102 104 112 114 122 124 132 134 142 144 152 154 162 164 172 174 182 184 192 194 202 204 212 214 222 224 232 234 242 244 252 254 272 274 282 284 292 294]; class2.test = [262 264];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 27 *****************************************************************
    class1.train = [11 13 21 23 31 33 41 43 51 53 61 63 71 73 81 83 91 93 101 103 111 113 121 123 131 133 141 143 151 153 161 163 171 173 181 183 191 193 201 203 211 213 221 223 231 233 241 243 251 253 261 263 281 283 291 293]; class1.test = [271 273];
    class2.train = [12 14 22 24 32 34 42 44 52 54 62 64 72 74 82 84 92 94 102 104 112 114 122 124 132 134 142 144 152 154 162 164 172 174 182 184 192 194 202 204 212 214 222 224 232 234 242 244 252 254 262 264 282 284 292 294]; class2.test = [272 274];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 28 *****************************************************************
    class1.train = [11 13 21 23 31 33 41 43 51 53 61 63 71 73 81 83 91 93 101 103 111 113 121 123 131 133 141 143 151 153 161 163 171 173 181 183 191 193 201 203 211 213 221 223 231 233 241 243 251 253 261 263 271 273 291 293]; class1.test = [281 283];
    class2.train = [12 14 22 24 32 34 42 44 52 54 62 64 72 74 82 84 92 94 102 104 112 114 122 124 132 134 142 144 152 154 162 164 172 174 182 184 192 194 202 204 212 214 222 224 232 234 242 244 252 254 262 264 272 274 292 294]; class2.test = [282 284];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
    % Subject 29 *****************************************************************
    class1.train = [11 13 21 23 31 33 41 43 51 53 61 63 71 73 81 83 91 93 101 103 111 113 121 123 131 133 141 143 151 153 161 163 171 173 181 183 191 193 201 203 211 213 221 223 231 233 241 243 251 253 261 263 271 273 281 283]; class1.test = [291 293];
    class2.train = [12 14 22 24 32 34 42 44 52 54 62 64 72 74 82 84 92 94 102 104 112 114 122 124 132 134 142 144 152 154 162 164 172 174 182 184 192 194 202 204 212 214 222 224 232 234 242 244 252 254 262 264 272 274 282 284]; class2.test = [292 294];
    cfg.class_spec{1} = cond_string(class1.train ,';', class1.test);
    cfg.class_spec{2} = cond_string(class2.train ,';', class2.test);
    adam_MVPA_firstlevel(cfg);
end

%% The output can now be entered in the second_level script for final decoding analyses.