% addpath('../Data/gaitCycles Manuscript1 data');



% Gamma = linspace(0.014,0.019,6)';
Gamma = [0.014; 0.016; 0.019];
Mags = (2:6:50);
Mags = flip(Mags);

% Convert numerical values to Matlab cells
Gammastr = cell(length(Gamma),1);
for itor = 1:length(Gamma)
    Gammastr(itor) = cellstr(num2str(Gamma(itor)));
end
Magstr = cell(length(Mags),1);
for itor = 1:length(Mags)
    Magstr(itor) = cellstr(num2str(Mags(itor)));
end
% pm = repelem("\pm",length(Mags),1);
% Magstr = append(pm,Magstr);

% Heatmap
RHO = load('../Data/Data NEWFALL (reviewer edits)/Gaitcycles combined n20000g0.014_0.019p0.02_0.5/fallratio1419NEWFALL.csv');
spec = '%3.2f';
thresh = 0.7;

% RHO = load('../Data/Data NEWFALL (reviewer edits)/Gaitcycles combined n20000g0.014_0.019p0.02_0.5/percentYield1419NEWFALL.csv');
% spec = '%3.2f%%';
% thresh = 10;

RHO = flip(RHO);

% Viz
% figure
% tiledlayout(2,1,'TileSpacing','Compact');
% nexttile
imagesc(RHO)
%colorbar
hold on
for itor = 1:size(RHO,2)
    for jtor = 1:size(RHO,1)
        if RHO(jtor,itor) > thresh  %  8.5 for TV, .7 for fall ratio
            if RHO(jtor,itor) > 10 
                text(itor-0.16,jtor,num2str(RHO(jtor,itor),spec),'color','w','FontSize',18)
            else
                text(itor-0.13,jtor,num2str(RHO(jtor,itor),spec),'color','w','FontSize',18)
            end
        else
            text(itor-0.13,jtor,num2str(RHO(jtor,itor),spec),'color','k','FontSize',18)
        end
        
    end
end
set(gca,'xtick',1:1:length(Gammastr),'ytick',1:1:length(Magstr))
set(gca,'xticklabel',Gammastr,'yticklabel',Magstr)
set(gca,'fontsize',14,'fontweight','bold')
xlabel('\boldmath$\gamma \ (rad.)$','Interpreter','Latex','Fontsize',18);
% ylabel('Perturbation (%)');
ylabel('\boldmath$\delta$','Interpreter','Latex','Fontsize',23);


cmap = colormap('gray');
cmap = flipud(cmap);
colormap(cmap)


% gamma = repelem(gam,length(pert));
% perturbation = string(repmat(pert*100,length(gam),1));
% pm = repelem("\pm",length(perturbation),1);
% perturbation = append(pm,perturbation);


