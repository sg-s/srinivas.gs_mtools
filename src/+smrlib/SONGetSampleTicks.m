function[interval,start]=SONGetSampleTicks(fid,chan)
% Finds the sampling interval on a data channel in a SON file
% in clock ticks and returns the time of the first sample
%
% Malcolm Lidierth 02/02
% Updated 09/05 ML
% Copyright © The Author & King's College London 2002-2006


FileH=smrlib.SONFileHeader(fid);                                   % File header
Info=smrlib.SONChannelInfo(fid,chan);                              % Channel header
header=smrlib.SONGetBlockHeaders(fid,chan);                        % Disk block headers
switch Info.kind
    case {1,6,7,9}
        switch FileH.systemID
            case {1,2,3,4,5}                                                % Before version 6
                if (isfield(Info,'divide'))
                    interval=Info.divide*FileH.timePerADC;
                    start=header(2,1)*FileH.timePerADC;
                else
                    interval=[];
                    start=[];
                end
            otherwise                                                        % Version 6 and above
                interval=Info.lChanDvd;
                start=header(2,1);
        end;
    otherwise
        warning('smrlib.SONGetSampleTicks: Invalid channel type');
        return
end;

