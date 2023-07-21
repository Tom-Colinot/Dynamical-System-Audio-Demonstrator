%% Extract RMS value and fundamental frequency descriptors

rms_est = mean(sqrt(positions.^2 + speeds.^2));

if ~any(positions==0)
    
    dphi = diff(atan(speeds./positions));
    f0_est = -Fs/2/pi*mean(dphi(dphi<0));
%    f0_est = mean(instfreq(positions,Fs));
    if f0_est > 10
     [midinote,detune] = freq2midinote(f0_est);
     set(freqlabel,'Text',[num2str(f0_est,3) ' Hz']);
     set(midinotelabel,'Text',midinotename(midinote));
     set(detunelabel,'Text',num2str(round(detune),2));
    end
end

% izc = find(diff(sign(positions(1:end-1)))>0);%from - to + zero crossings
% if ~isempty(izc)
%     samplesBetweenZC = [samplesSinceLastZC+izc(1); diff(izc)];
%     for iizc = 1:length(samplesBetweenZC)
%         ibufzc = mod(ibufzc + 1 - 1,length(bufferOfSamplesBetweenZC)) + 1;
%         bufferOfSamplesBetweenZC(ibufzc) = samplesBetweenZC(iizc);
%     end
%     f0_est = Fs/mean(bufferOfSamplesBetweenZC);
%     iLastZC = izc(end);
%     samplesSinceLastZC = Nbuf - iLastZC;
%     % Display
% else
%     samplesSinceLastZC = samplesSinceLastZC + Nbuf;
% end

