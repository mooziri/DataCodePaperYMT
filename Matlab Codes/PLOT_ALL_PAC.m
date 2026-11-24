clc,clear,close all
figure
%% OB2OB
load('PAC_YMT_v01_OB2OB.mat')
phase_freq=[1:0.5:12];
amp_freq=[12:1:30];
c_axis=[0 15e-3]

subplot(4,3,1)
imagesc(phase_freq,amp_freq,squeeze(mean(PAC_baseline,1)));
shading(gca,'interp');colormap(jet); colorbar;title('PAC Baseline OB2OB');
xlabel('Phase Frequency');ylabel('Amplitude Frequency (Hz)');set(gca,'YDir','normal')
   caxis(c_axis)
 
subplot(4,3,2)
imagesc(phase_freq,amp_freq,squeeze(mean(PAC_correct,1)));
shading(gca,'interp');colormap(jet); colorbar;title('PAC correct OB2OB');
xlabel('Phase Frequency');ylabel('Amplitude Frequency (Hz)');set(gca,'YDir','normal')
   caxis(c_axis)
 
subplot(4,3,3)
imagesc(phase_freq,amp_freq,squeeze(mean(PAC_wrong,1)));
shading(gca,'interp');colormap(jet); colorbar;title('PAC wrong OB2OB');
xlabel('Phase Frequency');ylabel('Amplitude Frequency (Hz)');set(gca,'YDir','normal')
   caxis(c_axis)
   %% PFC2PFC
   load('PAC_YMT_v01_PFC2PFC.mat')

subplot(4,3,4)
imagesc(phase_freq,amp_freq,squeeze(mean(PAC_baseline,1)));
shading(gca,'interp');colormap(jet); colorbar;title('PAC Baseline PFC2PFC');
xlabel('Phase Frequency');ylabel('Amplitude Frequency (Hz)');set(gca,'YDir','normal')
   caxis(c_axis)
 
subplot(4,3,5)
imagesc(phase_freq,amp_freq,squeeze(mean(PAC_correct,1)));
shading(gca,'interp');colormap(jet); colorbar;title('PAC correct PFC2PFC');
xlabel('Phase Frequency');ylabel('Amplitude Frequency (Hz)');set(gca,'YDir','normal')
   caxis(c_axis)
 
subplot(4,3,6)
imagesc(phase_freq,amp_freq,squeeze(mean(PAC_wrong,1)));
shading(gca,'interp');colormap(jet); colorbar;title('PAC wrong PFC2PFC');
xlabel('Phase Frequency');ylabel('Amplitude Frequency (Hz)');set(gca,'YDir','normal')
   caxis(c_axis)
   %% PFC2OB
   load('PAC_YMT_v01_PFC2OB.mat')

subplot(4,3,7)
imagesc(phase_freq,amp_freq,squeeze(mean(PAC_baseline,1)));
shading(gca,'interp');colormap(jet); colorbar;title('PAC Baseline PFC2OB');
xlabel('Phase Frequency');ylabel('Amplitude Frequency (Hz)');set(gca,'YDir','normal')
   caxis(c_axis)
 
subplot(4,3,8)
imagesc(phase_freq,amp_freq,squeeze(mean(PAC_correct,1)));
shading(gca,'interp');colormap(jet); colorbar;title('PAC correct PFC2OB');
xlabel('Phase Frequency');ylabel('Amplitude Frequency (Hz)');set(gca,'YDir','normal')
   caxis(c_axis)
 
subplot(4,3,9)
imagesc(phase_freq,amp_freq,squeeze(mean(PAC_wrong,1)));
shading(gca,'interp');colormap(jet); colorbar;title('PAC wrong PFC2OB');
xlabel('Phase Frequency');ylabel('Amplitude Frequency (Hz)');set(gca,'YDir','normal')
   caxis(c_axis)
   
   %% OB2PFC
   load('PAC_YMT_v01_PFC2OB.mat')

subplot(4,3,10)
imagesc(phase_freq,amp_freq,squeeze(mean(PAC_baseline,1)));
shading(gca,'interp');colormap(jet); colorbar;title('PAC Baseline OB2PFC');
xlabel('Phase Frequency');ylabel('Amplitude Frequency (Hz)');set(gca,'YDir','normal')
   caxis(c_axis)
 
subplot(4,3,11)
imagesc(phase_freq,amp_freq,squeeze(mean(PAC_correct,1)));
shading(gca,'interp');colormap(jet); colorbar;title('PAC correct OB2PFC');
xlabel('Phase Frequency');ylabel('Amplitude Frequency (Hz)');set(gca,'YDir','normal')
   caxis(c_axis)
 
subplot(4,3,12)
imagesc(phase_freq,amp_freq,squeeze(mean(PAC_wrong,1)));
shading(gca,'interp');colormap(jet); colorbar;title('PAC wrong OB2PFC');
xlabel('Phase Frequency');ylabel('Amplitude Frequency (Hz)');set(gca,'YDir','normal')
   caxis(c_axis)