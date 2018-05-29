rcvSig = pcmread("e2.pcm")';
[b, a] = butter(10, 16000/(Fs/2), 'high');
rcvFiltered = filtfilt(b, a, rcvSig);
[f, l] = xcorr(rcvFiltered, model);
[~, I] = max(f);
offset = l(I);
rcvChirp = rcvFiltered(offset+1+1 : offset+length(model)+1);
rcvLeft = [];
rcvRight = [];
for i = 1 : 1922 : length(rcvChirp)
    rcvLeft = [rcvLeft, rcvChirp(i : i+961-1)];
end
for i = 962 : 1922 : length(rcvChirp)
    rcvRight = [rcvRight, rcvChirp(i : i+961-1)];
end
deChirpLeft = rcvLeft .* modelLeft;
deChirpRight = rcvRight .* modelRight;
Left = {};
Right = {};
for i = 1 : length(hanChirpLeft) : length(finChirpLeft)
    if i+length(hanChirpLeft)-1 > length(deChirpLeft)
        break
    end
    fLeft = abs(fft(deChirpLeft(i : i+length(hanChirpLeft)-1), 8192*2));
    fRight = abs(fft(deChirpRight(i : i+length(hanChirpRight)-1), 8192*2));
%     subplot(2, 1, 1)
%     plot(fLeft(1:1000))
%     subplot(2, 1, 2)
%     plot(fRight(1:1000))
%     drawnow
    Left = [Left, fLeft(1:1000)];
    Right = [Right, fRight(1:1000)];
end

idxLeft = [];
idxRight = [];

for i = 1 : length(Left)-1
    dLeft = abs(Left{i+1} - Left{i});
    dRight = abs(Right{i+1} - Right{i});
    
%     subplot(2, 1, 1)
%     plot(dLeft)
%     subplot(2, 1, 2)
%     plot(dRight)
%     drawnow
    
%     [~, jLeft] = max(dLeft);
%     [~, jRight] = max(dRight);    
%     idxLeft = [idxLeft, jLeft];
%     idxRight = [idxRight, jRight];

    [pks, locs] = findpeaks(dLeft);
    [~, l] = max(pks);
    idxLeft = [idxLeft, locs(l)];
    [pks, locs] = findpeaks(dRight);
    [~, l] = max(pks);
    idxRight = [idxRight, locs(l)];

end

win = 50;
trackLeft = [];
trackRight = [];
for i = 1 : length(idxLeft)-win
    trackLeft = [trackLeft, sum(idxLeft(i : i+win-1))];
    trackRight = [trackRight, sum(idxRight(i : i+win-1))];
end
figure
plot(idxLeft)
hold on
plot(idxRight)
figure
plot(trackLeft)
hold on
plot(trackRight)