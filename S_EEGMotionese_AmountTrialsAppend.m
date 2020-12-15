function S_EEGMotionese_AmountTrialsAppend(INFO)

load([INFO.PATHS.Dir_Output 'amount_trials_header']);

amount_trials_all = ones(size(amount_trials_header))*88888888;
for s=1:length(INFO.SUBJ.subj_include4FFT)%For each Subject
    subj = INFO.SUBJ.subj_include4FFT(s);
    ['Participant: ' int2str(subj)]
    load([INFO.PATHS.Dir_Output 'amount_trials_P' int2str(subj)]);
    amount_trials_all = [amount_trials_all; amount_trials];    
    clear amount_trials
end

save([INFO.PATHS.Dir_Output 'amount_trials_all'], 'amount_trials_all')
amount_trials_all_with_header = [amount_trials_header; num2cell(amount_trials_all)];
save ([INFO.PATHS.Dir_Output 'amount_trials_all_with_header'], 'amount_trials_all_with_header');