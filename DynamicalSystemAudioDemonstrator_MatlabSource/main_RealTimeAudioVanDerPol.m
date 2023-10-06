%% This code runs the main demonstrator which is detailed in the article.
%
% Colinot and Vergez, 2023

clear functions; close all hidden;
% System parameters
nu0 = 0.5; 
sigma = -0.5;   sigmamin = -0.8;  sigmamax = 0.5;
mu = 0;         mumin = -0.5;     mumax = -mumin;
MIDInote0 = 36; MIDInotemin = 36; MIDInotemax = 84;
% Audio parameters
Fs = 44100;%Hz 
Nbuf = 1024;
try fprintf('\n Audio driver initialization. Trying VoiceMeeter ASIO. \n'); ADW = audioDeviceWriter('SampleRate',Fs,'Driver','ASIO','Device','VoiceMeeter Virtual ASIO'); ADW(zeros(Nbuf,2)); fprintf('\n Success!'); ADW,
catch, try    fprintf('Failed VoiceMeeter ASIO... Trying WASAPI.\n');       ADW = audioDeviceWriter('Driver','WASAPI','SampleRate',Fs,'BufferSize',Nbuf); ADW(zeros(Nbuf,2)); fprintf('\n Success!'); ADW, 
       catch, fprintf('Failed WASAPI... Trying default.\n');                ADW = audioDeviceWriter('SampleRate',Fs,'BufferSize',Nbuf); ADW(zeros(Nbuf,2)); fprintf('\n Success!'); ADW, 
       end
end
%end
% MIDI control parameters
muCC = 1; sigmaCC = 2;
%% Preparing user interactions (display and control)
uiChooseMIDIsource
uiBuildControlFigure

%% Synthesis loop
X = zeros(2,1)+1; audioout = zeros(Nbuf,2); speeds = zeros(Nbuf,1); positions = zeros(Nbuf,1); % System and audio variables
samplesSinceLastZC = 0; bufferOfSamplesBetweenZC = zeros(32,1); ibufzc = 1; recordingInProgress = 0; % Descriptor extraction
lastMIDInote = MIDInotemin; f0 = f0s(MIDInote0 - MIDInotemin + 1); % Note-related
while ~stopbutton.Value
    % Reading user controls
    if MIDIbutton.Value, loopReadMIDIcontrols
    else,                MIDInote = round(sldMIDInote.Value); % sigma and mu are handled via their sliders' ValueChangingFcn
    end
    if MIDInote ~= lastMIDInote, loopHandleNoteChange; end
    loopReadButtons
    % Synthesis
    if boolODE45
        if 	boolLinearStiffness,   [~,Xts] = ode45(@(t,Xt) VanDerPol5_odefun(Xt,t,mu,nu0,sigma,2*pi*f0),(0:Nbuf)/Fs,X.');
        elseif boolCubicStiffness, [~,Xts] = ode45(@(t,Xt) VanDerPol5cubic_odefun(Xt,t,mu,nu0,sigma,2*pi*f0),(0:Nbuf)/Fs,X.');
        end
        X = Xts(end,:); positions = Xts(2:end,1); speeds = Xts(2:end,2); 
    else
        for ibuf = 1:Nbuf
            if 	boolLinearStiffness
                if boolEuler,   X_np1 = VanDerPol5_explicitEuler(X,mu,nu0,sigma,2*pi*f0,Fs);
                elseif boolRK4, X_np1 = VanDerPol5_RK4(X,mu,nu0,sigma,2*pi*f0,Fs);
                end
            elseif boolCubicStiffness
                if boolEuler,   X_np1 = VanDerPol5cubic_explicitEuler(X,mu,nu0,sigma,2*pi*f0,Fs);
                elseif boolRK4, X_np1 = VanDerPol5cubic_RK4(X,mu,nu0,sigma,2*pi*f0,Fs);
                end
            end
            X = X_np1;  positions(ibuf) = X(1); speeds(ibuf) = X(2);
        end
    end
    audioout = [positions(:) speeds(:)]/Xmax;    
    % Descriptors
    loopExtractDescriptors
    % Display
    if ~((hBDCurrentPoint.XData == mu)&&(hBDCurrentPoint.YData == sigma)&&(abs(hBDCurrentPoint.ZData-rms_est)<1e-3))
        hBDCurrentPoint.XData = mu; hBDCurrentPoint.YData = sigma; hBDCurrentPoint.ZData = rms_est;
        addpoints(hBDPastPoints,mu,sigma,rms_est);
    end
    % Recording
    loopHandleRecording
    % Sound output
    ADW(audioout);
    % Display actualization
    drawnow limitrate
end
stopbutton.Value = 0;
