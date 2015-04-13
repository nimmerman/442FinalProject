function [ parted_bounds,partitions_alt ] = partitionBoundaries(boundaries, num_partitions)
%PARTITIONBOUNDARIES - 
%   REQUIRES that each boundary has at least num_partition points
%   This function takes as input a set of occluding boundaries of an image
%   and splits into num_partitions partitions each with an equal number of
%   points as closely as possible
%       INPUT - 
%               boundaries: a cell array of boundary points for each
%               boundary. each cell contains a n x 2 array of points 
%               (row major order) corrsponding to the location of each of
%               the n given points in im
%       OUTPUT - cell array of (array of points) for each boundary
%

num_boundaries = length(boundaries);
parted_bounds = cell(num_boundaries,1);
partitions_alt = cell(num_boundaries,1);

for i = 1:num_boundaries
    bound = boundaries{i};
    n = length(bound) - mod(length(bound),num_partitions);
    p = n/num_partitions;
    B = zeros(n,2*p);
    partitions = cell(num_partitions,1);
    for j = 1:num_partitions
        r0 = (j - 1)*p + 1;
        r1 = r0 + p - 1;
        c0 = 2*j - 1;
        c1 = c0 + 1;
        B(r0:r1,c0:c1) = bound(r0:r1,:);
        partitions{j} = bound(r0:r1,:);
        
    end
    parted_bounds{i} = B;
    partitions_alt{i} = partitions;
end
end

