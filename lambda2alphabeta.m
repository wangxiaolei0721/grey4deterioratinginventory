function [alpha,beta,res_var] = lambda2alphabeta(time0,time_train,p_vector_train,demand_train,lambda)
% calculate the initial values of alpha and beta based on lambda
% input parameter:
% time0: the time of order arrival
% time_train: the sample time
% demand_train: the demand
% p_vector_train: the price vector
% lambda: lambda
% output parameter：
% alpha: alpha
% beta: beta
% demand_var: the residual variance of demand regression equation


% number of orders
cell_length=length(time_train);
E_vector=[];
P_vector=[];
Y_demand=[];
for i = 1:cell_length
    time_i=[time0;time_train{i}];
    demand_i=demand_train{i};
    time_i_j=time_i(2:end);
    time_i_j1=time_i(1:end-1);
    E_i=lambda\1*(exp(-lambda.*(time_i_j1-time0))-exp(-lambda.*(time_i_j-time0)));
    P_i=-p_vector_train(i)*E_i;
    % prepare estimate matrix
    E_vector=[E_vector;E_i];
    P_vector=[P_vector;P_i];
    Y_demand=[Y_demand;demand_i];
end

% least squares
H_lambda=[E_vector,P_vector];
estimates=(H_lambda'*H_lambda)\H_lambda'*Y_demand;
alpha=estimates(1);
beta=estimates(2);
% residual
residual =  Y_demand-H_lambda*estimates;
res_var = (length(residual)-1)\sum(residual.^2);

end

