function name = midinotename(MIDInote,zeroifflats_oneifsharps)
if nargin<2
    zeroifflats_oneifsharps = 0;
end
Nsemitones = MIDInote - 12;% From C0
ichroma = mod(Nsemitones,12)+1;
ioctave = floor(Nsemitones/12);
if zeroifflats_oneifsharps
    nameschroma = {'C','C#','D','D#','E','F','F#','G','G#','A','A#','B'};
else
    nameschroma = {'C','Db','D','Eb','E','F','Gb','G','Ab','A','Bb','B'};
end
name = [nameschroma{ichroma} int2str(ioctave)];

end