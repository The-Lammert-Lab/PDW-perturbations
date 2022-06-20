%%% Bar chart comparing fall and non-fall occurances between gammas at the
%%% same perturbation percent

%%% I don't think I have the raw fall and non-fall data from the gaitCycles
%%% data. Need to back-calculate the "raw" values from the ratio values.

%%% Each ratio is based on 20,000 samples. 
% 1:1 ratio is half of each in a whole. (1+1 = 2; 1/2, 1/2)
% 
% 1:2 ratio is half of the first part in the whole. (1+2 = 3; 1/3, 2/3) AND ( 2/3 * 1/2 = 1/3)
% 
% 2:3 ratio is 2/3 of the first part in the whole. (2+3 = 5; 2/5, 3/5) AND (3/5 * 2/3 = 2/5)
% 
% So, 0.91:1 ratio is (0.91 + 1 = 1.91; 0.91/1.91, 1/1.91) —> 47.64%, 52.36%

addpath('../Data/gaitCycles NEW data');

ratiodata = load('fallRatio1419.csv');

gam = {'0.014';'0.015';'0.016';'0.017';'0.018';'0.019'};

pert = linspace(2,38,7);

falls = (ratiodata ./ (ratiodata+1))*20000;
nonfalls = (ones(size(ratiodata)) ./ (ratiodata+1))*20000;


for i = 1:size(ratiodata,1)
    figure
    bar([falls(i,:);nonfalls(i,:)]')
    grid on
    ylabel('Occurrence','Fontsize',14)
    xlabel('Gamma value','Fontsize',14)
    legend('Fall','Non-fall')
    set(gca,'xticklabel',gam,'Fontsize',14)
    title(['Perturbation = ± ', num2str(pert(i)), '%']);
end


% for i = 1:size(ratiodata,1)
%     figure
%     bar(falls(i,:)')
%     grid on
%     ylabel('Occurrence','Fontsize',14)
%     xlabel('Gamma value','Fontsize',14)
%     set(gca,'xticklabel',gam,'Fontsize',14)
%     title(['Falls - Perturbation = ± ', num2str(pert(i)), '%']);
% end

% for i = 1:size(ratiodata,1)
%     figure
%     bar(nonfalls(i,:)')
%     grid on
%     ylabel('Occurrence','Fontsize',14)
%     xlabel('Gamma value','Fontsize',14)
%     set(gca,'xticklabel',gam,'Fontsize',14)
%     title(['Nonfalls - Perturbation = ± ', num2str(pert(i)), '%']);
% end




