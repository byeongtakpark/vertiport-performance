%% Urban Air Mobility Demand Estimation For Thesis
clear all; clc

%% Load Data
% Origin-Destination Data
load('OD_MMODE_30_AMPEAK_F.mat');                                          % 2030년 오전 첨두시 O/D 데이터
load('OD_MMODE_30_F.mat');                                                 % 2030년 하루 전체 O/D 데이터
load('OD_MMODE_30_PMPEAK_F.mat');                                          % 2030년 오후 첨두시 O/D 데이터


% TAZ-TAZ간 대중교통 (1135*135)
load('TT_Tran.mat');
load('TT_Car.mat');
load('TC_Tran.mat');
load('TD_Car.mat');

% TAZ-GIMPO;TAZ-SAMSEONG;TAZ-INCEHON (1135*2)
load('Distance_Btwn_Dong_and_Vertiport.mat');                              % 직선거리
load('EGT_eVTOL.mat');                                                     % 네이버 지도로 추출한 이동거리

%% MNL Coefficient
CoefficientCostTransit       = -0.01518; % 100 KRW
CoefficientCostCar           = -0.00452; % 100 KRW
CoefficientCostUAM           = -0.00713; % 100 KRW
CoefficientTravelTimeTransit = -0.0086;  % min
CoefficientTravelTimeCar     = -0.0145;  % min
CoefficientTravelTimeUAM     = -0.0370;  % min
ASC_Car                      = 2.5395;
ASC_Transit                  = 3.5845;
ASC_UAM                      = 4.4956;

Coef_Car     = [ASC_Car     CoefficientCostCar     CoefficientTravelTimeCar];
Coef_Transit = [ASC_Transit CoefficientCostTransit CoefficientTravelTimeTransit];
Coef_UAM     = [ASC_UAM     CoefficientCostUAM     CoefficientTravelTimeUAM];

% VOT_Car     = 19,247 (KRW/hr) 
% VOT_Transit = 3,399  (KRW/hr)
% VOT_UAM     = 31,136 (KRW/hr)


%% Define Explanatory Vars
UAM.Cost          = [20:30];          % 100 KRW/km
UAM.Speed         = [100, 150, 200];  % km/h
UAM.PAX           = 1;
UAM.WaitingTime   = 5;                % min
UAM.ProcedureTime = 10;               % min
UAM.Catchment     = [2, 3, 4];        % km
UAM.Distance      = 30;               % km

%% Preprocess Data
UnitCostCar   = 3.4617;               % 100 KRW/km
TC_Car        = TD_Car.*UnitCostCar;  % 100 KRW
TC_Tran       = TC_Tran./100;         % 100 KRW
UAM.Speed     = UAM.Speed./60;        % km/min

%% Set Result
UAM_Demand_AMPEAK  = zeros(size(UAM.Cost,2), size(UAM.Speed,2), size(UAM.Catchment,2));
UAM_Demand_F       = zeros(size(UAM.Cost,2), size(UAM.Speed,2), size(UAM.Catchment,2));
UAM_Demand_PMPEAK  = zeros(size(UAM.Cost,2), size(UAM.Speed,2), size(UAM.Catchment,2));
% UAM_Demand = Cost X Speed X Catchment

MarksetSize_AMPEAK = zeros(size(UAM.Cost,2), size(UAM.Speed,2), size(UAM.Catchment,2));
MarksetSize_F      = zeros(size(UAM.Cost,2), size(UAM.Speed,2), size(UAM.Catchment,2));
MarksetSize_PMPEAK = zeros(size(UAM.Cost,2), size(UAM.Speed,2), size(UAM.Catchment,2));
% MarketSize =  ? X ? X Catchment

Process = waitbar(0, 'Starting');

for i = 1:size(UAM.Cost,2)
    for j = 1:size(UAM.Speed,2)
        for k = 1:size(UAM.Catchment, 2)
        
            UAM_Cost      = UAM.Cost(i);
            UAM_Speed     = UAM.Speed(j);
            UAM_Catchment = UAM.Catchment(k);
            
            % Origin & Destination Vertiport의 Catchment안의 TAZ들 찾기 
            OriginTAZ      = find(Distance_Btwn_Dong_and_Vertiport(:,1) <= UAM_Catchment);
            DestinationTAZ = find(Distance_Btwn_Dong_and_Vertiport(:,2) <= UAM_Catchment);
           

            TotTrips_AMPEAK = zeros(size(OriginTAZ,1), size(DestinationTAZ,1));
            TotTrips_F      = zeros(size(OriginTAZ,1), size(DestinationTAZ,1));
            TotTrips_PMPEAK = zeros(size(OriginTAZ,1), size(DestinationTAZ,1));

            Demand_AMPEAK = zeros(size(OriginTAZ,1), size(DestinationTAZ,1));
            Demand_F      = zeros(size(OriginTAZ,1), size(DestinationTAZ,1));
            Demand_PMPEAK = zeros(size(OriginTAZ,1), size(DestinationTAZ,1));

            for l = 1:size(OriginTAZ,1)
                for m = 1:size(DestinationTAZ,1)
                    
                    Origin = OriginTAZ(l);
                    Destination = DestinationTAZ(m);
                   
                    % Auto
                    TT     = TT_Car(Origin, Destination);
                    TC     = TC_Car(Origin, Destination);
                    U_Auto = utility(Coef_Car, TC, TT);

                    % Transit
                    TT        = TT_Tran(Origin, Destination);
                    TC        = TC_Tran(Origin, Destination);
                    U_Transit = utility(Coef_Transit, TC, TT);

                    % UAM
                    TT        = EGT_eVTOL(Origin,1) + EGT_eVTOL(Destination,2) + UAM.WaitingTime + UAM.ProcedureTime + UAM.Distance./UAM_Speed;
                    TC        = UAM.Distance*UAM_Cost;
                    U_UAM     = utility(Coef_UAM, TC, TT);
                    
                    Index     = 1307*(Origin-1) + Destination;

                    TotTrips_AMPEAK(l,m) = sum(OD_MMODE_30_AMPEAK_F(Index,3:11));
                    TotTrips_F(l,m)      = sum(OD_MMODE_30_F(Index,3:11));
                    TotTrips_PMPEAK(l,m) = sum(OD_MMODE_30_PMPEAK_F(Index,3:11));
                   
                    ModalShare        = U_UAM/(U_UAM + U_Transit + U_Auto);

                    Demand_AMPEAK(l,m) = ModalShare*TotTrips_AMPEAK(l,m);
                    Demand_F(l,m)      = ModalShare*TotTrips_F(l,m);
                    Demand_PMPEAK(l,m) = ModalShare*TotTrips_PMPEAK(l,m);
                            
                end % for m = 1:size(DestinationTAZ,1)
            end % for l = 1:size(OriginTAZ,1)

            MarksetSize_AMPEAK(i,j,k) = sum(TotTrips_AMPEAK, 'all');
            MarksetSize_F(i,j,k)      = sum(TotTrips_F, 'all');
            MarksetSize_PMPEAK(i,j,k) = sum(TotTrips_PMPEAK , 'all');

            UAM_Demand_AMPEAK(i,j,k)  = sum(Demand_AMPEAK, 'all');
            UAM_Demand_F(i,j,k)       = sum(Demand_F, 'all');
            UAM_Demand_PMPEAK(i,j,k)  = sum(Demand_PMPEAK, 'all');
            
        end % for k = 1:size(UAM.Catchment, 2)
    end % for j = 1:size(UAM.Speed,2)
    waitbar(i/size(UAM.Cost,2), Process, sprintf('Demand: %d %%', floor(i/size(UAM.Cost,2)*100)));
    pause(0.1);
end % for i = 1:size(UAM.Cost,2)

% UAM_Demand_AMPEAK  = UAM_Demand_AMPEAK./2;   % trip/hr
% MarksetSize_AMPEAK = MarksetSize_AMPEAK./2;  % trip/hr
% UAM_Demand_F       = UAM_Demand_F./24;       % trip/hr
% MarksetSize_F      = MarksetSize_F./24;      % trip/hr
% UAM_Demand_PMPEAK  = UAM_Demand_PMPEAK./2;   % trip/hr
% MarksetSize_PMPEAK = MarksetSize_PMPEAK./2;  % trip/hr

% UAM_Demand = Cost X Speed X Catchment
% MarketSize =  ? X ? X Catchment

% Prob_UAM_AMPEAK = 100.*UAM_Demand_AMPEAK./MarksetSize_AMPEAK;
Prob_UAM_F      = 100.*UAM_Demand_F./MarksetSize_F;
% Prob_UAM_PMPEAK = 100.*UAM_Demand_PMPEAK./MarksetSize_PMPEAK;

figure_code