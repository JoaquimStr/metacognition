function select_Cates_trials(params,state)
%SELECT_CATES_TRIALS selects the trials we want to keep for further
%analysis. It replaces the prepare_final function. 

server = 1; % 1 = running on server, other = running on laptop

if server == 1
    basefolder = '/home/js2715/';
    scriptfolder = [basefolder, 'metacognition'];
    datafolder = [basefolder, 'rds/rds-tb419-bekinschtein/Yanzhi/EXP_4_Metacognition/'];
    resultfolder = [basefolder, 'rds/rds-tb419-bekinschtein/Joaquim/DATA (see Yanzhis folder)/READY/REPLICATIONCATE/']; % the READY folder is where I save all prepared data
    drowsiness_datafolder = [datafolder, 'Analysis_Micromeasures/iaf']; % TO CHANGE if another measure of drowsiness is picked
    halfway_datafolder = [resultfolder, 'WITHOUT_EVENTS'];
    behav_results_folder = [resultfolder, 'CLEAN_BEHAV'];
    events_folder = [resultfolder, 'EVENTS_COUNTER'];
    finalfolder = resultfolder;
%     lengthfolder = [resultfolder, 'length'];
else
    basefolder = 'C:\Metacognition_Project\';
    scriptfolder = [basefolder, 'SCRIPTS\metacognition'];
    datafolder = [basefolder, 'DATA\'];
    resultfolder = [basefolder, 'RESULTS_LP\FINAL\'];
    drowsiness_datafolder = [datafolder, 'DROWSINESS_DATA'];
    halfway_datafolder = [resultfolder, 'WITHOUT_EVENTS_LP'];
    behav_results_folder = [resultfolder, 'CLEAN_BEHAV_LP'];
    events_folder = [resultfolder, 'EVENTS_COUNTER_LP'];
    finalfolder = resultfolder;
end

subject = params{1,1}; % retrieve the subject's number -- list of subjects available in main() function

addpath(scriptfolder)
addpath(datafolder)


% 1) FIND FILES AND LOAD DATA
cd(datafolder)
indices_awake = load("indices_awake.mat");
indices_drowsy = load("indices_drowsy.mat");
[rej_trials, eeg_file, behav_data] = load_data(subject, state);

% 2) ONLY KEEP SELECTED TRIALS
if strcmp(state, "W")
    behav_data = behav_data(indices_awake(n));
else
    behav_data = behav_data(indices_drowsy(n));
end

% 6) RECODE CONFIDENCE
behav_data = recode_conf(behav_data, state);

% 8) SAVE BEHAVIOURAL DATA
cd(behav_results_folder)
save(strcat(subject, '_behav_ready_', state, '.mat'), 'behav_data');
behav_data = load([subject, '_behav_ready_', state, '.mat']);
behav_data = behav_data.behav_data;

% 9) SAME TRIALS ARE REJECTED FROM THE EEG DATA (to double-check, the initial problem I got was from here)
cd(datafolder) % go back to data folder
align_behav_eeg(behav_data, eeg_file, subject, state, halfway_datafolder);

% 10) CHANGING THE EVENT CODES FOR TONE/CONE
cd(halfway_datafolder) % go where the data is
count_event = modify_events(behav_data, subject, state, finalfolder);

end
