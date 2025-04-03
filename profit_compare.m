% clear data and figure
clc;
clear;
close all;
%% model setting
% equation parameters
alpha=120;
beta=10;
theta=0.05;
% load estimated parameters
load(".\data\parameter.mat")
%% economic order quantity
% economic parameter
c=4.0;
h=0.02;
K=100;
% price interval
p_simu_interval=[c alpha/beta];
% price interval based on estimates
p_fit_interval=[c alpha_estimate/beta_estimate];
% cycle interval
T_interval=[1 7];
%% plot profit function
fprofit_opt_compare=figure('unit','centimeters','position',[5,5,30,15],'PaperPosition',[5,5,30,15],'PaperSize',[30,15]);
tiledlayout(1,2,'Padding','Compact');
nexttile
% order cycle to be evaluated
profit_simu_fd = @(p,T) profit(alpha,beta,p,theta,c,h,K,T);
profit_appro_simu_fd = @(p,T) profit_appro(alpha,beta,p,theta,c,h,K,T);
% [xmin xmax ymin ymax]
fsurf(profit_simu_fd,[p_simu_interval,T_interval])
hold on
fsurf(profit_appro_simu_fd,[p_fit_interval,T_interval])
xlabel({'Price'},'FontSize',12)
ylabel(['Ordering cycle'],'FontSize',12)
zlabel(['Profit'],'FontSize',12)
% title(["(b) 仿真参数"],'FontSize',14)
legend(["Profit surface of simulated parameters","Approximate profit surface of simulated parameters"],'location','northeast','FontSize',8,'NumColumns',1)
set(gca,'FontName','Book Antiqua','FontSize',12)
%% plot approximated profit function
% order cycle to be evaluated
profit_appro_simu_fd = @(p,T) profit_appro(alpha,beta,p,theta,c,h,K,T);
profit_appro_fit_fd = @(p,T) profit_appro(alpha_estimate,beta_estimate,p,theta_estimate,c,h,K,T);
% [xmin xmax ymin ymax]
nexttile
fsurf(profit_appro_simu_fd,[p_simu_interval,T_interval])
hold on
fsurf(profit_appro_fit_fd,[p_fit_interval,T_interval])
xlabel({'Price'},'FontSize',12)
ylabel(['Ordering cycle'],'FontSize',12)
zlabel(['Profit'],'FontSize',12)
% title(["(b) 估计参数"],'FontSize',14)
legend(["Profit surface of estimated parameters","Approximate profit surface of estimated parameters"],'location','northeast','FontSize',8,'NumColumns',1)
set(gca,'FontName','Book Antiqua','FontSize',12)
%% save figure
savefig(fprofit_opt_compare,'.\figure\profit_opt_compare.fig')
exportgraphics(fprofit_opt_compare,'.\figure\profit_opt_compare.pdf')



