function merge_datasets(params)
%%
% this function merges EEG datasets to be able to run cross-decoding
% analysis across participants

basefolder = '/home/js2715/rds/rds-tb419-bekinschtein/Joaquim/DATA (see Yanzhis folder)/READY/';
datafolder = [basefolder 'FINALL/PD/DROWSY']; 
resultfolder = [basefolder '/merged for cross-decoding'];
% scriptfolder = '/home/js2715/metacognition/'; 

cd(datafolder)
filenames = {dir(sprintf('*eventCodes_%s*.set',params{1,1}))};

EEG = cell(1,length(filenames{1})-1);
EEG_merged = pop_loadset('filename', filenames{1,1}(1).name, 'filepath', datafolder);

for subject = 2:length(filenames{1})
    EEG{:,subject-1} = pop_loadset('filename', filenames{1,1}(subject).name, 'filepath', datafolder);
    EEG_merged = pop_mergeset(EEG_merged,EEG{:, subject-1},1);
end

cd(resultfolder)
pop_saveset(EEG_merged,'filename', [params{1,1} '_merged_CLEAN_PD.set'], 'filepath', resultfolder, 'version', '7.3');