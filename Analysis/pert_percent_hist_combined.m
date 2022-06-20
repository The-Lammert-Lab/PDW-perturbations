%%% Graph the perturbation percent in histograms
%%% Using data from gamma = 0.019 pert = +/- 32% from original manuscript
%%% data

addpath('../Brewermap colors');


P = load('../Data/Data NEWFALL (reviewer edits)/Data n50000g0.014p0.5d03-Jun22/perturbationPercent.csv');
M = load('../Data/Data NEWFALL (reviewer edits)/Data n50000g0.014p0.5d03-Jun22/metrics.csv');
yall = M(:,1);


P(size(P,1)+1:size(P,1)+4,:) = load('../Data/Data NEWFALL (reviewer edits)/Data n50000g0.016p0.5d04-Jun22/perturbationPercent.csv');
M = load('../Data/Data NEWFALL (reviewer edits)/Data n50000g0.016p0.5d04-Jun22/metrics.csv');
yall(:,size(yall,2)+1) = M(:,1);


P(size(P,1)+1:size(P,1)+4,:) = load('../Data/Data NEWFALL (reviewer edits)/Data n50000g0.019p0.5d05-Jun22/perturbationPercent.csv');
M = load('../Data/Data NEWFALL (reviewer edits)/Data n50000g0.019p0.5d05-Jun22/metrics.csv');
yall(:,size(yall,2)+1) = M(:,1);



% pert = 0.32;
pert = 0.50;

gam = [0.014, 0.016, 0.019];
p_ind = (1:4:size(P,1));
bin_edges = -pert*100:pert*100;

% map = brewermap(2,'Set1');
map = brewermap(40,'Greys');

light = 25;
alpha = 0.75;

figure
t = tiledlayout(4,size(yall,2),'TileSpacing','Compact');
for i = 1:size(yall,2)
    
    p1g = P(p_ind(i),:)';
    p2g = P(p_ind(i)+1,:)';
    p3g = P(p_ind(i)+2,:)';
    p4g = P(p_ind(i)+3,:)';
    
    y = yall(:,i);
    
    nexttile(i)
    hold on
    histogram(p1g(y==0),bin_edges,'FaceColor',map(end,:),'facealpha',alpha,'edgecolor','none')
    histogram(p1g(y==1),bin_edges,'FaceColor',map(light,:),'facealpha',alpha,'edgecolor','none')
    title(['$\theta \ at \ \gamma =\ $' num2str(gam(i)), '$rad$'],'Interpreter','latex','Fontsize', 18)

    
    nexttile(i+3)
    hold on
    histogram(p2g(y==0),bin_edges,'FaceColor',map(end,:),'facealpha',alpha,'edgecolor','none')
    histogram(p2g(y==1),bin_edges,'FaceColor',map(light,:),'facealpha',alpha,'edgecolor','none')
    title(['$\dot{\theta} \ at \ \gamma =\ $' num2str(gam(i)), '$rad$'],'Interpreter','latex','Fontsize',18)

    
    nexttile(i+6)
    hold on
    histogram(p3g(y==0),bin_edges,'FaceColor',map(end,:),'facealpha',alpha,'edgecolor','none')
    histogram(p3g(y==1),bin_edges,'FaceColor',map(light,:),'facealpha',alpha,'edgecolor','none')
    title(['$\phi \ at \ \gamma =\ $' num2str(gam(i)), '$rad$'],'Interpreter','latex','Fontsize', 18)

    
    nexttile(i+9)
    hold on
    histogram(p4g(y==0),bin_edges,'FaceColor',map(end,:),'facealpha',alpha,'edgecolor','none')
    histogram(p4g(y==1),bin_edges,'FaceColor',map(light,:),'facealpha',alpha,'edgecolor','none')
    title(['$\dot{\phi} \ at \ \gamma =\ $' num2str(gam(i)), '$rad$'],'Interpreter','latex','Fontsize',18)    

end

% title(t, ['Distribution of \pm', num2str(pert*100),'% perturbation size at \gamma = ', num2str(gam)],'fontsize',23)

nexttile(3)
legend('Non-falls','Falls','Location','northeast','Fontsize',20)

xlabel(t, 'Perturbation magnitude (%)','fontsize',20)
ylabel(t, 'Frequency','fontsize',20)




