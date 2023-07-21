function f = midinote2freq(MIDInote,frefA4)
if nargin == 1
    frefA4 = 440;
end
Nsemitones = MIDInote - 69;
f = frefA4 * 2.^(Nsemitones/12);
end