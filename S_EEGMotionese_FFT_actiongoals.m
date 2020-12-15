function S_EEGMotionese_FFT_actiongoals(INFO)

%% initializing variables
cond_names = INFO.COND.experimental_cond_names;
load([INFO.PATHS.Dir_Output 'amount_trials_header']);
for cond = 1:length(cond_names)
    FFT_all.(cond_names{cond}) = {};
    amount_trials_header(5+cond)= cond_names(cond);%
end
save([INFO.PATHS.Dir_Output 'amount_trials_header'],'amount_trials_header');

%%
for s=1:length(INFO.SUBJ.subj_include4FFT)%For each Subject
    subj = INFO.SUBJ.subj_include4FFT(s);
    disp('----');       disp('----');
    disp(['loading data from subject ', int2str(subj)]);
    disp('----');       disp('----');
    
    load([INFO.PATHS.Dir_Output 'P' int2str(subj) 'cleaned_data'])
    data2use = cleaned_data;

    %detrend
    cfg = [];
    cfg.detrend = 'yes';
    cleandata_detrended = ft_preprocessing(cfg, data2use);
    save([INFO.PATHS.Dir_Output 'P' int2str(subj) 'cleandata_detrended'], 'cleandata_detrended');
    
    data2use= cleandata_detrended;
    
    FFT = struct();
    save([INFO.PATHS.Dir_Output 'P' int2str(subj) '_FFT'], 'FFT');
    clear FFT
    
    for cond = 1:length(cond_names)
        
        search_for_this_cond = INFO.MARKER.(cond_names{cond});
        trial_cond.(cond_names{cond}) = struct;
        trial_cond.(cond_names{cond}) = find(ismember(data2use.trialinfo(:,1),search_for_this_cond)==1);        
        
        disp('----');       disp('----');
        disp(['current condition is: --> ', (cond_names{cond})]);
        disp('----');       disp('----');
        
        %% FFT
        FFT.(cond_names{cond}) = {};
        
        cfg = [];
        cfg.trials         = trial_cond.(cond_names{cond});
        cfg.output         = 'pow';
        cfg.method         = 'mtmfft';
        cfg.taper          = 'hanning';
        cfg.toi            = [-1 .5];
        cfg.foilim         = [1 30];
        FFT.(cond_names{cond})= ft_freqanalysis(cfg, data2use);
        
        save([INFO.PATHS.Dir_Output 'P' int2str(subj) '_FFT'], 'FFT', '-append');
        save([INFO.PATHS.Dir_Output 'P' int2str(subj) '_FFT'], 'trial_cond', '-append');

        FFTall.(cond_names{cond}){s,1} =  FFT.(cond_names{cond});
        
        %% amount of trials
        load([INFO.PATHS.Dir_Output 'amount_trials_P' int2str(subj)]);        
        amount_trials(1,5+cond) =  length(cfg.trials); % amount of trials left after artifact rejection        
        save([INFO.PATHS.Dir_Output 'amount_trials_P' int2str(subj)], 'amount_trials')
        
    end
    
end

save([INFO.PATHS.Dir_Output 'FFTall'], 'FFTall');

