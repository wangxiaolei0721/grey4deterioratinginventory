function profit = profit(alpha,beta,p,theta,c,h,K,T)
% profit function:
% input parameter:
% d: basic demand
% theta: quantity deteriorating rate
% lambda: quality decay rate
% p: sales price
% c: production cost
% h: holding cost per unit per unit of time
% A: ordering cost per cycle
% T: order cycles
% output parameter:
% profit: total profits at T


par1=(alpha-beta*p).*(p*theta+h)/(theta^2);
par2=(alpha-beta*p)*(c*theta+h)/theta;
profit=par1.*(1-exp(-theta*T))./T-par2-K./T;

end
