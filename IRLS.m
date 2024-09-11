function [theta_next, history] = IRLS(time0,Q_vector_train,time_train,demand_train,level_diff_train,p_vector_train,weight_initial,theta_initial, max_iter, tol)
% Iteratively Reweighed Least Squares algorithm
% input parameter:
% time0: the time of order arrival
% Q_vector_train: order quantity vector
% time_train: the sample time
% demand_train: the demand
% level_diff_train: level changes
% p_vector_train: the price vector
% weight_initial: initial weight
% theta_initial: the initial value of theta
% max_iter: maximum number of iterations
% tol: maximum tolerance
% output parameter：
% theta_next: the estimated value of theta
% history: the historical value of theta


% previous theta
theta_prev = theta_initial;
% initial history
history = zeros(max_iter,1); % 记录每次迭代的参数估计值
history(1) = theta_initial;
weight=weight_initial;

% lsqnonlin function setting
opt_options=optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt','MaxFunctionEvaluations',10,'FunctionTolerance',1e-10,'StepTolerance',1e-6);

for iter = 2:max_iter
    % residual function of lambda under multiple orders
    minobjfun = @(theta) theta_residual(time0,Q_vector_train,time_train,demand_train,level_diff_train,p_vector_train,weight,theta);
    % next theta
    theta_next = lsqnonlin(minobjfun,theta_prev,0,0.2,opt_options);
    % the residual variance of inventory regression equation based on theta
    inventory_var = theta_inventoryres(time0,Q_vector_train,time_train,demand_train,level_diff_train,theta_next);
    % the initial values of alpha and beta based on theta
    [~,~,demand_var] = theta2alphabeta(time0,time_train,demand_train,p_vector_train,theta_next);
    % weight
    weight=[1/demand_var;1/inventory_var];
    % check for convergence
    if norm(theta_next - theta_prev) < tol
        break;
    end
    % record parameter estimates for the current iteration
    history(iter) = theta_next;
    theta_prev=theta_next;
end

end
