subjects   = {'105', '107', '108', '109', '111', '112', '113', '114', '116', '119', ...
    '120', '121', '123', '128', '129', '131', '132', '133', '134', '135', ...
    '136', '139', '140', '145', '146'};

% state = 'W';
state = 'S';

difficulty = zeros(1,10000);

datafolder = 'C:/Metacognition_Project/FINALL/behaviour_for_regression';
cd(datafolder)

first = 1;

for n = 1:23
    subject = subjects{n};
    behav_data = load(strcat(subject, '_behav_ready_', state, '.mat'));
    behav_data = behav_data.behav_data;
    morphed = behav_data(:, 3);
    difficulty(first:(first + length(morphed) - 1)) = morphed';
    first = first + length(morphed) + 1;
end

index = difficulty == 0;
difficulty(index) = [];

easy1 = difficulty(difficulty == 5 | difficulty == 15 | difficulty == 25);
easy2 = difficulty(difficulty == 75 | difficulty == 85 | difficulty == 95);
medium1 = difficulty(difficulty == 35);
medium2 = difficulty(difficulty == 65);
difficult = difficulty(difficulty == 45 | difficulty == 55);

%%

% compute statistics with correlationT
cfg = [];
cfg.statistic        = 'ft_statfun_depsamplesregrT';
cfg.method           = 'montecarlo';
cfg.numrandomization = 1000;

n1 = 3047;    % n1 is the number of trials
design(1,1:n1)       = difficulty; %here we insert our independent variable (behavioral data) in the cfg.design matrix, in this case reaction times of 3 subjects.

cfg.design           = design;
cfg.ivar             = 1;

data_brain = mvpa_stats.weights.indivWeights(1:130);

stat = ft_freqstatistics(cfg, data_brain);

% corrcoef(data_brain,design)

% weights = mvpa_stats.weights.indivWeights;

% 23 * 141 = 3243 (* 92 electrodes)

% import as csv into JASP?
