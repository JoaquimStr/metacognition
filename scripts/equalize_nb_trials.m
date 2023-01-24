function equalize_nb_trials(response_type)
% this function takes all trials from either PD or CF and "randomly" equalize the
% number of trials for awake and drowsy sessions
datafolder1 = ['/home/js2715/rds/rds-tb419-bekinschtein/Joaquim/DATA (see Yanzhis folder)/READY/28PARTICIPANTS_2EVENTS/', response_type, '/AWAKE/CLEAN_BEHAV/'];
datafolder2 = ['/home/js2715/rds/rds-tb419-bekinschtein/Joaquim/DATA (see Yanzhis folder)/READY/28PARTICIPANTS_2EVENTS/', response_type, '/DROWSY/CLEAN_BEHAV/'];
resultfolder1 = [datafolder1, 'EQUALIZED'];
resultfolder2 = [datafolder2, 'EQUALIZED'];

subjects   = {'102', '105', '106', '107', '108', '109', '112', '113', '114', '116', '119', ...
    '120', '121', '123', '124', '129', '130',  '131', '132', '133', '134', '135', ...
    '136', '139', '140', '143', '145', '146'};

%% MERGE ALL SUBJECTS TOGETHER

cd(datafolder1)

subject1 = load([subjects{1}, '_behav_ready_W.mat']);
f1 = fieldnames(subject1);
subject2 = load([subjects{2}, '_behav_ready_W.mat']);
f2 = fieldnames(subject2);
subject3 = load([subjects{3}, '_behav_ready_W.mat']);
f3 = fieldnames(subject3);
subject4 = load([subjects{4}, '_behav_ready_W.mat']);
f4 = fieldnames(subject4);

v = [subject1.(f1{1});subject2.(f2{1});subject3.(f3{1});subject4.(f4{1})];

cd(resultfolder1)
save merged_file_W v

cd(datafolder2)

subject1 = load([subjects{1}, '_behav_ready_S.mat']);
f1 = fieldnames(subject1);
subject2 = load([subjects{2}, '_behav_ready_S.mat']);
f2 = fieldnames(subject2);
subject3 = load([subjects{3}, '_behav_ready_S.mat']);
f3 = fieldnames(subject3);
subject4 = load([subjects{4}, '_behav_ready_S.mat']);
f4 = fieldnames(subject4);

v = [subject1.(f1{1});subject2.(f2{1});subject3.(f3{1});subject4.(f4{1})];

cd(resultfolder2)
save merged_file_S v

%% SEE HOW MANY TRIALS THERE ARE IN EACH CONDITION AND RANDOMLY DELETE TRIALS FROM CONDITION WITH MORE TRIALS
cd(resultfolder2)
drowsy_behav = load('merged_file_S.mat');
for trial = 1:length(drowsy_behav)
    drowsy_behav(:, 15) = trial;
end

cd(resultfolder1)

awake_behav = load('merged_file_W.mat');
for trial = 1:length(awake_behav)
    awake_behav(:, 14) = trial;
end

rng(0,'twister');

if length(drowsy_behav) > length(awake_behav)
    while length(drowsy_behav) > length(awake_behav)
        index = randi([1, length(drowsy_behav)]);
        drowsy_behav(index, :) = [];
    end
    cd(resultfolder2)
    save('equalized_drowsy', 'drowsy_behav')
else
    while length(drowsy_behav) < length(awake_behav)
        index = randi([1, length(awake_behav)]);
        awake_behav(index, :) = [];
    end
    cd(resultfolder1)
    save('equalized_awake', 'awake_behav')
end

%% SEPARATE PARTICIPANTS AGAIN

cd(resultfolder2)
if isfile('eqalized_drowsy.mat')
    to_split = load('eqalized_drowsy.mat');
    for i = 1:28
        subject = subjects{i};
        behav_subject = to_split(1,:) == str2double(subject);
        save([subject, 'behav_equalized_drowsy'], 'behav_subject')
    end
end

cd(resultfolder1)
if isfile('eqalized_awake.mat')
    to_split = load('eqalized_awake.mat');
    for i = 1:28
        subject = subjects{i};
        behav_subject = to_split(1,:) == str2double(subject);
        save([subject, 'behav_equalized_awake'], 'behav_subject')
    end
end