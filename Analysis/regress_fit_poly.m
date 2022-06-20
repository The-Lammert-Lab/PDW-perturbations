function b_hat = regress_fit_poly(x,y,p)
%
% Name: regress_fit_poly
%
% Inputs:
%    x - A n-by-1 vector of feature values 
%        (where n is number of data points)
%    y - A n-by-1 vector of response variable values
%    p - A scalar value, indicating the polynomial order
% Outputs:
%    b_hat - a (p+1)-by-1 vector of regression coefficients 
%
% Created by: Adam C. Lammert (2020)
% Author: Nelson Barnett
%
% Description: Determine coefficients of a polynomial
%               regression model given x, y and p
%

% Define some useful variables
n = length(x);

% Build design matrix, PHI, appropriate for a polynomial regression
% of the order specified by 'p'. 
% Your function should be able to handle any reasonable value for 'p'.
% Hint: In order to handle any value for 'p', you will most likely need
% to write a 'for' loop that iterates over increasing powers of 'x'.
PHI = zeros(n,p+1);

for itor = 0:p
    PHI(:,itor+1) = x.^(p-itor);
end
    
    
% Determine regression parameters, b_hat
b_hat = inv(PHI'*PHI)*PHI'*y;

return
%eof