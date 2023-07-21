function Xp = VanDerPol5cubic_odefun(X,t,mu,nu,sigma,w0)
% w0^2*x'' + [mu + sigma*((w0*x')² + x²) + nu*((w0*x')² + x²)²]*w0*x' + x = 0
%
% Main variables x and y such that 
% x' = y
% y' = 1/w0^2 * (-x - [mu + sigma*((x'*w0)² + x²) + nu*((x'*w0)² + x²)²]*x'*w0)

x = X(1);
y = X(2)*w0;

xp = y;
yp = y + w0^2*(-x^3 - (mu + sigma*((y/w0)^2 + x^2) + nu*((y/w0)^2 + x^2)^2)*y/w0);

Xp = [xp; yp/w0];

