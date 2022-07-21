% regress_fit_poly
%
% ARGUMENTS:
% 
%    x: n-by-1 vector of feature values 
%        (where n is number of data points)
% 
%    y: n-by-1 vector of response variable values
% 
%    p: 1x1 scalar
%       indicating the polynomial order
% 
% OUTPUTS:
% 
%    b_hat: (p+1)-by-1 vector of regression coefficients 
%
% Created by: Adam C. Lammert (2020)
%
% Description: Determine coefficients of a polynomial
%               regression model given x, y and p


function b_hat = regress_fit_poly(x,y,p)

% Define some useful variables
n = length(x);

% Build design matrix, PHI
PHI = zeros(n,p+1);

for itor = 0:p
    PHI(:,itor+1) = x.^(p-itor);
end
    
    
% Determine regression parameters, b_hat
b_hat = inv(PHI'*PHI)*PHI'*y;

return
%eof