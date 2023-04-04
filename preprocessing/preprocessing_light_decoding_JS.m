% New preprocessing script/function(HPC) to prepare input for decoding analysis:
% We want a lighter preprocessing to avoid spurious temporal displacements
% (i.e., no lowpass filter, only 0.01Hz highpass filter).
% This script loops through all 30 participants, calls three functions adapted from Stani's, plus select the right
% epochs and interpolate channels. It saves a new file after each step described below.

%% I will run it on HPC, i.e., participants will be ran in parallel so no need for a loop.
function preprocessing_light_decoding_JS(params, state)

% 1) ASSIGN FOLDERS

server = 1; % 1 = running on server, other = running on laptop

if server == 1
    basefolder = '/home/js2715/';
    scriptfolder = [basefolder, 'metacognition/'];
    datafolder = [basefolder, 'rds/rds-tb419-bekinschtein/Joaquim/newPreprocessingData/'];
    resultfolder = [basefolder, 'rds/rds-tb419-bekinschtein/Joaquim/DATA (see Yanzhis folder)/READY/newPreprocessedDataDecoding/']; % the READY folder is where I save all prepared data
    previousfolder = '/home/js2715/rds/rds-tb419-bekinschtein/Joaquim/DATA (see Yanzhis folder)/READY/FINAL_ANALYSES_MANUSCRIPT/PD/';
    behavfolder = [previousfolder, 'CLEAN_BEHAV/'];
    scriptfolder2 = [scriptfolder, 'preprocessing_ERP_Stani'];
    % subject = params{1,1}; % retrieve the subject's number -- list of subjects available in main() function
    mfffolder = [scriptfolder2, '/mffmatlabio-3315d55b9fc95a4bb99e6f7002f0c86a7ac9c0e4'];
else
%     subject = '105';
%     state = 'W';
    basefolder = 'C:\Metacognition_Project\';
    scriptfolder = [basefolder, 'SCRIPTS\metacognition\'];
    datafolder = [basefolder, 'SCRIPTS\metacognition\preprocessing_ERP_Stani'];
    % datafolder = "C:\Metacognition_Project\SCRIPTS\metacognition\preprocessing_ERP_Stani\W105.mff";
%     resultfolder = [basefolder, 'SCRIPTS\metacognition\preprocessing_ERP_Stani\test\'];
    resultfolder = 'C:\Users\strei\OneDrive - University of Cambridge\Stani\Joaquim_EEGpreprocessing';
    previousfolder = [basefolder, 'SCRIPTS\metacognition\preprocessing_ERP_Stani\old'];
    behavfolder = previousfolder;
    scriptfolder2 = [scriptfolder, 'preprocessing_ERP_Stani'];
    mfffolder = [scriptfolder2, '\mffmatlabio-3315d55b9fc95a4bb99e6f7002f0c86a7ac9c0e4'];
end

addpath(scriptfolder)
addpath(datafolder)
addpath(resultfolder)
addpath(scriptfolder2)
addpath(mfffolder)
% genpath(mfffolder)
% genpath(datafolder)

%subject = params; % laptop
subject = params{1,1}; % hpc

basename = [state, subject, '.mff'];


%% step 1: downsample to 500Hz, exclude peripheral channels, light highpass filter, save new EEG file
cd(scriptfolder2)
dataimport_newfilt_JS(subject, basename, state, datafolder, resultfolder, mfffolder)
    
%% step 2: epoching, baseline correction, rereferencing, save EEG file
epochdata_JS(subject, basename, state, resultfolder)

%% step 3: select the correct epochs, save EEG file
% load selected epochs as a vector
behav_data = select_epochs(subject, state, resultfolder, behavfolder);
    
%% step 4: interpolation 
% I could save EEG.history from all subjects in one
% file and then create a vector with channels + subjects to automatize the
% interpolation. If not possible, then interpolated channels can be found
% manually using the EEG.history command.

% find_interpolatchan()
 
% history = EEG.history;
% save("history.mat", "history")

%% step 5
% A second loop to interpolate once we have the history vector (or in
% parallel on HPC).

% interpolate_newchan()

% for participant = 1:participants
%     EEG = pop_interp(EEG, bad_chan(n));

%% additional steps to prepare data for decoding

% % 9) SAME TRIALS ARE REJECTED FROM THE EEG DATA (to double-check, the initial problem I got was from here)
% cd(datafolder) % go back to data folder
% align_behav_eeg(behav_data, eeg_file, subject, state, halfway_datafolder, datafolder);

% 10) CHANGING THE EVENT CODES FOR TONE/CONE
cd(resultfolder) % go where the data is
finalfolder = resultfolder;
halfway_datafolder = resultfolder;
behav_data = behav_data.behav_data;
modify_events(behav_data, subject, state, finalfolder, halfway_datafolder);

% end
