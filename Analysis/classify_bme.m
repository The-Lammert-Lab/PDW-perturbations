function [w c] = classify_bme(y,X)
%
% Name: classify_bme
%
% Inputs:
%    y - A n-by-1 vector of class labels, corresponding to data points in X
%    X - A n-by-p data matrix 
% Outputs:
%    w - a p-by-1 projection vector
%    c - a scalar (1-by-1) threshold value
%
% Created by: Adam C. Lammert (2020)

% Description: Determine parameters of a linear classification model
%               given data points X and corresponding class labels y

w = cov(X)\(mean(X(y==1,:))-mean(X(y==0,:)))';

% Determine the threshold
c = w'*(mean(X(y==0,:))+mean(X(y==1,:)))'/2;

return
%eof