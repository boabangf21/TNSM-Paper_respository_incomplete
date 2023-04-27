function [w] = gprTrain_RPCA(Xtrain, ytrain, sigma, alpha)
%l = 100; % can be tuned
   tol= 1e-2;
lambda=1e-3;
max_iter=2000;
mu=1e-5;


C = rbf(Xtrain, Xtrain, sigma); % C = K(:, S)

%rank=size(C,1);
[S, L] =RobustPCA(C, lambda, mu, tol, max_iter); % offline
%[L,Q,R,RMSE,error]=GoDec(C,rank,1e-6,1)
%c=size(Xtrain,1);
 %L=Nystrom(Xtrain,sigma,c)
l = size(L, 2);
w = L' * ytrain;
w = (alpha * eye(l) + L' * L)\w ;
w = ytrain - L * w;
w = w / alpha;
end