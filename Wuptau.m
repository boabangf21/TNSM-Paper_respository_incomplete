function F = Wuptau(x,BackOff_W,m,n)
F(1) = 2.*(1-2.*x(1))/((BackOff_W + 1).*(1-2.*x(1)) + x(1).*BackOff_W.*(1-(2.*x(1))^m)) - x(2);
F(2) = 1-(1-x(2))^(n-1) - x(1);
end