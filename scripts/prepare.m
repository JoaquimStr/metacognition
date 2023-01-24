function prepare(params, task_id)
% The prepare_data_final_version function was transformed into a group of sub-functions:
% This function is called by the main() function. It prepares inputs before
% running first and second-level analyses (Fahrenfort's ADAM toolbox).

% This function call 10 sub-functions:
% (a) load_data(), which loads the different data files one wants to work with
% (b) reject_EEG(), which rejects trials with noisy EEG data
% (c) assess_drowsy(), which creates a new column with drowsiness evaluation (based on micromeasures algorithm)
% (d) reject_drowsy(), which rejects low drowsiness trials
% (e) reject_incorrect(), which rejects incorrect trials (Type I incorrectness)
% (f) reject_RT(), which rejects trials < .2 sec and outliers (3 SD)
% (g) recode_conf(), which categorises confidence scores as "high" or "low"
% (h) easy_only(), if one wants to only keep easy trials
% (i) align_behav_eeg(), which align EEG data with behavioural data
% (j) modify_events(), which modifies the event codes based on subjects Type I and Type II responses
% (h) modify_events_across(), which modifies the event codes PER PARTICIPANT (cross-decoding) -- pick either j or h

% DROWSINESS and CONFIDENCE categorisation must be adapted, depending on the
% criteria one decides to pick.

% The function can be ran on HPC or on a laptop - see run_main_on_laptop() function.

% 0) To be ran on HPC server or laptop:
% Assign the different folders the function will need.

server = 1; % 1 = running on server, other = running on laptop

if server == 1
    basefolder = '/home/js2715/';
    scriptfolder = [basefolder, 'metacognition'];
    datafolder = [basefolder, 'rds/rds-tb419-bekinschtein/Yanzhi/EXP_4_Metacognition/'];
    resultfolder = [basefolder, 'rds/rds-tb419-bekinschtein/Joaquim/DATA (see Yanzhis folder)/READY/new_index/across/'];
    drowsiness_datafolder = [datafolder, 'Analysis_Micromeasures/iaf']; % TO CHANGE if another measure of drowsiness is picked
    halfway_datafolder = [resultfolder, 'WITHOUT_EVENTS'];
    behav_results_folder = [resultfolder, 'CLEAN_BEHAV'];
    events_folder = [resultfolder, 'EVENTS_COUNTER'];
else
    basefolder = 'C:\Metacognition_Project\';
    scriptfolder = [basefolder, 'SCRIPTS\metacognition'];
    datafolder = [basefolder, 'DATA\'];
    resultfolder = [basefolder, 'RESULTS_LP\NEW_INDEX\'];
    drowsiness_datafolder = [datafolder, 'DROWSINESS_DATA'];
    halfway_datafolder = [resultfolder, 'WITHOUT_EVENTS_LP'];
    behav_results_folder = [resultfolder, 'CLEAN_BEHAV_LP'];
    events_folder = [resultfolder, 'EVENTS_COUNTER_LP'];
end

alertness = {'W', 'S'}; % there are two alertness states
subject = params{1,1}; % retrieve the subject's number -- list of subjects available in main() function

addpath(scriptfolder)
addpath(datafolder)

for n = 1:2 % loop across alertness states
    state = alertness{n};
    cd(datafolder)

    % 1) FIND FILES AND LOAD DATA
    [rej_trials, eeg_file, behav_data] = load_data(subject, state);

    % 2) REJECT BEHAVIOURAL TRIALS BASED ON REJECTED EEG DATA AND RENAME
    % TRIALS TO HAVE IDENTICAL INDEXING BEHAVIOUR-EEG
    behav_data = reject_EEG(subject, state, behav_data, rej_trials);

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

    % 5) REJECT INCORRECT TRIALS
    cd(datafolder)
    behav_data = reject_incorrect(behav_data);

    % 6) REJECT TRIALS TOO LOW RT AND OUTLIERS
    behav_data = reject_RT(behav_data);

    % 7) RECODE CONFIDENCE
    behav_data = recode_conf(behav_data, state);

    % 8) REJECT DIFFICULT TRIALS 
    % behav_data = easy_only(behav_data);

    % 9) SAVE BEHAVIOURAL DATA
    cd(behav_results_folder)
    save(strcat(subject, '_behav_ready_', state, '.mat'), 'behav_data');

    % 10) SAME TRIALS ARE REJECTED FROM THE EEG DATA
    cd(datafolder) % go back to data folder
    eeg_file = align_behav_eeg(behav_data, eeg_file, subject, state, halfway_datafolder);

    % 11) CHANGING THE EVENT CODES FOR CONFIDENCE AND TONE/CONE (AND SAVE FINAL EEG FILES)
    cd(halfway_datafolder) % go where the data is
    % count_event = modify_events(eeg_file, behav_data, subject, state, resultfolder);
    count_event = modify_events_across(task_id, eeg_file, behav_data, subject, state, resultfolder); % if cross-decoding

    % 12) SAVE NUMBER OF EVENTS
    cd(events_folder)
    save(strcat(subject, '_event_counter_', state, '.mat'), 'count_event'); % save behavioural data after rejections and addition columns
end
% The outputs can now be entered in the first_level() function for decoding analyses.
end