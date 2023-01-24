% check number of events per state

%% confidence:
datafolder = 'C:\Metacognition_Project\FINALL\events_counter_CF';
cd(datafolder)

low_conf_W = zeros(1, 23);
high_conf_W = zeros(1, 23);
low_conf_S = zeros(1, 23);
high_conf_S = zeros(1, 23);

subjects   = {'105', '107', '108', '109', '112', '113', '114', '116', '119', ...
    '120', '121', '123', '129', '131', '132', '133', '134', '135', ...
    '136', '139', '140', '145', '146'};

for n = 1:23
    subject = subjects{n};
    data_W = load([subject, '_event_counter_W']);
    data_S = load([subject, '_event_counter_S']);
    data_W = data_W.count_event;
    data_S = data_S.count_event;
    low_conf_W(n) = data_W(1);
    high_conf_W(n) = data_W(2);
    low_conf_S(n) = data_S(1);
    high_conf_S(n) = data_S(2);
end

sumLCW = sum(low_conf_W);
sumLCS = sum(low_conf_S);
sumHCW = sum(high_conf_W);
sumHCS = sum(high_conf_S);
[low_conf, pLC] = ttest(low_conf_W, low_conf_S);
[high_conf, pHC] = ttest(high_conf_W, high_conf_S);

%% perceptual decision:
datafolder = 'C:\Metacognition_Project\FINALL\events_counter_PD';
cd(datafolder)

tone_W = zeros(1, 23);
cone_W = zeros(1, 23);
tone_S = zeros(1, 23);
cone_S = zeros(1, 23);

subjects   = {'105', '107', '108', '109', '112', '113', '114', '116', '119', ...
    '120', '121', '123', '129', '131', '132', '133', '134', '135', ...
    '136', '139', '140', '145', '146'};

for n = 1:23
    subject = subjects{n};
    data_W = load([subject, '_event_counter_W']);
    data_S = load([subject, '_event_counter_S']);
    data_W = data_W.count_event;
    data_S = data_S.count_event;
    tone_W(n) = data_W(1);
    cone_W(n) = data_W(2);
    tone_S(n) = data_S(1);
    cone_S(n) = data_S(2);
end

sumTW = sum(tone_W);
sumTS = sum(tone_S);
sumCW = sum(cone_W);
sumCS = sum(cone_S);
[tone, pT] = ttest(tone_W, tone_S);
[cone, pC] = ttest(cone_W, cone_S);