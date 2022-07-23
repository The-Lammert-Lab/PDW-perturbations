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

ratiodata = load(['../Data/Gaitcycles combined n20000g0.014_0.019p0.02_0.5/' ...
    'fallratio1419NEWFALL.csv']);

gam = {'0.014';'0.016';'0.019'};
pert = (2:6:50);
n = 20000; 

falls = (ratiodata ./ (ratiodata+1))*n;
nonfalls = (ones(size(ratiodata)) ./ (ratiodata+1))*n;

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
    title(['Perturbation = ± ', num2str(pert(i)), '%']);
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




