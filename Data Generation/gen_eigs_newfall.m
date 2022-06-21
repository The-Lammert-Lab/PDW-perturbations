%%% edited gen_eigs with new fall condition

function [a, pert_percent, y0_init, step_time, step_inds, step_length, ST2] = gen_eigs_newfall(steps,gam,pert)

per = 5;        % Max number of seconds allowed per step

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

%% y0 values for testing

% FALL AT STEP 50!!
% y0 = [0.141782242771965; -0.138488275496900; 0.388413527493334; -0.015427038129602];

%%% testing large pert falls

% non-fall gam = 0.019, pert percent = [-28.859027393020725;
% -27.762823650970802; -20.212823671316894; -31.233411775500752]
% y0 = [0.180658342544948; -0.177145919210308; 0.405229743245520; -0.021286223552702];

% non-fall gam = 0.019, pert percent = [27.932313832872246; 26.698495370175539; 
% 29.377198622068825; -30.685218133753196]
% y0 = [0.324876634772343; -0.310700425449482; 0.657091670514453; -0.021455913117209];

% fall gam = 0.019, pert percent = [-27.626394723762278; -27.890931985429269;
% -19.082952525264190; -27.798976613371156]
% y0 = [0.183788541175001; -0.176831761461997; 0.410968226739777; -0.022349329292363];

%%% Verification of results for fig. 3 in paper. (gam = 0.019).

% Fall on step 10. GOOD
% y0 = [0.252696518486410; -0.244652396358143; 0.512649148091296; -0.026448123590688];

% % non-fall GOOD
% y0 = [0.252694352775634; -0.244653678610799; 0.512653080984690; -0.026448203653911];

% % Fall
% y0 = [0.235991962480430; -0.227370542881631; 0.486549886806551; -0.025767213519994];
% 
% % alternate non-fall
% y0 = [0.321557285821432; -0.307976404827011; 0.645817118463110; -0.021720359301322];
% 

%%% Testing large pert falls (gam = 0.019)

% pert_percent =[21.092055531152781
%   20.081832632514473
%   25.836499827772364
%   45.781502924556392];

% y0 = [0.307506198551363; -0.294474503258058; 0.639108875166341; -0.045125659731298];

% pert_percent = [27.898752553752992
%   26.900222475098118
%   37.188762829814067
%   47.498741569674820];

% y0 = [0.324791407865299
%   -0.311195117175229
%    0.696765692129284
%   -0.045657219121361];

% pert_percent = [-48.056269373346275
%  -44.409223917425997
%  -19.962787030773406
%  -10.438953369900403];


% y0 = [0.131908068398996
%   -0.136324253334333
%    0.406499650119176
%   -0.027723004869145];


% pert_percent = [25.370758224677715
%   24.013965071768574
%   35.985539144219118
%  -10.482695294764099];
% 
% y0 = [0.318371713999475
%   -0.304117200420565
%    0.690654659659957
%   -0.027709464857705];


% y0 = [0.323688696315239
%   -0.338122438272251
%    0.647856123189040
%   -0.030787462621888];
% 
% 
% pert_percent =
% 
%   27.464518678521539
%   37.880738714838650
%   27.558777701030380
%   -0.539014853683505
% 
% 
% y0_init =
% 
%    0.129951133673453
%   -0.124907728068907
%    0.415660722195247
%   -0.038770421509929
% 
% 
% pert_percent =
% 
%  -48.826885541646604
%  -49.064694122825863
%  -18.159029815819029
%   25.250475015568153
% 
% 
% y0_init =
% 
%    0.336165943676190
%   -0.321247425295317
%    0.750051042522630
%   -0.034827934939390
% 
% 
% pert_percent =
% 
%   32.377901034473794
%   30.999387489018186
%   47.680311681877541
%   12.514004880052864
% 
% 
% y0_init =
% 
%    0.135930871592909
%   -0.128166696058345
%    0.405463032156417
%   -0.025573459530889
% 
% 
% pert_percent =
% 
%  -46.472140305239598
%  -47.735740871075130
%  -20.166890558608664
%  -17.383205307300038
% 
% 
% y0_init =
% 
%    0.312039822627928
%   -0.298509098854664
%    0.689098260808078
%   -0.021186072568812
% 
% 
% pert_percent =
% 
%   22.877339408430768
%   21.727073995726773
%   35.679094043131563
%  -31.556956318403561
% 
% 
% y0_init =
% 
%    0.331690306217201
%   -0.317267651492799
%    0.748418086431856
%   -0.022260386452773
% 
% 
% pert_percent =
% 
%   30.615451554514124
%   29.376501546833889
%   47.358792944116409
%  -28.086312486289472
% 
% 
% y0_init =
% 
%    0.142939137799232
%   -0.143011597904954
%    0.420049506799339
%   -0.025787637488024
% 
% 
% pert_percent =
% 
%  -43.712373625312182
%  -41.682235391762191
%  -17.294905854258879
%  -16.691288897204657
% 
% 
% y0_init =
% 
%    0.152557602341696
%   -0.155677679138054
%    0.420569057020188
%   -0.027923171725011
% 
% 
% pert_percent =
% 
%  -39.924743821466379
%  -36.517216926954461
%  -17.192609698131591
%   -9.792300772296963
% 
% 
% y0_init =
% 
%    0.163930620073909
%   -0.157232030531928
%    0.418792231837043
%   -0.041878637988071
% 
% 
% pert_percent =
% 
%  -35.446193140947670
%  -35.883378133217960
%  -17.542455351260152
%   35.291779060682828
% 
% 
% y0_init =
% 
%    0.350826652826532
%   -0.336519228753137
%    0.734553642360220
%   -0.042983374719864
% 
% 
% pert_percent =
% 
%   38.151103054213500
%   37.226976385607927
%   44.628971497686841
%   38.860705965147588
% 
% 
% y0_init =
% 
%    0.340207003390792
%   -0.325965334070420
%    0.711170626332366
%   -0.036462105945704
% 
% 
% pert_percent =
% 
%   33.969219289749390
%   32.923272666306104
%   40.025003368475645
%   17.793305099810965
% 
% 
% y0_init =
% 
%    0.134824898982975
%   -0.134527323939249
%    0.409734615459031
%   -0.017253456396006
% 
% 
% pert_percent =
% 
%  -46.907658344644688
%  -45.141982008485243
%  -19.325842792867874
%  -44.261539464905049
% 
% 
% y0_init =
% 
%    0.333460239352304
%   -0.319201392717369
%    0.695443071713102
%   -0.043279996763415
% 
% 
% pert_percent =
% 
%   31.312428859335828
%   30.165049239466846
%   36.928347225775013
%   39.818963585467806




%% 

% Initialization
y = y0.';     	% Vector to save states
t = 0;          % Vector to save times
tci = 0;        % Collision index vector
h = [0 per];    % Integration period in seconds

step_inds = zeros(1,steps); % Step indices
step_length = zeros(1,steps); % Step lengths
step_time = zeros(1,steps); 

L = 1; % Leg length
% Position of stance foot
xst = 0;
yst = 0;
% Position of hip
xm = xst-L*sin(y(1,1)-gam);
ym = yst+L*cos(y(1,1)-gam);
% Position of swing foot
xsw = xm-L*sin(y(1,3)-y(1,1)+gam);
ysw = ym-L*cos(y(1,3)-y(1,1)+gam);
I_a = [];
I_b = [];

% Distance below slope to count as a fall.
fall_thresh = 0.01; 

% point slope formula
coeff = polyfit([xst 10.25],[yst (xst-10.25)*tan(gam)],1);

% Initial distance of swing leg below ramp
if ysw < (coeff(1)*xsw)+coeff(2)
    init_sw_dist = (coeff(1)*xsw)+coeff(2) - ysw;
else
    init_sw_dist = 0;
end

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
   step_length(i) = 2*L*sin(abs(y(step_inds(i))));
   I_b = find(v >= pi/2, 1);
   step_time(i) = t(end);

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

   if step_inds(1) <= 100
       break
   elseif ysw + init_sw_dist < (coeff(1)*xsw)+coeff(2) - fall_thresh || yst < (coeff(1)*xst)+coeff(2) - fall_thresh
       I_a = i;
       break
   elseif isempty(I_b) == 0
       break
   end

end

fallIndex = zeros(length(y),1);

%%%%%%%%%

step_time(1) = step_inds(1);
step_time(2:length(diff(step_inds))+1,1) = diff(step_inds);

ST2(1) = step_time(1);
ST2(2:length(diff(step_time))+1,1) = diff(step_time);

% % Run model animation: mview.m
wmview(y,gam,tci)

% Report fall data if applicable
if step_inds(1) <= 100
    fallIndex(1) = step_inds(1);
    a = [y(:,1), y(:,3), fallIndex];
elseif isempty(I_a) == 1 && isempty(I_b) == 1
    a = [y(:,1), y(:,3)];
elseif isempty(I_a) == 0
    fallIndex(1) = step_inds(I_a(1));
    a = [y(:,1), y(:,3), fallIndex];
else
    fallIndex(1) = I_b(1);
    a = [y(:,1), y(:,3), fallIndex];
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