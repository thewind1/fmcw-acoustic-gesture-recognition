% Author: Wentao Xie, Meng Zhou and Xiaotong Zhang
clear;
% close all;

%% --------------- Constants & configuration ------------------

Fs = 48000;
initFreqLeft = 17e3;
finlFreqLeft = 23e3;
initFreqRight = 23e3;
finlFreqRight = 17e3;
timeInterv = 0.02;

% -------------------------------------------------------------
%% --------------- A frame of chirp signal --------------------

t = 0:1/Fs:timeInterv;
chirpSliceLeft = chirp(t,initFreqLeft,timeInterv,finlFreqLeft); 
chirpSliceRight = chirp(t,initFreqRight,timeInterv,finlFreqRight);

% -------------------------------------------------------------
%% ----------------- Series of chirp sigs ---------------------

N = length(chirpSliceLeft) ;
H = hanning(N);
hanChirpLeft = chirpSliceLeft.*H';
hanChirpRight = chirpSliceRight.*H';

finChirpLeft = [];
finChirpRight = [];
for i=1:1000
    finChirpLeft = [finChirpLeft, hanChirpLeft, zeros(1, N)];
    finChirpRight = [finChirpRight, zeros(1, N), hanChirpRight];
end

% -------------------------------------------------------------
%% ---------------------- Write / read ------------------------

douTrackSig = [ finChirpLeft', finChirpRight' ];
audiowrite('dou.wav', douTrackSig, Fs);
