function S_EEGMotionese_ArtifactRejection_3(INFO, subj, data2use)

%REJECT TRIALS, BASED ON SUMMARY OR BASED ON TRIAL VIEW
cfg                       = [];
cfg.method                = 'summary';                              % summary mode
cfg.alim                  = 1e2;                                    % limits the y-axis
cfg.keepchannel           = 'nan';                                  % when rejecting channels, values are replaced by NaN
data_artifact_3           = ft_rejectvisual(cfg,data2use);

save([INFO.PATHS.Dir_Output 'P' int2str(subj) 'data_artifact_3'], 'data_artifact_3')