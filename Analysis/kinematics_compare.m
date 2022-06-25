%%%%% visualize kinematic data comparisons %%%%%

gam = 0.019;
steps = 9;

% Fall on the 10th step, gam = 0.019
y0_1 = [0.252696518486410; -0.244652396358143; 0.512649148091296; -0.026448123590688];

% Doesn't fall, (in this case a difference of +/-10^-5) from the one above
% gam = 0.019
y0_2 = [0.252694352775634; -0.244653678610799; 0.512653080984690; -0.026448203653911];


% Stable ICs
Theta00 = 0.970956;
Theta10 = -0.270837;
alpha = -1.045203;
c1 = 1.062895;

tgam3 = Theta00*gam^(1/3);
y0_3 = [tgam3+Theta10*gam;
      alpha*tgam3+(alpha*Theta10+c1)*gam;
      2*(tgam3+Theta10*gam);
      (alpha*tgam3+(alpha*Theta10+c1)*gam)*(1-cos(2*(tgam3+Theta10*gam)))];

% Fall (different) on the 10th step, gam = 0.019
y0_4 = [0.235991962480430; -0.227370542881631; 0.486549886806551; -0.025767213519994];


% Alternate non-fall, gam = 0.019
y0_5 = [0.321557285821432; -0.307976404827011; 0.645817118463110; -0.021720359301322];

% Perturbation percent = [26.625196157246634; 25.587684808119938;
% 27.157310552296892; -29.830906808617851];




% Get data
[a_1,t_1] = perturb_pdw_y0(gam,steps,y0_1);
[a_2,t_2] = perturb_pdw_y0(gam,steps,y0_2);
[a_3,t_3] = perturb_pdw_y0(gam,steps,y0_3);
% [a_4,t_4] = perturb_pdw_y0(gam,steps,y0_4);
[a_5,t_5] = perturb_pdw_y0(gam,steps,y0_5);


% Graphing
nIDs = 6;
alphabet = ('a':'z').';
chars = num2cell(alphabet(1:nIDs));
chars = chars.';
charlbl = strcat('(',chars,')'); % {'(a)','(b)','(c)'}

fontsz = 11.5;
linewth = 2;

% figure
% t = tiledlayout(2,1);
% nexttile
% hold on
% grid on
% plot(t_3,a_3(:,1),'k','LineWidth',linewth)
% plot(t_5,a_5(:,1),'--k','LineWidth',linewth)
% plot(t_1,a_1(:,1),'-.k','LineWidth',linewth) 
% plot(t_2,a_2(:,1),':k','LineWidth',linewth)
% ylabel('$\theta$ (rad.)','Interpreter','latex','Fontsize',23)
% xlim([0 35])
% % legend('theoretical','non-fall','fall','non-fall','Location','northeast')
% lgd = legend('Theoretical','Non-fall','Fall','Alt. non-fall','Location','northeast');
% lgd.FontSize = fontsz;
% 
% 
% nexttile
% hold on
% grid on
% plot(t_3,a_3(:,2),'k','LineWidth',linewth)
% plot(t_5,a_5(:,2),'--k','LineWidth',linewth)
% plot(t_1,a_1(:,2),'-.k','LineWidth',linewth) 
% plot(t_2,a_2(:,2),':k','LineWidth',linewth)
% ylabel('$\phi$ (rad.)','Interpreter','latex','Fontsize',23)
% xlim([0 35])
% 
% xlabel(t, 'time $(\sqrt{\frac{l}{g}})$','Interpreter','latex','Fontsize',23)

figure
t = tiledlayout(2,1,'TileSpacing','Compact');
nexttile
hold on
grid on
plot(t_3,a_3(:,1),'k','LineWidth',linewth)
plot(t_5,a_5(:,1),'b','LineWidth',linewth)
plot(t_1,a_1(:,1),'r','LineWidth',linewth) 
plot(t_2,a_2(:,1),'--b','LineWidth',linewth)
ylabel('$\theta$ (rad.)','Interpreter','latex','Fontsize',23)
xlim([0 35])
lgd = legend('Pre-pert.','Non-fall','Fall','Alt. non-fall','Location','northeast');
lgd.FontSize = fontsz;

nexttile
hold on
grid on
plot(t_3,a_3(:,2),'k','LineWidth',linewth)
plot(t_5,a_5(:,2),'b','LineWidth',linewth)
plot(t_1,a_1(:,2),'r','LineWidth',linewth) 
plot(t_2,a_2(:,2),'--b','LineWidth',linewth)
ylabel('$\phi$ (rad.)','Interpreter','latex','Fontsize',23)
xlim([0 35])

xlabel(t, 'time $\left( \sqrt{\frac{l}{g}} \right)$','Interpreter','latex','Fontsize',23)






% % Theta
% figure
% t = tiledlayout(3,1);
% nexttile
% hold on
% grid on
% plot(t_3,a_3(:,1),'k') %k
% plot(t_5,a_5(:,1),'--k') %b
% xlim([0 35])
% text(0.95,0.1,charlbl{1},'Units','normalized','FontSize',12)
% legend('theoretical','non-fall','Location','northeast')
% 
% %%% fall + non-fall %%%
% nexttile
% hold on
% grid on
% plot(t_1,a_1(:,1),':k') %r
% plot(t_5,a_5(:,1),'--k') %b
% xlim([0 35])
% text(0.95,0.1,charlbl{2},'Units','normalized','FontSize',12)
% legend('fall','non-fall','Location','northeast')
% 
% %%% Fall + "almost fall" %%%
% nexttile
% hold on
% grid on
% plot(t_1,a_1(:,1),':k') %r
% plot(t_2,a_2(:,1),'-.k') %b
% text(0.95,0.1,charlbl{3},'Units','normalized','FontSize',12)
% legend('fall','non-fall','Location','northeast')
% 
% % title(t, 'Theta comparison','Fontsize',23)
% % xlabel(t, 'time $(\sqrt{\frac{l}{g}})$','Interpreter','latex','Fontsize',23)
% ylabel(t, '$\theta$ (rad.)','Interpreter','latex','Fontsize',23)
% 
% % Phi
% figure
% t = tiledlayout(3,1);
% 
% nexttile
% hold on
% grid on
% plot(t_3,a_3(:,2),'k') %k
% plot(t_5,a_5(:,2),'--k') %b
% xlim([0 35])
% text(0.95,0.1,charlbl{4},'Units','normalized','FontSize',12)
% legend('theoretical','non-fall','Location','northeast')
% 
% %%% fall + non-fall %%%
% nexttile
% hold on
% grid on
% plot(t_1,a_1(:,2),':k') %r
% plot(t_5,a_5(:,2),'--k') %b
% xlim([0 35])
% text(0.95,0.1,charlbl{5},'Units','normalized','FontSize',12)
% legend('fall','non-fall','Location','northeast')
% 
% %%% Fall + "almost fall" %%%
% nexttile
% hold on
% grid on
% plot(t_1,a_1(:,2),':k') %r
% plot(t_2,a_2(:,2),'-.k') %b
% text(0.95,0.1,charlbl{6},'Units','normalized','FontSize',12)
% legend('fall','non-fall','Location','northeast')

% % title(t, 'Phi comparison','Fontsize',23)
% xlabel(t, 'time $(\sqrt{\frac{l}{g}})$','Interpreter','latex','Fontsize',23)
% ylabel(t, '$\phi$ (rad.)','Interpreter','latex','Fontsize',23)




