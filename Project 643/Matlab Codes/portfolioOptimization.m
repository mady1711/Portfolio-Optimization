function f = portfolioOptimization(w,covariance_matrix,expected_returns)
% w = [0 0 0.1 0.1 0.2 0.1 0.3];
[lb,ub] = DATA;
weight = [w,1-sum(w)];
% Calculate portfolio variance
portfolio_variance = weight * covariance_matrix * weight';

% Calculate portfolio standard deviation (volatility)
portfolio_std_dev = sqrt(portfolio_variance);

%% CONSTRAINTS
% Bound Constraints
n = length(lb);
bound_penalty = 0;
if weight(n)<lb(n)
    bound_penalty = 1e10;
elseif weight(n) > ub(n)
    bound_penalty = 1e10;
end
%Risk Targets
target = 0.3;
risk_pen = 0;
if(portfolio_std_dev>=target)
    risk_pen = 1e5;
end

%% OBJECTIVE FUNCTION
net_ret = sum(weight.*expected_returns);

penalty = bound_penalty+risk_pen;

f=-net_ret+1e5*penalty;

