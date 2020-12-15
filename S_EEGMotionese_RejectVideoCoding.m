function S_EEGMotionese_RejectVideoCoding(INFO)


load([INFO.PATHS.Dir_Input 'action_markers.mat'])

for s=1:length(INFO.SUBJ.subj_EEG)%For each Subject
    subj = INFO.SUBJ.subj_EEG(s);
    
    %load the coded file of this participant
    [NUM, ~, ~] = xlsread([INFO.PATHS.Dir_Coded 'Coding_Scheme_P' num2str(subj) '_coded.xls']);
    %first select the experimental trials - so the 5 action-goal trials within each
    %video
    att_coded = [];
    for row = 1 : size(NUM,1)
        if ~isempty(find(NUM(row,1) == action_markers)) %continues if value refers to one of the 5 actions
            att_coded = [att_coded; NUM(row,:)];
        end
    end
    %combine attention info with EEG trial info in order to exclude the trials
    load([INFO.PATHS.Dir_Output 'P' num2str(subj) 'data.mat']);
    check_markers = [];
    if size(data.cfg.trl,1) == size(att_coded,1)
        for i = 1 : size(att_coded,1)
            coded_trl = num2str(att_coded(i,1));
            
            if strcmp(num2str(data.cfg.trl(i,4)),coded_trl(1:3)) % double-check: do these trials match in their marker
                check_markers(i,1) = 0;
            else
                check_markers(i,1) = 1;
                warning('video coding does not have same codes as EEG trials')
            end
        end      
    else
        warning('video coding does not have same number as EEG trials')
    end
    if sum(check_markers)>0 % extra double-check
        warning('video coding does not have same codes as EEG trials')
    end
    % choose only the trials that are valid by redefining the trials and saving
    % the new structure under data_validtrials
    variable_first_trl = (INFO.MARKER.variable(:)*10000)+3; % create marker for variable first trials that match the video coding
    idx_valid_trials = find((att_coded(:,2)==1) & (~ismember(att_coded(:,1),variable_first_trl)))'; % choose only trials in which the participant is looking and which is NOT the first trial of the variable video
    
    
    cfg = [];
    cfg.trials = idx_valid_trials;
    data_validtrials = ft_redefinetrial(cfg, data);
    
    % amount of trials
    amount_trials(1,1) = subj; % save subject number
    amount_trials(1,2) = length(att_coded(:,2)); % save total amount of trials
    amount_trials(1,3) = length(find(att_coded(:,2)==0)); % save amount of invalid  trials based on attention coding
    
    save([INFO.PATHS.Dir_Output 'P' int2str(subj) 'data_validtrials',], 'data_validtrials')
    save([INFO.PATHS.Dir_Output 'amount_trials_P' int2str(subj)], 'amount_trials')
end

amount_trials_header = {'subjnr', 'original_total_amount_of_trials','excluded_visual_coding'};
save([INFO.PATHS.Dir_Output 'amount_trials_header',], 'amount_trials_header')