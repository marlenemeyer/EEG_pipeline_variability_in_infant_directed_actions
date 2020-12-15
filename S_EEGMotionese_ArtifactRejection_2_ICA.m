function S_EEGMotionese_ArtifactRejection_2_ICA(INFO, subj, data2use, Output_preproc)


%% PERFORM ICA
goodchannel=Output_preproc.gooddchannel;
data2use = rmfield(data2use,'sampleinfo');

%PERFORM ICA NEEDED TO REMOVE EYE ARTIFACTS
cfg        = [];
cfg.channel=goodchannel;
cfg.method = 'runica';
cfg.demean = 'no';     
comp = ft_componentanalysis(cfg, data2use);


%% REJECT ICA COMPONENTS 
%Display the Subject name
fprintf('\n')
disp('------------------')
disp (['Artifact Rection: Rejecting ICA components for Subject: ' int2str(subj)])
disp('------------------')
fprintf('\n')

% topoplot
cfg = [];
cfg.component = [1:20];       % specify the component(s) that should be plotted
cfg.layout    = INFO.SUBJ.Eleclayout; % specify the layout file that should be used for plotting
cfg.comment   = 'no';
cfg.zlim      = 'maxabs';

ft_topoplotIC(cfg, comp)

disp('')
input('Press Enter to continue')

% timecourse plot
%In the end, plot the time course of all components again to check
%whether the components you want to remove indeed look like artifacts
%over time

cfg = [];
cfg.layout = INFO.SUBJ.Eleclayout; % specify the layout file that should be used for plotting
cfg.viewmode = 'component';
ft_databrowser(cfg, comp)

disp('')
input('Press Enter to continue')

%% Remove the bad components
% Remove the bad components and backproject the data

rejcom=[];
yn=input('Do you want to reject components? [y/n]','s');
if strcmp(yn,'y')==1
    s=1;
    prompt = 'Which component do you want to reject [enter number between 1 and n]';
    rejcom(1) = input(prompt);
    t=2;
elseif strcmp(yn,'n')==1
    s=0;
else
    error ('Not a valid input')
end

while s==1
    yn=input('Do you want to reject another component? [y/n]','s');
    if strcmp(yn,'y')==1
        prompt = 'Which component do you want to reject? [enter number between 1 and n]';
        rejcom(t)=input(prompt);
        t=t+1;
    elseif strcmp(yn,'n')==1
        s=0;
    else
        error ('Not a valid input, starting again')
    end
end

close all
disp('')
disp('Rejecting the following components')
rejcom
disp('')
yn=input('Press y to continue and n to stop','s')
if strcmp(yn,'y')==1
    
elseif strcmp(yn,'n')==1
    error ('Not the correct components, starting again')
else
    error ('Not a valid input, starting again')
end

if ~isempty(goodchannel)
    %Select part of the data (disregard the NaNs for reconstruction)
    include=find(ismember(data2use.label,goodchannel));
    exclude=find(~ismember(data2use.label,goodchannel));
    tempdata=data2use;
    for trl=1:length(tempdata.trial)
        tempdata.trial{1,trl}(exclude,:)=[];
        tempdata.label=goodchannel;
    end
else
    tempdata=data2use;
end

%Perform reconstruction
cfg = [];
cfg.component = rejcom; % to be removed component(s)
cfg.channel = goodchannel;
cfg.demean= 'no';
tempcleandata = ft_rejectcomponent(cfg, comp, tempdata);

if ~isempty(goodchannel)
    %Include the original data in here again
    cleandata=data2use;
    for trl=1:length(cleandata.trial) %for all trials
        in=1;
        for ri=1:size(cleandata.trial{1,trl},1) %for all channels
            if isnan(cleandata.trial{1,trl}(ri,1))==0 %if its not a missing channel, replace, otherwise do nothing
                cleandata.trial{1,trl}(ri,:)= tempcleandata.trial{1,trl}(in,:);
                in=in+1;
            else
            end
        end
    end
else
    cleandata=tempcleandata;
end
ica_rejected_data = cleandata;
Output_preproc.rejcom = rejcom;

%save the rejected components
save([INFO.PATHS.Dir_Output 'P' int2str(subj) 'Output_preproc'],'Output_preproc');
%save the cleaned data
save([INFO.PATHS.Dir_Output 'P' int2str(subj) 'ica_rejected_data'], 'ica_rejected_data');

