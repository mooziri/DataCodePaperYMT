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
ff = [1:0.2:30];


% load data
load('Behavior_Granger_YMT_v01.mat')

%% plot; states


for freq_i = 1: length(ff)
    
[granger_OB2MPFC_behavior, p_val_granger_OB2MPFC] = corr (performance_no_short' , rat_granger_OB2MPFC(:,freq_i));
granger_OB2MPFC_mat(freq_i) = granger_OB2MPFC_behavior;
p_val_granger_OB2MPFC_mat(freq_i) = p_val_granger_OB2MPFC;


[granger_MPFC2OB_behavior, p_val_granger_MPFC2OB] = corr (performance_no_short' , rat_granger_MPFC2OB(:,freq_i));
granger_MPFC2OB_mat(freq_i) = granger_MPFC2OB_behavior;
p_val_granger_MPFC2OB_mat(freq_i) = p_val_granger_MPFC2OB;

[granger_diff_behavior, p_val_granger_diff] = corr (performance_no_short' , rat_granger_diff(:,freq_i) );
granger_diff_mat(freq_i) = granger_diff_behavior;
p_val_granger_diff_mat(freq_i) = p_val_granger_diff;
end

%% plotting
alpha = 0.05;
alpha_2 = 0.095

figure 

subplot(2,2,1)
hold on
plot(ff ,granger_OB2MPFC_mat, 'LineWidth', 1,'Color',[120 120 120]/225)
sig_idx = p_val_granger_OB2MPFC_mat < alpha ;
line_height =  ones(1,size(ff,2)); 
line_height(~sig_idx) = NaN;
line_height= line_height .*granger_OB2MPFC_mat;
plot(ff,line_height, 'LineWidth', 10,'Color',[120 120 120]/225)
sig_idx = p_val_granger_OB2MPFC_mat < alpha_2 ;
line_height =  ones(1,size(ff,2)); 
line_height(~sig_idx) = NaN;
line_height= line_height .*granger_OB2MPFC_mat;
plot(ff,line_height, 'LineWidth', 5,'Color',[120 120 120]/225)
title('Granger OB2PFC')
xticks([1 4 12 30])
yticks([-0.2 1])
ylim([-.2 1])
xlim([1 30])

subplot(2,2,2)
plot(ff ,granger_MPFC2OB_mat, 'LineWidth', 1,'Color',[120 120 120]/225)
hold on
sig_idx = p_val_granger_MPFC2OB_mat < alpha ;
line_height =  ones(1,size(ff,2)); 
line_height(~sig_idx) = NaN;
line_height= line_height .*granger_MPFC2OB_mat;
plot(ff,line_height, 'LineWidth', 10,'Color',[120 120 120]/225)
sig_idx = p_val_granger_MPFC2OB_mat < alpha_2 ;
line_height =  ones(1,size(ff,2)); 
line_height(~sig_idx) = NaN;
line_height= line_height .*granger_MPFC2OB_mat;
plot(ff,line_height, 'LineWidth', 5,'Color',[120 120 120]/225)
title('Granger PFC2OB')
xticks([1 4 12 30])
yticks([-0.2 1])
ylim([-.2 1])
xlim([1 30])

subplot(2,2,3)
plot(ff ,granger_diff_mat, 'LineWidth', 1,'Color',[120 120 120]/225)
hold on
sig_idx = p_val_granger_diff_mat < alpha ;
line_height =  ones(1,size(ff,2)); 
line_height(~sig_idx) = NaN;
line_height= line_height .*granger_diff_mat;
plot(ff,line_height, 'LineWidth', 10,'Color',[120 120 120]/225)

sig_idx = p_val_granger_diff_mat < alpha_2 ;
line_height =  ones(1,size(ff,2)); 
line_height(~sig_idx) = NaN;
line_height= line_height .*granger_diff_mat;
plot(ff,line_height, 'LineWidth', 5,'Color',[120 120 120]/225)

title('Granger DIFF')
xticks([1 4 12 30])
yticks([-0.2 1])
ylim([-.2 1])
xlim([1 30])






