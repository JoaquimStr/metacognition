function eeg_file = align_behav_eeg(behav_data, eeg_file, subject, state, halfway_datafolder, datafolder)
%% this function is part of prepare()

cd(datafolder)
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab; 
EEG = pop_loadset(eeg_file); % load dataset in eeglab
final_index = behav_data(:,2)'; % indexing which trials were kept for behavioural data

% if strcmp(state, 'S') && strcmp(subject, '108') % adapt to participant 108
%     EEG = pop_select(EEG, 'trial', find(16:474));  % the first 15 trials do not have behavioural data
%     EEG = eeg_checkset(EEG);
%     eeglab redraw; % redraw dataset
%     EEG = pop_saveset( EEG, 'filename',strcat(subject, '_intermed_S.set'),'filepath',strcat(halfway_datafolder));
%     cd(halfway_datafolder)
%     eeg_file = strcat('108_intermed_S.set');
%     EEG = pop_loadset(eeg_file); % load dataset in eeglab
% end

% EEG = pop_select(EEG, 'trial', final_index); % select those trials

EEG = pop_selectevent( EEG, 'epoch', final_index,'deleteevents','on','deleteepochs','on','invertepochs','off');
EEG = eeg_checkset(EEG);
eeglab redraw; 

EEG = pop_saveset( EEG, 'filename', strcat(subject, '_clean_ready_', state, '.set'),'filepath',strcat(halfway_datafolder)); % save a new dataset without those trials