%% Build the user interface
% Size parameters
dl = 250;margin = 40;dxcontrol = 2*dl;
% Figure
controlfig = uifigure('Number',777); controlfig.Position = [10 50 3*dl 3*dl]; controlfig.Name = 'Real-time audio Van der Pol'; 

% Bifurcation diagram background (analytical surface and bifurcation locus)
sigmas = sigmamin:0.025:sigmamax; mus = mumin:0.025:mumax;
muf1nc = sigmas.^2/(4*nu0) .* (sigmas<0); mus = sort([mus muf1nc-1e-25]);
Xmax = sqrt( - sigmamin + sqrt(sigmamin.^2 - 4*mumin*nu0)./(2*nu0) );
Xs = 0:0.01:Xmax;
munc = -nu0*Xs.^4 - sigmas.'.*Xs.^2;
munc0 = -nu0*Xs.^4 - sigma.*Xs.^2;
XncF = real( sqrt( - sigmas - sqrt(sigmas.^2 - 4*muf1nc*nu0)./(2*nu0) ) );
muf0 = sigma^2/(4*nu0);
Xf0 = sqrt(- sigma - sqrt(sigma.^2 - 4*muf0*nu0)./(2*nu0) );
[Xsg,sg] = meshgrid(Xs,sigmas);
sp3 = [sigmamax 0 -0.5 sigmamin]; ip3 = [];
for isp3 = 1:length(sp3)
    ip3 = [ip3 find(sigmas==sp3(isp3))];
end

BDax = uiaxes(controlfig,'Position',[margin/2 dl 2*dl-margin 2*dl-margin],'NextPlot','add','Interactions',[],'HitTest','off');
mesh(BDax,munc,sg,Xsg,'facecolor','b','edgecolor','none','facealpha',0.4);
plot3(BDax,munc(ip3,:).',sg(ip3,:).',Xsg(ip3,:).','color','b','linewidth',1);
plot3(BDax,muf1nc,sigmas,zeros(size(sigmas))-2e-2,'k','linewidth',2);
plot3(BDax,muf1nc,sigmas,XncF,'color','k','linewidth',2);
hBDCurrentPoint = plot3(BDax,NaN,NaN,NaN,'Marker','o','color','r','MarkerFaceColor','r');
hBDPastPoints = animatedline(BDax,NaN,NaN,NaN,'Marker','none','color','r','MaximumNumPoints',250);
axis(BDax,[mumin mumax sigmamin sigmamax  -0.05 1.5 ]);
view(BDax,[150   30]);
BDax.XLabel.String = '$\mu$'; BDax.XLabel.FontSize = 18; BDax.XGrid = 'on'; BDax.XTick = mumin:0.1:mumax; BDax.XTickLabel(~~mod(10*BDax.XTick,5)) = {''};BDax.XLabel.Interpreter = 'latex'; 
BDax.YLabel.String = '$\sigma$';  BDax.YLabel.FontSize = 18; BDax.YGrid = 'on'; BDax.YTick = sigmamin:0.1:sigmamax; BDax.YTickLabel(~~mod(10*BDax.YTick,5)) = {''};BDax.YLabel.Interpreter = 'latex'; 
BDax.ZLabel.String = 'Amplitude'; BDax.ZLabel.FontSize = 18; BDax.ZGrid = 'on'; BDax.ZTick = 0:0.1:2; BDax.ZTickLabel(~~mod(10*BDax.ZTick,5)) = {''};
BDax.Title.String = '$\ddot{x} + (\mu + \sigma(\dot{x}^2 + x^2) + \nu(\dot{x}^2 + x^2)^2)\dot{x} + x^\alpha = 0$';BDax.Title.Interpreter = 'latex'; BDax.Title.FontSize = 18;

% Sliders
sldsigma = uislider(controlfig,'Limits',[sigmamin sigmamax],'Position',[margin 0.83*dl dxcontrol-4*margin 3],'Value',sigma,'MajorTicks',sigmamin:0.1:sigmamax,'ValueChangingFcn',@(sld,event) (assignin('base','sigma',event.Value)));
uilabel(controlfig,'Position',[margin/4 0.83*dl-10 margin/2 20],'Text','$\sigma$','interpreter','latex','FontSize',18);
sigmaCClistbox = uidropdown(controlfig,'Position',[margin+dxcontrol-3.5*margin 0.83*dl-0.06*dl 1.8*margin 0.1*dl],'Items',arrayfun(@(n) ['CC' int2str(n)],1:16,'UniformOutput',false),'ItemsData',1:16,'ValueChangedFcn',@(src,event) (assignin('base','sigmaCC',src.Value)),'Value',sigmaCC,'FontSize',18);

sldminusmu = uislider(controlfig,'Limits',[mumin mumax],'Position',[margin 0.67*dl dxcontrol-4*margin 3],'Value',mu,'MajorTicks',mumin:0.1:mumax,'MajorTickLabels', arrayfun(@num2str,mumax:-0.1:mumin,'UniformOutput',false),'ValueChangingFcn',@(sld,event) (assignin('base','mu',-event.Value)),'Interruptible','off');
uilabel(controlfig,'Position',[margin/4 0.67*dl-10 margin/2 20],'Text','$\mu$','interpreter','latex','FontSize',18);
muCClistbox = uidropdown(controlfig,'Position',[margin+dxcontrol-3.5*margin 0.67*dl-0.06*dl 1.8*margin 0.1*dl],'Items',arrayfun(@(n) ['CC' int2str(n)],1:16,'UniformOutput',false),'ItemsData',1:16,'ValueChangedFcn',@(src,event) (assignin('base','muCC',src.Value)),'Value',muCC,'FontSize',18);

sldMIDInote = uislider(controlfig,'Limits',[MIDInotemin MIDInotemax],'Position',[margin dl*0.5 dxcontrol-2*margin 3],'Value',MIDInote0,'MajorTicks',[],'MinorTicks',MIDInotemin:1:MIDInotemax);
uilabel(controlfig,'Position',[margin/4 dl*0.5-10 margin/2 20],'Text','$f_0$','interpreter','latex','FontSize',18);

% Piano keyboard
MIDInotenames = arrayfun(@(c) midinotename(c,1),MIDInotes,'UniformOutput',false);
inaturals = cellfun(@(c) ~any(c=='#'),MIDInotenames);
imgax = uiaxes(controlfig,'Position',sldMIDInote.Position + [-10 -dl/4 20 dl/4],'xlabel',[],'ylabel',[],'NextPlot','Add','xlim',[MIDInotemin MIDInotemax+1],'ylim',[0 1],'xtick',[],'ytick',[],'Interactions',[],'HitTest','off');
plot(imgax,MIDInotemin-1+[1;1].*find(inaturals&circshift(inaturals,1)),[0;1].*ones(size(find(inaturals&circshift(inaturals,1)))),'k','linewidth',1);
plot(imgax,MIDInotemin-1+[1;1].*find(~inaturals)+0.5,[0.5;1].*ones(size(find(~inaturals))),'k','linewidth',8);
plot(imgax,MIDInotemin-1+[1;1].*find(~inaturals)+0.5,[0;0.5].*ones(size(find(~inaturals))),'k','linewidth',1);

% Frequency estimate
uilabel(controlfig,'Position',[margin margin 3*dl/4 20],'Text','Estimated frequency: ','interpreter','latex','FontSize',18);
freqlabel = uilabel(controlfig,'Position',[margin+3*dl/4 margin dl/3 20],'Text','- - - Hz','interpreter','latex','FontSize',18);
midinotelabel =  uilabel(controlfig,'Position',[margin+7*dl/6 margin dl/6 20],'Text','?#?','interpreter','latex','FontSize',18);
detunelabel =  uilabel(controlfig,'Position',[margin+8*dl/6 margin 50 20],'Text','$\pm$xx','interpreter','latex','FontSize',18);
uilabel(controlfig,'Position',[margin+8*dl/6+50 margin dl/2-60 20],'Text','cents','interpreter','latex','FontSize',18);

% Buttons

integrationmethodbuttongroup = uibuttongroup(controlfig,'Position',[dxcontrol+margin/2 9*dl/4 dl-margin margin*4],'Title','Integration method','FontSize',18);
Eulerradiobutton = uiradiobutton(integrationmethodbuttongroup,'Position',[margin/2 margin/2 dl-margin margin/2],'Text',' Explicit Euler','FontSize',18,'Value',0);
RK4radiobutton = uiradiobutton(integrationmethodbuttongroup,'Position',[margin/2 margin/2+margin dl-margin margin/2],'Text',' Runge-Kutta','FontSize',18,'Value',1);
ODE45radiobutton = uiradiobutton(integrationmethodbuttongroup,'Position',[margin/2 margin/2+2*margin dl-margin margin/2],'Text',' ODE45','FontSize',18,'Value',0);

stiffnessbuttongroup = uibuttongroup(controlfig,'Position',[dxcontrol+margin/2 7*dl/4-margin/2 dl-margin margin*2.5]);
uilabel(controlfig,'Text','Stiffness','Interpreter','latex','Position',[stiffnessbuttongroup.Position(1) stiffnessbuttongroup.Position(2)+stiffnessbuttongroup.Position(4) stiffnessbuttongroup.Position(3) 20],'FontSize',18);
linearstiffnessradiobutton = uiradiobutton(stiffnessbuttongroup,'Position',[margin/2 margin/2 dl-margin margin/2],'Text','','Value',1); 
uilabel(stiffnessbuttongroup,'Text','Linear ($\alpha = 1$)','Interpreter','latex','FontSize',18,'Position',linearstiffnessradiobutton.Position + [17 0 0 0]);
cubicstiffnessradiobutton = uiradiobutton(stiffnessbuttongroup,'Position',[margin/2 margin/2+margin dl-margin margin/2],'Text','','Value',0);
uilabel(stiffnessbuttongroup,'Text','Cubic ($\alpha = 3$)','Interpreter','latex','FontSize',18,'Position',cubicstiffnessradiobutton.Position + [17 0 0 0]);

noisebutton = uibutton(controlfig,'state','Position',[dxcontrol+margin/2 5*dl/4+margin/2 dl-margin 2*dl/5-margin],'Text','Add noise floor','FontSize',18,'Value',1);
MIDIbutton = uibutton(controlfig,'state','Position',[dxcontrol+margin/2 3.5*dl/4+margin/2 dl-margin 2*dl/5-margin],'Text','Enable MIDI controls','FontSize',18,'Value',0,'Enable',MIDIbuttonEnable);
recordbutton = uibutton(controlfig,'state','Position',[dxcontrol+margin/2 2*dl/4+margin/2 dl-margin dl/2.5-margin],'Text','Start/stop recording','FontSize',18,'Value',0);
stopbutton = uibutton(controlfig,'state','Position',[dxcontrol+margin/2 0.5*dl/4+margin/2 dl-margin dl/2.5-margin],'Text','Stop and exit','FontSize',18,'Value',0);

drawnow;


figcol = [1 1 1];
set(controlfig,'Color',figcol);
objcol = 1*[1 1 1];
for ichild = 1:length(controlfig.Children)
    child = controlfig.Children(ichild);
    if isprop(child,'Color')
        set(child,'Color',objcol)
    elseif isprop(child,'BackgroundColor')
        set(child,'BackgroundColor',objcol)
    end
end

