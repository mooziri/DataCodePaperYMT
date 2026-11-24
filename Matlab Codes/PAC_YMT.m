%% initialize

%%%%%%%%%%%%%%% baseline correction for PAC analysis %%%%%%%%%%%%%%%
clc; clear; close all
addpath(genpath('D:\projects\ob-pfc\Working memory (Y---maze)\Analyses'));

% define frequency bands
fs = 2000;      % sampling frequency
chn_ob = 1; chn_mpfc = 2;

load('Dataset_YMT_v01.mat');
load('PAC_YMT_v01_PFC2OB.mat')


%%%%% Trial type: Baseline %%%%%
rat_id = unique(Data.Rat_indx_baseline);
baseline_corrected_PAC_baseline=[];
for rat_i= 1:length(rat_id)
    idx_rat_i = find(Data.Rat_indx_baseline==rat_id(rat_i));
    base_rat_i=PAC_baseline([idx_rat_i],:,:);
    
    mean_PAC_baseline(rat_i,:,:) = mean(base_rat_i ,1);
    std_PAC_baseline(rat_i,:,:) = std(base_rat_i ,[],1);
    
    for trial_i = idx_rat_i
        baseline_corrected_PAC_baseline(trial_i,:,:) = PAC_baseline(trial_i,:,:) ./ mean_PAC_baseline(rat_i,:,:);
    end
end

%%%%% Trial type: Correct %%%%%
correct_indx = Data.Rat_indx_correct(~Data.Is_short_correct);
rat_id = unique(Data.Rat_indx_correct);
baseline_corrected_PAC_correct=[];

for rat_i= 1:length(rat_id)
    idx_rat_i = find(correct_indx==rat_id(rat_i));
    for trial_i = idx_rat_i
        baseline_corrected_PAC_correct(trial_i,:,:) = PAC_correct(trial_i,:,:) ./ mean_PAC_baseline(rat_i,:,:);
    end
end


%%%%% Trial type: wrong %%%%%
wrong_indx = Data.Rat_indx_wrong(~Data.Is_short_wrong);
rat_id = unique(Data.Rat_indx_wrong);
baseline_corrected_PAC_wrong=[];

for rat_i= 1:length(rat_id)
    idx_rat_i = find(wrong_indx==rat_id(rat_i));
    for trial_i = idx_rat_i
        baseline_corrected_PAC_wrong(trial_i,:,:) = PAC_wrong(trial_i,:,:) ./ mean_PAC_baseline(rat_i,:,:);
    end
end


%% plotting
phase_freq=[1:0.5:12];
amp_freq=[12:1:30];
% c_axis=[0 7e-3]

figure
subplot(3,1,1)
imagesc(phase_freq,amp_freq,squeeze(mean(baseline_corrected_PAC_baseline,1)));
shading(gca,'interp');colormap(jet); colorbar;title('PAC Baseline');
xlabel('Phase Frequency');ylabel('Amplitude Frequency (Hz)');set(gca,'YDir','normal')
   caxis(c_axis)
 
subplot(3,1,2)
imagesc(phase_freq,amp_freq,squeeze(mean(baseline_corrected_PAC_correct,1)));
shading(gca,'interp');colormap(jet); colorbar;title('PAC correct');
xlabel('Phase Frequency');ylabel('Amplitude Frequency (Hz)');set(gca,'YDir','normal')
   caxis(c_axis)
 
subplot(3,1,3)
imagesc(phase_freq,amp_freq,squeeze(mean(baseline_corrected_PAC_wrong,1)));
shading(gca,'interp');colormap(jet); colorbar;title('PAC wrong');
xlabel('Phase Frequency');ylabel('Amplitude Frequency (Hz)');set(gca,'YDir','normal')
   caxis(c_axis)

save PAC_YMT_v02_division_PFC2OB baseline_corrected_PAC_baseline baseline_corrected_PAC_correct ...
    baseline_corrected_PAC_wrong phase_freq amp_freq









