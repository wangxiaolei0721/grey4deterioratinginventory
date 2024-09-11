% clear data and figure
clc;
clear;
close all;
%% model setting
% equation parameters
alpha=120;
beta=10;
theta=0.10;
% load estimated parameters
load(".\data\parameter.mat")
%% economic order quantity
% economic parameter
c=4.0;
h=0.02;
K=50;
% price interval
p_true_interval=[c alpha/beta];
% price interval based on estimates
p_fit_interval=[c alpha_estimate/beta_estimate];
% cycle interval
T_interval=[1 14];
%% plot profit function
% order cycle to be evaluated
profit_true_fd = @(p,T) profit(alpha,beta,p,theta,c,h,K,T);
profit_fit_fd = @(p,T) profit(alpha_estimate,beta_estimate,p,theta_estimate,c,h,K,T);
% [xmin xmax ymin ymax]
fsurf(profit_true_fd,[p_true_interval,T_interval])
hold on
fsurf(profit_fit_fd,[p_fit_interval,T_interval])
%% solve
% true profit
syms p T;
profit_true_syms = profit(alpha,beta,p,theta,c,h,K,T);
profit_der_p=diff(profit_true_syms,p);
profit_der_T=diff(profit_true_syms,T);
eq1 = profit_der_p == 0;
eq2 = profit_der_T == 0;
sol = vpasolve([eq1, eq2], [p, T],[p_fit_interval;T_interval]);
p_true_opt  = double(sol.p);
T_true_opt  = double(sol.T);
% The profit corresponding to the optimal point
profit_true_opt = profit(alpha,beta,p_true_opt,theta,c,h,K,T_true_opt);
plot3(p_true_opt,T_true_opt,profit_true_opt,'LineStyle','none','Marker','hexagram','MarkerFaceColor',[0 1 0],'MarkerSize',15)
% fit profit
profit_fit_syms = profit(alpha_estimate,beta_estimate,p,theta_estimate,c,h,K,T);
profit_der_p=diff(profit_fit_syms,p);
profit_der_T=diff(profit_fit_syms,T);
eq1 = profit_der_p == 0;
eq2 = profit_der_T == 0;
sol = vpasolve([eq1, eq2], [p, T],[p_fit_interval;T_interval]);
p_fit_opt  = double(sol.p);
T_fit_opt  = double(sol.T);
% The profit corresponding to the optimal point
profit_fit_opt = profit(alpha_estimate,beta_estimate,p_fit_opt,theta_estimate,c,h,K,T_fit_opt);
plot3(p_fit_opt,T_fit_opt,profit_fit_opt,'LineStyle','none','Marker','hexagram','MarkerFaceColor',[1 0.200000002980232 0.200000002980232],'MarkerSize',15)
xlabel({'Price'},'FontSize',12)
ylabel(['Ordering cycle'],'FontSize',12)
zlabel(['Profit'],'FontSize',12)
legend(["True profit surface","Estimated profit surface","True optimal point","Estimated optimal point"],'location','northeast','FontSize',8,'NumColumns',1)
% save figure
savefig(gcf,'.\figure\simulation_opt.fig')
exportgraphics(gcf,'.\figure\simulation_opt.pdf')




