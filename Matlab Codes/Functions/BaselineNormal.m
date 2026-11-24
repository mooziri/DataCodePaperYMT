function [NormData] = BaselineNormal(data,baseline,method)

%%   HELP of the function
%   description : this function normalizes the "data" with respect to the
%   "baseline".
%   *************** 
%   "data" and "baseline" MUST be the same feature of the signal. e.g.,
%   Power, Coherence, etc.
%   ***************
%
%   ***** Inputs *****
%   * data : your data.
%   * baseline : baseline values of the same signal feature.
%   * method : the preferred normalization methodology.
%   
%   ***** Output *****
%   * NormData : baseline-normalized data.

%% FUNCTION
% parameters
if isempty(method)
    method = 2;
end

switch method
    case 1
        
        
    case 2
        
        
end
    
end