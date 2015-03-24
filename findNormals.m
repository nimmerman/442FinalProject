function [ Norms ] = findNormals(parted_bounds, num_partitions, source_points)
%FINDNORMALS - This function finds the normals of points on a given
%boundary
%INPUT - parted_bounds
%        num_partitions
%        source_points: a cell array of 3*num_partitions x 2 matrix of points to use for
%        an estimate of each patch

Norms = cell(length(parted_bounds),1);
for h = 1:length(parted_bounds)
    
    bound_h = parted_bounds{h};
    
    M = zeros(size(bound_h,1),size(bound_h,2)+1);
    if source_points
        points = source_points{h};
    else
        points = 0; %for testing
    end
    for i = 1:num_partitions
        if (points)
            points_i = points((3*i - 2):3*i);
        else
            points_i = [4 2 1; 1 4 2]'; %for testing
        end
        p1 = points_i(1,:);
        p2 = points_i(2,:);
        p3 = points_i(3,:);
        
        x = [p1(1) p2(1) p3(1)];
        y = [p1(2) p2(2) p3(2)];
        
        [coefs,~,~] = polyfit(x,y,2);
        a = coefs(1);
        c_x = 2*i - 1;
        c_y = 2*i;
        size(bound_h,2)
        points_per_part = size(bound_h,1)/num_partitions;
        r0 = (i - 1)*points_per_part;
        

        %might need to convert to x and y first
        for j = 1:points_per_part
            point = bound_h(j,c_x:c_y);
            Nx = -2*a*point(1)/sqrt(1+4*a^2*point(1)^2);
            Ny = sqrt(1 - Nx^2);
            M(r0+j,c_x) = Nx;
            M(r0+j,c_y) = Ny;
        end 
    end
    M(:,end) = 1;
    Norms{h} = M;
    
end


end
