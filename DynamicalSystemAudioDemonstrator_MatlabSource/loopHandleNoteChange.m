%% Change the fundamental frequency
MIDInote = max([MIDInote,MIDInotemin]);% Clipping notes to range
MIDInote = min([MIDInote,MIDInotemax]);
inote = MIDInote-MIDInotemin+1; 
f0 = f0s(inote);
lastMIDInote = MIDInote;
