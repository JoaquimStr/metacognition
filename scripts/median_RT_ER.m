% CALCULATE MEDIAN RT AND MEDIAN ER

% subjects = {'105', '107', '108', '109', '111', '112', '113', '114', '116', '119', ...
%     '120', '121', '123', '125', '128', '129', '131', '132', ...
%     '133', '134', '135', '136', '137', '139', '140', '145', '146'};

subjects   = {'105', '107', '108', '109', '112', '113', '114', '116', '119', ...
    '120', '121', '123', '129', '131', '132', '133', '134', '135', ...
    '136', '139', '140', '145', '146'};

% missing behavioural data = 124, 130, 143

% RT = zeros(length(subjects) * 160);
% RT = RT';
% ER = zeros(length(subjects) * 160);
% ER = ER';
% length_previous = 0;
% behav_struct = load([subjects{1}, '_behav_ready_W.mat']);
% behav = behav_struct.behav_data_w;
behav_RT = {1:length(subjects)};
behav_ER = {1:length(subjects)};

for subject = 1:length(subjects)
    behav_struct_2 = load([subjects{subject}, '_behav_ready_W.mat']);
    behav = behav_struct_2.behav_data;
    RT = behav(:, 6);
    ERT = behav(:, 7);
    behav_RT{subject} = RT;
    behav_ER{subject} = ERT;
%     RT((length_previous + 1):(length_previous + 1 + length(behav))) = behav(:, 6);
%     ER((length_previous + 1):(length_previous + 1 + length(behav))) = behav(:,7);
%     length_previous = length(behav);
end

vec_RT = [behav_RT{1}', behav_RT{2}', behav_RT{3}', behav_RT{4}', behav_RT{5}', behav_RT{5}', behav_RT{6}', behav_RT{7}', behav_RT{8}', behav_RT{9}', behav_RT{10}', behav_RT{11}', behav_RT{12}', behav_RT{13}', behav_RT{14}', behav_RT{15}', behav_RT{16}', behav_RT{17}', behav_RT{18}', behav_RT{19}', behav_RT{20}', behav_RT{21}', behav_RT{22}', behav_RT{23}']; % , behav_RT{4}', behav_RT{5}'];
median_RT = median(vec_RT);
mean_RT = mean(vec_RT);
vec_ER = [behav_ER{1}', behav_ER{2}', behav_ER{3}', behav_ER{4}', behav_ER{5}', behav_ER{5}', behav_ER{6}', behav_ER{7}', behav_ER{8}', behav_ER{9}', behav_ER{10}', behav_ER{11}', behav_ER{12}', behav_ER{13}', behav_ER{14}', behav_ER{15}', behav_ER{16}', behav_ER{17}', behav_ER{18}', behav_ER{19}', behav_ER{20}', behav_ER{21}', behav_ER{22}', behav_ER{23}'];
median_ER = nanmedian(vec_ER);
% mean_ER = nanmean(vec_ER);