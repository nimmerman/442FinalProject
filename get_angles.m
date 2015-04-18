images = dir('Test_Images/*.JPG');
%South of West
for image = images'
imshow(image.name);

a = impoint(); %center of the cardboard
b = impoint(); %along the light direction
[a_pos] = a.getPosition();
[b_pos] = b.getPosition();

x_coords = [a_pos(1) b_pos(1)];
y_coords = [a_pos(2) b_pos(2)];

[P,~] = polyfit(x_coords, y_coords,1);

x_trans = a_pos(1) - b_pos(1);

adj = x_trans;
hyp = norm(a_pos - b_pos);
degrees = acosd(adj/hyp);
fprintf('%s: %f degrees\n',image.name, degrees);
delete(a);
delete(b);
pause(3);
hold off
end

