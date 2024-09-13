%% clear data and figure
clc;
clear;
close all;
%% model setting
% equation parameters
alpha=120;
beta=10;
theta=0.10;
%% simulation settings
% random seed
rng(10) % 10
% the order quantity
Q_vector=360+randi([0,120],10,1);
% the sales price
p_vector=5+3*rand(10,1);
% standard deviation of error in demand regression equation
std_dev=5.0;
% the time of order arrival
time0=0;
% the time resolution
delta_t=1;
% order cycles
m=length(Q_vector);
%% initialization of data storage
time_true = {};
demand_true = {};
level_true = {};
level_diff_true = {};
time_simu_t0 = {};
level_simu = {};
time_simu = {};
demand_simu = {};
level_diff_simu = {};
% generate the inventory levels
for i = 1:m
    % true level
    [time_true_i,demand_true_i,level_diff_true_i,level_true_i] = inventory_level(alpha,beta,p_vector(i),theta,time0,delta_t,Q_vector(i));
    time_true{i}=[time0;time_true_i];
    demand_true{i} = [alpha-beta*p_vector(i);demand_true_i];
    level_diff_true{i}=level_diff_true_i;
    level_true{i}=[Q_vector(i);level_true_i];
    % simulated level
    [time_simu_i,demand_simu_i,level_diff_simu_i,~] = inventory_level_simulation(alpha,beta,p_vector(i),std_dev,theta,time0,delta_t,Q_vector(i));
    time_simu{i} = time_simu_i;
    demand_simu{i} = demand_simu_i;
    level_diff_simu{i}=level_diff_simu_i;
    % time_simu0{i} = [time0;time_simu_i];
    % level_simu{i}=[Q_vector(i);level_simu_i];
end
%% cumulative generation
for i = 1:m
    time_i=[time0;time_simu{i}];
    time_i_diff=diff(time_i);
    level_diff_i=level_diff_simu{i};
    level_simu_i = [Q_vector(i);Q_vector(i) + cumsum(level_diff_i.*time_i_diff)];
    time_simu_t0{i} = time_i;
    level_simu{i}=level_simu_i;
end
%% estimation
train_length = 0.8 * m;
% simulated time 1,2,3 for parameter estimation
time_train=time_simu(1:train_length);
demand_train=demand_simu(1:train_length);
level_diff_train=level_diff_simu(1:train_length);
level_train=level_simu(1:train_length);
p_vector_train = p_vector(1:train_length);
Q_vector_train = Q_vector(1:train_length);
% the initial value of theta
[theta_initial,inventory_var] = theta_initial(time0,time_train,demand_train,level_diff_train,level_train);
% the initial alpha and beta correponding to theta_initial
[~,~,demand_var] = theta2alphabeta(time0,time_train,p_vector_train,demand_train,theta_initial);
% weight definition
weight_initial=[1/demand_var;1/inventory_var];
% maximum number of iterations
max_iter=10;
% maximum tolerance
tol=1e-10;
% Iteratively Reweighed Least Squares algorithm for parameter estimation
[theta_estimate, history] = IRLS(time0,p_vector_train,time_train,demand_train,level_diff_train,level_train,weight_initial,theta_initial, max_iter, tol);
%  the estimated values of alpha and beta based on theta
[alpha_estimate,beta_estimate] = theta2alphabeta(time0,time_train,p_vector_train,demand_train,theta_estimate);
disp(theta_estimate - theta_initial)
% save(".\data\parameter.mat","alpha_estimate","beta_estimate","theta_estimate")
%% fit level
time_fit = {};
demand_fit = {};
level_fit = {};
level_diff_fit = {};
for i = 1:m
    [time_fit_i,demand_fit_i,level_diff_fit_i,level_fit_i] = inventory_level(alpha_estimate,beta_estimate,p_vector(i),theta_estimate,time0,delta_t,Q_vector(i));
    time_fit{i}=[time0;time_fit_i];
    demand_fit{i} = [alpha_estimate-beta_estimate*p_vector(i);demand_fit_i];
    level_fit{i}=[Q_vector(i);level_fit_i];
    level_diff_fit{i}=level_diff_fit_i;
end
%% plot
% demand plot
fdemand=figure('unit','centimeters','position',[5,5,40,20],'PaperPosition',[5,5,40,20],'PaperSize',[40,20]);
tiledlayout(2,m/2,'Padding','Compact');
% plot time vs level
finvertorydiff=figure('unit','centimeters','position',[5,5,40,20],'PaperPosition',[5,5,40,20],'PaperSize',[40,20]);
tiledlayout(2,m/2,'Padding','Compact');
%
finvertory=figure('unit','centimeters','position',[5,5,40,20],'PaperPosition',[5,5,40,20],'PaperSize',[40,20]);
tiledlayout(2,m/2,'Padding','Compact');
for i = 1:m
    figure(fdemand)
    nexttile
    plot(time_true{i},demand_true{i},'LineWidth',1)
    hold on
    plot(time_simu{i},demand_simu{i},'LineWidth',1)
    plot(time_fit{i},demand_fit{i},'LineWidth',1)
    xlabel({'Day'},'FontSize',12)
    ylabel(['Demand'],'FontSize',12)
    title(strcat("(",char(96 + i),") The ", num2str(i),"th ordering cycle"),'FontSize',14)
    set(gca,'FontName','Book Antiqua','FontSize',10)
    if i==10
        legend(["Standard demand","Simulated demand","Fitted demand"],'location','northeast','FontSize',10,'NumColumns',1)
    end
    figure(finvertorydiff)
    nexttile
    plot(time_true{i}(2:end),level_diff_true{i},'LineWidth',1)
    hold on
    plot(time_simu{i},level_diff_simu{i},'LineWidth',1)
    plot(time_fit{i}(2:end),level_diff_fit{i},'LineWidth',1)
    xlabel({'Day'},'FontSize',12)
    ylabel(['Inventory change'],'FontSize',12)
    title(strcat("(",char(96 + i),") The ", num2str(i),"th ordering cycle"),'FontSize',14)
    set(gca,'FontName','Book Antiqua','FontSize',10)
    if i==10
        legend(["Standard inventory change","Simulated inventory change","Fitted inventory change"],'location','northeast','FontSize',8,'NumColumns',1)
    end
    figure(finvertory)
    nexttile
    plot(time_true{i},level_true{i},'LineWidth',1)
    hold on
    plot(time_simu_t0{i},level_simu{i},'LineWidth',1)
    % plot(time_fit{i},level_fit{i},'LineWidth',1)
    xlabel({'Day'},'FontSize',12)
    ylabel(['Inventory level'],'FontSize',12)
    title(strcat("(",char(96 + i),") The ", num2str(i),"th ordering cycle"),'FontSize',14)
    set(gca,'FontName','Book Antiqua','FontSize',10)
    if i==10
        legend(["Standard inventory level","Simulated inventory level"],'location','northeast','FontSize',8,'NumColumns',1) % ,"Fitted inventory level"
    end
end

% save figure
savefig(fdemand,'.\figure\simulation_demand.fig')
exportgraphics(fdemand,'.\figure\simulation_demand.pdf')
savefig(finvertorydiff,'.\figure\simulation_diff_level.fig')
exportgraphics(finvertorydiff,'.\figure\simulation_diff_level.pdf')
savefig(finvertory,'.\figure\simulation_level.fig')
exportgraphics(finvertory,'.\figure\simulation_level.pdf')


