function res_var = theta_inventoryres(time0,time_train,demand_train,level_diff_train,level_train,theta)
% calculate the residual variance of inventory regression equation based on theta
% input parameter:
% Q_vector_train: order quantity vector
% time_train: the sample time
% demand_train: the demand
% level_diff_train: level changes
% theta: theta
% output parameter:
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

residual =  Y_inventory_diff-H_inventory*theta;
res_var = (length(residual)-1)\sum(residual.^2);

end

