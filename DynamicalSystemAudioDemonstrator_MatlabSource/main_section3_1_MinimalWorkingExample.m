%% DISCLAIMER: Lower the volume before running this code, the sound can be quite loud. 
% This code is given inline in section 3.1 of the article. 
%
% Colinot and Vergez, 2023

clear 

nu0 = 0.5; sigma = -0.5; mu = -0.5; f0 = 440;
Fs = 44100;%Hz
Nbuf = 512;
ADW = audioDeviceWriter('SampleRate',Fs,'BufferSize',Nbuf);

X = [1;1];
while 1
    [~,Xts] = ode45(@(t,X) 2*pi*f0*[X(2) ; (-X(1) - (mu + sigma*(X(2)^2 + X(1)^2) + nu0*(X(2)^2 + X(1)^2)^2)*X(2))],(0:Nbuf)/Fs,X.');
    X = Xts(end,:);
    ADW(Xts(2:end,:));
end