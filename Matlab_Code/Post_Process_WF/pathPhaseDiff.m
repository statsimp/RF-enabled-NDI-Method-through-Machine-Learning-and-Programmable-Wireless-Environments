function df = pathPhaseDiff(d, f)
%phaseDiff: is a funcion that calculates the phase difference over a
%distance "d" for an operating frequency "f".
% ==============Arguments=====================
%
%      - d: distance travelled (in meters)
%
%      - f: operating frequency (in Hz)
%
% ==============Return=======================
%
%    - df: phase difference over a distance (in radians)
%% phaseDiff

c = physconst("Lightspeed"); % speed of light
lambda = c/f;

df = 2*pi*(d/ lambda);% phase difference formula

end