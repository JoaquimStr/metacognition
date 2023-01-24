% regression with MATLAB:

% sliding window per time point for both early and late ROIS, both awake
% and drowsy (ROIs different):

% curve fitting toolbox?

% problem = confscore only correct trials --> new decoding analysis?


data = load('confscores.mat');
data = data.confscore;
time = 1;
colors = 'rygcbm';

for n = 1:6
    for t = 30:35
        subject = n;
        scores = data(n).scores;
        score = mean(scores(:, t, 1));
        gscatter(score,time,subject,colors)
        xlabel('Time points')
        ylabel('Mean confidence score')
        title('Confidence scores early ROI')
        hold on
        time = time + 1;
    end
end


