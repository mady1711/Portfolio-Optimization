clc
clear
close all

%% DATA
%data on monthly returns on assets
returns = readtable("Returns.xlsx");
ret = table2array(returns(:,2:9));
%expected Return
expected_returns = mean(ret);
 
%variance-covariance matrix
covariance_matrix = cov(ret);
%bounds
[lb,ub] = DATA;
%% Problem Setting
prob = @portfolioOptimization;
n=length(lb);
lbp = lb(1:n-1);
ubp = ub(1:n-1);

%% Algorithm Parameters
Np = 50;
T = 1000;
Pc = 0.8; F = 0.85; % DE
w = 0.8; c1 = 1.5; c2 = 1.5; % PSO
Nruns = 5;
bestfitness = NaN(Nruns,1);
bestsol = NaN(Nruns,length(lb)-1,3);

for i=1:Nruns
    rng(i,"twister");
    [bestsol(i,:,1),bestfitness(i,1),~,~,~] = TLBO(prob,lbp,ubp,Np,T,covariance_matrix,expected_returns);
    rng(i,"twister");
    [bestsol(i,:,2),bestfitness(i,2),~,~,~] = DifferentialEvolution(prob,lbp,ubp,Np,T,Pc,F,covariance_matrix,expected_returns);
    rng(i,"twister");
    [bestsol(i,:,3),bestfitness(i,3),~,~,~] = PSO(prob,lbp,ubp,Np,T,w,c1,c2,covariance_matrix,expected_returns);
end

