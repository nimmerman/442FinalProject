a = [3 4 0 0 0 0 0 0 1; 2 2 0 0 0 0 0 0 1; 
     0 0 5 6 0 0 0 0 1; 0 0 5 5 0 0 0 0 1;
     0 0 0 0 7 8 0 0 1; 0 0 0 0 7 7 0 0 1;
     0 0 0 0 0 0 9 9 1; 0 0 0 0 0 0 9 8 1;
     ]
 
b = a * 2.5;
b = b(:,1:end-1)

A = {a,b+1}
B = {b,b+1}
find_intensity(A,B,4,rand(50))

% x = 1:15;
% y = 3 * x.^3;
% im = zeros(15);
% im(eye(15) == 1) = y;
% 
% n = [-1 -1 1]; N = {n};
% p = [1 1]; P = {p};
% find_intensity(N,P,1,im);
% 