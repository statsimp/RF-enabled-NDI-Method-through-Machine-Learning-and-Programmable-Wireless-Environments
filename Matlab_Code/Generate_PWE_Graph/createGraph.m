
%ris = [0.3,0.4,0.5];
ris = [0.1];
rx = [10];

for i = 1:length(ris)
    for iter = 1:length(rx) 
        
        len = ris(i);
        wid = ris(i);
        recSide = 1.5;
        rxDim = rx(iter);

        genGraph(len, wid, recSide, rxDim);
    end
end
