function S_EEGMotionese_ArtifactRejection_4(INFO, subj, data2use)

cfg                = [];
cfg.method         = 'channel';  % all channel per trial
cfg.keepchannel    = 'nan';    % when rejecting channels, values are replaced by NaN 
cfg.alim           = 1e2;
data_artifact_4   =  ft_rejectvisual(cfg,data2use);

save([INFO.PATHS.Dir_Output 'P' int2str(subj) 'data_artifact_4'], 'data_artifact_4')
