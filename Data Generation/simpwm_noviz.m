function [y] = simpwm_noviz(gam,steps,y0)
% SIMPWM_NOVIZ
% variation of simpwm without visualization, inputted ICs
%   SIMPWM simulates the "Simplest Walking Model" passive dynamic walker for
%   eight STEPS with a default slope, GAM, of 0.01 radians.
%   
%   SIMPWM(GAM) optionally specifies the slope angle, GAM, in radians.
%   
%   SIMPWM(GAM, STEPS) optionally specifies the integer number of STEPS to
%   simulate.
%   
%   See also: ACTUWM, FULLWM, WMVIEW.

%   Based on:
%   
%   [1] M. Garcia, A. Chatterjee, A. Ruina, and M. Coleman, "The Simplest
%   Walking Model: Stability, Complexity, and Scaling," ASME Journal of
%   Biomedical Engineering, Vol. 120, No. 2, pp. 281-288, 1998.
%   http://dx.doi.org/10.1115/1.2798313
%   
%   [2] Mario W. Gomes "A Derivation of the Transisition Rule at Heelstrike
%   which appears in the paper 'The Simplest Walking Model: Stability,
%   Complexity, and Scaling' by Garcia et al." pp. 1-3, Oct. 4, 1999.
%   http://ruina.tam.cornell.edu/research/topics/locomotion_and_robotics/simplest_walking/simplest_walking_gomes.pdf

%   Andrew D. Horchler, horchler @ gmail . com, Created 7-7-04
%   Revision: 1.1, 5-1-16


% Gamma: angle of slope (radians), used by integration function
if nargin < 1
    gam = 0.01;
end

% Integration time parameters
if nargin < 2
    steps = 18;  % Number of steps to simulate
end
per = 5;        % Max number of seconds allowed per step

% Initialization
y = y0.';     	% Vector to save states
t = 0;          % Vector to save times
tci = 0;        % Collision index vector
h = [0 per];    % Integration period in seconds

% Set integration tolerances, turn on collision detection, add more output points
opts = odeset('RelTol',1e-4,'AbsTol',1e-8,'Refine',30,'Events',@collision);

% Loop to perform integration of a noncontinuous function
for i=1:steps
   [tout,yout] = ode45(@(t,y)f(t,y,gam),h,y0,opts); % Integrate for one stride
   y = [y;yout(2:end,:)];                        	%#ok<AGROW> % Append states to state vector
   t = [t;tout(2:end)];                          	%#ok<AGROW> % Append times to time vector
   c2y1 = cos(2*y(end,1));                         	% Calculate once for new ICs
   y0 = [-y(end,1);
         c2y1*y(end,2);
         -2*y(end,1);
         c2y1*(1-c2y1)*y(end,2)];                 	% Mapping to calculate new ICs after collision
   tci = [tci length(t)];                          	%#ok<AGROW> % Append collision index to collision index vector
   h = t(end)+[0 per];                              % New integration period 
end

function ydot=f(t,y,gam)    %#ok<INUSL>
% ODE definition
% y1: theta
% y2: thetadot
% y3: phi
% y4: phidot
% gam: slope of incline (radians)

% First order differential equations for Simplest Walking Model
ydot = [y(2);
        sin(y(1)-gam);
        y(4);
        sin(y(1)-gam)+sin(y(3))*(y(2)*y(2)-cos(y(1)-gam))];


function [val,ist,dir]=collision(t,y)   %#ok<INUSL>
% Check for heelstrike collision using zero-crossing detection

val = y(3)-2*y(1);  % Geometric collision condition, when = 0
ist = 1;            % Stop integrating if collision found
dir = 1;            % Condition only true when passing from - to +