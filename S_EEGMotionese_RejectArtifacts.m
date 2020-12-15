function S_EEGMotionese_RejectArtifacts(INFO)

for s=1:length(INFO.SUBJ.subj_EEG)%For each Subject
    subj = INFO.SUBJ.subj_EEG(s);
    
    load([INFO.PATHS.Dir_Output 'P' int2str(subj) 'data_validtrials'])
    data2use = data_validtrials;
    
    % exclude massive artifacts manually to pre-clean for ICA
    S_EEGMotionese_ArtifactRejection_1(INFO, subj, data2use);
    clear data2use
    load([INFO.PATHS.Dir_Output 'P' int2str(subj) 'data_artifact_1'])
    load([INFO.PATHS.Dir_Output 'P' int2str(subj) 'Output_preproc'])
    data2use = data_artifact_1;
    
    % run ICA and determine components to reject
    S_EEGMotionese_ArtifactRejection_2_ICA(INFO, subj, data2use, Output_preproc);
    
    % artifact rejection 3rd round: summary view
    clear data2use
    load([INFO.PATHS.Dir_Output 'P' int2str(subj) 'ica_rejected_data']);
    data2use = ica_rejected_data;
    clear Output_preproc
    load([INFO.PATHS.Dir_Output 'P' int2str(subj) 'Output_preproc'])
    S_EEGMotionese_ArtifactRejection_3(INFO, subj, data2use);
    
    % artifact rejection 4th round: channel view
    clear data2use
    load([INFO.PATHS.Dir_Output 'P' int2str(subj) 'data_artifact_3'])
    data2use = data_artifact_3;
    S_EEGMotionese_ArtifactRejection_4(INFO, subj, data2use);
    
    clear data2use
    load([INFO.PATHS.Dir_Output 'P' int2str(subj) 'data_artifact_4'])
    data2use = data_artifact_4;
    
    %NOTE DOWN BAD CHANNELS FOR LATER INTERPOLATION 
    
    load([INFO.PATHS.Dir_Output 'P' int2str(subj) 'data_artifact_4'])
    i=1;
    j=1;
    badchannel={};
    goodchannel={};
    for row=1:size(data_artifact_4.trial{1,1},1)
        number=(data_artifact_4.trial{1,1}(row,1));
        if isnan(number)==1
            badchannel(i,1)=data_artifact_4.label(row,1);
            i=i+1;
        else
            goodchannel(j,1)=data_artifact_4.label(row,1);
            j=j+1;
        end
    end
    clear i number row
    
    % Save the preprocessing information of which channels/trials have been rejected
    %1. channels:
    
    Output_preproc.final_badchannel=badchannel;
    Output_preproc.final_goodchannel =goodchannel;
    save([INFO.PATHS.Dir_Output 'P' int2str(subj) 'Output_preproc'],'Output_preproc');
    
    % interpolate missing channels
    S_EEGMotionese_Interpolate_Channels(INFO, subj, data2use, Output_preproc);
    
    %% now re-reference data
    clear data2use
    load([INFO.PATHS.Dir_Output 'P' int2str(subj) 'data_interpolated']);
    data2use = data_interpolated;
    S_EEGMotionese_ReReferencing(INFO, subj, data2use);
    
    %% amount of trials
    load([INFO.PATHS.Dir_Output 'amount_trials_P' int2str(subj)]);  
    amount_trials(1,4) =  size(data2use.trialinfo,1); % amount of trials left after artifact rejection
    amount_trials(1,5) = (amount_trials(1,2)-amount_trials(1,3))- amount_trials(1,4); % amount of trials rejected based on artifact rejection    
    save([INFO.PATHS.Dir_Output 'amount_trials_P' int2str(subj)], 'amount_trials')
    
end
load([INFO.PATHS.Dir_Output 'amount_trials_header']);
amount_trials_header(4)= {'amount_trials_after_artifactrej'};
amount_trials_header(5)= {'trials_rejected_artifactrej'};
save([INFO.PATHS.Dir_Output 'amount_trials_header'],'amount_trials_header');