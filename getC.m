function [ C ] = getC(num_patches)
%GETC - this functions returns a matrix C as described in the paper
assert(num_patches > 2);
C = -1*eye(2*num_patches - 2,2*num_patches + 1);
ones = eye(size(C,1),size(C,2) - 2);
C(:,3:end) = C(:,3:end) + ones;

end