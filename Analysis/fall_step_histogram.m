% fall_step_histogram
% 
% Create log-scaled histograms for 
% the frequency of the number of steps each falling trial takes.
% Find percent of falls on first and second steps.

%% Load data
addpath('../Brewermap colors');

% Folders with data of interest.
foldernames = {'../Data/Data_n50000g0.014p0.5d03-Jun22/', ...
    '../Data/Data_n50000g0.016p0.5d04-Jun22/', ...
    '../Data/Data_n50000g0.019p0.5d05-Jun22/'};

% Order needs to match order of foldernames.
gam = [0.014, 0.016, 0.019];

% Load to struct with fields 'g14', 'g16', etc.
datafields = cell(1,length(foldernames));
for i = 1:length(foldernames)
    gamnum = extractBetween(foldernames{i},'g0.0','p');
    datafields{i} = strcat('g',gamnum{1});
    S.(datafields{i}) = load(strcat(foldernames{i},'fall_steps_data.csv'));
end

%% Plot
map = brewermap(50,'Greys');

percent_firstandsecond = zeros(1,3);
percent_first = zeros(1,3);

figure
t = tiledlayout(3,1);
for i = 1:length(fieldnames(S))
    
    data = S.(datafields{i});

    % Get percent occurrence for first and second steps
    first_and_second_steps = sum(data == 1 | data == 2);
    first_steps = sum(data == 1);
    
    percent_firstandsecond(i) = (first_and_second_steps / length(data))*100;
    percent_first(i) = (first_steps / length(data))*100;
    
    % Plot
    nexttile
    h = histogram(data,'FaceColor',map(40,:));
    h.BinWidth = 1;
    set(gca,'yscale','log','box','off');
    set(gca,'TickLength',[0.018,0.025]);
    ylabel('Frequency','Fontsize',14);
    xlim([1 50])
    xticks([1 5:5:50])
    xlabel('Number of steps','Fontsize',14);
    title(['$\gamma =\ $', num2str(gam(i)),'$rad$'],...
        'Interpreter','latex','Fontsize',18);
end

% xlabel(t,'Number of steps','Fontsize',14);
