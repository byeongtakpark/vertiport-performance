
% Prob_UAM_AMPEAK  = Cost X Speed X Catchment
% UAM_Demand       = Cost X Speed X Catchment
% MarketSize       =  ?   X   ?   X Catchment

figure(1)
hold on;
grid on;
plot(UAM.Cost(:),UAM_Demand_F(:,1,1), 's-.','Color','#E69F00','LineWidth',2,'MarkerSize',8, 'MarkerFaceColor', '#E69F00')
plot(UAM.Cost(:),UAM_Demand_F(:,1,2), 'd:','Color','#56B4E9','LineWidth',2,'MarkerSize',8, 'MarkerFaceColor', '#56B4E9')
plot(UAM.Cost(:),UAM_Demand_F(:,1,3), 'o-','Color','#009E73','LineWidth',2,'MarkerSize',8, 'MarkerFaceColor', '#009E73')

ylim([0 200])

xticks([20 21 22 23 24 25 26 27 28 29 30])
xticklabels({'2000','2100','2200','2300','2400','2500','2600','2700','2800','2900','3000'})
xtickangle(30)

legend('R=2km','R=3km','R=4km')
ylabel('Number of UAM operations per daily')
xlabel('Fare per km of UAM [KRW/km]')
title('UAM Vehicle Cruise Speed = 100 km/h')

hold off;

figure(2)
hold on;
grid on;

plot(UAM.Cost(:),UAM_Demand_F(:,2,1), 's-.','Color','#E69F00','LineWidth',2,'MarkerSize',8, 'MarkerFaceColor', '#E69F00')
plot(UAM.Cost(:),UAM_Demand_F(:,2,2), 'd:','Color','#56B4E9','LineWidth',2,'MarkerSize',8, 'MarkerFaceColor', '#56B4E9')
plot(UAM.Cost(:),UAM_Demand_F(:,2,3), 'o-','Color','#009E73','LineWidth',2,'MarkerSize',8, 'MarkerFaceColor', '#009E73')

ylim([0 200])

xticks([20 21 22 23 24 25 26 27 28 29 30])
xticklabels({'2000','2100','2200','2300','2400','2500','2600','2700','2800','2900','3000'})
xtickangle(30)

legend('R=2km','R=3km','R=4km')
ylabel('Number of UAM operations per day')
xlabel('Fare per km of UAM [KRW/km]')
title('UAM Vehicle Cruise Speed = 150 km/h')

hold off;

figure(3)

hold on;
grid on;

plot(UAM.Cost(:),UAM_Demand_F(:,3,1), 's-.','Color','#E69F00','LineWidth',2,'MarkerSize',8, 'MarkerFaceColor', '#E69F00')
plot(UAM.Cost(:),UAM_Demand_F(:,3,2), 'd:','Color','#56B4E9','LineWidth',2,'MarkerSize',8, 'MarkerFaceColor', '#56B4E9')
plot(UAM.Cost(:),UAM_Demand_F(:,3,3), 'o-','Color','#009E73','LineWidth',2,'MarkerSize',8, 'MarkerFaceColor', '#009E73')

ylim([0 200])

xticks([20 21 22 23 24 25 26 27 28 29 30])
xticklabels({'2000','2100','2200','2300','2400','2500','2600','2700','2800','2900','3000'})
xtickangle(30)

legend('R=2km','R=3km','R=4km')
ylabel('Number of UAM operations per day')
xlabel('Fare per km of UAM [KRW/km]')
title('UAM Vehicle Cruise Speed = 200 km/h')

hold off;

% figure(4)
% 
% hold on;
% grid on;
% 
% plot(UAM.Cost(:),UAM_Demand_AMPEAK(:,3,3), 's-','Color','#CC79A7','LineWidth',2,'MarkerSize',8, 'MarkerFaceColor', '#CC79A7')
% plot(UAM.Cost(:),UAM_Demand_F(:,3,3),      'd-','Color','#D55E00','LineWidth',2,'MarkerSize',8, 'MarkerFaceColor', '#D55E00')
% plot(UAM.Cost(:),UAM_Demand_PMPEAK(:,3,3), 'o-','Color','#0072B2','LineWidth',2,'MarkerSize',8, 'MarkerFaceColor', '#0072B2')
% 
% ylim([0 40])
% 
% xticks([20 21 22 23 24 25 26 27 28 29 30])
% xticklabels({'2000','2100','2200','2300','2400','2500','2600','2700','2800','2900','3000'})
% xtickangle(30)
% 
% legend('AM Peak','Full','PM Peak')
% ylabel('Number of UAM operations per hour')
% xlabel('Fare per km of UAM [KRW/km]')
% 
% hold off;

figure(5)

hold on;
grid on;

plot(UAM.Cost(:),Prob_UAM_F(:,3,1), 's-.','Color','#E69F00','LineWidth',2,'MarkerSize',8, 'MarkerFaceColor', '#E69F00')
plot(UAM.Cost(:),Prob_UAM_F(:,3,2), 'd:','Color','#56B4E9','LineWidth',2,'MarkerSize',8, 'MarkerFaceColor', '#56B4E9')
plot(UAM.Cost(:),Prob_UAM_F(:,3,3), 'o-','Color','#009E73','LineWidth',2,'MarkerSize',8, 'MarkerFaceColor', '#009E73')

xticks([20 21 22 23 24 25 26 27 28 29 30])
xticklabels({'2000','2100','2200','2300','2400','2500','2600','2700','2800','2900','3000'})
xtickangle(30)

legend('R=2km','R=3km','R=4km')
ylabel('Modal share of UAM [%]')
xlabel('Fare per km of UAM [KRW/km]')
title('UAM Vehicle Cruise Speed = 200 km/h')

hold off;
