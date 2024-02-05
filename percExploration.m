%want to define a local exploration process for discovering interfaces for
%site percolation on the hexagonal lattice.
%first we do it with boundary conditions on the edges. we start in the
%bottom left corner and explore to the top right. we only sample colours
%locally rather than generating the entire configuration beforehand. 
%the good thing about working on a parallelogram is that you can just use
%the normal coordinates. for coordinate (a,b) the center of the vertex is
%a+b*exp(i*pi/3)
%as a matrix we explore from the top left entry to the bottom right

%if this is =1 then it will draw the hexagons as they're being discovered
%(only the ones that are being explored/ on the boundary of the interface.
%otherwise it will only draw the interface and the boundary hexagons.
drawHexagons = 1;

%percolation probability. critical is p=1/2
p=1/2;

%rectangle width w (#cols) and height h (#rows)
w = 150;
h = 150; 

lineWidth = 2;

figure
axis off
hold on
%define the master hexagon
hex0 = rotate(nsidedpoly(6,'SideLength',1/sqrt(3)),360/12);

%define the percolation configuration
config = 2*ones([h,w]);

%colour the left side and bottom side yellow +1 and right and top side blue
%-1. top left corner = +1, bottom right corner = -1, explore from top row

config(1,:) = 0;
config(h,:) = 1;
config(:,1) = 1;
config(:,w) = 0;

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

%keep track of the boundary of two vertices you're on. start between (1,1)
%and (1,2). yellow on left and blue on right. 
%row vertex so multiply on the right
yellow = 1+1*exp(1i*pi()/3);
blue = 2+1*exp(1i*pi()/3);
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
        'Color','red','LineWidth',lineWidth);

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

axis equal
