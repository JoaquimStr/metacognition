% run preprocessing

subjects   = {'102', '105', '106', '107', '111', '112', '113', '114', '116', '117', ...
    '119', '120', '121', '123', '124', '125', '126', '127', '128', '131', ...
     '132', '133', '136', '137', '139', '140', '141', '143', '144', '146'}; 

sessions = {'W', 'S'};

for states = 1:2
    state = sessions{states};
    for subject = 1:1
        params = subjects{subject};
        preprocessing_light_decoding_JS(params, state)
    end
end