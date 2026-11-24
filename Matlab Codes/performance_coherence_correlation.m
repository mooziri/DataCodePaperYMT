%% initialize

%%%%%%%%%%%%%%% bahavior ceherence analysis %%%%%%%%%%%%%%%
% transform by baseline mean and std correct vs wrong trials
clc; clear; close all
addpath(genpath('D:\projects\ob-pfc\Working memory (Y---maze)\Analyses'));

chn_ob = 1; chn_mpfc = 2;
channels = {'OB', 'mPFC'};

fs = 2000; % sampling frequency
w  = fs*0.88; % window
ol = fs*0.85; % overlap
fr_constant = 10; % frequency resolution
ff = [30:0.2:160];


% load data
load('YMT_Coherence_v01_gamma.mat')
load('Dataset_YMT_v01.mat')
load('Behavior_power_YMT_v02.mat')
clear rat_power
%% power
correct_indx = Data.Rat_indx_correct(~Data.Is_short_correct);
wrong_indx = Data.Rat_indx_wrong(~Data.Is_short_wrong);
rat_id = unique(Data.Rat_indx_correct);
rat_ceherence=[];
for rat_i= 1:length(rat_id)
    correcct_rat_i=baseline_corrected_coherence_correct(correct_indx==rat_id(rat_i),:);
    wrong_rat_i=baseline_corrected_coherence_wrong(wrong_indx==rat_id(rat_i),:);
    
    rat_ceherence(rat_i,:) = squeeze(mean(cat(1,correcct_rat_i,wrong_rat_i   ) ,1))  ;
    
end


 save Behavior_coherence_YMT_v01_gamma  rat_ceherence performance_no_short freq_base






