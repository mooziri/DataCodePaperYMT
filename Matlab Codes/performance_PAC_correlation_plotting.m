%% initialize

%%%%%%%%%%%%%%% Wavelet power analysis %%%%%%%%%%%%%%%
% transform by baseline mean and std correct vs wrong trials
clc; clear; close all
addpath(genpath('D:\projects\ob-pfc\Working memory (Y---maze)\Analyses'));

chn_ob = 1; chn_mpfc = 2;
channels = {'OB', 'mPFC'};

% load data
load('Behavior_PAC_YMT_v01.mat')

%% plot; statS 
%% FIRST APPROACH %%
delta = [1:7];
theta = [8:12];

for freq_i = 1: length(freq_amp)
    
[PAC_behavior_delta, p_val_PAC_delta] = corr (performance_no_short' , mean (rat_PAC(:,freq_i,delta) ,3) );
[PAC_behavior_theta, p_val_PAC_theta] = corr (performance_no_short' , mean (rat_PAC(:,freq_i,theta) ,3) );

PAC_mat_delta(freq_i) = PAC_behavior_delta;
PAC_mat_theta(freq_i) = PAC_behavior_theta;

p_val_PAC_mat_delta(freq_i) = p_val_PAC_delta;
p_val_PAC_mat_theta(freq_i) = p_val_PAC_theta;

end

%% plotting
alpha = 0.05;
figure
subplot(2,1,1)
hold on  
plot(freq_amp ,PAC_mat_delta, 'LineWidth', 3,'Color',[120 120 120]/225)
sig_idx = p_val_PAC_mat_delta < alpha ;
line_height =  ones(1,size(freq_amp,2)); 
line_height(~sig_idx) = NaN;
line_height= line_height .*PAC_mat_delta;
plot(freq_amp,line_height, 'LineWidth', 8,'Color',[120 120 120]/225)
title('PAC Delta')
xticks([12 30])
yticks([0 1])
ylim([0 1])
xlim([12 30])

subplot(2,1,2)
hold on  
plot(freq_amp ,PAC_mat_theta, 'LineWidth', 3,'Color',[120 120 120]/225)
sig_idx = p_val_PAC_mat_theta < alpha ;
line_height =  ones(1,size(freq_amp,2)); 
line_height(~sig_idx) = NaN;
line_height= line_height .*PAC_mat_theta;
plot(freq_amp,line_height, 'LineWidth', 8,'Color',[120 120 120]/225)
title('PAC Theta')
xticks([12 30])
yticks([0 1])
ylim([0 1])
xlim([12 30])

%% SECOND APPROACH %%

for freq_i = 1: length(freq_phase)
   
[PAC_behavior, p_val_PAC] = corr (performance_no_short' , mean (rat_PAC(:,:,freq_i) ,2) );
PAC_mat(freq_i) = PAC_behavior;
p_val_PAC_mat(freq_i) = p_val_PAC;
end

%% plotting
alpha = 0.05;
figure
hold on  
plot(freq_phase ,PAC_mat, 'LineWidth', 3,'Color',[120 120 120]/225)
sig_idx = p_val_PAC_mat < alpha ;
line_height =  ones(1,size(freq_phase,2)); 
line_height(~sig_idx) = NaN;
line_height= line_height .*PAC_mat;
plot(freq_phase,line_height, 'LineWidth', 8,'Color',[120 120 120]/225)
title('PAC')
xticks([1 4 12])
yticks([0 1])
ylim([0 1])
xlim([1 12])


%% THIRD APPROACH %%
freq_phase= [1:0.5:12];
freq_amp = [12:30];
for freq_i = 1: length(freq_amp)
for freq_ii = 1: length(freq_phase)
   
[PAC_behavior, p_val_PAC] = corr (performance_no_short' ,  rat_PAC(:,freq_i,freq_ii)  );
PAC_mat(freq_i,freq_ii) = PAC_behavior;
p_val_PAC_mat(freq_i,freq_ii) = p_val_PAC;
end
end

%% plotting
alpha = 0.05;
figure
sig_idx = p_val_PAC_mat < alpha ;
plot_pac= PAC_mat .* sig_idx;
imagesc(freq_phase,freq_amp,plot_pac);
shading(gca,'interp');colormap(jet); colorbar;title('PAC');
xlabel('Phase Frequency');ylabel('Amplitude Frequency (Hz)');set(gca,'YDir','normal')


