%% Build a figure for choosing the MIDI input device
MIDInotes = MIDInotemin:MIDInotemax; f0s = midinote2freq(MIDInotes);

MIDIlist = mididevinfo;
inputnamescell = {MIDIlist.input.Name};
if ~isempty(inputnamescell)
    sourcechoicefig = uifigure('Position',[100 100 200 300],'Name','Real-time audio Van der Pol - MIDI Device');
    uilabel(sourcechoicefig,'Position',[20 270 160 20],'Text','Choose MIDI device','HorizontalAlignment','center','interpreter','latex');
    MIDIlistbox = uilistbox(sourcechoicefig,'Position',[20 80 160 180],'Items',inputnamescell);
    set(MIDIlistbox,'Value',inputnamescell(end));
    validatesourcebutton = uibutton(sourcechoicefig,'State','Text','OK','Position',[20 20 160 40]);    
    waitfor(validatesourcebutton,'Value')
    midicontroller = mididevice('Input',MIDIlistbox.Value);
    MIDIbuttonEnable = 1;
    delete(sourcechoicefig);
else
    MIDIbuttonEnable = 0;
end

%audiolist = audiodevinfo;
%audioinlist = {audiolist.output.Name};
%audiodevicedropdown = uidropdown(controlfig,'Position',[dxcontrol+margin/2 10.75*dl/4 dl-margin 0.1*dl],'Items',audioinlist,'ValueChangedFcn',@(src,event) (assignin('base','ADW',audioDeviceWriter('SampleRate',Fs,'BufferSize',Nbuf,'Device',src.Value))),'Value',audioinlist{end},'FontSize',18);
