% Record and display variables

if recordbutton.Value&&~recordingInProgress
    recordingInProgress = 1;
    recordedVariables = struct();
    recordedVariables.t = [];
    recordedVariables.RMS = [];
    recordedVariables.f0_est = [];
    recordedVariables.f0 = [];
    recordedVariables.mu = [];
    recordedVariables.sigma = [];
    recordedVariables.boolCubicStiffness = [];
    recordedVariables.boolLinearStiffness = [];
    recordedVariables.boolEuler = [];
    recordedVariables.boolRK4 = [];
    recordedVariables.boolODE45 = [];
    recordedVariables.boolNoiseFloor = [];
    
    recordingTime = 0;
end
if recordbutton.Value&&recordingInProgress
    recordedVariables.t = [recordedVariables.t recordingTime];
    recordingTime = recordingTime + Nbuf/Fs;
    recordedVariables.RMS = [recordedVariables.RMS rms_est];
    recordedVariables.f0_est = [recordedVariables.f0_est f0_est];
    recordedVariables.f0 = [recordedVariables.f0 f0];
    recordedVariables.mu = [recordedVariables.mu mu];
    recordedVariables.sigma = [recordedVariables.sigma sigma];
    recordedVariables.boolCubicStiffness = [recordedVariables.boolCubicStiffness boolCubicStiffness];
    recordedVariables.boolLinearStiffness = [recordedVariables.boolLinearStiffness boolLinearStiffness];
    recordedVariables.boolEuler = [recordedVariables.boolEuler boolEuler];
    recordedVariables.boolRK4 = [recordedVariables.boolRK4 boolRK4];
    recordedVariables.boolODE45 = [recordedVariables.boolODE45 boolODE45];
    recordedVariables.boolNoiseFloor = [recordedVariables.boolNoiseFloor boolNoiseFloor];
end
if ~recordbutton.Value&&recordingInProgress
    recordingInProgress = 0;
    save(['Recording_RealTimeVdPDemonstrator_' datestr(now,'yyyymmddTHHMMSS') '.mat'],'recordedVariables');
    
    hf = figure(1); set(hf,'Position',[controlfig.Position(1)+controlfig.Position(3) controlfig.Position(2) 2*dl controlfig.Position(4)-50]);
    clf;
    plotRecording
    
end
