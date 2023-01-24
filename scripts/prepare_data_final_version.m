function prepare_data_final_version(params)
%% The prepare_data script was transformed into a function to be ran on HPC:
% This function is called by the main() function. It prepares inputs before 
% running first and second-level analyses (Fahrenfort's ADAM toolbox).

% This function has three main roles: (1) coding drowsiness and confidence, 
% (2) rejecting trials and/or participants, and (3) modifying/inserting event codes. 

% DROWSINESS and CONFIDENCE categorisation must be adapted, depending on the 
% criteria one decides to pick.

% The function can be ran on HPC or on a laptop - see run_main_on_laptop() function.

% The function could be subdivided in multiple functions (e.g., one per 'chapter').

%% 0) To be ran on HPC server or laptop:
% Assign the different folders the function will need.

server = 1; % 1 = running on server, other = running on laptop

if server == 1
    basefolder = '/home/js2715/';
    datafolder = [basefolder, 'rds/rds-tb419-bekinschtein/Yanzhi/EXP_4_Metacognition/'];
    resultfolder = [basefolder, 'rds/rds-tb419-bekinschtein/Joaquim/DATA (see Yanzhis folder)/READY/only_easy/'];
    drowsiness_datafolder = [datafolder, 'Analysis_Micromeasures/iaf']; % TO CHANGE if another measure of drowsiness is picked
    halfway_datafolder = [resultfolder, 'WITHOUT_EVENTS'];
    behav_results_folder = [resultfolder, 'CLEAN_BEHAV'];
    events_folder_W = [resultfolder, 'EVENTS_COUNTER/AWAKE'];
    events_folder_S = [resultfolder, 'EVENTS_COUNTER/DROWSY'];
else
    basefolder = 'C:\Metacognition_Project\';
    datafolder = [basefolder, 'DATA\'];
    resultfolder = [basefolder, 'RESULTS_LP\EASY_ONLY\'];
    drowsiness_datafolder = [datafolder, 'DROWSINESS_DATA'];
    halfway_datafolder = [resultfolder, 'WITHOUT_EVENTS_LP'];
    behav_results_folder = [resultfolder, 'CLEAN_BEHAV_LP'];
    events_folder_W = [resultfolder, 'EVENTS_COUNTER_LP\AWAKE'];
    events_folder_S = [resultfolder, 'EVENTS_COUNTER_LP\DROWSY'];
end


%% 1) Find files and load data
cd(datafolder) % go to data folder
subject = params{1,1}; % retrieve the subject's number -- list of subjects available in main() function

% 1.1. Rejected trials, if there is a rejected file (sometimes missing because EEG data is OK, i.e., no noisy channels):
if isfile(strcat('Rejected_', subject, '.xlsx'))
    rej_filenames = strcat('Rejected_', subject, '.xlsx');
    rej_trials_w = xlsread(char(rej_filenames), strcat('W', subject, 'Trials'),'a2:a160'); % for awake session
    rej_trials_s = xlsread(char(rej_filenames), strcat('S', subject, 'Trials'),'a2:a480'); % for drowsy session
end

% 1.2. EEG data, we want 'clean' datasets but sometimes only 'epochs' available:
if isfile(strcat('W',subject, '_clean.set')) && isfile(strcat('S',subject, '_clean.set')) 
    eeg_file_w= strcat('W',subject, '_clean.set'); % assign eeg file awake session
    eeg_file_s= strcat('S',subject, '_clean.set'); % assign eeg file drowsy session
else
    eeg_file_w= strcat('W',subject, '_epochs.set'); % assign eeg file awake session /!\ is it a problem to have them 'only' epoched?
    eeg_file_s= strcat('S',subject, '_epochs.set'); % assign eeg file drowsy session
end

% 1.3. Behavioural data:
behav_data = load(strcat('behavioural_datamat_p', subject, '.mat'));
behav_data_w = behav_data.datamat_all_session1; % for awake session
behav_data_s = behav_data.datamat_all_session2; % for drowsy session

%% Adapt rejection data from subjects 108:
% /!\ BEWARE: 497 trials instead of 480. 
% EEG and drowsiness data == 474 trials (see also rejection of 15 first trials below).
if strcmp(subject, '108')
     rej_trials_s(1:21, :) = rej_trials_s(1:21, :) - 17; 
end

%% 2) REJECT BEHAVIOURAL TRIALS BASED ON REJECTED EEG DATA...
% ... if there is a file with rejected trials.
if isfile(strcat('Rejected_', subject, '.xlsx'))
    behav_data_w(rej_trials_w, :) = []; % for awake session
    behav_data_s(rej_trials_s, :) = []; % for drowsy session
end

%% Adapt behavioural data from subjects 113:
% For some trials, EEG data is missing.
if strcmp(subject, '113') % trials 190 and 208 do not have EEG data (30 and 48 in drowsy session) -- mismatch with drowsiness data.
    behav_data_s(30, :) = [];
    behav_data_s(48, :) = [];
end

%% 3) ASSESS DROWSINESS 
% The drowsiness categorisation method can be changed here. For now only categories 
% from the micromeasures algorithm are used.

% In the end, we'll probably just used micromeasures and refer to Yanzhi's
% work, as the results are very consistent across the 4 methods.

% 3.1. LOAD DATA:
method = {'_for_micromeasures_output_iaf', 'thetaalpha', 'rt', 'misses'}; % different categorization methods
method_subfolder = {'stages_clean', 'thetaalpha_ratio'}; % subfolder (missing for rt and misses)
method_number = 1; % change method here
cd(drowsiness_datafolder) % go to where the drowsiness data is
drowsiness_data = load(strcat('s', subject, method{method_number}, '.mat')); % load the corresponding file

if method_number == 1 % TO CHANGE depending on categorisation method
    stages = method_subfolder{1}; % fetch data subfolder
    drowsiness = drowsiness_data.(stages); % variable with level of drowsiness for each trial
% elseif method_number == 2
%     stages = method_subfolder{2}; % fetch data subfolder
%     drowsiness = drowsiness_data.(stages); % variable with level of drowsiness for each trial 
% elseif method_number == 3
%     drowsiness = drowsiness_data(:, 11); % take only trials from drowsy session
%     index_lowdrowsy = drowsiness < 2.5;
%     lowtrials = drowsiness(index_lowdrowsy, 11); % Use indexing and exclude 160 trials from awake session
% elseif method_number == 4
%     drowsiness = drowsiness_data(:, 11);
else
    error('Please enter a method number between 1 and 4!')
end

% Adapt drowsiness data for subject 108.
if strcmp(subject, '108') 
    drowsiness(1:15) = [];  % the first 15 trials do not have behavioural data
end

behav_data_s(:, 13) = drowsiness'; % insert drowsiness column (13), varies with method picked

% 3.2. REJECT BEHAVIOURAL TRIAL LOW DROWSINESS
index_lowdrowsy = zeros(length(behav_data_s(:,1)), 1); % preallocation index variable
count_drowsy = 1; % count initiation

% only micromeasures algorithm is used here:
for trial = 1:length(behav_data_s(:,1))
%     if method_number == 2
%         if behav_data_s(trial, 13) < 0.5 % ask Yanzhi for advice: which alpha-theta ratio to pick
%             index_lowdrowsy(count_drowsy) = trial; % add index low drowsiness trials (to exclude)
%             count_drowsy = count_drowsy +1; % add 1 to the counter
%         end
%     else

% micromeasures: 1 = relaxed; 2 = mild drowsiness; 3 = severe drowsiness
        if behav_data_s(trial, 13) == 1 % we exclude relaxed trials
            index_lowdrowsy(count_drowsy) = trial; % add index low drowsiness trials (to exclude)
            count_drowsy = count_drowsy +1; % add 1 to the counter
        end
%     end
end
behav_data_s(index_lowdrowsy(1:count_drowsy-1), :) = []; % exclude trials with too low drowsiness

% Manually exclude participants with a too low number of drowsy trials:
if length(behav_data_s(:,1)) < 50 % how many drowsy trials do we want as a minimum? 
    error('Participant %s must be excluded because there are only %d drowsy trials!', subject, length(behav_data_s(:,1)))
end

%% 4) REJECT INCORRECT TRIALS 
% We want to keep only correct trials for decoding analyses.
% We might change this later, as Type I incorrect trials do not equate Type
% II incorrect trials.
% (e.g., focusing decoding on confidence and keeping Type I incorrect trials -- which
% are Type II correct trials).

% 4.1. AWAKE SESSION:
index_incorrect_w = behav_data_w(:,1)'; % preallocate index vector
position_incorrect_w = 1; % initialize position marker
for trial = 1:length(behav_data_w(:,1))
    if behav_data_w(trial, 10) ~= behav_data_w(trial, 11) % if columns 10 and 11 (i.e., stimulus and response) are different
        index_incorrect_w(position_incorrect_w) = trial;
        position_incorrect_w = position_incorrect_w + 1;
    end
end
behav_data_w(index_incorrect_w(1:position_incorrect_w-1), :) = []; % then delete trial

% 4.2. DROWSY SESSION:
index_incorrect_s = behav_data_s(:,1)';
position_incorrect_s = 1;
for trial = 1:length(behav_data_s(:,1))
    if behav_data_s(trial, 10) ~= behav_data_s(trial, 11)
        index_incorrect_s(position_incorrect_s) = trial;
        position_incorrect_s = position_incorrect_s + 1;
    end
end
behav_data_s(index_incorrect_s(1:position_incorrect_s-1), :) = [];

%% 5) REJECT TRIALS TOO LOW RT
% I picked 0.2s, we might want to change that.
% find() rather than indexing? apparently indexing is more MATLAB efficient

% AWAKE SESSION
behav_data_w = behav_data_w(find(behav_data_w(:,6)>.2),:); % select only trials with RT > 0.2s

% DROWSY SESSION
behav_data_s = behav_data_s(find(behav_data_s(:,6)>.2),:); % same for drowsy session

%% 6) RECODE CONFIDENCE AND REJECT UNUSABLE TRIALS 

% TO CHANGE: this part must be adapted based on the criteria picked to categorize
% confidence responses as high or low.

% For now we use the median as a delimiter, with the median numbers being
% part of the high confidence category. We might want to change this to
% make the two categories more distinguishable.

% 6.1 AWAKE SESSION (column 13):
index_conf_w = zeros(length(behav_data_w(:,1)), 1); % preallocation index
count_w = 1; % count initialisation

% First exclude all 0s/less than 0.05! (otherwise median is biased)
% Moving the joystick less than 0.05 is considered as a non-response.
index_low_joystick_w = behav_data_w(:,1)';
position_w = 1;
for trial = 1:length(behav_data_w(:,1))
    if abs(behav_data_w(trial, 4)) < 0.05 % check if ok in joystick value 
        index_low_joystick_w(position_w) = trial;
        position_w = position_w + 1;
    end
end
behav_data_w(index_low_joystick_w(1:position_w-1), :) = [];

% This part is of first IMPORTANCE; it determines our criterion to
% categorise confidence scores as high or low:
median_w = median(abs(behav_data_w(:, 4))); % create median (objective criterion 0.5 = not enough low confidence awake trials)

% problem with median: sometimes many trials == median;
% for now we integrate them in the high confidence category
for trial = 1:length(behav_data_w(:,1))
    if abs(behav_data_w(trial, 4)) < median_w % inferior
        behav_data_w(trial, 13) = 0; % 0 for low confidence
    elseif abs(behav_data_w(trial, 4)) >= median_w % superior or EQUAL
        behav_data_w(trial, 13) = 1; % 1 for high confidence
    else
        index_conf_w(count_w) = trial; % indexing trials in-between bounds, if there are any
        count_w = count_w +1; % add 1 to counter
    end
end

behav_data_w(index_conf_w(1:count_w-1), :) = []; % delete trials with joystick movement in-between bounds
cd(drowsiness_datafolder)

%% 6) RECODE CONFIDENCE AND REJECT UNUSABLE TRIALS (second part)
% 6.2. DROWSY SESSION (column 14):
index_conf_s = zeros(length(behav_data_s(:,1))); %indexing variable preallocation
count_s = 1; % counter initialisation

% First exclude all 0s! (otherwise median is biased) --> see Excel document "uneven_events"
index_low_joystick_s = behav_data_s(:,1)';
position_s = 1;
for trial = 1:length(behav_data_s(:,1))
    if abs(behav_data_s(trial, 4)) < 0.05 % if lower than 0.05, considered as non-response (check)
        index_low_joystick_s(position_s) = trial;
        position_s = position_s + 1;
    end
end
behav_data_s(index_low_joystick_s(1:position_s-1), :) = [];

% calculation median of first importance (first exclusion trials that could bias it)
median_s = median(abs(behav_data_s(:, 4))); % create median (objective criterion 0.5 = not enough low confidence drowsy trials)

for trial = 1:length(behav_data_s(:,1))
    if abs(behav_data_s(trial, 4)) < median_s % lower bound = inferior to the median
        behav_data_s(trial, 14) = 0; % 0 for low confidence
    elseif abs(behav_data_s(trial, 4)) >= median_s % higher bound = superior or EQUAL to the median
        behav_data_s(trial, 14) = 1; % 1 for high confidence
    else
        index_conf_s(count_s) = trial; % indexing trials below 0.1 and in-between bounds if any
        count_s = count_s +1; % add 1 to counter
    end
end

behav_data_s(index_conf_s(1:count_s-1), :) = []; % delete trials with joystick movement below abs(0.1) or between abs(0.4) and abs(0.6)
cd(drowsiness_datafolder)

%% REJECT DIFFICULT TRIALS (KEEP ONLY 5, 15, 25, 75, 85, 95)
% AWAKE SESSION:
index_difficult_w = behav_data_w(:,1)';
position_dif_w = 1;
for trial = 1:length(behav_data_w(:,1))
    if behav_data_w(trial, 3) == 35 || behav_data_w(trial, 3) == 45 || behav_data_w(trial, 3) == 55 || behav_data_w(trial, 3) == 65 
        index_difficult_w(position_dif_w) = trial;
        position_dif_w = position_dif_w + 1;
    end
end
behav_data_w(index_difficult_w(1:position_dif_w-1), :) = [];

% DROWSY SESSION:
index_difficult_s = behav_data_s(:,1)';
position_dif_s = 1;
for trial = 1:length(behav_data_s(:,1))
    if behav_data_s(trial, 3) == 35 || behav_data_s(trial, 3) == 45 || behav_data_s(trial, 3) == 55 || behav_data_s(trial, 3) == 65 
        index_difficult_s(position_dif_s) = trial;
        position_dif_s = position_dif_s + 1;
    end
end
behav_data_s(index_difficult_s(1:position_dif_s-1), :) = [];

%% 7) SAVE BEHAVIOURAL DATA
cd(behav_results_folder)
save(strcat(subject, '_behav_ready_W.mat'), 'behav_data_w'); % save behavioural data after rejections and addition columns
save(strcat(subject, '_behav_ready_S.mat'), 'behav_data_s'); % for both awake and drowsy sessions

%% 8) SAME TRIALS ARE REJECTED FROM THE EEG DATA
% 8.1. AWAKE SESSION:
cd(datafolder) % go back to data folder
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab; 
EEG = pop_loadset(eeg_file_w); % load dataset in eeglab
final_index_w = behav_data_w(:,2); % indexing which trials were kept for behavioural data
EEG = pop_select(EEG, 'trial', find(final_index_w)); % select those trials
EEG_w = eeg_checkset(EEG);
eeglab redraw; % redraw dataset
EEG = pop_saveset( EEG, 'filename', strcat(subject, '_clean_ready_W.set'),'filepath',strcat(halfway_datafolder)); % save a new dataset without those trials

% 8.2. DROWSY SESSION:
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset(eeg_file_s); % load dataset in eeglab
final_index_s = behav_data_s(:,2); % indexing which trials were kept for behavioural data

% Adapt EEG data for subject 108.
if strcmp(subject, '108') 
    EEG = pop_select(EEG, 'trial', find(16:474));  % the first 15 trials do not have behavioural data
    EEG_s = eeg_checkset(EEG);
    eeglab redraw; % redraw dataset
    EEG = pop_saveset( EEG, 'filename',strcat(subject, '_intermed_S.set'),'filepath',strcat(halfway_datafolder));
    cd(halfway_datafolder)
    eeg_file_s= strcat('108_intermed_S.set');
    EEG = pop_loadset(eeg_file_s); % load dataset in eeglab
end

EEG = pop_select(EEG, 'trial', find(final_index_s)); % select those trials
% EEG_s = eeg_checkset(EEG);
eeglab redraw; % redraw dataset
EEG = pop_saveset( EEG, 'filename',strcat(subject, '_clean_ready_S.set'),'filepath',strcat(halfway_datafolder)); % save a new dataset without those trials


%% 9) CHANGING THE EVENT CODES FOR CONFIDENCE AND TONE/CONE
% We have to change the event codes based on participants' Type I and Type
% II responses. 

% For now I decided to transform already existing event codes (SOUN) rather 
% than creating new ones (easier and quicker).

cd(halfway_datafolder) % go where the data is
eeg_ready_w= strcat(subject, '_clean_ready_W.set'); % loading the new datasets 
eeg_ready_s= strcat(subject, '_clean_ready_S.set'); % for both awake and drowsy sessions

% 9.1. AWAKE SESSION:
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset(eeg_ready_w); % load dataset in eeglab
nb_events = length(behav_data_w(:,1)); % how many events we want to change
count_event_w = zeros(1,4);

% This loop replace "SOUN" event codes with either "11", "12", "13", or
% "14" -- based on behavioural data.
for epoch = 1:nb_events 
    for event = 1:length(EEG.event) % length of event fields
        if behav_data_w(epoch, 13) == 0 && behav_data_w(epoch, 11) == 0 && strcmp('SOUN', EEG.event(event).type) && EEG.event(event).epoch == epoch % we change all SOUN depending on confidence value from corresponding behavioural trial
            EEG.event(event).type = '11'; % low confidence-tone event code = 11
            EEG.epoch(epoch).eventtype{1} = '11';
            count_event_w(1) = count_event_w(1) + 1;
        elseif behav_data_w(epoch, 13) == 0 && behav_data_w(epoch, 11) == 1 && strcmp('SOUN', EEG.event(event).type) && EEG.event(event).epoch == epoch % here for high confidence
            EEG.event(event).type = '12'; % low confidence-cone event code = 12
            EEG.epoch(epoch).eventtype{1} = '12';
            count_event_w(2) = count_event_w(2) + 1;
        elseif behav_data_w(epoch, 13) == 1 && behav_data_w(epoch, 11) == 0 && strcmp('SOUN', EEG.event(event).type) && EEG.event(event).epoch == epoch % here for high confidence
            EEG.event(event).type = '13'; % high confidence-tone event code = 13
            EEG.epoch(epoch).eventtype{1} = '13';
            count_event_w(3) = count_event_w(3) + 1;
        elseif behav_data_w(epoch, 13) == 1 && behav_data_w(epoch, 11) == 1 && strcmp('SOUN', EEG.event(event).type) && EEG.event(event).epoch == epoch % here for high confidence
            EEG.event(event).type = '14'; % high confidence-cone event code = 14
            EEG.epoch(epoch).eventtype{1} = '14';
            count_event_w(4) = count_event_w(4) + 1;
        end
    end
end

% EEG_w = eeg_checkset(EEG);
eeglab redraw; % redraw dataset
EEG = pop_saveset( EEG, 'filename',strcat(subject, '_clean_ready_eventCodes_W.set'),'filepath',strcat(resultfolder)); % save dataset with confidence event codes

% 9.2. DROWSY SESSION:
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset(eeg_ready_s); % load dataset in eeglab
nb_move = length(behav_data_s(:,1)); % how many events we want to change
count_event_d = zeros(1,4);

% This loop replace "SOUN" event codes with either "11", "12", "13", or
% "14" — based on behavioural data (Type I and Type II responses).
for epoch = 1:nb_move 
    for event = 1:length(EEG.event) % length of event fields
        if behav_data_s(epoch, 14) == 0 && behav_data_s(epoch, 11) == 0 && strcmp('SOUN', EEG.event(event).type) && EEG.event(event).epoch == epoch % we change all SOUN depending on confidence value from corresponding behavioural trial
            EEG.event(event).type = '11'; % low confidence-tone event code = 11
            EEG.epoch(epoch).eventtype{1} = '11';
            count_event_d(1) = count_event_d(1) + 1;
        elseif behav_data_s(epoch, 14) == 0 && behav_data_s(epoch, 11) == 1 && strcmp('SOUN', EEG.event(event).type) && EEG.event(event).epoch == epoch % here for high confidence
            EEG.event(event).type = '12'; % low confidence-cone event code = 12
            EEG.epoch(epoch).eventtype{1} = '12';
            count_event_d(2) = count_event_d(2) + 1;
        elseif behav_data_s(epoch, 14) == 1 && behav_data_s(epoch, 11) == 0 && strcmp('SOUN', EEG.event(event).type) && EEG.event(event).epoch == epoch % here for high confidence
            EEG.event(event).type = '13'; % high confidence-tone event code = 13
            EEG.epoch(epoch).eventtype{1} = '13';
            count_event_d(3) = count_event_d(3) + 1;
        elseif behav_data_s(epoch, 14) == 1 && behav_data_s(epoch, 11) == 1 && strcmp('SOUN', EEG.event(event).type) && EEG.event(event).epoch == epoch % here for high confidence
            EEG.event(event).type = '14'; % high confidence-cone event code = 14
            EEG.epoch(epoch).eventtype{1} = '14';
            count_event_d(4) = count_event_d(4) + 1;
        end
    end
end

EEG_s = eeg_checkset(EEG);
eeglab redraw; % redraw dataset
EEG = pop_saveset( EEG, 'filename',strcat(subject, '_clean_ready_eventCodes_S.set'),'filepath',strcat(resultfolder)); % save dataset with confidence event codes

% save number of events:
cd(events_folder_W)
save(strcat(subject, '_event_counter_W.mat'), 'count_event_w'); % save behavioural data after rejections and addition columns
cd(events_folder_S)
save(strcat(subject, '_event_counter_S.mat'), 'count_event_d'); % for both awake and drowsy sessions

% The above files can be checked manually (per participant) to determine if 
% there are enough events in each class. 

%% The outputs can now be entered in the first_level() function for decoding analyses.