% fall_step_histogram
% 
% Create log-scaled histograms for 
% the frequency of the number of steps each falling trial takes.
% Find percent of falls on first and second steps.

%% Load data
addpath('../Brewermap colors');

% Load to struct so this is only section that needs to be changed for
% more/less data
S.fallsteps14 = load('../Data/Data n50000g0.014p0.5d03-Jun22/fall_steps_data.csv');
S.fallsteps16 = load('../Data/Data n50000g0.016p0.5d04-Jun22/fall_steps_data.csv');
S.fallsteps19 = load('../Data/Data n50000g0.019p0.5d05-Jun22/fall_steps_data.csv');

% Data are all different lengths, so pad with NaNs.
fallsteps = NaN(max(structfun(@(x) max(length(x)),S)),length(fieldnames(S)));

count = 0;
for ii = fieldnames(S)'
    count = count + 1;
    fallsteps(1:length(S.(ii{1})),count) = S.(ii{1});
end

%% Plot

% Setup
gam = [0.014, 0.016, 0.019];

map = brewermap(50,'Greys');

percent_firstandsecond = zeros(1,3);
percent_first = zeros(1,3);

figure
t = tiledlayout(3,1);
for i = 1:size(fallsteps,2)
    
    data = fallsteps(~isnan(fallsteps(:,i)),i);
    
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
