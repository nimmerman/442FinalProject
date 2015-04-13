function [ intensitys ] = find_intensitys(Normals, Points, num_partitions, Im)
%   Input: Normals: is a cell array where each cell is a matrix that 
%          contains the normal vectors [Nx1  Ny1  0    0    1
%                                        0    0   Nx2  Ny2  1]
%          Points:   is a cell array where each cell is a matrix that 
%          contains the points          [Px1  Py1  0    0   
%                                        0    0   Px2  Py2 ]
%          Im: The Image1
    
% For every boundry there are normals and points   
assert(size(Normals,1) == size(Points,1));
intensitys = cell(1,numel(Normals));

for boundry = 1:length(Normals)
    currentPatchNormals = Normals{boundry};
    currentPatchPoints = Points{boundry};
    
    num_points_per_patch = size(currentPatchNormals,1) / num_partitions;
    counter = num_points_per_patch;

    curr_patch = 1;
    curr_col_idx = 1;
    for curr_row = 1:size(currentPatchNormals,1)
        if counter == 0
            counter = num_points_per_patch;
            curr_patch = curr_patch + 1;
            curr_col_idx = curr_patch * 2 - 1;
        end

        currentNormal = currentPatchNormals(curr_row, curr_col_idx:curr_col_idx + 1);
        currentPoint = currentPatchPoints(curr_row, curr_col_idx:curr_col_idx + 1);
        % [currentNormal currentPoint]
        occ_intensity = getIntensity(currentNormal, currentPoint, Im);
        intensitys{boundry} = [intensitys{boundry}; occ_intensity];
        counter = counter - 1;
    end
end
end

%% intensity: function description
function [ occ_intensity ] = getIntensity(N, P, Im)
occ_intensity = Im(round(P(2)), round(P(1)));

estimation = true;
if ~estimation
    return;
end

Nx = N(1);
Ny = N(2);
Px = P(1);
Py = P(2);

PofT = []; %log(p(ti))
xvalues = []; % [1 log(ti)]
for i = 1:15
    newPointy = Py - i * Ny;
    newPointx = Px - i * Nx;

    if ~inBounds(newPointx, newPointy, Im)
        break;
    end

    PofT = [PofT; log(Im(newPointy, newPointx))];
    xvalues = [xvalues; 1 log(i)];
end
% PofT
% xvalues
params = xvalues \ PofT;
Alpha = exp(params(1));
Beta = params(2);

small_number = .5;
occ_intensity = Alpha * small_number .^ Beta;

end


function [ bool ] = inBounds(pointx, pointy, Im)
    [h w] = size(Im);

    offX = pointx > w;
    offY = pointy > h;

    if pointx < 1 || pointy < 1 || offX || offY
        bool = false;
    else
        bool = true;
    end
end


