%%% Analysis S_EEGMotionese: INITIATION OF VARIABLES AND PATHS
% last updated 27.9.2016


function [p_info]=S_EEGMotionese_Info()
% Directory of analysis and Fieldtrip

p_info.PATHS.Dir=('\Analysis\Matlab\');
p_info.PATHS.Dir_EEG= ('\Analysis\Matlab\EEG_raw_data\');
p_info.PATHS.Dir_CodingOutput= ('\Analysis\Matlab\CodingOutput\');
p_info.PATHS.Dir_Output = ('\Analysis\Matlab\Output\');
p_info.PATHS.Dir_Input = ('\Analysis\Matlab\Input\');
p_info.PATHS.Dir_Coded = ('\Analysis\Matlab\Coded\');


%% Information about EEG markers

p_info.MARKER.type         = 'Stimulus';
p_info.MARKER.all_markers={'S101','S102','S103','S104','S105','S106','S107','S108','S109','S110','S111','S112','S113','S114','S115','S116','S117','S118', ... %% Intro Videos
    'S201','S202','S203','S204','S205','S206','S207','S208','S209','S210','S211','S212','S213','S214','S215','S216','S217','S218'...    %% Experimental Videos
    'S 81','S 82','S 83','S 84'...                                                                                                          %% Peek-a-boo Videos
    'S 95'};                   
p_info.MARKER.experimental_markers={'S201','S202','S203','S204','S205','S206','S207','S208','S209','S210','S211','S212','S213','S214','S215','S216','S217','S218'}; %% Experimental Videos
p_info.MARKER.intro = [101:118];
p_info.MARKER.experimental = [201:218];
p_info.MARKER.peekaboo = [81:84];
p_info.MARKER.fixcross = [95];

p_info.MARKER.normal = [201, 207, 213];
p_info.MARKER.high = [202, 208, 214];
p_info.MARKER.variable = [203:206, 209:212, 215:218];

%% Marker Info
p_info.COND.experimental_cond_names = {'normal', 'high', 'variable'};

%% Subjects
p_info.SUBJ.Eleclayout     = [p_info.PATHS.Dir_Input, 'elec1010.lay'];
p_info.SUBJ.subj_coding = [1,5,7,8,9,10,13,14,15,17,22,23,24,26,28,29,30,32,35,36,37,38,40,41,42,43,44,45,46,47]; %FULL SAMPLE EXPERIMENTAL PARTICIPANTS
p_info.SUBJ.subj_EEG = [1,5,7,8,9,10,13,14,15,17,22,23,24,26,28,29,30,32,35,36,37,38,40,41,42,43,44,45,46,47];%
p_info.SUBJ.subj_include4FFT = [1,7,9,10,14,15,17,22,23,24,26,28,29,30,32,35,36,40,41,42,44,45,46];% paricipants with at least 8 arftifact-free trials per condition
p_info.SUBJ.subj_peekaboo_coding = [4,12,16,18,19,21,25,27,31,33]; %31's data might not be good enough

%% Defining variables for plotting
p_info.PLOTTING.upper_ylim = [20,30];
p_info.PLOTTING.frequency_ranges = {[2,15]};  % frequency of interest
p_info.PLOTTING.topo.zlim = [0 12];

%% Frequency of interest
p_info.FREQ.frequency_range = [4 5];
%% Channels of interest
p_info.CHANNELS = {'Fz','FCz','Cz'};
p_info.CHANNEL_GROUPS = {{'Fz','Fz'};{'FCz','FCz'};{'Cz','Cz'}};
p_info.CHANNELS_4_MODELLING = {'Fz','FCz','Cz'};
