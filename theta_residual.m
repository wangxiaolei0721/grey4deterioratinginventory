function residual = theta_residual(time0,time_train,p_vector_train,demand_train,level_diff_train,level_train,weight,theta)
% Iteratively Reweighed Least Squares algorithm
% input parameter:
% time0: the time of order arrival
% Q_vector_train: order quantity vector
% time_train: the sample time
% demand_train: the demand
% level_diff_train: level changes
% p_vector_train: the price vector
% weight_initial: initial weight
% theta: theta
% output parameter：
% residual: residual vector of derivative


cell_length=length(time_train);
E_vector=[];
P_vector=[];
Y_demand=[];
H_inventory=[];
Y_inventory_diff=[];
for i = 1:cell_length
    time_i=[time0;time_train{i}];
    time_i_diff=diff(time_i);
    demand_i=demand_train{i};
    time_i_j=time_i(2:end);
    time_i_j1=time_i(1:end-1);
    % demand equation
    E_i=theta\1*(exp(-theta.*(time_i_j1-time0))-exp(-theta.*(time_i_j-time0)));
    P_i=-p_vector_train(i)*E_i;
    E_vector=[E_vector;E_i];
    P_vector=[P_vector;P_i];
    Y_demand=[Y_demand;demand_i];
    % inventory equation
    level_diff_i=level_diff_train{i};
    level_i = level_train{i};
    inventory_i=-0.5*(level_i(2:end)+level_i(1:end-1)).*time_i_diff;
    H_inventory=[H_inventory;inventory_i];
    Y_inventory_diff=[Y_inventory_diff;level_diff_i+demand_i];
end
H_theta=[E_vector,P_vector];
estimates=(H_theta'*H_theta)\H_theta'*Y_demand;
% demand residual
demand_residual=weight(1)*(Y_demand-H_theta*estimates);
% inventory residual
inventory_residual=weight(2)*(Y_inventory_diff-H_inventory*theta);
residual=[demand_residual;inventory_residual];
% residual=demand_residual;
% size(demand_residual)
% size(inventory_residual)
% size([demand_residual;inventory_residual])


end

