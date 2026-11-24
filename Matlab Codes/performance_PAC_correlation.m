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
ff = [1:0.2:30];


% load data
load('PAC_YMT_v02_subtract_OB2OB.mat')
load('Dataset_YMT_v01.mat')
load('Behavior_power_YMT_v02.mat')
clear rat_power
%% power
correct_indx = Data.Rat_indx_correct(~Data.Is_short_correct);
wrong_indx = Data.Rat_indx_wrong(~Data.Is_short_wrong);
rat_id = unique(Data.Rat_indx_correct);
rat_ceherence=[];
for rat_i= 1:length(rat_id)
    correcct_rat_i=baseline_corrected_PAC_correct(correct_indx==rat_id(rat_i),:,:);
    wrong_rat_i=baseline_corrected_PAC_wrong(wrong_indx==rat_id(rat_i),:,:);
    
    rat_PAC(rat_i,:,:) = squeeze(mean(cat(1,correcct_rat_i,wrong_rat_i   ) ,1))  ;
    
end


 save Behavior_PAC_YMT_v02_subtract_OB2OB  rat_PAC performance_no_short 



