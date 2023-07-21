function X_np1 = VanDerPol5_RK4(X,mu,nu,sigma,w0,Fs)
% w0^2*x'' + [mu + sigma*((w0*x')² + x²) + nu*((w0*x')² + x²)²]*w0*x' + x = 0
%
% Main variables x and y such that 
% x' = y
% y' = 1/w0^2 * (-x - [mu + sigma*((x'*w0)² + x²) + nu*((x'*w0)² + x²)²]*x'*w0)
% x_np1 = y_n/Fs + x_n;
% y_np1 = y_n + 1/Fs*w0^2*(-x_n - [mu + sigma*((y_n/w0)^2 + x_n^2) + nu*((y_n/w0)^2 + x_n^2)^2)*y_n/w0)
%

x_n = X(1);
y_n = X(2);

Xb = [x_n y_n];

Fb = @(X) w0*[X(2) (-X(1) - (mu + sigma*(X(2)^2 + X(1)^2) + nu*(X(2)^2 + X(1)^2)^2)*X(2))];

K1 = 1/Fs * Fb(Xb);
K2 = 1/Fs * Fb(Xb + K1/2);
K3 = 1/Fs * Fb(Xb + K2/2);
K4 = 1/Fs * Fb(Xb + K3);

Xb_np1 = Xb + 1/6 * (K1 + 2*K2 + 2*K3 + K4);

X_np1 = [Xb_np1(1) Xb_np1(2)];

