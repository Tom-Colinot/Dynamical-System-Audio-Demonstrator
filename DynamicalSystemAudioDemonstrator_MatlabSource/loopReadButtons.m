%% Read the user interface buttons
boolEuler = Eulerradiobutton.Value; boolRK4 = RK4radiobutton.Value; boolODE45 = ODE45radiobutton.Value;
boolLinearStiffness = linearstiffnessradiobutton.Value; boolCubicStiffness = cubicstiffnessradiobutton.Value;
boolNoiseFloor = noisebutton.Value;

if boolNoiseFloor % Add noise floor
    if norm(X) < eps
        X = 1e-4 * randn(size(X));
    end
end
