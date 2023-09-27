%plots an approximately square-looking bernoulli percolation lattice for
%parameters given by P. It couples them. Lattice is of size N.
N = 150;
keepEdges = 0;
hexes = repmat(polyshape,N,N);
hexColours = unifrnd(0,1,[floor(N/3), N+2]);

P = [0.45 0.5 0.55];

for k = 1:numel(P)
    p = P(k);
    extendedHexColours = (hexColours <= p);
    figure(k+1)
    clf
    hold on
    for i=1:floor(N/3)
        for j = 0:(N+1)
            hexCenter = [3*i-1.5*mod(j-1,2),sqrt(3)*(j-1)/2];
            hex = nsidedpoly(6, 'Center', ...
                hexCenter);
            if keepEdges == 1
            plot(hex, 'FaceColor', ...
                [extendedHexColours(i,j+1),extendedHexColours(i,j+1),...
                1-extendedHexColours(i,j+1)])
            else
            plot(hex, 'FaceColor', ...
                [extendedHexColours(i,j+1),extendedHexColours(i,j+1),...
                1-extendedHexColours(i,j+1)],'EdgeColor', 'none')
            end
        end
    end
    xlim([0,150])
    ylim([0,130])
    set(gca, 'Visible', 'off')
    axis square
end
