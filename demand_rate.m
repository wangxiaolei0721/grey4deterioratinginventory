function demand = demand_rate(alpha,beta,p,theta,time,time0)
% generate the demand
% input parameter:
% alpha: basic demand
% beta: price sensitivity coefficient
% p: price
% theta: deteriorating rate
% time0: the time of order arrival
% time: the time 
% output parameter
% demand: demand at time


% the potential demand
D_p=alpha-beta*p;
% the quality decay level
R_t=exp(-theta*(time-time0));
% demand rate
demand=D_p*R_t;


end
