function genGraph(lenTile, widTile, recSide, rxDim)

%% ris-dimensions, initialize the space dimensions, height/ length/ width of the room and other variables,
% number of patches on the horizontal and vertical axis
% unit vectors in cartesian space
ex = [1 0 0];
ey = [0 1 0];
ez = [0 0 1];

len = lenTile;
wid = widTile;

hspacing = len/5;
vspacing = wid/5;
  
room_height = 3;
room_length = 8.5;
room_width = 5;


%%
[rxPoints, ~, ~, centRoom1Left]= getRXpointsTrain(rxDim, recSide);

room1BackBoundary = centRoom1Left(1) + recSide/2;
room1FrontBoundary = centRoom1Left(1) - recSide/2;
room1TopBoundary = centRoom1Left(3) + recSide/2;
room1BottomBoundary = centRoom1Left(3) - recSide/2;

%%

frontLen1 = abs(room_width/2 - room1BackBoundary);
frontLen2 = abs(room1FrontBoundary + room_width/2);
frontLen3 = abs(room1BackBoundary - room1FrontBoundary);
frontVer1 = abs(room_height - room1TopBoundary);
frontVer2 = room1BottomBoundary;


num_frontLen1 = fix(frontLen1/(len+hspacing));
num_frontLen1_rem = rem(frontLen1,(len+hspacing));

num_frontLen2 = fix(frontLen2/(len+hspacing));
num_frontLen2_rem = rem(frontLen2,(len+hspacing));

num_frontLen3 = fix(frontLen3/(len+hspacing));
num_frontLen3_rem = rem(frontLen3,(len+hspacing));

num_frontVer1 = fix(frontVer1/(wid+vspacing));
num_frontVer1_rem = rem(frontVer1,(wid+vspacing));

num_frontVer2 = fix(frontVer2/(wid+vspacing));
num_frontVer2_rem = rem(frontVer2,(wid+vspacing));


num_Hor_len = fix(room_length/(len+hspacing)); %number of patches on the horizontal axis ( "length room axis" )
num_len_rem = rem(room_length,(len+hspacing));
num_Hor_wid = fix(room_width/(len+hspacing)); %number of patches on the horizontal axis ( "width room axis" )
num_wid_rem = rem(room_width,(len+hspacing));
num_Ver = fix(room_height/(wid+vspacing)); %number of patches on the vertical axis
num_ver_rem = rem(room_height,(wid+vspacing));


% center point translators
ceilTrans = -ex*(num_wid_rem/2) - ey*(num_len_rem/2);
%
leftTrans = +ez*(num_ver_rem/2) - ey*(num_len_rem/2);
%
% leftTrans1 = +ez*(num_ver_rem/2) - ey*(num_leftLen1_rem/2);
% leftTrans2 = +ez*(num_leftVer2_rem/2) - ey*(num_leftLen3_rem/2);
% leftTrans3 = +ez*(num_leftVer1_rem/2) - ey*(num_leftLen3_rem/2);
% leftTrans4 = +ez*(num_ver_rem/2) - ey*(num_leftLen2_rem/2);
%
rightTrans = +ez*(num_ver_rem/2) - ey*(num_len_rem/2);
%
% rightTrans1 = +ez*(num_ver_rem/2) - ey*(num_rightLen1_rem/2);
% rightTrans2 = +ez*(num_rightVer2_rem/2) - ey*(num_rightLen3_rem/2);
% rightTrans3 = +ez*(num_rightVer1_rem/2) - ey*(num_rightLen3_rem/2);
% rightTrans4 = +ez*(num_ver_rem/2) - ey*(num_rightLen2_rem/2);
%
backTrans = -ex*(num_wid_rem/2) + ez*(num_ver_rem/2);
%
%frontTrans =  -ex*(num_wid_rem/2) + ez*(num_ver_rem/2);
frontTrans1 = +ez*(num_ver_rem/2) - ex*(num_frontLen1_rem/2);
frontTrans2 = +ez*(num_frontVer2_rem/2) - ex*(num_frontLen3_rem/2);
frontTrans3 = +ez*(num_frontVer1_rem/2) - ex*(num_frontLen3_rem/2);
frontTrans4 = +ez*(num_ver_rem/2) - ex*(num_frontLen2_rem/2);


% room1Trans = -ex*(num_wid_div_rem/2) + ez*(num_Ver_div_rem/2);
% room2Trans = -ex*(num_wid_div_rem/2) + ez*(num_Ver_div_rem/2);

%% tile centers
label = 1;

% creating the patches on the ceiling
p_Ceil = zeros(num_Hor_len*num_Hor_wid,4);
iter = 1;
for i =0:num_Hor_len-1
    for j = 0:num_Hor_wid-1
        p = [ room_width/2-(len/2+j*len+j*hspacing), room_length/2-(len/2+i*len+i*hspacing) , room_height] + ceilTrans;
        p_Ceil(iter,:) = [p, label];
        iter = iter+1;
        label=label+1;
    end
end

% creating the patches on the ceiling on the left
p_Left = zeros(num_Hor_len*num_Ver,4);
iter = 1;
for i =0:num_Hor_len-1
    for j = 0:num_Ver-1
        p = [-room_width/2 , room_length/2-(len/2+i*len+i*hspacing) , j*vspacing+j*wid+wid/2] + leftTrans; 
        p_Left(iter,:) = [p, label];
        iter = iter+1;
        label = label+1;
    end
end


% creating the patches on the right
p_Right = zeros(num_Hor_len*num_Ver,4);
iter = 1;
for i =0:num_Hor_len-1
    for j = 0:num_Ver-1
        p = [room_width/2 , room_length/2-(len/2+i*len+i*hspacing) , j*vspacing+j*wid+wid/2] + rightTrans; 
        p_Right(iter,:) = [p, label];
        iter = iter+1;
        label = label+1;
    end
end

% creating the patches on the back wall
p_Back = zeros(num_Hor_wid*num_Ver,4);
iter = 1;
for i =0:num_Hor_wid-1
    for j = 0:num_Ver-1
        p = [room_width/2-(len/2+i*len+i*hspacing), room_length/2 , j*vspacing+j*wid+wid/2] +backTrans;
        p_Back(iter,:) = [p, label];
        iter = iter+1;
        label = label+1;
    end
end

% creating the patches on the front
p_Front1 = zeros(num_frontLen1*num_Ver,4);
iter = 1;
for i =0:num_frontLen1-1
    for j = 0:num_Ver-1
        p = [room_width/2-(len/2+i*len+i*hspacing), -room_length/2 , j*vspacing+j*wid+wid/2] + frontTrans1;
        p_Front1(iter,:) = [p, label];
        iter = iter+1;
        label = label+1;
    end
end

% creating the patches on the front
p_Front2 = zeros(num_frontLen3*num_frontVer2,4);
iter = 1;
for i =0:num_frontLen3-1
    for j = 0:num_frontVer2-1
        p = [room1BackBoundary-(len/2+i*len+i*hspacing), -room_length/2 , j*vspacing+j*wid+wid/2] + frontTrans2;
        p_Front2(iter,:) = [p, label];
        iter = iter+1;
        label = label+1;
    end
end

% creating the patches on the front
p_Front3 = zeros(num_frontLen3*num_frontVer1,4);
iter = 1;
for i =0:num_frontLen3-1
    for j = 0:num_frontVer1-1
        p = [room1BackBoundary-(len/2+i*len+i*hspacing), -room_length/2 , j*vspacing+j*wid+wid/2 + room1TopBoundary] + frontTrans3;
        p_Front3(iter,:) = [p, label];
        iter = iter+1;
        label = label+1;
    end
end

% creating the patches on the front
p_Front4 = zeros(num_frontLen2*num_Ver,4);
iter = 1;
for i =0:num_frontLen2-1
    for j = 0:num_Ver-1
        p = [room1FrontBoundary-(len/2+i*len+i*hspacing), -room_length/2 , j*vspacing+j*wid+wid/2] + frontTrans4;
        p_Front4(iter,:) = [p, label];
        iter = iter+1;
        label = label+1;
    end
end
p_Front = [p_Front1; p_Front2; p_Front3; p_Front4];

rx = zeros(rxDim^2,4);
for i =1:rxDim^2
    rx(i,:) = [rxPoints(:,i)' label];
    label = label+1;
end


p_Front = [p_Front; rx];

patches = {p_Ceil, p_Left, p_Right, p_Back, p_Front};
G = genRISGraphTrain(patches);

savePath = ""; % enter the suitable savePath
save(savePath, "G");
end

