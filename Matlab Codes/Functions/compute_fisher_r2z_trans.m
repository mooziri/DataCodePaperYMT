function [z_value,decision] = compute_fisher_r2z_trans(corr_1,corr_2,size_1,size_2)

% Written by Morteza Mooziri

%% Function help
% this function computes "fisher r-to-z transformation"

%%%%% input %%%%%
% corr_1: correlation coefficient for population 1
% corr_2: correlation coefficient for population 2
% size_1: size of population 1
% size_2: size of population 2

%%%%% ouput %%%%%
% z_value: the z_value of the difference
% decision: decision regarding statistical significance with
%           level of significance equal to 0.05. "deicision = 1" rejects the
%           null hypothesis.

%% Function
% compute z-values from each sample's r-value
z1 = 0.5 * ( log(1+corr_1) - log(1-corr_1) );
z2 = 0.5 * ( log(1+corr_2) - log(1-corr_2) );

% compute z-score of the difference between the two corrlation coefficients
z_value = (z1 - z2) ./ ( sqrt( (1 ./ (size_1-3)) + (1 ./ (size_2-3)) ) );

% compute decision
if z_value < -1.96 || z_value > 1.96
    decision = 1;
else
    decision = 0;
end

end

