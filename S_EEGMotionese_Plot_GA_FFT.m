function S_EEGMotionese_Plot_GA_FFT(INFO)
%% Plot
%Initialize variables
load([INFO.PATHS.Dir_Output 'GA_FFT'], 'GA_FFT');
GA = GA_FFT;

upper_ylim = INFO.PLOTTING.upper_ylim;
frequency_ranges = INFO.PLOTTING.frequency_ranges;
cond_names = INFO.COND.experimental_cond_names;

color_normal = 1/255*[64,224,208];
color_high = 1/255*[65,105,225];	
color_variable = 1/255*[199,21,133];

%% channel of interest
for chan_group = 1:size(INFO.CHANNEL_GROUPS,1)
    
    channnels_oI = INFO.CHANNEL_GROUPS{chan_group};
    chan1 = match_str(GA.normal.label,channnels_oI);
    for i = 1:length(frequency_ranges)
        
        foi = frequency_ranges{i};
        colour_code = {color_normal, color_high,color_variable};
        shaded_area = {color_normal,color_high,color_variable,[0, 1, 0]};
        
        h= figure;
        for cond= 1:length(cond_names)  
            
            freq_sel = GA_FFT.(cond_names{cond}).freq <= foi(2) & GA_FFT.(cond_names{cond}).freq >= foi(1);
            se1 =   mean(squeeze(std(GA_FFT.(cond_names{cond}).powspctrm(:,chan1,freq_sel))) / sqrt(length(INFO.SUBJ.subj_EEG)));
            mean1 = mean(squeeze(mean(GA_FFT.(cond_names{cond}).powspctrm(:,chan1,freq_sel))));        
            Hz = GA_FFT.(cond_names{cond}).freq(freq_sel);
            plot(Hz, squeeze(mean1), 'Color', colour_code{cond}, 'LineWidth', 2); hold on;
            patch([Hz, fliplr(Hz)], [mean1-se1, fliplr(mean1+se1)],  shaded_area{cond}, 'edgecolor', 'none', 'FaceAlpha', .3);
            
            ylabel('Power [V2]');
            xlabel('Frequency [Hz]');
            ylim([0 upper_ylim(i)])
            hold on
            line(foi, [0 0])
        end
        
        title([' Freq: ',int2str(foi(1)),' to ', int2str(foi(2)),' Hz' ' Channels: ' [channnels_oI{1:end}] ' Colorcode: ' [cond_names{:}] ' = ' (colour_code{1:length(cond_names)}) ])

        saveas(h,[INFO.PATHS.Dir_Output '\plots\GA_fig',channnels_oI{1:end},'_',int2str(i)], 'fig');
        saveas(h,[INFO.PATHS.Dir_Output '\plots\GA_fig',channnels_oI{1:end},'_',int2str(i)], 'bmp');
    end
end