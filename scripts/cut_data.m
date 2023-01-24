function cut_data(params, response_type, state)

server = 1;

if server == 1
%     if strcmp(state, 'W')
    datafolder = '/rds/project/tb419/rds-tb419-bekinschtein/Joaquim/DATA (see Yanzhis folder)/READY/REPLICATION_INDICES_CATE2/FOUR';
%     else
%         datafolder = '/rds/project/tb419/rds-tb419-bekinschtein/Joaquim/DATA (see Yanzhis folder)/READY/REPLICATION/DROWSY';
%     end
else
    datafolder = 'C:\Metacognition_Project\cross_decoding';
end

datafolder2 = [datafolder, '/CD_SHORTEN'];
cd(datafolder)

subject = params{1,1};

% if strcmp(response_type, 'PD')
%     response = '1';
% else
    response = '2';
% end

% cut the drowsy data

if strcmp(state, 'S')
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab; 
    EEG = pop_loadset('filename', strcat(subject, '_clean_ready_eventCodes_S_', response, '.set'));
    EEG = eeg_checkset(EEG);
    
    EEG = pop_select( EEG, 'time',[-0.2 2.001]);
    EEG = eeg_checkset(EEG);
    eeglab redraw; % redraw datase
    
    EEG = pop_saveset(EEG, 'filename', strcat(subject, '_clean_shorten_eventCodes_S_', response, '.set'), 'filepath', strcat(datafolder2));
else
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab; 
    EEG = pop_loadset('filename', strcat(subject, '_clean_ready_eventCodes_W_', response, '.set'));
    EEG = eeg_checkset(EEG);
    
    EEG = pop_select( EEG, 'time',[-0.2 2.001]);
    EEG = eeg_checkset(EEG);
    eeglab redraw; % redraw datase
    
    EEG = pop_saveset(EEG, 'filename', strcat(subject, '_clean_shorten_eventCodes_W_', response, '.set'), 'filepath', strcat(datafolder2));
end

end 