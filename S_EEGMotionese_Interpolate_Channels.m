function S_EEGMotionese_Interpolate_Channels(INFO, subj, data2use, Output_preproc)

fprintf('\n')
disp('------------------')
disp (['Analysis Part4: Interpolation, Rejection of trials, Rereferencing: ' int2str(subj)])
disp('------------------')
fprintf('\n')

goodchannel=Output_preproc.final_goodchannel;
badchannel=Output_preproc.final_badchannel;

%INTERPOLATE THE DATA

if ~isempty(badchannel)
    %prepare layout
    cfg         = [];
    cfg.layout  = INFO.SUBJ.Eleclayout;
    layout = ft_prepare_layout(cfg, data2use);
    
    %prepare neighborhood file
    if ~exist([INFO.PATHS.Dir_Output 'P' int2str(subj) 'neighbours.mat'],'file')
        cfg               = [];
        cfg.method        = 'triangulation';
        cfg.layout        = layout;
        neighbours = ft_prepare_neighbours(cfg, data2use);
        save([INFO.PATHS.Dir_Output 'P' int2str(subj) 'neighbours.mat'],'neighbours');
    else
        load([INFO.PATHS.Dir_Output 'P' int2str(subj) 'neighbours.mat'],'neighbours');
    end
    
    %perform interpolation of bad channels
    cfg                = [];
    cfg.method         = 'nearest';
    cfg.badchannel     = badchannel;
    cfg.missingchannel =[];
    cfg.layout         = layout;
    cfg.neighbours     = neighbours;
    [data_interpolated] = ft_channelrepair(cfg, data2use);
    
    save([INFO.PATHS.Dir_Output 'P' int2str(subj) 'data_interpolated'],'data_interpolated');
else
    data_interpolated = data2use;
    save([INFO.PATHS.Dir_Output 'P' int2str(subj) 'data_interpolated'],'data_interpolated');
end