% heatmap_grey
% 
% Create a nice looking greyscale heatmap of either
% fall ratio or percent yield data.
% Used with `gaitCyclesProcessed...` output from `heatmap_loop.m`.

%% Load data, extract info
full_data = readtable(['../Data/HeatmapData_n20000g0.016_0.019p0.02_0.5d01-Jun22/' ...
    'HeatmapProcessed_0.014_0.019_0.02_0.5.csv']);

% How many perturbations at each gamma. 
% Should always be the same so only need first value.
[pert_tot, ~] = find(diff(table2array(full_data(:,1))) ~= 0, 1, 'first');

% Get gamma values from table.
Gammastr = unique(table2array(full_data(:,1)));
Gammastr = cellstr(num2str(Gammastr));

% Get perturbation information from table
Magstr = table2array(full_data(1:pert_tot,2));

% Strip '\pm' from data (holdover from previous versions, but data is still
% saved like this).
Magstr = cellfun(@(x) x(4:end), Magstr, 'UniformOutput', false);
Magstr = flip(Magstr);

%% Choose data to plot and set specs

% % Fall ratio is Var 3 of data table.
% data = reshape(table2array(full_data(:,3)), [pert_tot, length(Gammastr)]);
% 
% % Set specifications for heatmap 
% spec = '%3.2f';
% thresh = 0.7;
% shift_gt10 = 0.16;
% shift_lt10 = 0.13;

% Percent yield is Var 4 of data table.
data = reshape(table2array(full_data(:,4)), [pert_tot, length(Gammastr)]);

% Set specifications for heatmap
spec = '%3.2f%%';
thresh = 10;
shift_gt10 = 0.23;
shift_lt10 = 0.16;

data = flip(data);

%% Viz
figure
imagesc(data)
% colorbar
hold on
for itor = 1:size(data,2)
    for jtor = 1:size(data,1)
        if data(jtor,itor) > thresh
            if data(jtor,itor) > 10
                text(itor-shift_gt10,jtor,num2str(data(jtor,itor),spec),'color','w','FontSize',18)
            else
                text(itor-shift_lt10,jtor,num2str(data(jtor,itor),spec),'color','w','FontSize',18)
            end
        else
            text(itor-shift_lt10,jtor,num2str(data(jtor,itor),spec),'color','k','FontSize',18)
        end
        
    end
end
set(gca,'xtick',1:1:length(Gammastr),'ytick',1:1:length(Magstr))
set(gca,'xticklabel',Gammastr,'yticklabel',Magstr)
set(gca,'fontsize',14,'fontweight','bold')
xlabel('\boldmath$\gamma \ (rad.)$','Interpreter','Latex','Fontsize',18);
ylabel('\boldmath$\delta$','Interpreter','Latex','Fontsize',23);

cmap = colormap('gray');
cmap = flipud(cmap);
colormap(cmap)

