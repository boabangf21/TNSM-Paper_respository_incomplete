function [L, S] = RobustPCA(X, lambda, mu, tol, max_iter)
%X=rand(1,5);
% - X is a data matrix (of the size N x M) to be decomposed
    %   X can also contain NaN's for unobserved values
    % - lambda - regularization parameter, default = 1/sqrt(max(N,M))
    % - mu - the augmented lagrangian parameter, default = 10*lambda
    % - tol - reconstruction error tolerance, default = 1e-6
    % - max_iter - maximum number of iterations, default = 1000
   % h = min(111*X.^2, 111 +  min( abs(X - 1), abs(X + 1) ));
    [M, N] = size(X);
    unobserved = isnan(X);
    X(unobserved) = 0;
    normX = norm(X, 'fro');

    
    %[M, N] = size(X);

    
    
    % default arguments
    if nargin < 2
        lambda = 1 / sqrt(max(M,N));
    end
    if nargin < 3
        mu = 10*lambda;
    end
    if nargin < 4
        tol = 1e-6;
    end
    if nargin < 5
        max_iter = 1000;
    end
    
    % initial solution
    L = zeros(M, N);
    S = zeros(M, N);
    Y = zeros(M, N);
    h=zeros(M,N);
    for iter = (1:max_iter)
        % ADMM step: update L and S
        
     %h =  min(h , min( (h), (X)));
       %h = min(X,  min( abs(X), abs(X) ));
       
     h = min(X, min((X), (X) ));
   
     L= Do(1/mu, abs(X) - S + (1/mu)*(Y));
       %C= So(lambda/mu, abs(h) - L + (1/mu)*(Y));
     S= So(lambda/mu, abs(X) - L + (1/mu)*(Y));
    % h= min(lambda/mu, X - L + (1/mu)*(Y)); 
   
        % and augmented lagrangian multiplier
        %h = @(X) min( 0.5 * X.^2 , 0.5 + min( abs(X-1), abs(X+1) ));
    % Z = X - L - S - h;
        Z = X - L - S-h;
        %Z(unobserved) = 0; % skip missing values
        Y = Y + mu*(Z);
        
        err = norm(Z, 'fro') / normX;
        if (iter == 1) || (mod(iter, 10) == 0) || (err < tol)
            fprintf(1, 'iter: %04d\terr: %f\trank(L): %d\tcard(S): %d\n', ...
                    iter, err, rank(S), nnz(L(~unobserved)));
        end
        if (err < tol) break; end
    end
end

function r = So(tau, X)
    % shrinkage operator
   % h = min(X.^2, min((X), (X) ));
    r = sign(X) .* max(abs(X) - tau, 0);
 %r = sign(X);
end

function r = Do(tau, X)
    % shrinkage operator for singular values
   % h = min(X.^2, min((X), (X) ));
    [U, S, V] = svd(X);
    r = U*So(tau, S)*V';
    %r = U*S*V';
end