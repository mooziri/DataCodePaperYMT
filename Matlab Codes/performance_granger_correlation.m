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
load('YMT_Granger_v01.mat')
load('Dataset_YMT_v01.mat')
load('Behavior_power_YMT_v02.mat')
clear rat_power
%% power
correct_indx = Data.Rat_indx_correct(~Data.Is_short_correct);
wrong_indx = Data.Rat_indx_wrong(~Data.Is_short_wrong);
rat_id = unique(Data.Rat_indx_correct);
rat_ceherence=[];
for rat_i= 1:length(rat_id)
    correcct_rat_OB2MPFC=baseline_corrected_granger_correct(correct_indx==rat_id(rat_i),1,:);
    wrong_rat_OB2MPFC=baseline_corrected_granger_wrong(wrong_indx==rat_id(rat_i),1,:);
    rat_granger_OB2MPFC(rat_i,:) = squeeze(mean(cat(1,correcct_rat_OB2MPFC,wrong_rat_OB2MPFC   ) ,1))  ;
    
     correcct_rat_MPFC2OB=baseline_corrected_granger_correct(correct_indx==rat_id(rat_i),2,:);
    wrong_rat_MPFC2OB=baseline_corrected_granger_wrong(wrong_indx==rat_id(rat_i),2,:);
    rat_granger_MPFC2OB(rat_i,:) = squeeze(mean(cat(1,correcct_rat_MPFC2OB,wrong_rat_MPFC2OB   ) ,1))  ;
    
         correcct_rat_diff= ( baseline_corrected_granger_correct(correct_indx==rat_id(rat_i),2,:) ...
              -  baseline_corrected_granger_correct(correct_indx==rat_id(rat_i),1,:) ) ;
    wrong_rat_diff= ( baseline_corrected_granger_wrong(wrong_indx==rat_id(rat_i),2,:) ...
              -  baseline_corrected_granger_wrong(wrong_indx==rat_id(rat_i),1,:) );
    rat_granger_diff(rat_i,:) = squeeze(mean(cat(1,correcct_rat_diff,wrong_rat_diff   ) ,1))  ;
    
end


 save Behavior_Granger_YMT_v01  rat_granger_MPFC2OB rat_granger_OB2MPFC rat_granger_diff performance_no_short ff






