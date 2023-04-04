% plot behavioural results

folder = 'C:/Metacognition_project/HMETA/30participants'; % for continuum (20) data
% folder = 'C:\Metacognition_Project\LME\data'; % for binary data
cd(folder)
% 
% subjects   = {'105', '107', '108', '109', '112', '113', '114', '116', '119', ...
%      '120', '121', '123', '129', '131', '132', '133', '134', '135', ...
%      '136', '139', '140', '145', '146'};

d = zeros(30, 2);
meta = zeros(30, 2);
ratio = zeros(30, 2);

alertness = {'Awake', 'Drowsy'};

for n = 1:30 % add more subjects
%     subject = subjects{n};
%     behav_data_W = load([subject, '_meta_d_W.mat']);
%     behav_data_S = load([subject, '_meta_d_S.mat']);
    d(n, 1) = group_W.d1(1,n);
    d(n, 2) = group_S.d1(1,n);
    meta(n, 1) = group_W.meta_d(1,n);
    meta(n, 2) = group_S.meta_d(1,n);
    ratio(n, 1) = group_W.Mratio(1,n);
    ratio(n, 2) = group_S.Mratio(1,n);
end

%% OR PER DIFFICULTY LEVEL

% d = zeros(23, 6);
% meta = zeros(23, 6);
% ratio = zeros(23, 6);
% 
% for n = 1:23 % add more subjects
%     subject = subjects{n};
%     behav_data_W_easy = load([subject, '_meta_d_W_easy.mat']);
%     behav_data_W_medium = load([subject, '_meta_d_W_medium.mat']);
%     behav_data_W_difficult = load([subject, '_meta_d_W_difficult.mat']);
%     behav_data_S_easy = load([subject, '_meta_d_S_easy.mat']);
%     behav_data_S_medium = load([subject, '_meta_d_S_medium.mat']);
%     behav_data_S_difficult = load([subject, '_meta_d_S_difficult.mat']);
%     d(n, 1) = behav_data_W_easy.meta_d.d1;
%     d(n, 2) = behav_data_W_medium.meta_d.d1;
%     d(n, 3) = behav_data_W_difficult.meta_d.d1;
%     d(n, 4) = behav_data_S_easy.meta_d.d1;
%     d(n, 5) = behav_data_S_medium.meta_d.d1;
%     d(n, 6) = behav_data_S_difficult.meta_d.d1;
%     meta(n, 1) = behav_data_W_easy.meta_d.meta_d;
%     meta(n, 2) = behav_data_W_medium.meta_d.meta_d;
%     meta(n, 3) = behav_data_W_difficult.meta_d.meta_d;
%     meta(n, 4) = behav_data_S_easy.meta_d.meta_d;
%     meta(n, 5) = behav_data_S_medium.meta_d.meta_d;
%     meta(n, 6) = behav_data_S_difficult.meta_d.meta_d;
%     ratio(n, 1) = behav_data_W_easy.meta_d.M_ratio;
%     ratio(n, 2) = behav_data_W_medium.meta_d.M_ratio;
%     ratio(n, 3) = behav_data_W_difficult.meta_d.M_ratio;
%     ratio(n, 4) = behav_data_S_easy.meta_d.M_ratio;
%     ratio(n, 5) = behav_data_S_medium.meta_d.M_ratio;
%     ratio(n, 6) = behav_data_S_difficult.meta_d.M_ratio;
% end

clear figure
h = boxplot(d,'Colors', 'rb', 'OutlierSize', 7); % 'BoxStyle', 'filled', 
set(h(7,:),'Visible','off');
set(gca,'XTickLabel', {''; ''})
title('Discrimination performance (d'')')
ylabel('d''')
ylim([0, 4])
for state = 1:2 % or 1:6
    for n = 1:23
        hold on
        if state == 1
            s1 = plot(rand(1)*0.4 + state - 0.2, d(n,state),'ro');
        else
            s2 = plot(rand(1)*0.4 + state - 0.2, d(n,state),'bo');
        end
    end
end
legend([s1, s2], alertness, 'Location', 'northeast')
% plot(1.5, 4, '*k')
figure = gca;
exportgraphics(figure, 'd.jpg')

%%
clear figure
h = boxplot(meta,'Colors', 'rb', 'OutlierSize',7);
set(h(7,:),'Visible','off');
set(gca,'XTickLabel', {''; ''})
title('Metacognitive performance (meta-d'')')
ylabel('meta-d''')
ylim([0, 4])
for state = 1:2 % or 1:6
    for n = 1:30
        hold on
        if state == 1
            s1 = plot(rand(1)*0.4 + state - 0.2, meta(n,state),'ro');
        else
            s2 = plot(rand(1)*0.4 + state - 0.2, meta(n,state),'bo');
        end
    end
end
legend([s1, s2], alertness, 'Location', 'northeast')
figure = gca;
exportgraphics(figure, 'meta.jpg')

%%
clear figure
h = boxplot(ratio,'Colors', 'rb', 'OutlierSize',7);
set(h(7,:),'Visible','off');
set(gca,'XTickLabel', {''; ''})
title('Metacognitive efficiency (HMeta-d''/d'')')
ylabel('HMeta-d''/d''')
ylim([0, 4])
for state = 1:2 % or 1:6
    for n = 1:30
        hold on
        if state == 1
            s1 = plot(rand(1)*0.4 + state - 0.2, ratio(n,state),'ro');
        else
            s2 = plot(rand(1)*0.4 + state - 0.2, ratio(n,state),'bo');
        end
    end
end
legend([s1, s2], alertness, 'Location', 'northeast')
figure = gca;
exportgraphics(figure, 'ratio.jpg')

%% t-tests

[h1, p1] = ttest(d(:,1), d(:,2));

[h2, p2] = ttest(meta(:,1), meta(:,2));

[h3, p3] = ttest(ratio(:,1), ratio(:,2));

d1 = mean(d(:,1));
d2 = mean(d(:,2));

meta1 = mean(meta(:,1));
meta2 = mean(meta(:,2));

ratio1 = mean(ratio(:,1));
ratio2 = mean(ratio(:,2));