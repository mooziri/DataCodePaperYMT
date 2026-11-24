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
load('Behavior_coherence_YMT_v01.mat')

%% plot; states


for freq_i = 1: length(freq_base)
    
[coh_behavior, p_val_coh] = corr (performance_no_short' , rat_ceherence(:,freq_i),'Type','Spearman' );

coh_mat(freq_i) = coh_behavior;


p_val_coh_mat(freq_i) = p_val_coh;

end

%% plotting
alpha = 0.05;
alpha_2 = 0.095

figure
hold on  
plot(freq_base ,coh_mat, 'LineWidth', 1,'Color',[120 120 120]/225)

sig_idx = p_val_coh_mat < alpha ;
line_height =  ones(1,size(freq_base,2)); 
line_height(~sig_idx) = NaN;
line_height= line_height .*coh_mat;
plot(freq_base,line_height, 'LineWidth', 10,'Color',[120 120 120]/225)

sig_idx = p_val_coh_mat < alpha_2 ;
line_height =  ones(1,size(freq_base,2)); 
line_height(~sig_idx) = NaN;
line_height= line_height .*coh_mat;
plot(freq_base,line_height, 'LineWidth', 5,'Color',[120 120 120]/225)


title('Coherence')
xticks([1 4 12 30])
yticks([0 1])
ylim([0 1])
xlim([1 30])








