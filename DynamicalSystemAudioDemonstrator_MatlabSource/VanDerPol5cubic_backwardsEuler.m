function X_np1 = VanDerPol5cubic_backwardsEuler(X,mu,nu,sigma,w0,Fs)
% w0^2*x'' + [mu + sigma*((w0*x')² + x²) + nu*((w0*x')² + x²)²]*w0*x' + x^3 = 0
%
% Main variables x and y such that 
% x' = w0*y
% y' = w0*(-x^3 - [mu + sigma*(x'² + x²) + nu*(x'² + x²)²]*x')
% Explicit scheme :
% x_np1 = y_n/Fs*w0 + x_n;
% y_np1 = y_n + 1/Fs*w0*(-x_n^3 - (mu + sigma*((y_n)^2 + x_n^2) + nu*((y_n)^2 + x_n^2)^2)*y_n);
%

x_n = X(1);
y_n = X(2);

x_np1 = y_n/Fs*w0 + x_n;
y_np1 = y_n + 1/Fs*w0*(-x_n^3 - (mu + sigma*((y_n)^2 + x_n^2) + nu*((y_n)^2 + x_n^2)^2)*y_n);

X_np1 = [x_np1 y_np1];

