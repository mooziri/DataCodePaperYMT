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
load('Behavior_power_YMT_v01.mat')


%% plot; states
% parameters
face_alpha_epm = 0.3; face_alpha_of = 0.5;
color_open = [255 178 102 0.5]; color_closed = [153 204 255 0.5]; color_baseline = [255 204 102 0.5];


for freq_i = 1: length(ff)
    
[CORR_behavior_ob, p_val_ob ] = corr (performance_no_short' , mean ( rat_power(:,chn_ob,freq_i),2));
[CORR_behavior_mpfc, p_val_mpfc ] = corr (performance_no_short' , mean ( rat_power(:,chn_mpfc,freq_i),2) );

corr_mat(chn_ob,freq_i) = CORR_behavior_ob;
corr_mat(chn_mpfc,freq_i) = CORR_behavior_mpfc;

p_val_corr_mat(chn_ob,freq_i) = p_val_ob;
p_val_corr_mat(chn_mpfc,freq_i) = p_val_mpfc;
end

%% plotting
color_plot = [120 120 120] /225;
alpha = 0.05;
alpha_2 = 0.095;
figure
subplot(2,1,1)
hold on  
plot(ff ,corr_mat(1,:), 'LineWidth', 1,'Color',color_plot)

sig_idx = p_val_corr_mat(1,:) < alpha ;
line_height =  ones(1,size(ff,2)); 
line_height(~sig_idx) = NaN;
line_height= line_height .* corr_mat(1,:);
plot(ff ,line_height, 'LineWidth', 10,'Color',color_plot)

sig_idx = p_val_corr_mat(1,:) < alpha_2 ;
line_height =  ones(1,size(ff,2)); 
line_height(~sig_idx) = NaN;
line_height= line_height .* corr_mat(1,:);
plot(ff ,line_height, 'LineWidth', 5,'Color',color_plot)

title('OB')
xticks([1 4 12 30])
yticks([0 1])
ylim([0 1])
xlim([1 30])


subplot(2,1,2)
hold on  
plot(ff ,corr_mat(2,:), 'LineWidth', 1,'Color',color_plot)
sig_idx = p_val_corr_mat(2,:) < alpha ;
line_height =  ones(1,size(ff,2)); 
line_height(~sig_idx) = NaN;
line_height= line_height .* corr_mat(2,:);
plot(ff ,line_height, 'LineWidth', 10,'Color',color_plot)

sig_idx = p_val_corr_mat(2,:) < alpha_2 ;
line_height =  ones(1,size(ff,2)); 
line_height(~sig_idx) = NaN;
line_height= line_height .* corr_mat(2,:);
plot(ff ,line_height, 'LineWidth', 5,'Color',color_plot)

title('PFC')
xticks([1 4 12 30])
yticks([0 1])
ylim([0 1])
xlim([1 30])






