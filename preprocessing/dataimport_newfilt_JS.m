function EEG = dataimport_newfilt_JS(subject, basename, state, datafolder, resultfolder, mfffolder)% use the very specific file name, and the whole of it! % SG updated with the latest filter funstion in eeglab 07/07/17

loadpaths_JS(datafolder) % this is just another .m file with one line of code specifying the directory you want to be in. you can comment on it and just include something like: eval(sprintf(['cd /imaging/sg04/stanimira_p4/eeg_emg/p33_s2/...']));

chanexcl = [1,8,14,17,21,25,32,38,43,44,48,49,56,63,64,68,69,73,74,81,82,88,89,94,95,99,107,113,114,119,120,121,125,126,127,128];

filepath = datafolder;
% filenames = dir(sprintf('%s%s*', filepath, basename));
filename = basename;

if isempty(filename)
    error('No files found to import!\n');
end

mfffile = filename; %(logical(cell2mat({filenames.isdir})));
% if length(mfffiles) > 1
%     error('Expected 1 MFF recording file. Found %d.\n',length(mfffiles));
% else
%     filename = mfffiles.name;
%     fprintf('\nProcessing %s.\n\n', filename);
%     EEG = pop_readegimff(sprintf('%s%s', filepath, filename));
% end

% cd(mfffolder)
cd(datafolder)
% cd(resultfolder)

fprintf('\nProcessing %s.\n\n', filename);
EEG = pop_mffimport(filename, ['code']); % double-check that typefield is ok
% EEG = pop_readegimff;
% EEG = pop_readegimff(filename);
% EEG = pop_readegimff(sprintf('%s%s', filepath, filename));
EEG = eeg_checkset(EEG);

%%% preprocessing

samprate = 500; %downsaple if srate is higher that 250!
fprintf('Downsampling to %dHz.\n',samprate);
EEG = pop_resample(EEG,samprate);

fprintf('Removing excluded channels.\n');
EEG = pop_select(EEG,'nochannel',chanexcl);

hpfreq = 0.01; % lpfreq = 40;
% fprintf('Low-pass and High-pass filtering between %dHz',lpfreq, ' %dHz...\n', hpfreq);
% EEG = pop_eegfiltnew(EEG, hpfreq, lpfreq);

fprintf('High-pass filtering above %dHz...\n',hpfreq);
% EEG = pop_eegfiltnew(EEG, hpfreq, 0, [], [0], 0, 0, 'fir1', 0);
EEG = pop_eegfiltnew(EEG, hpfreq, 0, [], [0], 0, 0); % to double-check
filepath = resultfolder;

EEG.setname = sprintf('%s_step1_%s', subject, state); % the output file is called: basename_orig
EEG.filename = sprintf('%s_step1_%s.set',subject, state);
EEG.filepath = filepath;

fprintf('Saving %s%s.\n', EEG.filepath, EEG.filename);
pop_saveset(EEG,'filename', EEG.filename, 'filepath', EEG.filepath);
