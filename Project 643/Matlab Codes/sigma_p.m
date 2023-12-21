%function [portfolio_variance,portfolio_std_dev,portfolio_returns] = sigma_p(returns_matrix,weights)
data = DATA;
[returns_matrix,~] = r_i(data);
weights = [0.3 0.4 0.3];
% Calculate portfolio returns
portfolio_returns = returns_matrix * weights';

% Calculate the covariance matrix of asset returns
covariance_matrix = cov(returns_matrix);

% Calculate portfolio variance
portfolio_variance = weights * covariance_matrix * weights';

% Calculate portfolio standard deviation (volatility)
portfolio_std_dev = sqrt(portfolio_variance);

% Display the results
% disp('Portfolio Standard Deviation:');
% disp(portfolio_std_dev);
