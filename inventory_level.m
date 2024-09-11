function [time,demand,level_diff,level] = inventory_level(alpha,beta,p,theta,time0,delta_t,Q)
% generate inventory levels and inventory changes 
% input parameter:
% alpha: basic demand
% beta: price sensitivity coefficient
% p: price
% theta: deteriorating rate
% time0: the time of order arrival
% delta_t: the time resolution
% Q: the order quantity
% output parameter
% time: sampling time
% demand: demand quantity
% level: inventory level
% level_diff: inventory changes


% calculate order cycle based on order quantity
T=Q/(alpha-beta*p);
% the moment when the inventory drops to 0
tT=time0+T;
% generate sampling time with time resolution as the step size
time=[(time0+delta_t):delta_t:tT]';
% demand quantity
demand=(alpha-beta*p)*exp(-theta*(time-time0));
% inventory levels
level=(alpha-beta*p)*exp(-theta*(time-time0)).*(tT-time);
% inventory changes
level_diff=diff([Q;level]);


end

