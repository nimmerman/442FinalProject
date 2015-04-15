function [ Norms, normals_alt ] = findNormals(parted_bounds, num_partitions, source_points, directional_points)
%FINDNORMALS - This function finds the normals of points on a given
%boundary
%INPUT - parted_bounds: 
%        num_partitions
%        source_points: a cell array of 3*num_partitions x 2 matrix of points to use for
%        an estimate of each patch
%        directiona_points: a num_boundaries x 2 array of points indicating
%        boundary concavity

Norms = cell(length(parted_bounds),1); % Cell Array of M's (from paper)
normals_alt = cell(length(parted_bounds),1);
for curr_bound = 1:length(parted_bounds)
    
    bound = parted_bounds{curr_bound};
    
    M = zeros(size(bound,1),size(bound,2)+1);
    points = source_points{curr_bound};
    normals = cell(num_partitions,1);
    for i = 1:num_partitions
        points_i = points((3*i - 2):3*i,:);

        p1 = points_i(1,:);
        p2 = points_i(2,:);
        p3 = points_i(3,:);
        directional_point = directional_points(curr_bound);
        
        [a,b,c] = quadratic_coefs(p1,p2,p3);
        
        X = [0:0.1:151];
        Y = a*X.^2 + b*X + c;
        
        %plot(X, Y, '-b');
        
        c_x = 2*i - 1;
        c_y = 2*i;
        size(bound,2)
        points_per_part = size(bound,1)/num_partitions;
        r0 = (i - 1)*points_per_part;
        
        part_normals = [];

            
            
        for j = 1:points_per_part

            
            point = bound(r0+j,c_x:c_y);
            m = -1.0/(2*a*point(1) + b);
            normal = [1 m]/norm([1 m]);
            
            normal_point = point + normal;
            reverse_normal_point = point - normal;
            if norm(normal_point - directional_point) <...
                norm(reverse_normal_point - directional_point)
                normal = -normal;
            end
            
            M(r0+j,c_x:c_y) = normal;

            part_normals = [part_normals; normal];
            
        end 
        normals{i} = part_normals;
    end
    M(:,end) = 1;
    Norms{curr_bound} = M;
    normals_alt{curr_bound} = normals;
end


end
