function S_EEGMotionese_DefineTrial_actiongoals(INFO)

for s=1:length(INFO.SUBJ.subj_EEG)%For each Subject
    subj = INFO.SUBJ.subj_EEG(s);
   
    close all    
    subjname= ['P' int2str(subj)];
    
    %Display the Subject name
    fprintf('\n')
    disp('------------------')
    disp (['Analysis Part1: Reading in Data for Subject: ' subjname])
    disp('------------------')
    fprintf('\n')
    
    %READ IN DATA
    filename = [INFO.PATHS.Dir_EEG 'P' int2str(subj) '.vhdr'];
    
    cfg=[];
    cfg.dataset                 = filename;
    cfg.trialdef.eventtype      = INFO.MARKER.type;        
    cfg.trialdef.eventvalue     = INFO.MARKER.experimental_markers;
    cfg.trialdef.prestim        = 1.5;                       % time before the period for the trials
    cfg.trialdef.poststim       = 1;                        % time after the period (both in seconds)
    cfg.INFO                    = INFO;
    cfg.subj                    = subj;
    cfg.trialfun                = 'S_EEGMotionese_Trialfun_actiongoals';
    cfg                         = ft_definetrial(cfg);
    
    
    cfg.bpfilter            = 'yes';  % band-pass filtering
    cfg.bpfreq              = [1 30]; % filter between 1-30 Hz
    cfg.padding             = 5;
    cfg.demean              = 'yes';  % whether to apply baseline correction
    data                    = ft_preprocessing(cfg);

    load([cfg.INFO.PATHS.Dir_Output 'P' int2str(cfg.subj) '_experimental_cond_info',])
    
    data.extra_cond_info(:,1) = cond_info; % save information about the trial type
    data.extra_cond_info(:,2) = cond_num_info; % and which occurrence the trial is within a video (e.g. 1st time stacking the ring)
    save([INFO.PATHS.Dir_Output 'P' int2str(cfg.subj) 'data',], 'data')
end