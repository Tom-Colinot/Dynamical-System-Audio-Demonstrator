%% DISCLAIMER: Lower the volume before running this code, the sound can be quite loud. 
% This code is used to verify how many oscillators can be solved at once
% (see section 4.2 of the article). Run it on your machine gives an idea
% of the headroom you have for more complex systems!
%
% Colinot and Vergez, 2023

clear
global nu0 sigma mu

nu0 = 0.5; sigma = -0.5; mu = -0.5; f0 = 55;
Fs = 44100;%Hz
Nbuf = 512;
ADW = audioDeviceWriter(Fs);

Nloop = 10;
%% ODE45
Nmodes = 0;
Xs = [1 1];
no_underrun = 1;
fprintf('\n ODE45  \n',Nmodes)

while no_underrun
    Nmodes = Nmodes+1;
    fprintf(' %i',Nmodes)
    for iloop = 1:Nloop
        for imode = 1:Nmodes
            X = Xs(2*(imode-1)+(1:2));
            [~,Xts] = ode45(@(t,Xt) VanDerPol5_odefun(Xt,t,mu,nu0,sigma,2*pi*f0*2^(imode/12)),(0:Nbuf)/Fs,X.');
            X = Xts(end,:);
            Xs(2*(imode-1)+(1:2)) = X;
        end
        audioout = Xts(2:end,end-1:end)/10;
        ADW(audioout);
    end
    
    for iloop = 1:Nloop
        for imode = 1:Nmodes
            X = Xs(2*(imode-1)+(1:2));
            [~,Xts] = ode45(@(t,Xt) VanDerPol5_odefun(Xt,t,mu,nu0,sigma,2*pi*f0*2^(imode/12)),(0:Nbuf)/Fs,X.');
            X = Xts(end,:);
            Xs(2*(imode-1)+(1:2)) = X;
        end
        audioout = Xts(2:end,end-1:end)/10;
        nunderrun = ADW(audioout);
        if nunderrun
            no_underrun = 0;
        end
    end
	Xs = [Xs; Xs(end-1:end)];
end

fprintf('\n ODE45 : maximum %i oscillators in parallel',Nmodes)

%% RK4
fprintf('\n RK4  \n',Nmodes)

Nmodes = 0;
Xs = [1 1];
no_underrun = 1;
while no_underrun
    Nmodes = Nmodes+1;
    fprintf(' %i',Nmodes)
    for iloop = 1:Nloop
        for imode = 1:Nmodes
            X = Xs(2*(imode-1)+(1:2));
            for ibuf=1:Nbuf
                X = VanDerPol5_RK4(X,mu,nu0,sigma,2*pi*f0*2^(imode/12),Fs);
                audioout(ibuf,:) = X/10;
            end
            Xs(2*(imode-1)+(1:2)) = X;
        end
        ADW(audioout);
    end
    
    for iloop = 1:Nloop
        for imode = 1:Nmodes
            X = Xs(2*(imode-1)+(1:2));
            for ibuf=1:Nbuf
                X = VanDerPol5_RK4(X,mu,nu0,sigma,2*pi*f0*2^(imode/12),Fs);
                audioout(ibuf,:) = X/10;
            end
            Xs(2*(imode-1)+(1:2)) = X;
        end
        nunderrun = ADW(audioout);
        if nunderrun
            no_underrun = 0;
            nunderrun;
        end
    end
    Xs = [Xs; Xs(end-1:end)];%[1;1];    
end

fprintf('\n RK4 : maximum %i oscillators in parallel',Nmodes)

%% EULER
fprintf('\n Euler  \n',Nmodes)

no_underrun = 1;
Xs = [1 1];
Nmodes = 0;
while no_underrun
    Nmodes = Nmodes+1;    
    fprintf(' %i',Nmodes)
    if ~mod(Nmodes,30)
        fprintf('\n')
    end
    for iloop = 1:Nloop
        for imode = 1:Nmodes
            X = Xs(2*(imode-1)+(1:2));
            for ibuf=1:Nbuf
                X = VanDerPol5_backwardsEuler(X,mu,nu0,sigma,2*pi*f0*2^(mod(imode,72)/12),Fs);
                audioout(ibuf,:) = X/10;
            end
            Xs(2*(imode-1)+(1:2)) = X;
        end
        
        ADW(audioout);
    end
    
    for iloop = 1:Nloop
        for imode = 1:Nmodes
            X = Xs(2*(imode-1)+(1:2));
            for ibuf=1:Nbuf
                X = VanDerPol5_backwardsEuler(X,mu,nu0,sigma,2*pi*f0*2^(mod(imode,72)/12),Fs);
                audioout(ibuf,:) = X/10;
            end
            Xs(2*(imode-1)+(1:2)) = X;
        end
        
        nunderrun = ADW(audioout);
        if nunderrun
            no_underrun = 0;
        end
    end
	Xs = [Xs; Xs(end-1:end)];
end

fprintf('\n EULER : maximum %i oscillators in parallel',Nmodes)

