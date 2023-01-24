subjects   = {'105', '107', '108', '109', '112', '113', '114', '116', '119', ...
    '120', '121', '123', '129', '131', '132', '133', '134', '135', '136', ...
     '139', '140', '145', '146'}; 

rejection_total = 0;
incorrect_total = 0;
RT_total = 0;
drowsiness_total = 0;

for n = 1:23
    subject = subjects{n};
    rejection = load(strcat("length_rejectionW_", subject, ".mat"));
    rejection = rejection.length_subject_rej;
    incorrect = load(strcat("length_incorrect_W_", subject, ".mat"));
    incorrect = incorrect.length_subject_incorrect;
    RT = load(strcat("length_RT_W_", subject, ".mat"));
    RT = RT.length_subject_RT;
    rejection_total = rejection_total + rejection;
    incorrect_total = incorrect_total + incorrect;
    RT_total = RT_total + RT;
end

%% same for drowsy session
for n = 1:23
    subject = subjects{n};
    rejection = load(strcat("length_rejectionS_", subject, ".mat"));
    rejection = rejection.length_subject_rej;
    drowsiness = load(strcat("length_drowsiness_S_", subject, ".mat"));
    drowsiness = drowsiness.length_subject_drowsiness;
    incorrect = load(strcat("length_incorrect_S_", subject, ".mat"));
    incorrect = incorrect.length_subject_incorrect;
    RT = load(strcat("length_RT_S_", subject, ".mat"));
    RT = RT.length_subject_RT;
    rejection_total = rejection_total + rejection;
    drowsiness_total = drowsiness_total + drowsiness;
    incorrect_total = incorrect_total + incorrect;
    RT_total = RT_total + RT;
end

