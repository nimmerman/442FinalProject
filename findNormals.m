function [ M ] = findNormals(parted_bounds, num_partitions, source_points)
%FINDNORMALS - This function finds the normals of points on a given
%boundary
%INPUT - parted_bounds
%        num_partitions
%        source_points: a cell array of 3*num_partitions x 2 matrix of points to use for
%        an estimate of each patch


for h = 1:length(parted_bounds)
    
    bound_h = parted_bounds{h};
    M = zeros(size(part,1),size(part,2)+1);

    for i = 1:num_partitions
        part = bound_h{i};
        points_i = source_points{i};
                
        p1 = points_i(3*i - 2);
        p2 = points_i(3*i - 1);
        p3 = points_i(3*i);
        
        x = [p1(1) p2(1) p3(1)];
        y = [p1(2) p2(2) p3(2)];
        
        [a,~,~] = polyfit(x,y,1);
        
        c_x = 2*i - 1;
        c_y = 2*i;
        %might need to convert to x and y first
        for j = 1:(size(M,1)/num_partitions)
            point = part(j,c_x:c_y);
            Nx = -2*a*point(1)/sqrt(1+4*a^2*point(1)^2);
            Ny = 1/sqrt(1+4*a^2*point(1)^2);
            
            M(j,c_x) = Nx;
            M(j,c_y) = Ny;
        end 
    end
end

M(:,end) = 1;
end
