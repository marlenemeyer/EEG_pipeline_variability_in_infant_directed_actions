function S_EEGMotionese_ArtifactRejection_1(INFO, subj, data2use)

%First CHANNEL REJECTION AND REJECTION OF VERY NOISY TRIALS
%Trial View
cfg                = [];
cfg.method         = 'trial';  % all channel per trial
cfg.keepchannel    = 'nan';    % when rejecting channels, values are replaced by NaN
cfg.alim           = 1e2;      % 
data_artifact_1   =  ft_rejectvisual(cfg,data2use);


%NOTE DOWN BAD CHANNELS FOR LATER INTERPOLATION 
i=1;
j=1;
badchannel={};
goodchannel={};
for row=1:size(data_artifact_1.trial{1,1},1)
    number=(data_artifact_1.trial{1,1}(row,1));
    if isnan(number)==1
        badchannel(i,1)=data_artifact_1.label(row,1);
        i=i+1;
    else
        goodchannel(j,1)=data_artifact_1.label(row,1);
        j=j+1;
    end
end
clear i number row

% Save the preprocessing information of which channels/trials have been rejected
%1. channels:

Output_preproc.badchannel=badchannel;
Output_preproc.gooddchannel =goodchannel;
save([INFO.PATHS.Dir_Output 'P' int2str(subj) 'Output_preproc'],'Output_preproc');
save([INFO.PATHS.Dir_Output 'P' int2str(subj) 'data_artifact_1'], 'data_artifact_1')
