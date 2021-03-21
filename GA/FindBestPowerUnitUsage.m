function FindBestPowerUnitUsage()
% FINDBESTPOWERUNITUSAGE
%
% A simple function to optimise power unit usage throught a damage model.
% Optimisation uses Genetic Algorithm optimisation for discrete 
% optimisation problems.
% 
% Author: Dr Farraen Mohd Azmin
% Date:   25 Feb 2018
%
%

%% 2018 Track info

DataTable = {
1  '25 March'      'AUSTRALIAN'   	14 24   307.574
2  '8 April'       'BAHRAIN '      	21 29   308.238
3  '15 April'      'CHINESE '    	11 19  	305.066
4  '29 April'      'AZERBAIJAN '   	9  16   306.049
5  '13 May'        'ESPAÑA '     	14 22   307.104
6  '27 May'        'MONACO '        15 19   260.286
7  '10 June'       'CANADA '        12 23   305.27
8  '24 June'       'FRANCE '        16 26   305         %France TBC
9  '1 July'        'ÖSTERREICH '    12 24   306.452
10 '8 July'        'BRITISH '       12 21   306.198
11 '22 July'       'DEUTSCHLAND '  	15 25   306.458
12 '29 July'       'NAGYDÍJ'     	15 27   306.630
13 '26 August'     'BELGIAN '       13 21   308.052
14 '2 September'   'DITALIA '    	16 24   306.72
15 '16 September'  'MARINABAY'    	25 31   308.828
16 '30 September'  'RUSSIAN '      	16 25   309.745
17 '7 October'     'JAPANESE '    	13 22   307.471
18 '21 October'    'UNITEDSTATES'  	16 28   308.405
19 '28 October'    'DEMÉXICO'       10 24   305.354
20 '11 November'   'BRASIL'         17 27   305.909
21 '25 November'   'ABUDHABI'       19 31   305.355
};
S.DataTable = cell2table(DataTable,...
    'VariableNames',{'No' 'Date' 'Track' 'MinTemp' 'MaxTemp' 'Distance'});

%% Initialise RUL for each components

S.ICE_RUL  = [80 70 95];
S.ICE_KW  = [425 400 450];


%% Generate several solutions to compare with GA results

xtest = randi([1 3],5,21);
for i = 1:size(xtest,1)
    [~,R{i}] = DamageModel(xtest(i,:),S);
end

%% Setup GA optimisation

% Set boundaries (this should be ICE number)
lb = repmat(1,height(S.DataTable),1);
ub = repmat(3,height(S.DataTable),1);

% Assign function objection and constraint with extra parameters
fobj = @(x)PowerLossFuncObj(x,S);
fcon = @(x)RULConstraints(x,S);
%fplot = @(a,b,c)PlotIter(a,b,c,S);


% Setup optimisation settings
opts = optimoptions(@ga, ...
                    'PopulationSize', 150, ...
                    'MaxGenerations', 200, ...
                    'EliteCount', 10, ...
                    'FunctionTolerance', 1e-8, ...
                    'PlotFcn', @gaplotbestf);



% Run GA optimisation (make output integer) - Mixed integer
[BestUsage, fbest, exitflag] = ga(fobj,21,[],[],[],[],lb,ub,fcon,1:21,opts);

%% Calculate new data table with optimisation results

[~,S] = DamageModel(BestUsage,S);
assignin('base','PerformanceTable',S.DataTable)


%% Analyse results

R{end+1} = S;

figure(3)
h = [];
for i = 1:length(R)
    
    if i == length(R)
        h{i} = plot(R{i}.DataTable.RUL,'w','LineStyle','none','LineWidth',2);

    else
        h{i} = plot(R{i}.DataTable.RUL,'Color',[0.8 0.8 0.8]);
    end
   hold on
   
end
plot([0 22],[0 0],'r--','LineWidth',2)
hold off
legend([h{1} h{end}],{'Random Results' 'Optimisation Result'})
ylabel('ICE RUL')
xlabel('Race')
box on

figure(4)
h = [];
for i = 1:length(R)
    eng_no = R{i}.DataTable.ICE;
    pwr = R{i}.DataTable.PowerReduced;
    pwr1 = pwr(eng_no==1);
    pwr2 = pwr(eng_no==2);
    pwr3 = pwr(eng_no==3);
    
    if i == length(R)
        h{i} = plot([pwr1(end) pwr2(end) pwr3(end)],'w','LineStyle','none','LineWidth',2);
        ymin = min([pwr1(end) pwr2(end) pwr3(end)]);
        ymax = max([pwr1(end) pwr2(end) pwr3(end)]);
    else
        h{i} = plot([pwr1(end) pwr2(end) pwr3(end)],'Color',[0.8 0.8 0.8]);
    end
    hold on
end
plot([1 3],[ymin ymin],'r--','LineWidth',2)
plot([1 3],[ymax ymax],'r--','LineWidth',2)
hold off
legend([h{1} h{end}],{'Random Results' 'Optimisation Result'})
ylabel('ICE POWER Reduction for Season(kW)')
xlabel('ICE Number')
box on
xticks([1 2 3])


figure(5)
h = [];
for i = 1:length(R)
    
    if i == length(R)
        h{i} = plot(R{i}.DataTable.RUL,'b','LineWidth',2);

    else
        h{i} = plot(R{i}.DataTable.RUL,'Color',[0.8 0.8 0.8]);
    end
   hold on
   
end
plot([0 22],[0 0],'r--','LineWidth',2)
hold off
legend([h{1} h{end}],{'Random Results' 'Optimisation Result'})
ylabel('ICE RUL')
xlabel('Race')
box on

figure(6)
h = [];
for i = 1:length(R)
    eng_no = R{i}.DataTable.ICE;
    pwr = R{i}.DataTable.PowerReduced;
    pwr1 = pwr(eng_no==1);
    pwr2 = pwr(eng_no==2);
    pwr3 = pwr(eng_no==3);
    
    if i == length(R)
        h{i} = plot([pwr1(end) pwr2(end) pwr3(end)],'b','LineWidth',2);
        ymin = min([pwr1(end) pwr2(end) pwr3(end)]);
        ymax = max([pwr1(end) pwr2(end) pwr3(end)]);
    else
        h{i} = plot([pwr1(end) pwr2(end) pwr3(end)],'Color',[0.8 0.8 0.8]);
    end
    hold on
end
plot([1 3],[ymin ymin],'r--','LineWidth',2)
plot([1 3],[ymax ymax],'r--','LineWidth',2)
hold off
legend([h{1} h{end}],{'Random Results' 'Optimisation Result'})
ylabel('ICE POWER Reduction for Season(kW)')
xlabel('ICE Number')
box on
xticks([1 2 3])



%figure(5)
%scatter(S.DataTable.RUL_Reduced,S.DataTable.PowerReduced,'bo')
%hold on
%scatter(R{1}.DataTable.RUL_Reduced,R{1}.DataTable.PowerReduced,'ro')
%hold off
%
%xlabel('Reduction in RUL')
%ylabel('Reduction in Power')


% figure(4)
% scatter(S.DataTable.RUL_Reduced,S.DataTable.PowerReduced,'bo')
% hold on
% scatter(R{1}.DataTable.RUL_Reduced,R{1}.DataTable.PowerReduced,'ro')
% hold off
% 
% xlabel('Reduction in RUL')
% ylabel('Reduction in Power')

end

function e = PowerLossFuncObj(x,S)

% Call 
 e = DamageModel(x,S);
end

function [PowerLoss,S] = DamageModel(x,S)

% Accumulate mileage
S.DataTable.TotalDistance = cumsum(S.DataTable.Distance);

% Assign current solution to ICE number
S.DataTable.ICE = x';

%% Damage model 
% Piston clearance/km temp
S.DamageModel.X = [0 5 10 15 20 25 30 35 40];
S.DamageModel.Z = [2 3  4 6 9 14 19 25 32]*0.000001;

% Power degradation due to piston clearance
S.PerfModel.X = [0.001 0.002 0.003 0.004 0.005 0.006 0.007 0.008 0.009 0.015];
S.PerfModel.Z = [0.1   1     2     3     5     7     8     10    15    30];

% RUL loss based on ICE power loss and mileage per race
S.RULModel.X =[150 200 250 300 350 400];
S.RULModel.Y =[0 2 5 10 20 25];
S.RULModel.Z = [1.5 1.4 1.9 2.3 3.8 6.4;1.3 1.5 1.8 2.3 3.1 4.9;1.2 1.3 1.4 2.0 2.8 3.4;0.9 1.3 1.4 2.0 2.3 2.6;0.7 1.0 1.3 1.7 1.8 2.0;0.3 0.7 1.1 1.4 1.6 1.5]*5;
[S.RULModel.X ,S.RULModel.Y] = meshgrid(S.RULModel.X,S.RULModel.Y);

%% Calculations

% Average temperature in the race month
S.DataTable.AmbTemp = (S.DataTable.MinTemp + S.DataTable.MaxTemp/2);

% Calculate ICE damage for each race
DamagePerKM = interp1(S.DamageModel.X,S.DamageModel.Z,S.DataTable.AmbTemp,'linear','extrap');
S.DataTable.DamageThisRace = S.DataTable.Distance.*DamagePerKM;

% Calculate the ICE power reduction
S.DataTable.PowerReducedThisRace = interp1(S.PerfModel.X,S.PerfModel.Z,S.DataTable.DamageThisRace,'linear','extrap');

% Get individual power reduction for each ICE
PowerRedICE1 = (S.DataTable.PowerReducedThisRace(x == 1));
PowerRedICE2 = (S.DataTable.PowerReducedThisRace(x == 2));
PowerRedICE3 = (S.DataTable.PowerReducedThisRace(x == 3));

% Get distance ran for each ICE
DistanceICE1 = (S.DataTable.Distance(x == 1));
DistanceICE2 = (S.DataTable.Distance(x == 2));
DistanceICE3 = (S.DataTable.Distance(x == 3));

% RUL reduction for each ICE based on damage model
RULReducedICE1 = interp2(S.RULModel.X,S.RULModel.Y,S.RULModel.Z,DistanceICE1,PowerRedICE1,'linear',0);
RULReducedICE2 = interp2(S.RULModel.X,S.RULModel.Y,S.RULModel.Z,DistanceICE2,PowerRedICE2,'linear',0);
RULReducedICE3 = interp2(S.RULModel.X,S.RULModel.Y,S.RULModel.Z,DistanceICE3,PowerRedICE3,'linear',0);

% Calculate cummulative RUL reduction
RULARR1 = [find(x==1)' cumsum(RULReducedICE1)];
RULARR2 = [find(x==2)' cumsum(RULReducedICE2)];
RULARR3 = [find(x==3)' cumsum(RULReducedICE3)];
RULARR = sortrows([RULARR1;RULARR2;RULARR3],1);
S.DataTable.RUL_Reduced = RULARR(:,2);

% Calculate cummulative Power reduction
RULARR1 = [find(x==1)' cumsum(PowerRedICE1)];
RULARR2 = [find(x==2)' cumsum(PowerRedICE2)];
RULARR3 = [find(x==3)' cumsum(PowerRedICE3)];
RULARR = sortrows([RULARR1;RULARR2;RULARR3],1);
S.DataTable.PowerReduced = RULARR(:,2);

% Calculate RUL left for each ICE and store in data table
RULARR1 = [find(x==1)' S.ICE_RUL(1)-cumsum(RULReducedICE1)];
RULARR2 = [find(x==2)' S.ICE_RUL(2)-cumsum(RULReducedICE2)];
RULARR3 = [find(x==3)' S.ICE_RUL(3)-cumsum(RULReducedICE3)];
RULARR = sortrows([RULARR1;RULARR2;RULARR3],1);
S.DataTable.RUL = RULARR(:,2);

% Calculate Power left for each ICE and store in data table
PWRARR1 = [find(x==1)' S.ICE_KW(1)-cumsum(PowerRedICE1)];
PWRARR2 = [find(x==2)' S.ICE_KW(2)-cumsum(PowerRedICE2)];
PWRARR3 = [find(x==3)' S.ICE_KW(3)-cumsum(PowerRedICE3)];
PWRARR = sortrows([PWRARR1;PWRARR2;PWRARR3],1);
S.DataTable.PowerLeft = PWRARR(:,2);

% Make function objective min power loss for maximising performance
PowerLoss = sum(PowerRedICE1) + sum(PowerRedICE2) + sum(PowerRedICE3);

end

function [c, ceq] = RULConstraints(x,S)

% Calculate data table with current ICE settings
[~,S] = DamageModel(x,S);

% Make sure RUL is always more than 0
c = S.DataTable.RUL < 5;

% No equality constraint
ceq = [];

end

%{
function [state,options,optchanged] = PlotIter(options,state,flag,S)
optchanged = false;

% Calculate data table with current ICE settings
figure(2)
for i = 1:size(state.Population,1)
    [~,S] = DamageModel(state.Population(i,:),S);
    if any(S.DataTable.RUL<0)
        h(i) = plot(S.DataTable.RUL,'Color',[0.8 0.8 0.8]);
        
    else
        plot(S.DataTable.RUL,'b')
    end
    hold on
end
try
    uistack(h,'top')
catch
    
end

plot([1 21],[0 0],'r','LineWidth',2)
hold off
xlabel('Race')
ylabel('ICE RUL')
title('Searching for best ICE allocation..')

end
%}

