%poisson process in a box of radius M
Mtrue = 40;
%simulate in box that's 10% bigger than true box to get rid of
%non-colouring artefacts
M = Mtrue*1.1;
%L is the rate of the poisson process
L = 1;
A = 4*M^2;

%N = # points in box
N = poissrnd(L*A);
%conditional on N, points are uniformly distributed in box
x = rand(N,2);
X = 2*M*x(:,1)-M;
Y = 2*M*x(:,2)-M;

figure
hold on
[v,c] = voronoin([X,Y]);
color = {'r','b'};
for i=1:length(c)
    fill(v(c{i},1),v(c{i},2),char(randsample(color,1)),...
        'LineStyle','none');
end
% voronoi(X,Y)
axis([-Mtrue Mtrue -Mtrue Mtrue])
