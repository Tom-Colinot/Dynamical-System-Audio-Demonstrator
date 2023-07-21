inotechange = 1+find(diff(recordedVariables.f0)); notenamechange = freq2midinote(recordedVariables.f0([1 inotechange]));

tEulerOn = recordedVariables.t(find(diff([0 recordedVariables.boolEuler])>0));
tRK4On = recordedVariables.t(find(diff([0 recordedVariables.boolRK4])>0));
tODE45On = recordedVariables.t(find(diff([0 recordedVariables.boolODE45])>0));

tLinearOn = recordedVariables.t(find(diff([0 recordedVariables.boolLinearStiffness])>0));
tCubicOn = recordedVariables.t(find(diff([0 recordedVariables.boolCubicStiffness])>0));

tNoiseFloorOn = recordedVariables.t(find(diff([recordedVariables.boolNoiseFloor])>0));
tNoiseFloorOff = recordedVariables.t(find(diff([recordedVariables.boolNoiseFloor])<0));
%
a1 = subplot(411);
plot(recordedVariables.t,recordedVariables.RMS,'k'); ylabel('RMS'); ylim([0 Xmax]); grid on;
hold on;
plot(tLinearOn.*[1; 1],ones(size(tLinearOn)).*[0; Xmax],'g','linewidth',1)
text(tLinearOn,ones(size(tLinearOn)).*0.01*Xmax,'$\alpha = 1$','Rotation',90,'HorizontalAlignment','left','VerticalAlignment','top','interpreter','latex','color',[0 0.7 0])
plot(tCubicOn.*[1; 1],ones(size(tCubicOn)).*[0; Xmax],'g','linewidth',1)
text(tCubicOn,ones(size(tCubicOn)).*0.01*Xmax,'$\alpha = 3$','Rotation',90,'HorizontalAlignment','left','VerticalAlignment','top','interpreter','latex','color',[0 0.7 0])
plot(tEulerOn.*[1; 1],ones(size(tEulerOn)).*[0; Xmax],'b','linewidth',1)
text(tEulerOn,ones(size(tEulerOn)).*0.99*Xmax,'Euler','Rotation',90,'HorizontalAlignment','right','VerticalAlignment','top','interpreter','latex','color',[0 0 0.7])
plot(tRK4On.*[1; 1],ones(size(tRK4On)).*[0; Xmax],'b','linewidth',1)
text(tRK4On,ones(size(tRK4On)).*0.99*Xmax,'RK4','Rotation',90,'HorizontalAlignment','right','VerticalAlignment','top','interpreter','latex','color',[0 0 0.7])
plot(tODE45On.*[1; 1],ones(size(tODE45On)).*[0;Xmax],'b','linewidth',1)
text(tODE45On,ones(size(tODE45On)).*0.99*Xmax,'ODE45','Rotation',90,'HorizontalAlignment','right','VerticalAlignment','top','interpreter','latex','color',[0 0 0.7])
plot(tNoiseFloorOn.*[1; 1],ones(size(tNoiseFloorOn)).*[0;Xmax],'r','linewidth',1)
text(tNoiseFloorOn,ones(size(tNoiseFloorOn)).*0.5*Xmax,'Noise on','Rotation',0,'HorizontalAlignment','left','VerticalAlignment','middle','interpreter','latex','color',[0.7 0 0])
plot(tNoiseFloorOff.*[1; 1],ones(size(tNoiseFloorOff)).*[0;Xmax],'r','linewidth',1)
text(tNoiseFloorOff,ones(size(tNoiseFloorOff)).*0.5*Xmax,'Noise off','Rotation',0,'HorizontalAlignment','left','VerticalAlignment','middle','interpreter','latex','color',[0.7 0 0])
a2 = subplot(412);
hf0 = plot(recordedVariables.t,recordedVariables.f0,'k'); hold on;
f0_est_plt = recordedVariables.f0_est;
f0_est_plt(recordedVariables.RMS<1e-3) = NaN;
yf0eventline = [min(f0_est_plt) ; max(f0_est_plt)];
hf0_est = plot(recordedVariables.t,f0_est_plt,'r'); ylabel('Frequency');grid on;
plot(tLinearOn(:).'.*[1; 1],ones(size(tLinearOn)).*yf0eventline,'g','linewidth',1)
plot(tCubicOn(:).'.*[1; 1],ones(size(tCubicOn)).*yf0eventline,'g','linewidth',1)
plot(tEulerOn(:).'.*[1; 1],ones(size(tEulerOn)).*yf0eventline,'b','linewidth',1)
plot(tRK4On(:).'.*[1; 1],ones(size(tRK4On)).*yf0eventline,'b','linewidth',1)
plot(tODE45On(:).'.*[1; 1],ones(size(tODE45On)).*yf0eventline,'b','linewidth',1)
legend([hf0 hf0_est],'Expected','Estimate','Location','best')
a3 = subplot(413);
plot(recordedVariables.t,recordedVariables.sigma,'k'); ylabel('$\sigma$'); ylim([sigmamin sigmamax]);grid on;
hold on;
plot(tLinearOn(:).'.*[1; 1],ones(size(tLinearOn(:).')).*[sigmamin ; sigmamax],'g','linewidth',1)
plot(tCubicOn(:).'.*[1; 1],ones(size(tCubicOn(:).')).*[sigmamin ; sigmamax],'g','linewidth',1)
plot(tEulerOn(:).'.*[1; 1],ones(size(tEulerOn(:).')).*[sigmamin ; sigmamax],'b','linewidth',1)
plot(tRK4On(:).'.*[1; 1],ones(size(tRK4On(:).')).*[sigmamin ; sigmamax],'b','linewidth',1)
plot(tODE45On(:).'.*[1; 1],ones(size(tODE45On(:).')).*[sigmamin ; sigmamax],'b','linewidth',1)
a4 = subplot(414);
plot(recordedVariables.t,recordedVariables.mu,'k'); ylabel('$\mu$'); ylim([mumin mumax]);grid on;
hold on;
plot(tLinearOn(:).'.*[1; 1],ones(size(tLinearOn(:).')).*[mumin ; mumax],'g','linewidth',1)
plot(tCubicOn(:).'.*[1; 1],ones(size(tCubicOn(:).')).*[mumin ; mumax],'g','linewidth',1)
plot(tEulerOn(:).'.*[1; 1],ones(size(tEulerOn(:).')).*[mumin ; mumax],'b','linewidth',1)
plot(tRK4On(:).'.*[1; 1],ones(size(tRK4On(:).')).*[mumin ; mumax],'b','linewidth',1)
plot(tODE45On(:).'.*[1; 1],ones(size(tODE45On(:).')).*[mumin ; mumax],'b','linewidth',1)

linkaxes([a1 a2 a3 a4],'x')