cond_names = INFO.COND.experimental_cond_names;
for s=1:length(INFO.SUBJ.subj_include4FFT)%For each Subject
    subj = INFO.SUBJ.subj_include4FFT(s);
    disp('----');       disp('----');
    disp(['loading data from subject ', int2str(subj)]);
    disp('----');       disp('----');
    
    load([INFO.PATHS.Dir_Output 'P' int2str(subj) 'cleaned_data'])
    data2use = cleaned_data;
    for cond = 1:length(cond_names)
        
        search_for_this_cond = INFO.MARKER.(cond_names{cond});
        trial_cond.(['S' int2str(subj)]).(cond_names{cond}) = struct;
        trial_cond.(['S' int2str(subj)]).(cond_names{cond}) = find(ismember(data2use.trialinfo(:,1),search_for_this_cond)==1);
        
    end
end

for s=1:length(INFO.SUBJ.subj_include4FFT)%For each Subject
    subj = INFO.SUBJ.subj_include4FFT(s);
    amount_trls_left(s,1) = subj;
    for cond = 1:length(cond_names)
        amount_trls_left(s,cond+1) = length(trial_cond.(['S' int2str(subj)]).(cond_names{cond}));
    end
end


for s=1:length(INFO.SUBJ.subj_EEG)%For each Subject
    subj = INFO.SUBJ.subj_EEG(s);
    disp('----');       disp('----');
    disp(['loading data from subject ', int2str(subj)]);
    disp('----');       disp('----');
    
    load([INFO.PATHS.Dir_Output 'P' int2str(subj) 'cleaned_data'])
    data2use = cleaned_data;
    for cond = 1:length(cond_names)
        
        search_for_this_cond = INFO.MARKER.(cond_names{cond});
        trial_cond.(['S' int2str(subj)]).(cond_names{cond}) = struct;
        trial_cond.(['S' int2str(subj)]).(cond_names{cond}) = find(ismember(data2use.trialinfo(:,1),search_for_this_cond)==1);
        
    end
end