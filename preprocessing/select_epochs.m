function behav_data = select_epochs(subject, state, resultfolder, behavfolder)
% This function selects the same epochs as for the ERP and previous
% decoding analysis
filepath = resultfolder;

% cd(previousfolder)
% old_file = [subject, '_clean_ready_eventCodes_', state, '_1.set'];
% EEGp = pop_loadset(old_file);
% epochs = EEGp.epochs;

cd(behavfolder)
behav_data = load(strcat(subject, "_behav_ready_", state, ".mat"));
final_index = behav_data.behav_data(:,2)';

cd(resultfolder)
EEG = pop_loadset('filename', [subject '_step2_', state, '.set'], 'filepath', filepath);
EEG = pop_selectevent( EEG, 'epoch', final_index,'deleteevents','on','deleteepochs','on','invertepochs','off');
EEG = eeg_checkset(EEG);
eeglab redraw;

EEG.filename = [subject '_step3_' state '.set'];
fprintf('Saving set %s%s.\n',filepath,EEG.filename);
pop_saveset(EEG,'filename', EEG.filename, 'filepath', filepath);

end