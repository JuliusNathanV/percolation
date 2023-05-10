M = 50;
x = -M:M;
n = numel(x);
y = x;
[X,Y] = meshgrid(x,y);
p = 1/2;
squareColors = binornd(1,p,size(X));
figure
hold on
for i = 1:n
    for j = 1:n
        rectangle('Position',[x(i)-1/2,y(j)-1/2,1,1],'FaceColor',...
            [squareColors(i,j),squareColors(i,j),...
             1-squareColors(i,j)],'EdgeColor', 'none')
    end
end
xlim([-M-1/2,M+1/2])
ylim([-M-1/2,M+1/2])