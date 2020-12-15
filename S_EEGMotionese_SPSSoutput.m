function S_EEGMotionese_SPSSoutput(INFO)

load([INFO.PATHS.Dir_Output 'GA_FFT'], 'GA_FFT');

%% initializing variables
cond_names = INFO.COND.experimental_cond_names;

foi = INFO.FREQ.frequency_range;
for p = 1:length(INFO.SUBJ.subj_include4FFT)
   
        channnels_oI = INFO.CHANNELS;
        chan1 = match_str(GA_FFT.normal.label,channnels_oI);
        
        for cond= 1:length(cond_names)            
            freq_sel = GA_FFT.(cond_names{cond}).freq <= foi(2) & GA_FFT.(cond_names{cond}).freq >= foi(1);           
            SPSS_output(p,cond) = mean(squeeze(mean(GA_FFT.(cond_names{cond}).powspctrm(p,chan1,freq_sel))));         
            SPSS_output_header{1,cond} = ([ cond_names{cond} '_Elecs_' [channnels_oI{:}] '_' num2str(foi(1)) '_' num2str(foi(2)) 'Hz']);
        end
        
end
save([INFO.PATHS.Dir_Output 'SPSS_output'], 'SPSS_output');
save([INFO.PATHS.Dir_Output 'SPSS_output_header'], 'SPSS_output_header');

h= figure;
boxplot(SPSS_output)
title(['Electrodes: ' [channnels_oI{:}]])
saveas(h,[INFO.PATHS.Dir_Output '\plots\Boxplot_Elecs_' [channnels_oI{:}] '_' num2str(foi(1)) '_to_' num2str(foi(2)) 'Hz'], 'fig');
saveas(h,[INFO.PATHS.Dir_Output '\plots\Boxplot_Elecs_' [channnels_oI{:}] '_' num2str(foi(1)) '_to_' num2str(foi(2)) 'Hz'], 'bmp');

