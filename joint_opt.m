% clear data and figure
clc;
clear;
close all;
%% model setting
% equation parameters
alpha=120;
beta=10;
lambda=0.05;
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
T_interval=[1 14];
%% plot profit for simulated and estimated pars
fprofit_opt=figure('unit','centimeters','position',[5,5,30,15],'PaperPosition',[5,5,30,15],'PaperSize',[30,15]);
tiledlayout(1,2,'Padding','Compact');
nexttile
profit_simu_fd = @(p,T) profit(alpha,beta,p,lambda,c,h,K,T);
fsurf(profit_simu_fd,[p_simu_interval,T_interval])
hold on
% solve
% simulated profit
syms p T;
profit_simu_syms = profit(alpha,beta,p,lambda,c,h,K,T);
profit_der_p=diff(profit_simu_syms,p);
profit_der_T=diff(profit_simu_syms,T);
eq1 = profit_der_p == 0;
eq2 = profit_der_T == 0;
sol = vpasolve([eq1, eq2], [p, T],[p_simu_interval;T_interval]);
p_simu_opt  = double(sol.p);
T_simu_opt  = double(sol.T);
% Q
Q_simu_opt=(alpha-beta*p_simu_opt)*T_simu_opt;
% The profit corresponding to the optimal point
profit_simu_opt = profit(alpha,beta,p_simu_opt,lambda,c,h,K,T_simu_opt);
plot3(p_simu_opt,T_simu_opt,profit_simu_opt,'LineStyle','none','Marker','hexagram','MarkerFaceColor',[0 1 0],'MarkerSize',15)
xlabel({'Price'},'FontSize',12)
ylabel(['Ordering cycle'],'FontSize',12)
zlabel(['Profit'],'FontSize',12)
zlim([-100,120])
% title(["(a) Profit surface of simulated parameters"],'FontSize',14)
set(gca,'FontName','Book Antiqua','FontSize',12)
% fit profit
profit_fit_fd = @(p,T) profit(alpha_estimate,beta_estimate,p,lambda_estimate,c,h,K,T);
nexttile
fsurf(profit_fit_fd,[p_fit_interval,T_interval])
hold on
profit_fit_syms = profit(alpha_estimate,beta_estimate,p,lambda_estimate,c,h,K,T);
profit_fit_der_p=diff(profit_fit_syms,p);
profit_fit_der_T=diff(profit_fit_syms,T);
eq1 = profit_fit_der_p == 0;
eq2 = profit_fit_der_T == 0;
sol = vpasolve([eq1, eq2], [p, T],[p_fit_interval;T_interval]);
p_fit_opt  = double(sol.p);
T_fit_opt  = double(sol.T);
% Q
Q_fit_opt=(alpha_estimate-beta_estimate*p_fit_opt)*T_fit_opt;
% The profit corresponding to the optimal point
profit_fit_opt = profit(alpha_estimate,beta_estimate,p_fit_opt,lambda_estimate,c,h,K,T_fit_opt);
plot3(p_fit_opt,T_fit_opt,profit_fit_opt,'LineStyle','none','Marker','hexagram','MarkerFaceColor',[1 0.200000002980232 0.200000002980232],'MarkerSize',15)
xlabel({'Price'},'FontSize',14)
ylabel(['Ordering cycle'],'FontSize',14)
zlabel(['Profit'],'FontSize',14)
zlim([-100,120])
% title(["(b) Profit surface of estimated parameters"],'FontSize',14)
set(gca,'FontName','Book Antiqua','FontSize',14)
%% plot approximated profit for simulated and estimated pars
fprofit_appro_opt=figure('unit','centimeters','position',[5,5,30,15],'PaperPosition',[5,5,30,15],'PaperSize',[30,15]);
tiledlayout(1,2,'Padding','Compact');
nexttile
profit_appro_simu_fd = @(p,T) profit_appro(alpha,beta,p,lambda,c,h,K,T);
fsurf(profit_appro_simu_fd,[p_simu_interval,T_interval])
hold on
% solve
syms p T;
profit_appro_simu_syms = profit_appro(alpha,beta,p,lambda,c,h,K,T);
profit_appro_der_p=diff(profit_appro_simu_syms,p);
profit_appro_der_T=diff(profit_appro_simu_syms,T);
eq1 = profit_appro_der_p == 0;
eq2 = profit_appro_der_T == 0;
sol = vpasolve([eq1, eq2], [p, T],[p_simu_interval;T_interval]);
p_appro_simu_opt  = double(sol.p);
T_appro_simu_opt  = double(sol.T);
% Q
Q_appro_simu_opt=(alpha-beta*p_appro_simu_opt)*T_appro_simu_opt;
% The profit corresponding to the optimal point
profit_appro_simu_opt = profit_appro(alpha,beta,p_appro_simu_opt,lambda,c,h,K,T_appro_simu_opt);
plot3(p_appro_simu_opt,T_appro_simu_opt,profit_appro_simu_opt,'LineStyle','none','Marker','hexagram','MarkerFaceColor',[0 1 0],'MarkerSize',15)
xlabel({'Price'},'FontSize',14)
ylabel(['Ordering cycle'],'FontSize',14)
zlabel(['Profit'],'FontSize',14)
zlim([-100,120])
% title(["(a) Approximated profit surface of simulated parameters"],'FontSize',14)
set(gca,'FontName','Book Antiqua','FontSize',14)
% approximated profit for fit pars
nexttile
profit_appro_fit_fd = @(p,T) profit_appro(alpha_estimate,beta_estimate,p,lambda_estimate,c,h,K,T);
fsurf(profit_appro_fit_fd,[p_fit_interval,T_interval])
hold on
profit_appro_fit_syms = profit_appro(alpha_estimate,beta_estimate,p,lambda_estimate,c,h,K,T);
profit_appro_fit_der_p=diff(profit_appro_fit_syms,p);
profit_appro_fit_der_T=diff(profit_appro_fit_syms,T);
eq1 = profit_appro_fit_der_p == 0;
eq2 = profit_appro_fit_der_T == 0;
sol = vpasolve([eq1, eq2], [p, T],[p_fit_interval;T_interval]);
p_appro_fit_opt  = double(sol.p);
T_appro_fit_opt  = double(sol.T);
% Q
Q_appro_fit_opt=(alpha_estimate-beta_estimate*p_appro_fit_opt)*T_appro_fit_opt;
% The profit corresponding to the optimal point
profit_appro_fit_opt = profit_appro(alpha_estimate,beta_estimate,p_appro_fit_opt,lambda_estimate,c,h,K,T_appro_fit_opt);
plot3(p_appro_fit_opt,T_appro_fit_opt,profit_appro_fit_opt,'LineStyle','none','Marker','hexagram','MarkerFaceColor',[1 0.200000002980232 0.200000002980232],'MarkerSize',15)
xlabel({'Price'},'FontSize',14)
ylabel(['Ordering cycle'],'FontSize',14)
zlabel(['Profit'],'FontSize',14)
zlim([-100,120])
% title(["(b) Approximated profit of estimated parameters"],'FontSize',14)
set(gca,'FontName','Book Antiqua','FontSize',14)
%% save figure
savefig(fprofit_opt,'.\figure\profit_opt.fig')
exportgraphics(fprofit_opt,'.\figure\profit_opt.pdf')
savefig(fprofit_appro_opt,'.\figure\profit_appro_opt.fig')
exportgraphics(fprofit_appro_opt,'.\figure\profit_appro_opt.pdf')



