function level = levelattime(alpha,beta,p,theta,time,time0,Q)
% calculate inventory levels at a specific time
% input parameter:
% alpha: basic demand
% beta: price sensitivity coefficient
% p: price
% theta: deteriorating rate
% time: the time to be evaluated
% time0: the time of order arrival
% Q: the order quantity
% output parameter:
% level: inventory level


% calculate order cycle based on order quantity
T=Q/(alpha-beta*p);
% the moment when the inventory drops to 0
tT=time0+T;
level=(alpha-beta*p)*exp(-theta*(time-time0))*(tT-time);


end
