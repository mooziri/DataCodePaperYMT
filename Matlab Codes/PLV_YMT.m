%% In the name of Allah
%%%%%% PLV for each frequency %%%%%
clear all; close all; clc;
addpath(genpath('D:\Programming\Project_Anxiety\EPM\'));

%% Parameters

% define frequency bands
theta = [30 120];
freqs  = [theta(1):1:theta(2)];
fs = 2000; % sampling frequency

chn_ob = 1; chn_mpfc = 2;
channels = {'OB', 'mPFC'};

%% load data
load('Dataset_YMT_v01.mat')

%% correct data
data = Data.Correct(~Data.Is_short_correct);
phase_diff_correct=[];
for trial_i = 1:size(data,2)
    %% Wavelet
    [analytic_sig, freqs] = ma_wavelet(squeeze(data{trial_i})', freqs, fs);
    %% Compute phase lag
    phi_ob = angle(analytic_sig(chn_ob,:,:));
    phi_mpfc = angle(analytic_sig(chn_mpfc,:,:));
    
    temp_phase_diff = mean( exp(1i*(phi_mpfc - phi_ob)),'all');
    phase_diff_correct(trial_i,:) =  angle( temp_phase_diff ) ;
    
    PLV_correct(trial_i,:) = abs(temp_phase_diff );
    

end
%% Stat correct

p_val_uniformity_correct = circ_rtest(phase_diff_correct);
p_val_diff_0_correct = circ_medtest(phase_diff_correct,0);
p_val_diff_pi_correct  = circ_medtest(phase_diff_correct,pi);



%% wrong data
data = Data.Wrong(~Data.Is_short_wrong);
phase_diff_wrong=[];
for trial_i = 1:size(data,2)
    %% Wavelet
    [analytic_sig, freqs] = ma_wavelet(squeeze(data{trial_i})', freqs, fs);
    %% Compute phase lag
    phi_ob = angle(analytic_sig(chn_ob,:,:));
    phi_mpfc = angle(analytic_sig(chn_mpfc,:,:));
    
    temp_phase_diff = mean( exp(1i*(phi_mpfc - phi_ob)), 'all');
    phase_diff_wrong(trial_i,:) =  angle( temp_phase_diff ) ;
    
    PLV_wrong(trial_i,:) = abs(temp_phase_diff );
    

end
%% Stat wrong

p_val_uniformity_wrong= circ_rtest(phase_diff_wrong);
p_val_diff_0_wrong  = circ_medtest(phase_diff_wrong,0);
p_val_diff_pi_wrong  = circ_medtest(phase_diff_wrong,pi);


%% baseline data
data = Data.Baseline;
phase_diff_baseline=[];
for trial_i = 1:size(data,2)
    %% Wavelet
    [analytic_sig, freqs] = ma_wavelet(squeeze(data{trial_i})', freqs, fs);
    %% Compute phase lag
    phi_ob = angle(analytic_sig(chn_ob,:,:));
    phi_mpfc = angle(analytic_sig(chn_mpfc,:,:));
    
    temp_phase_diff = mean( exp(1i*(phi_mpfc - phi_ob)), 'all');
    phase_diff_baseline(trial_i,:) =  angle( temp_phase_diff ) ;
    
    PLV_baseline(trial_i,:) = abs(temp_phase_diff );
    

end
%% Stat baseline

p_val_uniformity_base = circ_rtest(phase_diff_baseline);
p_val_diff_0_base = circ_medtest(phase_diff_baseline,0);
p_val_diff_pi_base= circ_medtest(phase_diff_baseline,pi);


%% plotting
alpha = 0.05;
nbin= 30;
figure
load('PLV_YMT_v02x02_delta.mat')
subplot(3,3,1)
polarhistogram(  phase_diff_baseline,nbin,'FaceColor','k')
title(['Baseline  p-val-0 = ',num2str(p_val_diff_0_base),'  p-val-pi = ',num2str(p_val_diff_pi_base)])

subplot(3,3,2)
polarhistogram( phase_diff_wrong,nbin,'FaceColor','r')
title(['Wrong  p-val-0 = ',num2str(p_val_diff_0_wrong),'  p-val-pi = ',num2str(p_val_diff_pi_wrong)])


subplot(3,3,3)
polarhistogram( phase_diff_correct,nbin,'FaceColor','b')
title(['Correct  p-val-0 = ',num2str(p_val_diff_0_correct),'  p-val-pi = ',num2str(p_val_diff_pi_correct)])

load('PLV_YMT_v02x02_theta.mat')
subplot(3,3,4)
polarhistogram(  phase_diff_baseline,nbin,'FaceColor','k')
title(['Baseline  p-val-0 = ',num2str(p_val_diff_0_base),'  p-val-pi = ',num2str(p_val_diff_pi_base)])

subplot(3,3,5)
polarhistogram( phase_diff_wrong,nbin,'FaceColor','r')
title(['Wrong  p-val-0 = ',num2str(p_val_diff_0_wrong),'  p-val-pi = ',num2str(p_val_diff_pi_wrong)])


subplot(3,3,6)
polarhistogram( phase_diff_correct,nbin,'FaceColor','b')
title(['Correct  p-val-0 = ',num2str(p_val_diff_0_correct),'  p-val-pi = ',num2str(p_val_diff_pi_correct)])
 load('PLV_YMT_v02x02_alpha.mat')
 
 subplot(3,3,7)
polarhistogram(  phase_diff_baseline,nbin,'FaceColor','k')
title(['Baseline  p-val-0 = ',num2str(p_val_diff_0_base),'  p-val-pi = ',num2str(p_val_diff_pi_base)])

subplot(3,3,8)
polarhistogram( phase_diff_wrong,nbin,'FaceColor','r')
title(['Wrong  p-val-0 = ',num2str(p_val_diff_0_wrong),'  p-val-pi = ',num2str(p_val_diff_pi_wrong)])


subplot(3,3,9)
polarhistogram( phase_diff_correct,nbin,'FaceColor','b')
title(['Correct  p-val-0 = ',num2str(p_val_diff_0_correct),'  p-val-pi = ',num2str(p_val_diff_pi_correct)])
% save PLV_YMT_v02x02_theta PLV_baseline p_val_diff_0_base p_val_diff_pi_base PLV_wrong p_val_diff_0_wrong p_val_diff_pi_wrong...
%     PLV_correct p_val_diff_0_correct p_val_diff_pi_correct p_val_uniformity_base p_val_uniformity_wrong p_val_uniformity_correct...
%      phase_diff_baseline phase_diff_wrong phase_diff_correct