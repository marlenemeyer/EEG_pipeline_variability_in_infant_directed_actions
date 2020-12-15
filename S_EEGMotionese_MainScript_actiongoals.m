%%% Analysis S_EEGMotionese: Main Script
clear all
close all

%% READ IN INFO FILE AND SET PATHS

%Go to Info directory
cd([ '\Analysis\Matlab']);
INFO = S_EEGMotionese_Info();

%Restore FT defaults
addpath \fieldtrip-20190410
ft_defaults

%% START ANALYSIS

%Define an output folder
foldout=INFO.PATHS.Dir_Output;

%Define the different paths
EEGpath=INFO.PATHS.Dir_EEG;

% segmented EEG into trials based on post-defined markers
S_EEGMotionese_DefineTrial_actiongoals(INFO);

% select only those trials that were coded as infants looking at the screen (based on video coding)
S_EEGMotionese_RejectVideoCoding(INFO);

% reject artifacts
S_EEGMotionese_RejectArtifacts(INFO);

%% run this after artifact rejection
S_EEGMotionese_Intermediate_trial_overview % to have an look at which participants have enough trials to be included in further analysis

% separate data by trials and calculate FFT
S_EEGMotionese_FFT_actiongoals(INFO);

% put all amount trial information together in one file
S_EEGMotionese_AmountTrialsAppend(INFO)

% calculating grand average
S_EEGMotionese_GA_FFT(INFO);

% plot the GA FFT
S_EEGMotionese_Plot_GA_FFT(INFO);

close all
% make a topoplot of all conditions
S_EEGMotionese_Topoplot(INFO)

close all
% prepare SPSS output and make a boxplot
S_EEGMotionese_SPSSoutput(INFO)

% prepare SPSS output for individual channels/ several channel groups and make a boxplot
S_EEGMotionese_SPSSoutput_individual_chans(INFO)
