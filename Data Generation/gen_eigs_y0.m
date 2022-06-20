function [a,t] = gen_eigs_y0(gam,steps,y0)
%%%%%%% model simulation that takes in y0 %%%%%%

per = 5;        % Max number of seconds allowed per step

y0_init = y0;

% Initialization
y = y0.';     	% Vector to save states
t = 0;          % Vector to save times
tci = 0;        % Collision index vector
h = [0 per];    % Integration period in seconds
v = 0;          % Fall values
step_inds = zeros(1,steps); % Step indices
step_length = zeros(1,steps); % Step lengths

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
   v = y(:,1) - gam;
   step_inds(i) = length(y);
   step_length(i) = (1.5*sin(abs(y(step_inds(i),3))))/sin((pi/2)-abs(y(step_inds(i),1)));
end

fall = zeros(length(y),1);
fallIndex = zeros(length(y),1);

% Determine if he fell
I = find(v >= pi/2);
TF = isempty(I);


%%%%%%%%%

step_time(1) = step_inds(1);
step_time(2:length(diff(step_inds))+1,1) = diff(step_inds);

% Report fall data if applicable
if TF == 0
    fallIndex(1) = I(1);
    fall(1) = 1;
    a = [y(:,1), y(:,3), fall, fallIndex];
else
    a = [y(:,1), y(:,3)];
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