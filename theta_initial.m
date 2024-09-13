function [theta_initial,res_var] = theta_initial(time0,time_train,demand_train,level_diff_train,level_train)
% calculate the initial value of theta according to the inventory regression equation
% input parameter:
% time0: the time of order arrival
% Q_vector_train: order quantity vector
% time_train: the sample time
% demand_train: the demand
% level_diff_train: level changes
% output parameter：
% theta_initial: the initial value of theta
% res_var: residual variance


% number of orders
cell_length=length(time_train);
H_inventory=[];
Y_inventory_diff=[];
for i = 1:cell_length
    time_i=[time0;time_train{i}];    
    time_i_diff=diff(time_i);
    demand_i=demand_train{i};
    level_diff_i=level_diff_train{i};
    level_i = level_train{i};
    % inventory equation
    inventory_i=-0.5*(level_i(2:end)+level_i(1:end-1)).*time_i_diff;
    H_inventory=[H_inventory;inventory_i];
    Y_inventory_diff=[Y_inventory_diff;level_diff_i+demand_i];
end
% the initial value of theta
theta_initial = (H_inventory'*H_inventory)\H_inventory'*Y_inventory_diff;
residual =  Y_inventory_diff-H_inventory*theta_initial;
res_var = (length(residual)-1)\sum(residual.^2);

end

