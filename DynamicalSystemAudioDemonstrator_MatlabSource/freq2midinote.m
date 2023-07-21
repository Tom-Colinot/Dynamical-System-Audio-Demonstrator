function [MIDInote,centsfrom12TETMIDInote] = freq2midinote(f,frefA4)
if nargin == 1
    frefA4 = 440;
end
Ncents= cents(f,frefA4);
Nsemitones = round(Ncents/100);
MIDInote = 69+Nsemitones; % A4 is MIDInote 69
centsfrom12TETMIDInote = Ncents - 100*Nsemitones;

end