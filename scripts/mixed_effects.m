% linear mixed effecs model

% random effects = subjects

% fixed effect 1 = neural data (PD trustworthiness scores) either average ROI 
% fixed effect 2 = difficulty?
% fixed effect 3 = performance?
% fixed effect 4 = drowsiness

% dependent variable = joystick data

% 141 time points
% cut last time point
% 1984ms; 1 time point = 15.625ms (64Hz)


% loop per time point (141 times) or ROIs OR 1 vector and time as a random
% effect

%% CREATE THE MATRIX

% 26 subjects were finally selected!! 124, 130, 143 + see 102, 106

subjects   = {'107', '108', '109', '112', '113', '114', '116', '119', ...
    '120', '121', '123', '129',  '131', '132', '133', '134', '135', ...
    '136', '139', '140', '145', '146'};

datafolder = 'C:\Metacognition_Project\LME\data';
cd(datafolder)

confscore_w = load('confscore_w.mat');
confscore_d = load('confscore_d.mat');

subject1 = load('105_behav_ready_W.mat');
subject1.behav_data(:,2) = 0;
difficulty = subject1.behav_data(:, 3)';
for trial = 1:length(subject1.behav_data(:,3))
    if  difficulty(trial) == 5 || difficulty(trial) == 15 || difficulty(trial) == 25 || difficulty(trial) == 75 || difficulty(trial) == 85 || difficulty(trial) == 95
        subject1.behav_data(trial,3) = 1;
    elseif difficulty(trial) == 35 || difficulty(trial) == 65
        subject1.behav_data(trial,3) = 2;
    elseif difficulty(trial) == 45 || difficulty(trial) == 55
        subject1.behav_data(trial,3) = 3;
    end
end
subject1.behav_data(:,4) = abs(subject1.behav_data(:,4));
subject1.behav_data(:,5) = subject1.behav_data(:,6);
subject1.behav_data(:,6:13) = [];
if length(subject1.behav_data) > length(confscore_w.confscore(1).scores(:,1,1))
    index_selected = confscore_w.confscore.trial_index;
    subject1.behav_data = subject1.behav_data(index_selected, :);
end
subject1.behav_data(:,6) = confscore_w.confscore(1).scores(:, 1, 1); % time point to change + ask what is third dimension
f1 = fieldnames(subject1);

subject2 = load('105_behav_ready_S.mat');
subject2.behav_data(:,2) = 1;
difficulty = subject2.behav_data(:, 3)';
for trial = 1:length(subject2.behav_data(:,3))
    if  difficulty(trial) == 5 || difficulty(trial) == 15 || difficulty(trial) == 25 || difficulty(trial) == 75 || difficulty(trial) == 85 || difficulty(trial) == 95
        subject2.behav_data(trial,3) = 1;
    elseif difficulty(trial) == 35 || difficulty(trial) == 65
        subject2.behav_data(trial,3) = 2;
    elseif difficulty(trial) == 45 || difficulty(trial) == 55
        subject2.behav_data(trial,3) = 3;
    end
end
subject2.behav_data(:,4) = abs(subject2.behav_data(:,4));
subject2.behav_data(:,5) = subject2.behav_data(:,6);
subject2.behav_data(:,6:14) = [];
if length(subject2.behav_data) > length(confscore_d.confscore(1).scores(:,1,1))
    index_selected = confscore_d.confscore.trial_index;
    subject2.behav_data = subject2.behav_data(index_selected, :);
end
subject2.behav_data(:,6) = confscore_d.confscore(1).scores(:, 1, 1); % time point to change + ask what is third dimension
f2 = fieldnames(subject2);

v = [subject1.(f1{1});subject2.(f2{1})];


% now the same but for the other participants:
for number = 1:22
    subject_a = load([subjects{number}, '_behav_ready_W.mat']);
    subject_a.behav_data(:,2) = 0;
    difficulty = subject_a.behav_data(:, 3)';
    for trial = 1:length(subject_a.behav_data(:,3))
        if  difficulty(trial) == 5 || difficulty(trial) == 15 || difficulty(trial) == 25 || difficulty(trial) == 75 || difficulty(trial) == 85 || difficulty(trial) == 95
            subject_a.behav_data(trial,3) = 1;
        elseif difficulty(trial) == 35 || difficulty(trial) == 65
            subject_a.behav_data(trial,3) = 2;
        elseif difficulty(trial) == 45 || difficulty(trial) == 55
            subject_a.behav_data(trial,3) = 3;
        end
    end
    subject_a.behav_data(:,4) = abs(subject_a.behav_data(:,4));
    subject_a.behav_data(:,5) = subject_a.behav_data(:,6);
    subject_a.behav_data(:,6:13) = [];
    if length(subject_a.behav_data) > length(confscore_w.confscore(number + 1).scores(:,1,1))
        index_selected = confscore_w.confscore(number + 1).trial_index;
        subject_a.behav_data = subject_a.behav_data(index_selected, :);
    end
    subject_a.behav_data(:,6) = confscore_w.confscore(number + 1).scores(:, 1, 1);
    f11 = fieldnames(subject_a);

    % drowsy:
    subject_d = load([subjects{number}, '_behav_ready_S.mat']);
    subject_d.behav_data(:,2) = 1;
    difficulty = subject_d.behav_data(:, 3)';
    for trial = 1:length(subject_d.behav_data(:,3))
        if  difficulty(trial) == 5 || difficulty(trial) == 15 || difficulty(trial) == 25 || difficulty(trial) == 75 || difficulty(trial) == 85 || difficulty(trial) == 95
            subject_d.behav_data(trial,3) = 1;
        elseif difficulty(trial) == 35 || difficulty(trial) == 65
            subject_d.behav_data(trial,3) = 2;
        elseif difficulty(trial) == 45 || difficulty(trial) == 55
            subject_d.behav_data(trial,3) = 3;
        end
    end
    subject_d.behav_data(:,4) = abs(subject_d.behav_data(:,4));
    subject_d.behav_data(:,5) = subject_d.behav_data(:,6);
    subject_d.behav_data(:,6:14) = [];
    if length(subject_d.behav_data) > length(confscore_d.confscore(number + 1).scores(:,1,1))
        index_selected = confscore_d.confscore(number + 1).trial_index;
        subject_d.behav_data = subject_d.behav_data(index_selected, :);
    end
    subject_d.behav_data(:,6) = confscore_d.confscore(number + 1).scores(:, 1, 1);
    f12 = fieldnames(subject_d);

    v = [v; subject_a.(f11{1});subject_d.(f12{1})];
end

save merged_file_confscores v

%% csv file

% /!\ trustworthiness from participant 107 look weird!

matrix = load('merged_file_confscores.mat');
csvwrite('matrix_lme_model1.csv', matrix.v)

%% csv file all conscores right order

confscore_w = load('confscore_w.mat');
confscore_d = load('confscore_d.mat');
% all_scores = nan(500, 3243);
starter = 1;

for tp = 1:141
    for subject = 1:23
        if tp == 1
            confscore_d.confscore(subject).scores(:, 142, :) = [];
        end
        tp_w = confscore_w.confscore(subject).scores(:, tp, 1);
        tp_d = confscore_d.confscore(subject).scores(:, tp, 1);
        lengthy = length(tp_w) + length(tp_d);
        all_scores(starter:(starter + lengthy - 1), tp) = [tp_w;tp_d]';
        starter = starter + lengthy;
    end
    starter = 1;
end

% for column = 1:3243
%     for row = 1:552
%         if all_scores(row, column) == 0
%             all_scores(row, column) = [];
%         end
%     end
% end

all_confscores(2:7607,:) = all_scores;
all_confscores(1,:) = vec(:);

save all_confscores all_confscores
csvwrite('all_confscores.csv', all_confscores)


%% AVERAGE EVERY 3 TIME POINTS

final_confscores = load('all_confscores.mat');
final_confscores = final_confscores.all_confscores;

neural_scores = zeros(7607, 47);
first_col = 1;
second_col = 2;
third_col = 3;

for timewind = 1:47
    neural_scores(:, timewind) = (final_confscores(:,first_col) + final_confscores(:,second_col) + final_confscores(:,third_col))/3;
    first_col = first_col + 3;
    second_col = second_col + 3;
    third_col = third_col + 3;
end

neural_scores(1, :) = 1:47;
save neural_scores neural_scores
csvwrite('neural_scores.csv', neural_scores)

%%
table_model1 = zeros(6, 47);
csvwrite('table_model1.csv', table_model1)

table_model2 = zeros(14, 47);
csvwrite('table_model2.csv', table_model2)