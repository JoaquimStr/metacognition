% convert to .csv to enter confidence scores and behavioural data into
% JASP:

confscore = mvpa_pd_stats.indivConf;
save('confscore.mat', 'confscore')


confscore = load('confscore.mat');
% csvwrite('confscore.csv', confscore.confscore);

for n = 1:23
    writematrix(confscore.confscore(n).scores,strcat(['confscore', num2str(n), '.csv']));
end