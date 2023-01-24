function count_event = modify_events_across(task_id, eeg_file, behav_data, subject, state, finalfolder)
%% this function is part of prepare()

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset(eeg_file); % load dataset in eeglab
nb_events = length(behav_data(:,1)); % how many events we want to change
count_event = zeros(1,4);

if strcmp(state, 'W')
    column = 13;
else
    column = 14;
end

% This loop replace "SOUN" event codes with either "11", "12", "13", or
% "14" -- based on behavioural data.
% for epoch = 1:nb_events 
%     for event = 1:length(EEG.event) % length of event fields
%         if behav_data(epoch, 10) == 0 && strcmp('SOUN', EEG.event(event).type) && EEG.event(event).epoch == epoch % we change all SOUN depending on confidence value from corresponding behavioural trial
%             EEG.event(event).type = [num2str(task_id) '1']; % low confidence-tone event code = subject-1
%             EEG.epoch(epoch).eventtype{1} = [num2str(task_id) '1'];
%             count_event(1) = count_event(1) + 1;
%         elseif behav_data(epoch, 10) == 1 && strcmp('SOUN', EEG.event(event).type) && EEG.event(event).epoch == epoch % here for high confidence
%             EEG.event(event).type = [num2str(task_id) '2']; % low confidence-cone event code = subject-2
%             EEG.epoch(epoch).eventtype{1} = [num2str(task_id) '2'];
%             count_event(2) = count_event(2) + 1;
%         end
%     end
% end


for epoch = 1:nb_events 
    for event = 1:length(EEG.event) % length of event fields
        if behav_data(epoch, column) == 0 && strcmp('SOUN', EEG.event(event).type) && EEG.event(event).epoch == epoch % here for high confidence
            EEG.event(event).type = [num2str(task_id) '3']; % high confidence-tone event code = subject-3
            EEG.epoch(epoch).eventtype{1} = [num2str(task_id) '3'];
            count_event(3) = count_event(3) + 1;
        elseif behav_data(epoch, column) == 1 && strcmp('SOUN', EEG.event(event).type) && EEG.event(event).epoch == epoch % here for high confidence
            EEG.event(event).type = [num2str(task_id) '4']; % high confidence-cone event code = subject-4
            EEG.epoch(epoch).eventtype{1} = [num2str(task_id) '4'];
            count_event(4) = count_event(4) + 1;
        end
    end
end

EEG = eeg_checkset(EEG);
eeglab redraw; % redraw dataset
EEG = pop_saveset( EEG, 'filename',strcat(subject, '_clean_ready_eventCodes_', state, '_across.set'),'filepath',strcat(finalfolder)); % save dataset with confidence event codes
