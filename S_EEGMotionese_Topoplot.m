function S_EEGMotionese_Topoplot(INFO)

%Initialize variables
load([INFO.PATHS.Dir_Output 'GA_FFT'], 'GA_FFT');
GA = GA_FFT;
cond_names = INFO.COND.experimental_cond_names;

h= figure;
for cond= 1:length(cond_names)

    subplot(1,3,cond)
    cfg=[];
    cfg.layout = INFO.SUBJ.Eleclayout;
    cfg.xlim = INFO.FREQ.frequency_range;
    cfg.zlim = INFO.PLOTTING.topo.zlim;
    cfg.marker = 'labels';
    cfg.style = 'straight';
    
    ft_topoplotER(cfg, GA_FFT.(cond_names{cond}))
    title(cond_names{cond})
end

saveas(h,[INFO.PATHS.Dir_Output '\plots\Topoplot_' num2str(INFO.FREQ.frequency_range(1)) '_to_' num2str(INFO.FREQ.frequency_range(2)) 'Hz'], 'fig');
saveas(h,[INFO.PATHS.Dir_Output '\plots\Topoplot_' num2str(INFO.FREQ.frequency_range(1)) '_to_' num2str(INFO.FREQ.frequency_range(2)) 'Hz'], 'bmp');