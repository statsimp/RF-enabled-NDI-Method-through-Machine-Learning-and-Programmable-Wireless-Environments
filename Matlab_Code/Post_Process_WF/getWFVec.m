function finalVec = getWFVec(data)

    freq = 12e9;
    finalVec = zeros(1,900*4);

    [rxPoints, ~, ~, ~]= getRXpointsTrain(30, 1.5);

    rx = cell(900,1);
    for i = 1:length(data)
        members = ismembertol( rxPoints', data{i}(4,:),"Byrows", 10^-4);
        idx = find(members);
        rx{idx} = [rx{idx}; data{i}];
    end

    rays = cell(900,1);
    for j = 1:900
        r = rx{j};
        rays{j} = cell(size(r,1)/4, 1);

        iter = 0;
        for k=1:size(r,1)/4
            rays{j}{k} = r(1+iter*4:(1+iter*4)+3, :);
            iter = iter+1;
        end

    end

    f1 = zeros(1, 900);
    f2 = zeros(1, 900);
    f3 = zeros(1,900);
    f4 = zeros(1,900);
    for j = 1:900
        num = size(rays{j}, 1);
        df = zeros(num,1);
        pl = zeros(num,1);
        doas = zeros(num,3);
        for l = 1:num
            d1 = norm(rays{j}{l}(2,:) - rays{j}{l}(1,:));
            d2 = norm(rays{j}{l}(3,:) - rays{j}{l}(2,:));
            d3 = norm(rays{j}{l}(4,:) - rays{j}{l}(3,:));
            d = d1+d2+d3;
            
            pl(l) = FSPL(d, freq);
            df(l) = pathPhaseDiff(d, freq);

            vecAoA = rays{j}{l}(4,:) - rays{j}{l}(3,:);
            %[az, el, ~] = cart2sph(vecAoA(1), vecAoA(2), vecAoA(3));
            doas(l, :) = vecAoA./norm(vecAoA);
        end
        

    end
    

end
    