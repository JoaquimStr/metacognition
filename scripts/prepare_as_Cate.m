function prepare_as_Cate(params, state)

% 0) ASSIGN FOLDERS

server = 1; % 1 = running on server, other = running on laptop

if server == 1
    basefolder = '/home/js2715/';
    scriptfolder = [basefolder, 'metacognition'];
    datafolder = [basefolder, 'rds/rds-tb419-bekinschtein/Yanzhi/EXP_4_Metacognition/'];
    resultfolder = [basefolder, 'rds/rds-tb419-bekinschtein/Joaquim/DATA (see Yanzhis folder)/READY/POST/'];
    drowsiness_datafolder = [datafolder, 'Analysis_Micromeasures/iaf']; % TO CHANGE if another measure of drowsiness is picked
    halfway_datafolder = [resultfolder, 'WITHOUT_EVENTS'];
    behav_results_folder = [resultfolder, 'CLEAN_BEHAV'];
    events_folder = [resultfolder, 'EVENTS_COUNTER'];
    finalfolder = [resultfolder, 'CF/DROWSY'];
else
    basefolder = 'C:\Metacognition_Project\';
    scriptfolder = [basefolder, 'SCRIPTS\metacognition'];
    datafolder = [basefolder, 'DATA\'];
    resultfolder = [basefolder, 'RESULTS_LP\as_Cate\'];
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
[rej_trials, eeg_file, behav_data] = load_data(subject, state);

% 2) REJECT BEHAVIOURAL TRIALS BASED ON REJECTED EEG DATA AND RENAME
% TRIALS TO HAVE IDENTICAL INDEXING BEHAVIOUR-EEG
behav_data = reject_EEG(subject, state, behav_data, rej_trials);

%% IF DROWSY SESSION

% 3) ASSESS DROWSINESS
if strcmp(state, 'S')
    cd(drowsiness_datafolder) % go to where the drowsiness data is
    behav_data = assess_drowsy(subject, behav_data);
end

% 4) REJECT LOW DROWSINESS TRIALS
if strcmp(state, 'S')
    cd(drowsiness_datafolder)
    behav_data = reject_drowsy(subject, behav_data);
end

%%

% 3) REJECT INCORRECT TRIALS
behav_data = reject_incorrect(behav_data);

% 3BIS) REJECT TYPE II INCORRECT TRIALS!

% 4) REJECT TRIALS TOO LOW RT AND OUTLIERS
behav_data = reject_RT(behav_data);

% 5) REJECT DIFFICULT TRIALS 
% behav_data = easy_only(behav_data);

% 6) RECODE CONFIDENCE
behav_data = recode_conf(behav_data, state);

% 7) SAVE BEHAVIOURAL DATA
cd(behav_results_folder)
save(strcat(subject, '_behav_ready_', state, '.mat'), 'behav_data');

% 8) SAME TRIALS ARE REJECTED FROM THE EEG DATA
cd(datafolder) % go back to data folder
align_behav_eeg(behav_data, eeg_file, subject, state, halfway_datafolder);

% 9) CHANGING THE EVENT CODES FOR TONE/CONE
cd(halfway_datafolder) % go where the data is
count_event = modify_events(behav_data, subject, state, finalfolder);

% 10) SAVE NUMBER OF EVENTS (EXCLUDE PARTICIPANTS LESS THAN 20 TRIALS/CLASS)
cd(events_folder)
save(strcat(subject, '_event_counter_', state, '.mat'), 'count_event'); % save behavioural data after rejections and addition columns

end
