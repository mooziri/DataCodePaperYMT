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
load('Power_YMT_v01.mat')
load('Dataset_YMT_v01.mat')

%% power
correct_indx = Data.Rat_indx_correct(~Data.Is_short_correct);
wrong_indx = Data.Rat_indx_wrong(~Data.Is_short_wrong);
rat_id = unique(Data.Rat_indx_correct);
rat_power=[];
for rat_i= 1:length(rat_id)
    correcct_rat_i=baseline_correcected_power_correct(:,correct_indx==rat_id(rat_i),:);
    wrong_rat_i=baseline_correcected_power_wrong(:,wrong_indx==rat_id(rat_i),:);
    
    rat_power(rat_i,:,:) = squeeze(mean(cat(2,correcct_rat_i,wrong_rat_i   ) ,2))  ;
    
end


for rat_i= 1:length(rat_id)
    correcct_rat_I= sum(correct_indx==rat_id(rat_i));
    wrong_rat_I= sum (wrong_indx==rat_id(rat_i));
    performance_no_short(rat_i) = ( correcct_rat_I / (correcct_rat_I+wrong_rat_I)  ) * 100 ;      
end

 save Behavior_power_YMT_v01 rat_power performance_no_short






