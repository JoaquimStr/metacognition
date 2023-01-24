

awake = pop_loadset('106_clean_ready_eventCodes_W.set');
drowsy = pop_loadset('106_clean_ready_eventCodes_S.set');


size_awake = size(awake.data, 3);
size_drowsy = size(drowsy.data, 3);

if size_awake > size_drowsy
    index_selected = randperm(size_awake, size_drowsy);
    awake = pop_select(awake, 'trial', index_selected);
    EEG = awake;
    EEG = eeg_checkset(EEG);
    pop_saveset(EEG, '105_clean_ready_eventCodes_W_selected.set')
else
    index_selected = randperm(size_drowsy, size_awake);
    drowsy = pop_select(drowsy, 'trial', index_selected);
    EEG = drowsy;
    EEG = eeg_checkset(EEG);
    pop_saveset(EEG, '105_clean_ready_eventCodes_S_selected.set')
end