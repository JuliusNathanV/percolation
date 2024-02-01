%in this we use the local exploration process algorithm to explore all
%intefaces of clusters touching the boundary when our boundary conditions
%are not fixed. we start an exploration process from each boundary point,
%unless the boundary point has already been visited (which will only happen
%if an explored interface has exited from that boundary point). 
%we only need to start exploration processes from boundary points where
%there is a yellow on the left and a blue on the right. these are in
%one-to-one correspondence with boundary points with a yellow on the right
%blue on the left, and each interface will start at a yellow-blue and end
%on a blue-yellow.
drawHexagons = 0;

%percolation probability. critical is p=1/2
p=1/2;

%rectangle width w (#cols) and height h (#rows)
w = 300;
h = 300; 

figure
axis off
hold on
%define the master hexagon
hex0 = rotate(nsidedpoly(6,'SideLength',1/sqrt(3)),360/12);

%define the percolation configuration. if the configuration colour == 2
%then the site hasn't been explored yet.
config = 2*ones([h,w]);

%random boundary conditions
config(1,:) = binornd(1,p,[1,w]);
config(h,:) = binornd(1,p,[1,w]);
config(:,1) = binornd(1,p,[h,1]);
config(:,w) = binornd(1,p,[h,1]);

%draw boundary vertices
%top and bottom
for j = 1:w
    hex = translate(hex0,[real(j+1*exp(1i*pi()/3)),...
        imag(j+1*exp(1i*pi()/3))]);
    plot(hex,'FaceColor', ...
        [config(1,j), config(1,j), 1-config(1,j)])
    hex = translate(hex0,[real(j+h*exp(1i*pi()/3)),...
        imag(j+h*exp(1i*pi()/3))]);
    plot(hex,'FaceColor', ...
        [config(h,j), config(h,j), 1-config(h,j)])
end
%left and right
for i = 2:(h-1)
    hex = translate(hex0,[real(1+i*exp(1i*pi()/3)),...
        imag(1+i*exp(1i*pi()/3))]);
    plot(hex,'FaceColor', ...
        [config(i,1), config(i,1), 1-config(i,1)])
    hex = translate(hex0,[real(w+i*exp(1i*pi()/3)),...
        imag(w+i*exp(1i*pi()/3))]);
    plot(hex,'FaceColor', ...
        [config(i,w), config(i,w), 1-config(i,w)])
end

%go through all of the bottom row pairs of adjacent vertices. if the left
%is yellow and the right is blue, then start an exploration process from
%that pair of points.
for left = 1:w-1
    %bottom row
    if config(1,left)==1 && config(1,left+1)==0
        yellowLeft = [1,left];
        blueRight = [1,left+1];
        config = exploration(yellowLeft,blueRight,config,w,h,p,drawHexagons);
    end
    %top row
    if config(h,w+1-left) == 1 && config(h,w-left)==0
        yellowLeft = [h,w+1-left];
        blueRight = [h,w-left];
        config = exploration(yellowLeft,blueRight,config,w,h,p,drawHexagons);
    end
end
for up = 1:h-1
    %left side
    if config(up+1,1) == 1 && config(up,1) == 0
        yellowLeft = [up+1,1];
        blueRight = [up,1];
        config = exploration(yellowLeft,blueRight,config,w,h,p,drawHexagons);
    end
    %right side
    if config(h-up,w) == 1 && config(h+1-up,w) == 0
        yellowLeft = [h-up,w];
        blueRight = [h+1-up,w];
        config = exploration(yellowLeft,blueRight,config,w,h,p,drawHexagons);
    end
end

function [newConfig] = exploration(yellowLeft,blueRight,config,w,h,p,drawHexagons)
    %given a configuration config and boundary points yellowLeft and
    %blueRight in complex form, performs an exploration process on the
    %configuration, revealing unrevealed vertices, until the path exits the
    %boundary. returns an update to the new configuration.
    %yellowLeft and blueRight are in coordinate form (height,width).

    %master hexagon
    hex0 = rotate(nsidedpoly(6,'SideLength',1/sqrt(3)),360/12);

        %start an exploration process.
        %keep track of the boundary of two vertices you're on. start between (1,1)
        %and (1,2). yellow on left and blue on right. 
        %row vertex so multiply on the right
        yellow = yellowLeft(2)+yellowLeft(1)*exp(1i*pi()/3);
        blue = blueRight(2)+blueRight(1)*exp(1i*pi()/3);
        displacement = blue-yellow;
        facing = yellow + displacement*exp(1i*pi()/3);
        
        yellowVertex = [round(2*imag(yellow)/sqrt(3)),...
            round(real(yellow)-imag(yellow)/sqrt(3))];
        blueVertex = [round(2*imag(blue)/sqrt(3)),...
            round(real(blue)-imag(blue)/sqrt(3))];
        facingVertex =[round(2*imag(facing)/sqrt(3)),...
            round(real(facing)-imag(facing)/sqrt(3))];
        
        
        % displacement = blueVertex - yellowVertex;
        % facingVertex = yellowVertex + displacement*[-1,1;1,0];
        
        % yellow = yellowVertex(1)+exp(1i*pi()/3)*yellowVertex(2);
        % blue = blueVertex(1)+exp(1i*pi()/3)*blueVertex(2);
        % facingCoord = facingVertex(1)+exp(1i*pi()/3)*facingVertex(2);
        % displacement = blue - yellow;
        
        %explore until facing vertex is outside of lattice
        while facingVertex(1) >= 1 && facingVertex(1) <= h && ...
                facingVertex(2) >= 1 && facingVertex(2) <= w
        %if facing vertex colour is undiscovered i.e. then discover it. then colour
        %it in.
            if config(facingVertex(1),facingVertex(2)) == 2
                config(facingVertex(1),facingVertex(2)) = binornd(1,p);
                %colour it in
                if drawHexagons == 1
                    color = config(facingVertex(1),facingVertex(2)) ;
                    hexCenterCoords = [real(facing),imag(facing)];
                    hex = translate(hex0,hexCenterCoords);
                    plot(hex,'FaceColor', ...
                        [color, color, 1-color])
                end
            end
            %walk along the interface (draw the line segment between the currently
            %occupied vertices.
        % line([oldVertex(1),currentVertex(1)],...
        %     [oldVertex(2),currentVertex(2)],...
        %     'Color','black','LineWidth',1)
            lineStart = yellow + displacement*(1+1i*(1/sqrt(3)))/2;
            lineEnd = yellow + displacement*(1-1i*(1/sqrt(3)))/2;
            line([real(lineStart),real(lineEnd)],...
                [imag(lineStart),imag(lineEnd)],...
                'Color','red','LineWidth',2);
        
            %then change the currently occupied yellow/blue vertex to the facing
            %vertex and find the new facing vertex.
            if config(facingVertex(1),facingVertex(2)) == 1
                yellow = facing;
            else
                blue = facing;
            end
            displacement = blue-yellow;
            facing = yellow + displacement*exp(1i*pi()/3);
            
            yellowVertex = [round(2*imag(yellow)/sqrt(3)),...
                round(real(yellow)-imag(yellow)/sqrt(3))];
            blueVertex = [round(2*imag(blue)/sqrt(3)),...
                round(real(blue)-imag(blue)/sqrt(3))];
            facingVertex =[round(2*imag(facing)/sqrt(3)),...
                round(real(facing)-imag(facing)/sqrt(3))];
        
        end
        %once we are facing outside the boundary we draw the last line
        %which points outwards

        newConfig = config;
        lineStart = yellow + displacement*(1+1i*(1/sqrt(3)))/2;
        lineEnd = yellow + displacement*(1-1i*(1/sqrt(3)))/2;
        line([real(lineStart),real(lineEnd)],...
            [imag(lineStart),imag(lineEnd)],...
            'Color','red','LineWidth',2);
end
