function S_EEGMotionese_GA_FFT(INFO)

%% initializing variables
cond_names = INFO.COND.experimental_cond_names;
load([INFO.PATHS.Dir_Output 'FFTall'], 'FFTall');
for cond = 1:length(cond_names)
    GA_FFT.(cond_names{cond}) = {};
end

%% make grand average of the FFT
for cond= 1:length(cond_names)
    cfg=[];
    cfg.parameter = 'powspctrm';
    cfg.keepindividual = 'yes';
    GA_FFT.(cond_names{cond}) = ft_freqgrandaverage(cfg, FFTall.(cond_names{cond}){:,1});
end
save([INFO.PATHS.Dir_Output 'GA_FFT'], 'GA_FFT');
disp("--------------Grand Average of the FFT is calculated.------------------")
