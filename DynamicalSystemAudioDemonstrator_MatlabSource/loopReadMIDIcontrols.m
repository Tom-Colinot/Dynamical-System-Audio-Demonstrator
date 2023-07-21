%% Read the MIDI messages
msgs = midireceive(midicontroller);
if ~isempty(msgs)
    msgsbytes = vertcat(msgs.MsgBytes);
    imsgCCmu = find((msgsbytes(:,1)==176)&(msgsbytes(:,2)==muCC),1,'last');% 176 : CC;
    if ~isempty(imsgCCmu)
        newCCmu = double(msgsbytes(imsgCCmu,3));
        mu = mumin + ((127-newCCmu)/127)*(mumax-mumin);
        sldminusmu.Value = -mu;
    end
    imsgCCsigma = find((msgsbytes(:,1)==176)&(msgsbytes(:,2)==sigmaCC),1,'last');% 176 : CC;
    if ~isempty(imsgCCsigma)
        newCCsigma = double(msgsbytes(imsgCCsigma,3));
        sigma = sigmamin + (newCCsigma/127)*(sigmamax-sigmamin);
        sldsigma.Value = sigma;
    end
    imsgNoteOn = find(msgsbytes(:,1)==144,1,'last'); %144 : NoteOn
    if ~isempty(imsgNoteOn)
        MIDInote = double(msgsbytes(imsgNoteOn,2));
        sldMIDInote.Value = min(max(MIDInote,MIDInotemin),MIDInotemax); % Respect slider bounds
    end
    imsgNoteOff = find(msgsbytes(:,1)==128,1,'last');
    if ~isempty(imsgNoteOff)
        % Do something on NoteOff
    end
    
end