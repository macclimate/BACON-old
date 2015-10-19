function [] = colorguide()
% colorguide.m
% usage: colorguide
% This function plots the resulting colors from the possible
% combinations of Red, Green and Blue colors.
% Created Sept 16, 2010 by JJB.

interv = 0.1;
f1 = figure('Name','Colorguide');
for red = 0:interv:1
    
    for green = 0:interv:1
        
        for blue = 0:interv:1
            
            xvert = [blue   blue+interv blue+interv blue        blue+interv     blue+interv     blue            blue] - interv/2;
            yvert = [green  green       green       green       green+interv    green+interv    green+interv    green+interv]  - interv/2;
            zvert = [red    red         red+interv  red+interv  red             red+interv      red+interv      red]  - interv/2;
            
            patchinfo.Vertices = [xvert' yvert' zvert'];
            patchinfo.Faces = [1 2 3 4; 2 5 6 3; 3 6 7 4; 5 6 7 8; 1 4 7 8; 1 2 5 8];
            patchinfo.FaceColor = [red green blue];
            subplot(221);
            p = patch(patchinfo);hold on;
            subplot(222);
            p = patch(patchinfo);hold on;            
            subplot(223);
            p = patch(patchinfo);hold on;            
            subplot(224);
            p = patch(patchinfo);hold on;
            
        end
    end
end
angl = [45:90:360];

figure(f1);

for i = 1:1:4
    subplot(2,2,i);
    xlabel('Blue');
    ylabel('Green');
    zlabel('Red');
    axis([-0.05 1.05 -0.05 1.05 -0.05 1.05])
    view([angl(i) 30])
end

end
