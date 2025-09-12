function [lambda_next, history] = IRLS(time0,p_vector_train,time_train,demand_train,level_diff_train,level_train,weight_initial,lambda_initial, max_iter, tol)
% Iteratively Reweighed Least Squares algorithm
% input parameter:
% time0: the time of order arrival
% time_train: the sample time
% demand_train: the demand
% level_diff_train: level changes
% p_vector_train: the price vector
% weight_initial: initial weight
% lambda_initial: the initial value of lambda
% max_iter: maximum number of iterations
% tol: maximum tolerance
% output parameter：
% lambda_next: the estimated value of lambda
% history: the historical value of lambda


% previous lambda
lambda_prev = lambda_initial;
% initial history
history = NaN(max_iter,1); % 记录每次迭代的参数估计值
history(1) = lambda_initial;
weight=weight_initial;

% lsqnonlin function setting
opt_options=optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt','MaxFunctionEvaluations',10,'FunctionTolerance',1e-10,'StepTolerance',1e-6);

for iter = 2:max_iter
    % residual function of lambda under multiple orders
    minobjfun = @(lambda) lambda_residual(time0,time_train,p_vector_train,demand_train,level_diff_train,level_train,weight,lambda);
    % next lambda
    lambda_next = lsqnonlin(minobjfun,lambda_prev,0,0.2,opt_options);
    % the residual variance of inventory regression equation based on lambda
    inventory_var = lambda_inventoryres(time0,time_train,demand_train,level_diff_train,level_train,lambda_next);
    % the initial values of alpha and beta based on lambda
    [~,~,demand_var] = lambda2alphabeta(time0,time_train,p_vector_train,demand_train,lambda_next);
    % weight 
    weight=[1/demand_var;1/inventory_var];
    % check for convergence
    if norm(lambda_next - lambda_prev) < tol
        break;
    end
    % record parameter estimates for the current iteration
    history(iter) = lambda_next;
    lambda_prev=lambda_next;
end

end
