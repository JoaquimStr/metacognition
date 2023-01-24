function main(task_id) 

%%MAIN Entry point of Matlab SLURM job

% Starts up toolboxes, selects files to analyse, loads them, and saves the
% results.

% Original function from Pedro Mediano, February 2021

%% Step 0: start up toolboxes
startup

% toolfolder = '/home/js2715/tools';
% Hmeta_path = [toolfolder, '/HMeta-d-master'];
% genpath(Hmeta_path)

%% Step 1: define parameter settings
% Selection based on the results from Yanzhi = 34 participants.

% Participants 125, 127, and 137 were excluded based on confidence scores
% distribution.

% Behavioural data was missing for five participants: 115, 122, 124, 130, and 143.

% Some EEG files are not "clean": 142, 144, etc.

% Some participants were rejected to align with Cate's analysis: 102, 106,
% 126, 142, and 144 \u2014 it was probably excluded in the first place because
% the EEG data was not usable (e.g., participants 142 and 144).

% The number of trials per class was checked and all selected participants
% had at lead 20 trials in each class... Checking if enough drowsy trials!
% Note: 
% - p111 has only 16 events (cone) in the drowsy session.
% - p128 has only 13 events (tone) in drowsy session.
% ... and for confidence:
% - p111 = 20 low confidence and 21 high confidence (still drowsy session)
% - p128 has only 17 trials in low confidence class 
% ...exclusion of participants 111 and 128 and analysis with 23
% participants?

% 26 subjects were finally selected!! 124, 130, 143 + see 102, 106

% subjects   = {'102', '105', '106', '107', '108', '109', '112', '113', '114', '116', '119', ...
%     '120', '121', '123', '124', '129', '130',  '131', '132', '133', '134', '135', ...
%     '136', '139', '140', '143', '145', '146'};

subjects   = {'105', '107', '108', '109', '112', '113', '114', '116', '119', ...
    '120', '121', '123', '129', '131', '132', '133', '134', '135', '136', ...
     '139', '140', '145', '146'}; 

%% Cate's replication:

% subjects   = {'105', '107', '108', '109', '111', '112', '113', '116', '119', ...
%     '120', '121', '123', '124', '125', '128', '130', '131', '132', '133', '135', '137', ...
%      '139', '143', '145', '146'}; 

% subjects = {'105','107','108','109','111','112','113','116','119','120','121','123','124','125','128','130','131','132','133','135','137','139','143','145','146'};

% /!\ Beware: number of trials not corresponding EEG/behaviour for subjects 108 and 113.

%% Step 2: Fetch task_id from command-line

% To change manually for first-level analysis:

% across = 'on';
across = 'off';

states = {'W', 'S'};

if strcmp(across, 'off')
    params = subjects(task_id);
else
    params = states(task_id);
end

%% Step 3: Select condition (state and response type)

% To change manually:

% response_type = 'PD';
response_type = 'CF';

% state = 'W'; 
state = 'S';

%% Step 4: Prepare the data (kfold)
% prepare_final_version(params, state); % To comment if unused

% OR

%% REPLICATION
% % folders
% basefolder = '/home/js2715/';
% scriptfolder = [basefolder, 'metacognition'];
% datafolder = [basefolder, 'rds/rds-tb419-bekinschtein/Yanzhi/EXP_4_Metacognition/'];
% resultfolder = [basefolder, 'rds/rds-tb419-bekinschtein/Joaquim/DATA (see Yanzhis folder)/READY/REPLICATION_INDICES_CATE2/TWO']; % the READY folder is where I save all prepared data
% halfway_datafolder = [resultfolder, 'WITHOUT_EVENTS'];
% behav_results_folder = [resultfolder, 'CLEAN_BEHAV'];
% finalfolder = resultfolder;
% 
% step1 = [resultfolder, '1)indices'];
% step2 = [resultfolder, '2)conf'];
% step3 = [resultfolder, '3)eeg'];
% step4 = [resultfolder, '4)events'];
% 
% addpath(scriptfolder)
% addpath(datafolder)
% 
% % indices
% indices_awake = load("indices_awake.mat");
% indices_drowsy = load("indices_drowsy.mat");
% indices_awake = indices_awake.indices_awake;
% indices_drowsy = indices_drowsy.indices_drowsy;
% 
% % 1) select data
% for n = 1:25
%     subject = subjects{n};
%     behav_data = load(strcat('behavioural_datamat_p', subjects{n}, '.mat'));
% %     if isfile(strcat(state, subjects{n}, '_clean.set'))  
%         eeg_file= strcat(state, subjects{n}, '_clean.set'); 
% %     else
% %         eeg_file= strcat(state, subjects{n}, '_epochs.set'); 
% %     end
%     if strcmp(state, "W")
%         behav_data = behav_data.datamat_all_session1; % for awake session
%         behav_data = behav_data(indices_awake{n}', :);
%         cd(step1)
%         save(strcat(subjects{n}, '_behav_indiced_', state, '.mat'), 'behav_data');
%     else
%         behav_data = behav_data.datamat_all_session2; % for drowsy session
%         behav_data = behav_data(indices_drowsy{n}', :);
%         cd(step1)
%         save(strcat(subjects{n}, '_behav_indiced_', state, '.mat'), 'behav_data');
%     end
%     % 2) recode confidence (1:high or 0:low)
%     behav_data = recode_conf(behav_data, state);
%     cd(step2)
%     save(strcat(subjects{n}, '_behav_ready_', state, '.mat'), 'behav_data');
%     behav_data = load([subjects{n}, '_behav_ready_', state, '.mat']);
%     behav_data = behav_data.behav_data;
%     % 3) select corresponding eeg data
%     align_behav_eeg(behav_data, eeg_file, subject, state, step3, datafolder);
%     % 4) modify events
%     modify_events(behav_data, subject, state, step4, halfway_datafolder);
% end


% select_Cates_trials(params, state, position); % add position for indices


%% Additional preparation for some specific analyses
% prepare_type2(params, state); % To comment if unused

% equalize_nb_trials(response_type)

%% Step 5: Run the first-level analyses (kfold)
% load the two datasets 
% first_level_final_version(params, response_type, state); % To comment if unused

%% OR

%% Step 4: Prepare the data (across participants)
% prepare_across_final_version(params, state, task_id) % To comment if unused.

%% Step 5: Merge datasets for cross-decoding
% merge_datasets(params) % To comment if unused.

%% Step 6: Cross-decoding across participants
% first_level_across_final_version(params, response_type) % To comment if unused.

%% AND...

%% Step 7: Calculate meta-d'
% Hmeta(params, state)

%% Step 8: Cross-decoding
cut_data(params, response_type, state)

% cross_decoding2(params, response_type, state)

% mean_step(params)

end
