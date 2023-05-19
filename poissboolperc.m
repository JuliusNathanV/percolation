xlim = 10;
N = poissrnd((2*xlim)^2,1);
x = zeros([N,2]);
R = zeros([N,1]);
%radii are exp lambda random variables
lambda = 1/0.4;
mu = 1/lambda;
figure
hold on
for i = 1:N
    x(i,:) = unifrnd(-xlim,xlim,[1,2]);
    R(i) = exprnd(mu);
    x1 = x(i,1);
    y1 = x(i,2);
    r = R(i); 
    rectangle('Position',[x1-r,y1-r,2*r,2*r],'Curvature',[1,1], 'FaceColor', 'red',...
        'EdgeColor','none');
end
% figure
% viscircles(x,R);