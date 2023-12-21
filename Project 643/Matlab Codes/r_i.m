function [returns,expected_returns] = r_i(data)

returns = price2ret([data.ABC(:),data.XYZ(:),data.DEF(:)]);

% Calculate expected return for each asset
expected_returns = mean(returns);

% Display the results
% disp('Expected Returns:');
% disp(expected_returns);
