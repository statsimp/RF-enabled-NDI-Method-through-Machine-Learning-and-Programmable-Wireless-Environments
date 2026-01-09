%% This is the main script for generating a PWE graph based on some RIS dimensions and rx dimensions

ris = [0.5];
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

