function pl = FSPL(d, f)
%FSPL: is a funcion that calculates the free space path loss in dB, given a
%distance & an operating frequency.
% 
% ==============Arguments=====================
%
%      - d: distance travelled (in meters)aa
%
%      - f: operating frequency (in Hz)
%
% ==============Return=======================
%
%    - pl: path loss in dB
%% FSPL

%c = physconst("LightSpeed"); % speed of light
%pl = 20*log10(d) + 20*log10(f) + 20*log10((4*pi)/c); % free space path loss formula
pl = 20*log10(d) + 20*log10(f) -147.5522; % free space path loss formula

end