%% initialize

%%%%%%%%%%%%%%% Wavelet power analysis %%%%%%%%%%%%%%%
% transform by baseline mean and std correct vs wrong trials
clc; clear; close all
addpath(genpath('D:\projects\ob-pfc\Working memory (Y---maze)\Analyses'));

chn_ob = 1; chn_mpfc = 2;
channels = {'OB', 'mPFC'};

fs = 2000; % sampling frequency
w  = fs*0.88; % window
ol = fs*0.85; % overlap
fr_constant = 10; % frequency resolution
ff = [30:1:160];


% load data
load('Dataset_YMT_v01.mat')

%% Power
%%%%% Trial type: Baseline %%%%%
rat_id = unique(Data.Rat_indx_baseline);
baseline_correcected_power_baseline = [];
for rat_i= 1:length(rat_id)
    power_B=[]; total_power_B=[];
    power_baseline_ob_v1=[];
    power_baseline_mpfc_v1=[];
    power_baseline_ob_v2=[];
    power_baseline_mpfc_v2=[];
    base_rat_i=Data.Baseline(1,Data.Rat_indx_baseline==rat_id(rat_i));
    
    for trial_i = 1:length(base_rat_i)
        power_B=[]; total_power_B=[];
        %%%%% OB
        [total_power_B, f_power] = ma_wavelet(squeeze(base_rat_i{trial_i}(:,chn_ob))',ff , fs);
        power_B= abs(total_power_B) .^ 2 ;
        power_baseline_ob_v1{trial_i} = power_B;
        power_baseline_ob_v2 = cat (3,power_baseline_ob_v2,power_B);
        
        power_B=[]; total_power_B=[];
        %%%%% mPFC
        [total_power_B, f_power] = ma_wavelet(squeeze(base_rat_i{trial_i}(:,chn_mpfc))',ff , fs);
        power_B= abs(total_power_B) .^ 2 ;
        power_baseline_mpfc_v1{trial_i} = power_B;
        power_baseline_mpfc_v2 = cat (3,power_baseline_mpfc_v2,power_B);
        
    end
    Baseline_mean(rat_i,:,:) = cat(1,mean(power_baseline_ob_v2,3),mean(power_baseline_mpfc_v2,3));
    Baseline_std(rat_i,:,:)  = cat(1,std(squeeze(power_baseline_ob_v2)'),std(squeeze(power_baseline_mpfc_v2)'));
    
    norm_power_baseline = [];
    for trial_i = 1:length(base_rat_i)
        norm_power_baseline(1,trial_i,:) = ( squeeze(mean( power_baseline_ob_v1{trial_i},3)) - ...
            squeeze(Baseline_mean(rat_i,1,:))' ) ./ squeeze(Baseline_std(rat_i,1,:))' ;
        norm_power_baseline(2,trial_i,:) = ( squeeze(mean( power_baseline_mpfc_v1{trial_i},3)) - ...
            squeeze(Baseline_mean(rat_i,2,:))' ) ./ squeeze(Baseline_std(rat_i,2,:))' ;
    end
    
    baseline_correcected_power_baseline = cat(2,baseline_correcected_power_baseline , norm_power_baseline);
end


%%%%% Trial type: Correct %%%%%
data = Data.Correct;
correct_indx = Data.Rat_indx_correct;
rat_id = unique(Data.Rat_indx_correct);
baseline_correcected_power_correct=[];
for rat_i= 1:length(rat_id)
    correcct_rat_i=data(1,correct_indx==rat_id(rat_i));
    power_C=[]; total_power_C=[]; power_correct=[];norm_power_correct=[];
    for trial_i = 1:length(correcct_rat_i)
        %%%%% OB
        [total_power_C, f_power] = ma_wavelet(squeeze(correcct_rat_i{trial_i}(:,chn_ob))',ff , fs);
        power_C= nanmean(abs(total_power_C) .^ 2 , 3) ;
        power_correct(chn_ob,trial_i,:) = power_C;
        
        
        power_C=[]; total_power_C=[];
        %%%%% mPFC
        [total_power_C, f_power] = ma_wavelet(squeeze(correcct_rat_i{trial_i}(:,chn_mpfc))',ff , fs);
        power_C= nanmean(abs(total_power_C) .^ 2 , 3) ;
        power_correct(chn_mpfc,trial_i,:) = power_C;
    end
    
               norm_power_correct(1,:,:) = ( reshape( power_correct(1,:,:),[length(correcct_rat_i),length(ff)])  - ...
            reshape(Baseline_mean(rat_i,1,:),[1,length(ff)]) ) ./ reshape(Baseline_std(rat_i,1,:),[1,length(ff)]) ;
        norm_power_correct(2,:,:) = ( reshape( power_correct(2,:,:),[length(correcct_rat_i),length(ff)])  - ...
            reshape(Baseline_mean(rat_i,2,:),[1,length(ff)]) ) ./ reshape(Baseline_std(rat_i,2,:),[1,length(ff)]) ;
    
    
    baseline_correcected_power_correct = cat(2,baseline_correcected_power_correct,norm_power_correct );

end

%%%%% Trial type: Wrong %%%%%
data = Data.Wrong;
wrong_indx = Data.Rat_indx_wrong;
rat_id = unique(Data.Rat_indx_wrong);
baseline_correcected_power_wrong=[];
for rat_i= 1:length(rat_id)
    wrong_rat_i=data(1,wrong_indx==rat_id(rat_i));
    power_W=[]; total_power_W=[];power_wrong=[];norm_power_wrong=[];
    for trial_i = 1:length(wrong_rat_i)
        %%%%% OB
        [total_power_W, f_power] = ma_wavelet(squeeze(wrong_rat_i{trial_i}(:,chn_ob))',ff , fs);
        power_W= nanmean(abs(total_power_W) .^ 2 , 3) ;
        power_wrong(chn_ob,trial_i,:) = power_W;
        
        
        power_W=[]; total_power_W=[];
        %%%%% mPFC
        [total_power_W, f_power] = ma_wavelet(squeeze(wrong_rat_i{trial_i}(:,chn_mpfc))',ff , fs);
        power_W= nanmean(abs(total_power_W) .^ 2 , 3) ;
        power_wrong(chn_mpfc,trial_i,:) = power_W;
    end
               norm_power_wrong(1,:,:) = ( reshape( power_wrong(1,:,:),[length(wrong_rat_i),length(ff)])  - ...
            reshape(Baseline_mean(rat_i,1,:),[1,length(ff)]) ) ./ reshape(Baseline_std(rat_i,1,:),[1,length(ff)]) ;
        norm_power_wrong(2,:,:) = ( reshape( power_wrong(2,:,:),[length(wrong_rat_i),length(ff)])  - ...
            reshape(Baseline_mean(rat_i,2,:),[1,length(ff)]) ) ./ reshape(Baseline_std(rat_i,2,:),[1,length(ff)]) ;
    
    
    baseline_correcected_power_wrong = cat(2,baseline_correcected_power_wrong,norm_power_wrong );
    
end

%% plot; states
desired_band = [30 160];
ind_desired_band = [find(ff==desired_band(1)):find(ff==desired_band(2))];

% parameters
face_alpha_epm = 0.3; face_alpha_of = 0.5;
color_open = [255 178 102 0.5]; color_closed = [153 204 255 0.5]; color_baseline = [255 204 102 0.5];
figure(2)
subplot(2,1,1)
c1 = ma_plot(ff(ind_desired_band), squeeze(baseline_correcected_power_correct(1,:,ind_desired_band)), 1, color_open, 'sem', '-')
w1 = ma_plot(ff(ind_desired_band), squeeze(baseline_correcected_power_wrong(1,:,ind_desired_band))  , 2, color_closed, 'sem', '-')
b1 = ma_plot(ff(ind_desired_band), squeeze(baseline_correcected_power_baseline(1,:,ind_desired_band))  , 2, color_baseline, 'sem', '-')
legend([c1,w1,b1],{'Correct','Wrong','Baseline'})
title('OB')

subplot(2,1,2)
c2 = ma_plot(ff(ind_desired_band), squeeze(baseline_correcected_power_correct(2,:,ind_desired_band)), 1, color_open, 'sem', '-')
w2 = ma_plot(ff(ind_desired_band), squeeze(baseline_correcected_power_wrong(2,:,ind_desired_band))  , 2, color_closed, 'sem', '-')
b2 = ma_plot(ff(ind_desired_band), squeeze(baseline_correcected_power_baseline(2,:,ind_desired_band))  , 2, color_baseline, 'sem', '-')
legend([c2,w2,b2],{'Correct','Wrong','Baseline'})
title('PFC')

 %save Power_gamma_YMT_v02 baseline_correcected_power_correct baseline_correcected_power_wrong baseline_correcected_power_baseline ff






