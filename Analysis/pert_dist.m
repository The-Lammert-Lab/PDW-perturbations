%%% Attempt to find a metric for perturbation magnitude.
%%% 4d Eucdist 

addpath('../Brewermap colors');


%% Load data
Pall = load('../Data/Data n50000g0.014p0.32d13-May22/perturbationPercent.csv');
M = load('../Data/Data n50000g0.014p0.32d13-May22/metrics.csv');
y = M(:,1);

Pall(5:8,:) = load('../Data/Data n50000g0.016p0.32d14-May22/perturbationPercent.csv');
M = load('../Data/Data n50000g0.016p0.32d14-May22/metrics.csv');
y(:,2) = M(:,1);

Ptemp = load('../Data/Data n50000g0.019p0.32d29-Jun21/perturbationPercent.csv');
Pall(9:12,:) = Ptemp(:,1:50000);
M = load('../Data/Data n50000g0.019p0.32d29-Jun21/fullmetrics.csv');
M = M(1:50000,:);
y(:,3) = M(:,1);

%% Distance

d = NaN(size(y));
w = zeros(4,1);
pind = [1 5 9];


for i = 1:size(y,2)
    P = Pall(pind(i):pind(i)+3,:);   
    
    for j = 1:length(P)
        v = P(:,j);        
        d(j,i) = sqrt((v-w)'*(v-w));
    end 
    
end

%% Viz

x = (1:length(d))';
map = brewermap(2,'Set1');
gam = [0.014 0.016 0.019];

figure
tiledlayout('flow')
for i = 1:size(d,2)
    data = d(:,i);
%     nexttile
%     hold on
%     scatter(x(y(:,i)==0),data(y(:,i)==0),'b')
%     scatter(x(y(:,i)==1),data(y(:,i)==1),'r')
%     title(['Gamma = ', num2str(gam(i))],'Fontsize',18)
    
    nexttile
    hold on
    histogram(data(y(:,i)==0),'FaceColor',map(2,:),'facealpha',.5,'edgecolor','none')
    histogram(data(y(:,i)==1),'FaceColor',map(1,:),'facealpha',.5,'edgecolor','none')
    title(['Gamma = ', num2str(gam(i))],'Fontsize',18)
    xlabel('Distance','Fontsize',14);
    ylabel('Occurance','Fontsize',14);
    legend('non-falls','falls','Location','northeast')
end


















