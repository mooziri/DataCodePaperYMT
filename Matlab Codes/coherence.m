%% initialize

%%%%%%%%%%%%%%% baseline corrected coherogram-chronux analysis %%%%%%%%%%%%%%%
clc; clear; close all
addpath(genpath('D:\projects\ob-pfc\Working memory (Y---maze)\Analyses'));

% define frequency bands
frequency = [30 160];
fs = 2000;      % sampling frequency
chn_ob = 1; chn_mpfc = 2;

load('Dataset_YMT_v01.mat');


%% coherence
% Settings Chronux
params.Fs = fs; % sampling frequency
params.fpass = frequency ; % band of frequencies to be kept
params.tapers = [2 3];%[3 5]; % taper parameters
params.pad = 2; % pad factor for fft
params.err = [0 0.05];
params.trialave = 0;
movingwin = [0.5 0.01]; %%%movingwin=[0.5 0.05];

%%%%% Trial type: Baseline %%%%%
rat_id = unique(Data.Rat_indx_baseline);
baseline_corrected_coherence_baseline=[];
for rat_i= 1:length(rat_id)
    base_rat_i=Data.Baseline(1,Data.Rat_indx_baseline==rat_id(rat_i));
    temp_coh_base=[];
    temp_trial_coh_base=[];
    
    for trial_i = 1:length(base_rat_i)
        coh_base=[];
        [coh_base,~,~,~,~,time_base,freq_base] = cohgramc(squeeze(base_rat_i{trial_i}(:,chn_ob)) ,...
            squeeze(base_rat_i{trial_i}(:,chn_mpfc))  , movingwin,params);
        
        temp_coh_base = cat(1,temp_coh_base,coh_base);
        temp_trial_coh_base{trial_i} = coh_base;
    end
    
    mean_coh_baseline(rat_i,:) = mean(temp_coh_base ,1);
    std_coh_baseline(rat_i,:) = std(temp_coh_base ,[],1);
    
    trial_base=[];
    for trial_i = 1:length(base_rat_i)
%     trial_base(trial_i,:) = ( mean(temp_trial_coh_base{trial_i},1) - mean_coh_baseline (rat_i,:) ) ./ std_coh_baseline (rat_i,:);
        trial_base(trial_i,:) =  mean(temp_trial_coh_base{trial_i},1) ./ mean_coh_baseline (rat_i,:)  ;

    end
    baseline_corrected_coherence_baseline = cat(1,baseline_corrected_coherence_baseline,trial_base);
end

%%%%% Trial type: Correct %%%%%
data = Data.Correct;
correct_indx = Data.Rat_indx_correct;
rat_id = unique(Data.Rat_indx_correct);
baseline_corrected_coherence_correct=[];
for rat_i= 1:length(rat_id)
   correct_rat_i=data(1,correct_indx==rat_id(rat_i));
    trial_corr=[];
    for trial_i = 1:length(correct_rat_i)
        coh_correct=[];
        [coh_correct,~,~,~,~,time_base,freq_base] = cohgramc(squeeze(correct_rat_i{trial_i}(:,chn_ob)) ,...
            squeeze(correct_rat_i{trial_i}(:,chn_mpfc))  , movingwin,params);
        
%     trial_corr(trial_i,:) = ( mean(coh_correct,1) - mean_coh_baseline (rat_i,:) ) ./ std_coh_baseline (rat_i,:);
        trial_corr(trial_i,:) = mean(coh_correct,1) ./ mean_coh_baseline (rat_i,:) ;

    end
    
    baseline_corrected_coherence_correct= cat(1,baseline_corrected_coherence_correct,trial_corr);
end


%%%%% Trial type: wrong %%%%%
data = Data.Wrong;
wrong_indx = Data.Rat_indx_wrong;
rat_id = unique(Data.Rat_indx_wrong);
baseline_corrected_coherence_wrong=[];
for rat_i= 1:length(rat_id)
   wrong_rat_i=data(1,wrong_indx==rat_id(rat_i));
    trial_wrong=[];
    for trial_i = 1:length(wrong_rat_i)
        coh_wrong=[];
        [coh_wrong,~,~,~,~,time_base,freq_base] = cohgramc(squeeze(wrong_rat_i{trial_i}(:,chn_ob)) ,...
            squeeze(wrong_rat_i{trial_i}(:,chn_mpfc))  , movingwin,params);
        
%     trial_wrong(trial_i,:) = ( mean(coh_wrong,1) - mean_coh_baseline (rat_i,:) ) ./ std_coh_baseline (rat_i,:);
    trial_wrong(trial_i,:) = mean(coh_wrong,1) ./ mean_coh_baseline (rat_i,:) ;
    
    end
    
    baseline_corrected_coherence_wrong= cat(1,baseline_corrected_coherence_wrong,trial_wrong);
end











%% plot; states
desired_band = [30 160];

% parameters
face_alpha_epm = 0.3; face_alpha_of = 0.5;
color_open = [255 178 102 0.5]; color_closed = [153 204 255 0.5]; color_baseline = [255 204 102 0.5];
figure(1)
c1 = ma_plot(freq_base, squeeze(baseline_corrected_coherence_correct), 1, color_open, 'sem', '-')
w1 = ma_plot(freq_base, squeeze(baseline_corrected_coherence_wrong)  , 1, color_closed, 'sem', '-')
b1 = ma_plot(freq_base, squeeze(baseline_corrected_coherence_baseline)  , 1, color_baseline, 'sem', '-')
legend([c1,w1,b1],{'Correct','Wrong','Baseline'})
title('chronux coherence')

 save Coherence_YMT_v01_gamma baseline_corrected_coherence_correct baseline_corrected_coherence_wrong ...
     baseline_corrected_coherence_baseline freq_base











