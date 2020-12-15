function [trl,event,cond_info] = S_EEGMotionese_Trialfun_actiongoals(cfg)

%% Read in the data and select based on markers
% read the header information and the events from the data
hdr   = ft_read_header(cfg.dataset);
event = ft_read_event(cfg.dataset);

% search for "trigger" events
value  = {event(find(strcmp(cfg.trialdef.eventtype, {event.type}))).value}';
sample = [event(find(strcmp(cfg.trialdef.eventtype, {event.type}))).sample]';

% determine the number of samples before and after the trigger
pretrig  = -round(cfg.trialdef.prestim  * hdr.Fs);
posttrig =  round(cfg.trialdef.poststim * hdr.Fs);

load([cfg.INFO.PATHS.Dir_Input 'stim_videos_msec_info_actiongoals.mat'])

trl = [];
cond_info = [];
cond_num_info = [];
for j = 1:(length(value))
    
    
    if ismember(value(j),cfg.trialdef.eventvalue) ==1 % if this is our marker of interest
        idx_current_marker = find(strcmp(value(j),cfg.trialdef.eventvalue)==1);
        for goals = 5:9
            goal_info_sec = stim_videos_msec_info_actiongoals(idx_current_marker,goals); % goal_amp info of the stim video in sec
            goal_info_samples = goal_info_sec * hdr.Fs; % goal_amp info of the stim video in sample points with respect to stim onset
            trlbegin = sample(j) + goal_info_samples + pretrig;
            trlend   = sample(j) + goal_info_samples + posttrig;
            offset   = pretrig;
            newtrl   = [trlbegin trlend offset str2double(value{j}(2:end))];
            trl      = [trl; newtrl];
            cond_info= [cond_info; str2double(value{j}(2:end))];
            cond_num_info = [cond_num_info; (goals - 4)];
        end
    end
end
save([cfg.INFO.PATHS.Dir_Output 'P' int2str(cfg.subj) '_experimental_cond_info',], 'cond_info', 'cond_num_info')