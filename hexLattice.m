n = 20;
N = 2*n-1;
keepEdges = 0;
drawGreenLines = 0;
hexes = repmat(polyshape,N,N);
hexColours = binornd(1,0.5,N);
hexColours(1,:) = zeros(size(hexColours(:,1)));
hexColours(N,:) = ones(size(hexColours(:,N)));
hexColours(:,1) = [zeros(1, n) ones(1, N-n)];
hexColours(:,N) = [zeros(1,N-n) ones(1,n)];
extendedHexColours = [hexColours(:,1), hexColours, hexColours(:,N)];
figure
hold on
for i=1:N
    for j = 0:(N+1)
        hexCenter = [3*i-1.5*mod(j-1,2),sqrt(3)*(j-1)/2];
        hex = nsidedpoly(6, 'Center', ...
            hexCenter);
%         plot(hex, 'FaceColor', ...
%             [hexColours(i,max(min(j,N),1)),0,...
%             1-hexColours(i,max(min(j,N),1))])
        if keepEdges == 1
        plot(hex, 'FaceColor', ...
            [extendedHexColours(i,j+1),extendedHexColours(i,j+1),...
            1-extendedHexColours(i,j+1)])
%             'EdgeColor', 'none')
        else
        plot(hex, 'FaceColor', ...
            [extendedHexColours(i,j+1),extendedHexColours(i,j+1),...
            1-extendedHexColours(i,j+1)],'EdgeColor', 'none')
        end
%         plot(hexes(i))
%check interfaces upper left, directly above, upper right if they are
%different colours
        if j < N+1 && drawGreenLines ==1
            offset = mod(j-1,2);
            %upper left
            if i > 1
                if extendedHexColours(i,j+1)~=extendedHexColours(i-offset,j+2)
                    line([hexCenter(1)-1,hexCenter(1)-1/2],...
                        [hexCenter(2),hexCenter(2)+sqrt(3)/2],...
                        'Color','green','LineWidth',2)
                end
            end
            %upper right
            if i < N
                if extendedHexColours(i,j+1)~=extendedHexColours(i+1-offset,j+2)
                    line([hexCenter(1)+1,hexCenter(1)+1/2],...
                        [hexCenter(2),hexCenter(2)+sqrt(3)/2],...
                        'Color','green','LineWidth',2)
                end
            end
            %above
            if j < N
                if extendedHexColours(i,j+1)~=extendedHexColours(i,j+3)
                    line([hexCenter(1)-1/2,hexCenter(1)+1/2],...
                        [hexCenter(2)+sqrt(3)/2,hexCenter(2)+sqrt(3)/2],...
                        'Color','green','LineWidth',2)
                end
            end
        end
    end
end

%begin percolation exploration
%direction indicates the direction in which the 'explorer' is facing; 
%one of 6 directions. if the hexagon it is facing is blue (hexColour = 0)
%then the explorer turns right, i.e. add 1 to the direction mod 6.
%if the hexagon it is facing is red (hexColour = 1) then the explorer turns
%left, -1 to the direction mod 6.
%the explorer continues until it is facing the endpoint hexagon.
direction = 1;
facingHex = [n+1,2];
currentVertex = [3*n + 1, 0];
w = exp(2*pi*sqrt(-1)/6);
oldVertex = currentVertex-[real(w),imag(w)];
line([oldVertex(1),currentVertex(1)],...
    [oldVertex(2),currentVertex(2)],...
    'Color','black','LineWidth',2)
while facingHex(2) < N+2
    hexIndex = facingHex + [0,1];
    if extendedHexColours(hexIndex(1),hexIndex(2)) == 1
        %red is -1; turn left
        currentColour = -1;
    else
        %blue is 1; turn right
        currentColour = 1;
    end
    %parity of current vertex
    parity = mod(facingHex(2),2);
    if direction == 2 || direction == 5
        sgn = sign(direction-3);
        facingHex = [facingHex(1), ...
            facingHex(2) + 2*currentColour*sgn] ;
    elseif direction == 1 || direction == 0
        sgn = sign(direction - 0.5);
        facingHex = [facingHex(1) + parity + (currentColour - 1)/2,...
            facingHex(2)-currentColour*sgn];
    elseif direction == 3 || direction == 4
        sgn = sign(direction-3.5);
        facingHex = [facingHex(1) + parity - (currentColour + 1)/2,...
            facingHex(2) + currentColour*sgn];
    end
        
    direction = mod(direction + currentColour, 6);
    %move to new vertex
    directionVect = w^(2-direction);
    oldVertex = currentVertex;
    currentVertex = oldVertex + [real(directionVect),imag(directionVect)];
    line([oldVertex(1),currentVertex(1)],...
        [oldVertex(2),currentVertex(2)],...
        'Color','black','LineWidth',2)
end
