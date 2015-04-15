function [a,b,c] = quadratic_coefs(p1,p2,p3)

x = [p1(1) p2(1) p3(1)];
y = [p1(2) p2(2) p3(2)];


M = ones(3,3);
M(1,1) = p1(1)^2;
M(2,1) = p2(1)^2;
M(3,1) = p3(1)^2;
M(1,2) = p1(1);
M(2,2) = p2(1);
M(3,2) = p3(1);

Y = [p1(2); p2(2); p3(2)];

temp = inv(M)*Y;
a = temp(1);
b = temp(2);
c = temp(3);



