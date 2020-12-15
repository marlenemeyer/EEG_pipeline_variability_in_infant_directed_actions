function S_EEGMotionese_ReReferencing(INFO, subj, data2use)
%RE-REFERENCE THE DATA : 
%Linked-mastoid reference
cfg = [];
cfg.channel     = 'all';
cfg.reref       = 'yes';
cfg.implicitref = 'M1';           % the implicit (non-recorded) reference channel is added to the data representation
cfg.refchannel  = {'M1', 'TP10'}; % the average of these channels is used as the new reference, note that channel corresponds to the right mastoid (M2)
cleaned_data       = ft_preprocessing(cfg, data2use);

save([INFO.PATHS.Dir_Output 'P' int2str(subj) 'cleaned_data'], 'cleaned_data')
