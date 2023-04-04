function EEG = epochdata_JS(subject, basename, state, resultfolder) %,icamode

% if ~exist('icamode','var') || isempty(icamode)
%     icamode = false;
% end
% keepica = true;
filepath = resultfolder;

eventlist = {
'SOUN'
};

if strcmp(state, 'W')
    timewin = [-.2 2.002]; % WAKE
else
    timewin = [-.2 4.002]; % SLEEP
end

%filepath = '/imaging/sg04/stanimira_p4/eeg_emg/p27_s2/';
% chanlocpath = '';

% loadpaths(subject)

% if ischar(subject)
    EEG = pop_loadset('filename', [subject '_step1_', state, '.set'], 'filepath', filepath);
% else
%     EEG = basename;
% end

fprintf('Epoching and baselining.\n');

allevents = {EEG.event.type};
selectevents = [];
for e = 1:length(eventlist)
    selectevents = [selectevents find(strncmp(eventlist{e},allevents,length(eventlist{e})))];
end
EEG = pop_epoch(EEG,{},timewin,'eventindices',selectevents);

EEG = pop_rmbase(EEG, [-200 0]); % baseline correction
EEG = eeg_checkset(EEG);

% Average rereference
EEG = pop_reref( EEG, []);
EEG = eeg_checkset(EEG);


if ischar(basename)
    EEG.setname = basename;
    
%     if icamode
        EEG.filename = [subject '_step2_' state '.set'];
%     else
%         EEG.filename = [subject '.set'];
%     end
    
%     if icamode == true && keepica == true && exist([filepath EEG.filename],'file') == 2
%         oldEEG = pop_loadset('filepath',filepath,'filename',EEG.filename,'loadmode','info');
%         if isfield(oldEEG,'icaweights') && ~isempty(oldEEG.icaweights)
%             fprintf('Loading existing ICA info from %s%s.\n',filepath,EEG.filename);
%             EEG.icaact = oldEEG.icaact;
%             EEG.icawinv = oldEEG.icawinv;
%             EEG.icasphere = oldEEG.icasphere;
%             EEG.icaweights = oldEEG.icaweights;
%             EEG.icachansind = oldEEG.icachansind;
%             EEG.reject.gcompreject = oldEEG.reject.gcompreject;
%         end
%     end
    
    fprintf('Saving set %s%s.\n',filepath,EEG.filename);
    pop_saveset(EEG,'filename', EEG.filename, 'filepath', filepath);
end