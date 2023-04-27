function [w] = gprTrain_proper(Xtrain, ytrain, sigma, alpha)


L = rbf(Xtrain, Xtrain, sigma); % C = K(:, S)


l = size(L, 2);
w = L' * ytrain;
w = (alpha * eye(l) + L' * L)\w ;
w = ytrain - L * w;
w = w / alpha;
end