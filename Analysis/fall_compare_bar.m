% fall_compare_bar
% 
% Generate a tiled figure with bar chart comparing fall and non-fall 
% occurances between gammas at the
% same perturbation percent
% 
% Need to back-calculate the "raw" values from the ratio values.
% 
% Each ratio is based on 20,000 combined falls and non-falls (n). 
% So, 0.91:1 ratio is (0.91 + 1 = 1.91; 0.91/1.91, 1/1.91) —> 47.64%, 52.36%

%% Load data

filename = ['../Data/Gaitcycles data n20000g0.016_0.019p0.02_0.5d01-Jun22/' ...
    'gaitCyclesProcessed0.014_0.019_0.02_0.5.csv'];

full_data = readtable(filename);

% Set number of trials based on data
n = 20000; 

% How many perturbations at each gamma. 
% Should always be the same so only need first value.
[pert_tot, ~] = find(diff(table2array(full_data(:,1))) ~= 0, 1, 'first');

% Get gamma values from table.
gam = unique(table2array(full_data(:,1)));
gam = cellstr(num2str(gam));

% Get perturbation information from table
pert = table2array(full_data(1:pert_tot,2));

% Strip '\pm' from data (holdover from previous versions, but data is still
% saved like this).
pert = cellfun(@(x) x(4:end), pert, 'UniformOutput', false);

ratiodata = reshape(table2array(full_data(:,3)), [pert_tot, length(gam)]);

%% Calculate falls and nonfalls
falls = (ratiodata ./ (ratiodata+1))*n;
nonfalls = (ones(size(ratiodata)) ./ (ratiodata+1))*n;

%% Plot
figure
t = tiledlayout('flow','TileSpacing','Compact');
for i = 1:size(ratiodata,1)
    nexttile(i)
    bar([falls(i,:);nonfalls(i,:)]')
    grid on
    ylabel('Occurrence','Fontsize',14)
    xlabel('Gamma value','Fontsize',14)
    legend('Fall','Non-fall')
    set(gca,'xticklabel',gam,'Fontsize',14)
    title(['Perturbation = ± ', num2str(pert{i}), '%']);
end

% figure
% t = tiledlayout(3,length(pert)/3,'TileSpacing','Compact');
% for i = 1:size(ratiodata,1)
%     nexttile(i)
%     bar(falls(i,:)')
%     grid on
%     ylabel('Occurrence','Fontsize',14)
%     xlabel('Gamma value','Fontsize',14)
%     set(gca,'xticklabel',gam,'Fontsize',14)
%     title(['Falls - Perturbation = ± ', num2str(pert(i)), '%']);
% end

% figure
% t = tiledlayout(3,length(pert)/3,'TileSpacing','Compact');
% for i = 1:size(ratiodata,1)
%     nexttile(i)
%     bar(nonfalls(i,:)')
%     grid on
%     ylabel('Occurrence','Fontsize',14)
%     xlabel('Gamma value','Fontsize',14)
%     set(gca,'xticklabel',gam,'Fontsize',14)
%     title(['Nonfalls - Perturbation = ± ', num2str(pert(i)), '%']);
% end




