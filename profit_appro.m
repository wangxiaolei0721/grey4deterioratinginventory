function profit = profit_appro(alpha,beta,p,theta,c,h,K,T)
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


par1=(p-c)*(alpha-beta*p);
par2=(p*theta+h)*(alpha-beta*p)*T/2;
profit=par1-par2-K./T;


end
