%% In His Name
%%%%%%%%%%%%%%% Granger Prediction %%%%%%%%%%%%%%%
% initialize
clear; close all; clc;
addpath(genpath('D:\projects\ob-pfc\Working memory (Y---maze)\Analyses'));

%% load data
load('Dataset_YMT_v01.mat')

%% Parameters
% define frequency bands
freq = [30 160];

chn_ob = 1; chn_mpfc = 2;
channels = {'OB', 'mPFC'};

frequencies = freq(1):0.2:freq(2);
order_points = 30; % time order for granger
decimate_order = 4; % decimate order for downsampling

% fs = 2000; % sampling frequency before downsampling
fs = 2000 ./ decimate_order; % sampling frequency after downsampling

%% downsampling
%%%%% trial type: baseline %%%%%
data = Data.Baseline;
for trial_i = 1 : size(data,2)
    temp_trial=[];
        temp_trial(chn_ob,:) = decimate( data{trial_i}(:,chn_ob) , decimate_order );
        temp_trial(chn_mpfc,:) = decimate( data{trial_i}(:,chn_mpfc) ,decimate_order);
        data_base{trial_i} = temp_trial;
end

%%%%% trial type: correct  %%%%%
data = Data.Correct(~Data.Is_short_correct);
for trial_i = 1 : size(data,2)
    temp_trial=[];
        temp_trial(chn_ob,:) = decimate( data{trial_i}(:,chn_ob) , decimate_order );
        temp_trial(chn_mpfc,:) = decimate( data{trial_i}(:,chn_mpfc) ,decimate_order);
        data_correct{trial_i} = temp_trial;
end

%%%%% trial type: correct  %%%%%
data = Data.Wrong(~Data.Is_short_wrong);
for trial_i = 1 : size(data,2)
    temp_trial=[];
        temp_trial(chn_ob,:) = decimate( data{trial_i}(:,chn_ob) , decimate_order );
        temp_trial(chn_mpfc,:) = decimate( data{trial_i}(:,chn_mpfc) ,decimate_order);
        data_wrong{trial_i} = temp_trial;
end

clear data 

%% Granger prediction for baseline


for trial_i = 1 : size(data_base,2)
   trial_t = length(data_base{trial_i});
    % parameters
% granger_bins = [1 floor(.5*trial_t)+1 ; floor(.5*trial_t) trial_t];
granger_bins = [1 ;  trial_t];
timewin_points = floor(.5*trial_t);
tf_granger=[];
    data = data_base{trial_i};
    
    trial_num = 1;
    
    for time_i = 1 : size(granger_bins,2)
        tempdata_02=[];
        t1 = granger_bins(1,time_i);
        t2 = granger_bins(2,time_i);
        
        tempdata = data(:,t1:t2);
        
        % detrend and zscore all data
            tempdata_02(1,:) = zscore(detrend(squeeze(tempdata(1,:))));
            tempdata_02(2,:) = zscore(detrend(squeeze(tempdata(2,:))));

        
        % reshape tempdata for armorf
        NEWtempdata = tempdata_02;
        
        % fit AR models
        [Ax,Ex] = armorf(NEWtempdata(1,:),trial_num,timewin_points,order_points);
        [Ay,Ey] = armorf(NEWtempdata(2,:),trial_num,timewin_points,order_points);
        [Axy,E] = armorf(NEWtempdata     ,trial_num,timewin_points,order_points);
        
        % code below is adapted from bsmart toolbox function pwcausal.m
        % corrected covariance
        eyx = E(2,2) - E(1,2)^2/E(1,1);
        exy = E(1,1) - E(2,1)^2/E(2,2);
        N = size(E,1);
        
        for fi=1:length(frequencies)
            
            % transfer matrix (note the similarity to Fourier transform)
            H = eye(N);
            for m = 1:order_points
                H = H + Axy(:,(m-1)*N+1:m*N)*exp(-1i*m*2*pi*frequencies(fi)/fs);
            end
            
            Hi = inv(H);
            S  = H\E*Hi'/fs;
            
            % granger prediction per frequency
            tf_granger(1,fi,time_i) = log( abs(S(2,2))/abs(S(2,2)-(Hi(2,1)*exy*conj(Hi(2,1)))/fs) );
            tf_granger(2,fi,time_i) = log( abs(S(1,1))/abs(S(1,1)-(Hi(1,2)*eyx*conj(Hi(1,2)))/fs) );
        end
        
        disp(strcat('Base Trial: #', num2str(trial_i), ' | Progress: %', num2str((time_i ./ size(granger_bins,2))*100)));
    end
    
    granger_results_base(trial_i,:,:) = tf_granger;
    
end

%% Granger prediction for correct

for trial_i = 1 : size(data_correct,2)
   trial_t = length(data_correct{trial_i});
    % parameters
% granger_bins = [1 floor(.5*trial_t)+1 ; floor(.5*trial_t) trial_t];
granger_bins = [1 ;  trial_t];
timewin_points = floor(.5*trial_t);
tf_granger=[];
    data = data_correct{trial_i};
    
    trial_num = 1;
    
    for time_i = 1 : size(granger_bins,2)
        tempdata_02=[];
        t1 = granger_bins(1,time_i);
        t2 = granger_bins(2,time_i);
        
        tempdata = data(:,t1:t2);
        
        % detrend and zscore all data
            tempdata_02(1,:) = zscore(detrend(squeeze(tempdata(1,:))));
            tempdata_02(2,:) = zscore(detrend(squeeze(tempdata(2,:))));

        
        % reshape tempdata for armorf
        NEWtempdata = tempdata_02;
        
        % fit AR models
        [Ax,Ex] = armorf(NEWtempdata(1,:),trial_num,timewin_points,order_points);
        [Ay,Ey] = armorf(NEWtempdata(2,:),trial_num,timewin_points,order_points);
        [Axy,E] = armorf(NEWtempdata     ,trial_num,timewin_points,order_points);
        
        % code below is adapted from bsmart toolbox function pwcausal.m
        % corrected covariance
        eyx = E(2,2) - E(1,2)^2/E(1,1);
        exy = E(1,1) - E(2,1)^2/E(2,2);
        N = size(E,1);
        
        for fi=1:length(frequencies)
            
            % transfer matrix (note the similarity to Fourier transform)
            H = eye(N);
            for m = 1:order_points
                H = H + Axy(:,(m-1)*N+1:m*N)*exp(-1i*m*2*pi*frequencies(fi)/fs);
            end
            
            Hi = inv(H);
            S  = H\E*Hi'/fs;
            
            % granger prediction per frequency
            tf_granger(1,fi,time_i) = log( abs(S(2,2))/abs(S(2,2)-(Hi(2,1)*exy*conj(Hi(2,1)))/fs) );
            tf_granger(2,fi,time_i) = log( abs(S(1,1))/abs(S(1,1)-(Hi(1,2)*eyx*conj(Hi(1,2)))/fs) );
        end
        
        disp(strcat('correct Trial: #', num2str(trial_i), ' | Progress: %', num2str((time_i ./ size(granger_bins,2))*100)));
    end
    
    granger_results_correct(trial_i,:,:) = tf_granger;
    
end


%% Granger prediction for wrong

for trial_i = 1 : size(data_wrong,2)
   trial_t = length(data_wrong{trial_i});
    % parameters
% granger_bins = [1 floor(.5*trial_t)+1 ; floor(.5*trial_t) trial_t];
granger_bins = [1 ;  trial_t];
timewin_points = floor(.5*trial_t);
tf_granger=[];
    data = data_wrong{trial_i};
    
    trial_num = 1;
    
    for time_i = 1 : size(granger_bins,2)
        tempdata_02=[];
        t1 = granger_bins(1,time_i);
        t2 = granger_bins(2,time_i);
        
        tempdata = data(:,t1:t2);
        
        % detrend and zscore all data
            tempdata_02(1,:) = zscore(detrend(squeeze(tempdata(1,:))));
            tempdata_02(2,:) = zscore(detrend(squeeze(tempdata(2,:))));

        
        % reshape tempdata for armorf
        NEWtempdata = tempdata_02;
        
        % fit AR models
        [Ax,Ex] = armorf(NEWtempdata(1,:),trial_num,timewin_points,order_points);
        [Ay,Ey] = armorf(NEWtempdata(2,:),trial_num,timewin_points,order_points);
        [Axy,E] = armorf(NEWtempdata     ,trial_num,timewin_points,order_points);
        
        % code below is adapted from bsmart toolbox function pwcausal.m
        % corrected covariance
        eyx = E(2,2) - E(1,2)^2/E(1,1);
        exy = E(1,1) - E(2,1)^2/E(2,2);
        N = size(E,1);
        
        for fi=1:length(frequencies)
            
            % transfer matrix (note the similarity to Fourier transform)
            H = eye(N);
            for m = 1:order_points
                H = H + Axy(:,(m-1)*N+1:m*N)*exp(-1i*m*2*pi*frequencies(fi)/fs);
            end
            
            Hi = inv(H);
            S  = H\E*Hi'/fs;
            
            % granger prediction per frequency
            tf_granger(1,fi,time_i) = log( abs(S(2,2))/abs(S(2,2)-(Hi(2,1)*exy*conj(Hi(2,1)))/fs) );
            tf_granger(2,fi,time_i) = log( abs(S(1,1))/abs(S(1,1)-(Hi(1,2)*eyx*conj(Hi(1,2)))/fs) );
        end
        
        disp(strcat('wrong Trial: #', num2str(trial_i), ' | Progress: %', num2str((time_i ./ size(granger_bins,2))*100)));
    end
    
    granger_results_wrong(trial_i,:,:) = tf_granger;
    
end

%% baseline correction
rat_id = unique(Data.Rat_indx_baseline);
    base_indx = Data.Rat_indx_baseline ;
    correct_indx = Data.Rat_indx_correct(~Data.Is_short_correct);
    wrong_indx = Data.Rat_indx_wrong(~Data.Is_short_wrong);
    baseline_corrected_granger_base = []; baseline_corrected_granger_correct=[]; baseline_corrected_granger_wrong=[];
for rat_i = 1: length(rat_id)
mean_rat_i = mean ( granger_results_base(base_indx==rat_id(rat_i),:,:) ) ;
baseline_corrected_granger_base =  cat( 1 , baseline_corrected_granger_base , ...
    granger_results_base(base_indx==rat_id(rat_i),:,:) ./ mean_rat_i ) ;
baseline_corrected_granger_correct =  cat( 1 , baseline_corrected_granger_correct , ...
    granger_results_correct(correct_indx==rat_id(rat_i),:,:) ./ mean_rat_i ) ;
baseline_corrected_granger_wrong =  cat ( 1, baseline_corrected_granger_wrong , ...
    granger_results_wrong(wrong_indx==rat_id(rat_i),:,:) ./ mean_rat_i ) ;
end
freqs = [30:0.2:160]; 

% save YMT_Granger_v01 baseline_corrected_granger_base baseline_corrected_granger_correct baseline_corrected_granger_wrong...
%     freqs


face_alpha_epm = 0.3; face_alpha_of = 0.5;
color_open = [255 178 102 0.5]; color_closed = [153 204 255 0.5]; color_baseline = [120 120 120 0.5];
figure(1)
subplot(2,1,1)
c1 = ma_plot(freqs, squeeze(baseline_corrected_granger_correct(:,1,:)), 1, color_open, 'sem', '-')
b1 = ma_plot(freqs, squeeze(baseline_corrected_granger_base(:,1,:)), 1, color_baseline, 'sem', '-')
w1 = ma_plot(freqs, squeeze(baseline_corrected_granger_wrong(:,1,:)), 1, color_closed, 'sem', '-')
legend([c1,w1,b1],{'Correct','Wrong','Baseline'})
subplot(2,1,2)
c1 = ma_plot(freqs, squeeze(baseline_corrected_granger_correct(:,2,:)), 1, color_open, 'sem', '-')
b1 = ma_plot(freqs, squeeze(baseline_corrected_granger_base(:,2,:)), 1, color_baseline, 'sem', '-')
w1 = ma_plot(freqs, squeeze(baseline_corrected_granger_wrong(:,2,:)), 1, color_closed, 'sem', '-')
legend([c1,w1,b1],{'Correct','Wrong','Baseline'})

figure
c1 = ma_plot(freqs, squeeze(baseline_corrected_granger_correct(:,2,:) - baseline_corrected_granger_correct(:,1,:)) , 1, color_open, 'sem', '-')
b1 = ma_plot(freqs, squeeze(baseline_corrected_granger_base(:,2,:) - baseline_corrected_granger_base(:,1,:)), 1, color_baseline, 'sem', '-')
w1 = ma_plot(freqs, squeeze(baseline_corrected_granger_wrong(:,2,:) - baseline_corrected_granger_wrong(:,1,:)), 1, color_closed, 'sem', '-')
legend([c1,w1,b1],{'Correct','Wrong','Baseline'})


%% Stat: ob-to-mpfc vs. mpfc-to-ob in maze
for trial_i = 1 : size(granger_results_maze,2)
    
    temp_trial = squeeze(granger_results_maze{trial_i}(1,:,:));
    
    ave_granger_1to2_unsafe(trial_i) = mean(temp_trial(:,1));
    ave_granger_1to2_safe(trial_i) = mean(temp_trial(:,2));
    
end

for trial_i = 1 : size(granger_results_maze,2)
    
    temp_trial = squeeze(granger_results_maze{trial_i}(2,:,:));
    
    ave_granger_2to1_unsafe(trial_i) = mean(temp_trial(:,1));
    ave_granger_2to1_safe(trial_i) = mean(temp_trial(:,2));
    
end

ave_1to2_maze = [ave_granger_1to2_unsafe';ave_granger_1to2_safe'];
ave_2to1_maze = [ave_granger_2to1_unsafe';ave_granger_2to1_safe'];

% remove outlier trial for OF
if ~experiment_num
    ave_1to2_maze = ave_1to2_maze([1:11 13:24]);
    ave_2to1_maze = ave_2to1_maze([1:11 13:24]);
end

%% Stat: ob-to-mpfc vs. mpfc-to-ob in base
for trial_i = 1 : size(granger_results_base,2)
    
    temp_trial = squeeze(granger_results_base{trial_i}(1,:));
    
    ave_granger_1to2_base(trial_i) = mean(temp_trial);
    
end

for trial_i = 1 : size(granger_results_base,2)
    
    temp_trial = squeeze(granger_results_base{trial_i}(2,:));
    
    ave_granger_2to1_base(trial_i) = mean(temp_trial);
    
end

ave_1to2_base = ave_granger_1to2_base';
ave_2to1_base = ave_granger_2to1_base';

%% Plot: ob-to-mpfc in maze vs. base
for trial_i = 1 : size(granger_results_maze,2)
    temp_trial = squeeze(granger_results_maze{trial_i}(1,:,:));
    
    granger_1to2_unsafe(trial_i,:) = temp_trial(:,1);
    granger_1to2_safe(trial_i,:) = temp_trial(:,2);
    
end
granger_1to2_maze = [granger_1to2_unsafe;granger_1to2_safe];

for trial_i = 1 : size(granger_results_base,2)
    temp_trial = squeeze(granger_results_base{trial_i}(1,:,:));
    granger_1to2_base(trial_i,:) = temp_trial;
end

% parameters
face_alpha_epm = 0.3; face_alpha_of = 0.5;
color_open = [255 178 102]; color_closed = [153 204 255];
color_center = [255 128 0]; color_periph = [0 128 255];
color_base_epm = [153 255 153]; color_base_of = [0 204 0];
color_epm = [160 160 160]; color_of = [96 96 96];
line_safe = '-'; line_unsafe = '--'; line_base = ':';

% plotting
figure(1);
subplot(121);
if experiment_num == 1
    
    p1 = ndass_niceplot(granger_1to2_maze, frequencies , 1, color_epm, face_alpha_epm, line_unsafe);
    hold on;
    p2 = ndass_niceplot(granger_1to2_base, frequencies , 1, color_base_epm, face_alpha_epm, line_safe);
    xlabel('Frequency (Hz)'); ylabel('Granger Causality');
    title('EPM Theta Granger Causality; OB to mPFC');
    legend([p1 p2], 'EPM', 'Baseline'); legend('boxoff');
    set(gca, 'fontsize', 13, 'fontweight', 'bold');
    hold off;
    
else
    
    p1 = ndass_niceplot(granger_1to2_maze, frequencies , 1, color_of, face_alpha_of, line_unsafe);
    hold on;
    p2 = ndass_niceplot(granger_1to2_base, frequencies , 1, color_base_of, face_alpha_of, line_safe);
    xlabel('Frequency (Hz)'); ylabel('Granger Causality');
    title('OF Theta Granger Causality; OB to mPFC');
    legend([p1 p2], 'OF', 'Baseline'); legend('boxoff');
    set(gca, 'fontsize', 13, 'fontweight', 'bold');
    hold off;
    
end

%% Plot: ob-to-mpfc vs. mpfc-to-ob in maze
for trial_i = 1 : size(granger_results_maze,2)
    temp_trial = squeeze(granger_results_maze{trial_i}(1,:,:));
    
    granger_1to2_unsafe(trial_i,:) = temp_trial(:,1);
    granger_1to2_safe(trial_i,:) = temp_trial(:,2);
    
end
granger_1to2_maze = [granger_1to2_unsafe;granger_1to2_safe];

for trial_i = 1 : size(granger_results_maze,2)
    temp_trial = squeeze(granger_results_maze{trial_i}(2,:,:));
    
    granger_2to1_unsafe(trial_i,:) = temp_trial(:,1);
    granger_2to1_safe(trial_i,:) = temp_trial(:,2);
    
end
granger_2to1_maze = [granger_2to1_unsafe;granger_2to1_safe];

% remove outlier trial for OF
if ~experiment_num
    granger_1to2_maze = granger_1to2_maze([1:11 13:24],:);
    granger_2to1_maze = granger_2to1_maze([1:11 13:24],:);
end


% parameters
face_alpha_epm = 0.4; face_alpha_of = 0.5;
color_open = [255 178 102]; color_closed = [153 204 255];
color_center = [255 128 0]; color_periph = [0 128 255];
color_base_epm = [153 255 153]; color_base_of = [0 204 0];
color_epm = [160 160 160]; color_of = [96 96 96];

color_1to2_epm = [205,133,63]; color_2to1_epm = [180 0 180];
color_1to2_of = [160,82,45]; color_2to1_of = [96 0 96];

line_safe = '-'; line_unsafe = '--'; line_base = ':';

% plotting
figure(2);
% subplot(121);
if experiment_num == 1
    
    p1 = ndass_niceplot(granger_1to2_maze, frequencies , 1, color_1to2_epm, face_alpha_epm, line_unsafe);
    hold on;
    p2 = ndass_niceplot(granger_2to1_maze, frequencies , 1, color_2to1_epm, face_alpha_epm, line_safe);
    xlabel('Frequency (Hz)'); ylabel('Granger Causality');
    title('Theta Granger Causality during Anxiety (EPM)');
    legend([p1 p2], 'OB -> mPFC', 'mPFC -> OB'); legend('boxoff');
    set(gca, 'fontsize', 13, 'fontweight', 'bold');
    hold off;
    
else
    
    p1 = ndass_niceplot(granger_1to2_maze, frequencies , 1, color_1to2_of, face_alpha_of, line_unsafe);
    hold on;
    p2 = ndass_niceplot(granger_2to1_maze, frequencies , 1, color_2to1_of, face_alpha_of, line_safe);
    xlabel('Frequency (Hz)'); ylabel('Granger Causality');
    title('Theta Granger Causality during Anxiety (OF)');
    legend([p1 p2], 'OB -> mPFC', 'mPFC -> OB'); legend('boxoff');
    set(gca, 'fontsize', 13, 'fontweight', 'bold');
    hold off;
    
end













