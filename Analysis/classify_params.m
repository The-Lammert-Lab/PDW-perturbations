% classify_params
% 
% Determine parameters of a linear classification model
% given data points X and corresponding class labels y
%
% ARGUMENTS:
% 
%    y: n-by-1 vector of class labels, 
%       corresponding to data points in X
% 
%    X: n-by-p data matrix 
% 
% OUTPUTS:
% 
%    w: p-by-1 projection vector
% 
%    c: 1x1 scalar,
%       the threshold value

function [w, c] = classify_params(y,X)

    arguments
        y (:,1) {mustBeInteger}
        X (:,:) double
    end
    
    % Projection vector
    w = cov(X)\(mean(X(y==1,:))-mean(X(y==0,:)))';
    
    % Determine the threshold
    c = w'*(mean(X(y==0,:))+mean(X(y==1,:)))'/2;

return
%eof