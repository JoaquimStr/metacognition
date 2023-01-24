function count_event = modify_events(behav_data, subject, state, finalfolder, halfway_datafolder)
%% this function is part of prepare()
% We have to change the event codes based on participants' Type I and Type
% II responses. 

% For now I decided to transform already existing event codes (SOUN) rather 
% than creating new ones (easier and quicker).
cd(halfway_datafolder)
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset([subject, '_clean_ready_', state, '.set']); % load dataset in eeglab
nb_events = length(behav_data(:,1)); % how many events we want to change
% count_event = zeros(1,4);
count_event = zeros(1,2);

if strcmp(state, 'W')
    column = 13; % TO CHANGE WHEN CONFIDENCE COLUMN IS ADDED!
else
    column = 14;
end

% This loop replace "SOUN" event codes with either "11", "12", "13", or
% "14" -- based on behavioural data.
% for epoch = 1:nb_events 
%     for event = 1:length(EEG.event) % length of event fields
%         if behav_data(epoch, column) == 0 && behav_data(epoch, 10) == 0 && strcmp('SOUN', EEG.event(event).type) && EEG.event(event).epoch == epoch % we change all SOUN depending on confidence value from corresponding behavioural trial
%             EEG.event(event).type = '11'; % low confidence-tone event code = 11
%             EEG.epoch(epoch).eventtype{1} = '11';
%             count_event(1) = count_event(1) + 1;
%         elseif behav_data(epoch, column) == 0 && behav_data(epoch, 10) == 1 && strcmp('SOUN', EEG.event(event).type) && EEG.event(event).epoch == epoch % here for high confidence
%             EEG.event(event).type = '12'; % low confidence-cone event code = 12
%             EEG.epoch(epoch).eventtype{1} = '12';
%             count_event(2) = count_event(2) + 1;
%         elseif behav_data(epoch, column) == 1 && behav_data(epoch, 10) == 0 && strcmp('SOUN', EEG.event(event).type) && EEG.event(event).epoch == epoch % here for high confidence
%             EEG.event(event).type = '13'; % high confidence-tone event code = 13
%             EEG.epoch(epoch).eventtype{1} = '13';
%             count_event(3) = count_event(3) + 1;
%         elseif behav_data(epoch, column) == 1 && behav_data(epoch, 10) == 1 && strcmp('SOUN', EEG.event(event).type) && EEG.event(event).epoch == epoch % here for high confidence
%             EEG.event(event).type = '14'; % high confidence-cone event code = 14
%             EEG.epoch(epoch).eventtype{1} = '14';
%             count_event(4) = count_event(4) + 1;
%         end
%     end
% end

% for epoch = 1:nb_events 
%     for event = 1:length(EEG.event) % length of event fields
%         if behav_data(epoch, 10) == 0 && strcmp('SOUN', EEG.event(event).type) && EEG.event(event).epoch == epoch % we change all SOUN depending on confidence value from corresponding behavioural trial
%             EEG.event(event).type = '11'; % low confidence-tone event code = 11
%             EEG.epoch(epoch).eventtype{1} = '11';
%             count_event(1) = count_event(1) + 1;
%         elseif behav_data(epoch, 10) == 1 && strcmp('SOUN', EEG.event(event).type) && EEG.event(event).epoch == epoch % here for high confidence
%             EEG.event(event).type = '12'; % low confidence-cone event code = 12
%             EEG.epoch(epoch).eventtype{1} = '12';
%             count_event(2) = count_event(2) + 1;
%         end
%     end
% end

for epoch = 1:nb_events 
    for event = 1:length(EEG.event) % length of event fields
        if behav_data(epoch, column) == 0 && strcmp('SOUN', EEG.event(event).type) && EEG.event(event).epoch == epoch % we change all SOUN depending on confidence value from corresponding behavioural trial
            EEG.event(event).type = '13'; % low confidence = 13
            EEG.epoch(epoch).eventtype{1} = '13';
            count_event(1) = count_event(1) + 1;
        elseif behav_data(epoch, column) == 1 && strcmp('SOUN', EEG.event(event).type) && EEG.event(event).epoch == epoch % here for high confidence
            EEG.event(event).type = '14'; % high confidence = 14
            EEG.epoch(epoch).eventtype{1} = '14';
            count_event(2) = count_event(2) + 1;
        end
    end
end

% save('event_counter', 'count_event')
EEG = eeg_checkset(EEG);
eeglab redraw; % redraw dataset
EEG = pop_saveset( EEG, 'filename',strcat(subject, '_clean_ready_eventCodes_', state, '_2.set'),'filepath',strcat(finalfolder)); % save dataset with confidence event codes