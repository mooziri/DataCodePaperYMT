%% function help
% Written by: Morteza Mooziri (Apr 17, 2024)
% this function calculates signal power based on pwelch
% 
%%%%% Input %%%%%
% input_sig:     N*M input signal, where N is the number of trials and M is the
%                number of time-points
% fs:            sampling frequency of input signal
% win:           window size for pwelch method (in number of data points)
% ol:            window overlap for pwelch method (in number of data points)
% freqs:         frequencies
% trans_method:  transform type (1 for pwelch, and 2 for wavelet)
% output_method: output type (1 for absolute power, and 2 for relative power)
% 
%%%%% Output %%%%%
% power_val: power values for the desired frequency band
% freqs :    output frequencies

%% function
function [power_val,freqs] = ComputePower(input_sig, fs, win, ol, ...
    freqs, trans_method, output_method)

% variables
total_freqs = .1:.1:200;
if isempty(fs); fs=1000; end
if isempty(win); win=.9*fs; end
if isempty(ol); ol=.9*win; end
if isempty(trans_method); trans_method=1; end
if isempty(output_method); output_method=1; end

% core
switch trans_method
    
    case 1 % pwelch method
        
        switch output_method
            case 1 % absolute power
                for iTrial = 1 : size(input_sig,1)
                    power_val(iTrial,:) = pwelch(squeeze(input_sig(iTrial,:)),win,ol,freqs,fs);
                end
                
            case 2 % relative power
                for iTrial = 1 : size(input_sig,1)
                    abs_power(iTrial,:) = pwelch(squeeze(input_sig(iTrial,:)),win,ol,total_freqs,fs);
                    power_desired_band(iTrial,:) = abs_power(iTrial,ind_freq_band);
                    
                    power_val(iTrial,:) = ...
                        power_desired_band(iTrial,:) ./ sum(squeeze(abs_power(iTrial,:)));
                end
        end
        
    case 2 % wavelet transform
        % not yet defined
end

end

