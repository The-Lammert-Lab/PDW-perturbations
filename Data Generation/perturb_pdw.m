function [outcome, fallIndex, pert_percent, y0_init, step_inds, step_length, step_time] = perturb_pdw(steps,gam,pert,view)

    %% General Setup
    
    % % IC constants - short period
    % Theta00 = 0.943976;
    % Theta10 = -0.264561;
    % alpha = -1.090331;
    % c1 = 0.866610;
    
    % IC constants - long period
    Theta00 = 0.970956;
    Theta10 = -0.270837;
    alpha = -1.045203;
    c1 = 1.062895;
    
    % Max number of seconds allowed per step
    per = 5;
    
    %%% Perturb ICs here %%%
    
    % Calculate stable ICs from theoretically determined equations
    tgam3 = Theta00*gam^(1/3);
    y0 = [tgam3+Theta10*gam;
          alpha*tgam3+(alpha*Theta10+c1)*gam;
          2*(tgam3+Theta10*gam);
          (alpha*tgam3+(alpha*Theta10+c1)*gam)*(1-cos(2*(tgam3+Theta10*gam)))];
      
    randmax = abs(y0).*pert; 
    randmin = -randmax;
    
    r = randmin + (randmax-randmin).*rand(4,1);
    
    pert_percent = (r./y0)*100;
    y0 = y0+r;
    
    y0_init = y0;
        
    %% Initialization
    
    y = y0.';     	% Vector to save states
    t = 0;          % Vector to save times
    tci = 0;        % Collision index vector
    h = [0 per];    % Integration period in seconds
    
    step_inds = zeros(1,steps); % Step indices
    step_length = zeros(1,steps); % Step lengths
    step_time_tot = zeros(1,steps); % Time after each step from beginning 
    
    % Leg length
    L = 1; 
    % Position of stance foot
    xst = 0;
    yst = 0;
    % Position of hip
    xm = xst-L*sin(y(1,1)-gam);
    ym = yst+L*cos(y(1,1)-gam);
    % Position of swing foot
    xsw = xm-L*sin(y(1,3)-y(1,1)+gam);
    ysw = ym-L*cos(y(1,3)-y(1,1)+gam);
    
    % Fall detection
    outcome = 'nonfall';
    fallIndex = NaN;
    
    % Distance below slope to count as a fall.
    fall_thresh = 0.01; 
    
    % point slope formula (m should always equal gamma) 
    coeff = polyfit([xst 10.25],[yst (xst-10.25)*tan(gam)],1);
    
    % Initial distance of swing leg below ramp
    if ysw < (coeff(1)*xsw)+coeff(2)
        init_sw_dist = (coeff(1)*xsw)+coeff(2) - ysw;
    else
        init_sw_dist = 0;
    end
    
    % Set integration tolerances, turn on collision detection, add more output points
    opts = odeset('RelTol',1e-4,'AbsTol',1e-8,'Refine',30,'Events',@collision);
    
    %% Integration
    for i = 1:steps   
       % Model simulation
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
       
       % Metrics and fall detection
       v = y(:,1) - gam;
       step_inds(i) = length(y);
       step_length(i) = 2*L*sin(abs(y(step_inds(i))));
       hip_fall_ind = find(v >= pi/2, 1);
       step_time_tot(i) = t(end);
    
       %% Model position
       % On collision switch stance and swing legs
       if i>1
           xst = xsw;
           yst = ysw;
       end
       
       t1 = tci(i)+1;
       t2 = tci(i+1);
       for j=t1:t2
           if mod(j,20)==0 || j==t1 || j==t2           % When to draw
               xm = xst-L*sin(y(j,1)-gam);          	% Position of hip
               ym = yst+L*cos(y(j,1)-gam);
               
               xsw = xm-L*sin(y(j,3)-y(j,1)+gam);    	% Position of swing leg
               ysw = ym-L*cos(y(j,3)-y(j,1)+gam);
           end
       end
    
       %% Fall condition
       if step_inds(1) <= 100
           % This happens sometimes when a fall on step 1 occurs, but never
           % otherwise
           fallIndex = step_inds(1);
           outcome = 'fall';
           break
       elseif ysw + init_sw_dist < (coeff(1)*xsw)+coeff(2) - fall_thresh || ...
               yst < (coeff(1)*xst)+coeff(2) - fall_thresh
           % Foot falls below the line
           fallIndex = step_inds(i);
           outcome = 'fall';
           break
       elseif ~isempty(hip_fall_ind)
           % Hip falls below the line
           fallIndex = hip_fall_ind;
           outcome = 'fall';
           break
       end
    
    end
    
    step_time = [step_time_tot(1), diff(step_time_tot)]';
    
    if view
        % Run model animation
        wmview(y,gam,tci)
    end

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

end


function [val,ist,dir]=collision(t,y)   %#ok<INUSL>
    % Check for heelstrike collision using zero-crossing detection

    val = y(3)-2*y(1);  % Geometric collision condition, when = 0
    ist = 1;            % Stop integrating if collision found
    dir = 1;            % Condition only true when passing from - to +

end