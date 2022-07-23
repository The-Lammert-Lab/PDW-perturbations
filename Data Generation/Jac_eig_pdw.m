% Jac_eig_pdw
%
% Estimate the Jacobian for Theta
% 
% ARGUMENTS: 
% 
%   gam: 1x1 scalar, 
%       the slope value in radians
% 
%   y0: 4x1 vector,
%       the initial conditions of the PDW
% 
% OUTPUTS:
% 
%   e_n: 2x2 Jacobian of Theta
% 
% Author: Adam C. Lammert (2020)

function e_n = Jac_eig_pdw(gam, y0)

    arguments
        gam (1,1) double {mustBeGreaterThanOrEqual(gam,0), mustBeLessThanOrEqual(gam, 0.019)}
        y0 (4,1) double
    end

    % Setup
    steps = 1;
    n = 1000; % number of simulation iterations
    c = 1e-6; % perturbation size
    period = 'long'; % 'short' or 'long'
    
    % Simulate!
    % y1: theta
    % y2: thetadot
    % y3: phi
    % y4: phidot
    Yminus = zeros(n,4);
    Yplus = zeros(n,4);
    for itor = 1:n
        
        % Perturb ICs - Lammert
        Yminus(itor,:) = y0 + c*randn(4,1);
        
        %%% Perturb ICs - Garcia
        %temp = zeros(4,1);
        %temp(floor(rand(1,1)*4+1)) = sign(randn(1,1));
        %Yminus(itor,:) = y0 + c*temp;
        
        % Run simulation
        [y,~] = simpwm_noviz(gam,steps,Yminus(itor,:)');
            
        % Calculate heelstrike
        c2y1 = cos(2*y(end,1)); % Calculate once for new ICs
        yplus = [-y(end,1);
            c2y1*y(end,2);
            -2*y(end,1);
            c2y1*(1-c2y1)*y(end,2)]; % Mapping to calculate new ICs after collision
        
        % Store Result
        Yplus(itor,:) = yplus;
    end
    
    % Eliminate solutions with no movement
    % NOTE: Need to get to the bottom of why those solutions exist!
    ind = Yplus(:,1)>0;
    Yplus = Yplus(ind,:);
    Yminus = Yminus(ind,:);
    n = size(Yplus,1);
    
    % % % % Jacobian Estimation - Partial State
    % % % % J is a 2-by-2 matrix of partial derivatives
    % % % % rows represent state displacements after heelstrike
    % % % % columns represent state displacements before heelstrike
    % % % J = zeros(2,2);
    % % % b = regress(Yplus(:,1),[Yminus(:,[1 2]) ones(n,1)]);
    % % % J(1,:) = b(1:2);
    % % % b = regress(Yplus(:,2),[Yminus(:,[1 2]) ones(n,1)]);
    % % % J(2,:) = b(1:2);
    
    % Jacobian Estimation - Full State
    % J is a 4-by-4 matrix of partial derivatives
    % rows represent state variables after heelstrike
    % columns represent state variables before heelstrike
    J = zeros(4,4);
    b = regress(Yplus(:,1),[Yminus ones(n,1)]);
    J(1,:) = b(1:4);
    b = regress(Yplus(:,2),[Yminus ones(n,1)]);
    J(2,:) = b(1:4);
    b = regress(Yplus(:,3),[Yminus ones(n,1)]);
    J(3,:) = b(1:4);
    b = regress(Yplus(:,4),[Yminus ones(n,1)]);
    J(4,:) = b(1:4);
    
    % disp('Jacobian (Numerical):');
    J(1:2,1:2);
    
    % disp('Jacobian (Analytical):');
    if strcmp(period,'short')
        % Analytical Jacobian - short period
        Jan = [7.2959766 5.7743697; -5.7743697 -4.2959766] - [17.2297481 17.8663823; 21.0696840 12.0844905].*gam^(2/3);
    elseif strcmp(period,'long')
        % Analytical Jacobian - long period
        Jan = [-5.0707519 -5.8082044; 5.8082044 6.5570116] - [20.3741653 22.1941780; 13.2143569 15.7150640].*gam^(2/3);
    else
        error('period must be specified as short or long')
    end
    
    % Eigenvalue Decomposition - numerical
    [V D] = eigs(J);
    % disp('Magnitude of Eigenvalues (Numerical, 4x4):')
    abs(diag(D)');
    
    % Eigenvalue Decomposition - numerical
    [V D] = eigs(J(1:2,1:2));
    % disp('Magnitude of Eigenvalues (Numerical, 2x2):')
    e_n = abs(diag(D)');
    
    % Eigenvalue Decomposition - analytical
    [V D] = eigs(Jan);
    % disp('Magnitude of Eigenvalues (Analytical):')
    e_a = abs(real(diag(D)'));
    
end %eof