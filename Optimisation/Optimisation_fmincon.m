
StartPoint = [-0.8 -0.8];  

% Option 1: Basic fmincon
%x = fmincon(@ProblemFunction,StartPoint,[],[]);

% Option 2: Apply boundary
%x = fmincon(@ProblemFunction,StartPoint,[],[],[],[],[-1 -1],[1 0.4],[]);

% Option 3: 
S.options = optimset('display','iter','MaxIter',10,'GradObj','off','OutputFcn',@outfun);
%x = fmincon(@ProblemFunction,StartPoint,[],[],[],[],[-1 -1],[1 1],[],S.options,S);

% Option 4
S.options = optimset('display','iter','MaxIter',10,'OutputFcn',@outfun,'GradObj','on');
x = fmincon(@ProblemFunction,StartPoint,[],[],[],[],[-1 -1],[1 1],[],S.options,S);



%% Function objectives

function [zp,zp_g] = ProblemFunction(x,S)

zp = -1 * exp(-(x(1)-0.5).^2/(2*1^2)-(x(2)-0.5).^2/(2*0.5^2)); % Function objective

if nargin>1
    if contains(S.options.GradObj,'off')
        zp_g = [];
    else
        zp_g = -ProblemGradient(x);
    end
end

end

function g = ProblemGradient(x)
% Gradients of the function objective
wd = [1 0.5];
c = [0.5 0.5];
dz_dx = -((x(1)-c(1))/(wd(1)^2)) * exp(-(x(1)-c(1)).^2/(2*wd(1)^2)-(x(2)-c(2)).^2/(2*wd(2)^2));
dz_dy = -((x(2)-c(2))/(wd(2)^2)) * exp(-(x(1)-c(1)).^2/(2*wd(1)^2)-(x(2)-c(2)).^2/(2*wd(2)^2));

g = [dz_dx dz_dy];
end

%% Plotting function

function stop = outfun(sol,optimValues,state,S)

persistent matrix
matrix = [matrix ;sol optimValues.fval];

% Get surface mesh and plot
[x,y] = meshgrid(-1:0.1:1);
z = -1 * exp(-(x-0.5).^2/(2*1^2)-(y-0.5).^2/(2*0.5^2)); % Function objective;
figure(1)
surf(x,y,z,'FaceAlpha',0.5)

% Plot results
zp = ProblemFunction(sol,S);
hold on;
plot3(matrix(:,1),matrix(:,2),matrix(:,3),'-ok')
plot3(sol(1),sol(2),zp,'rx','MarkerSize',20,'LineWidth',3)
hold off;
xlabel('Parameter 1'); ylabel('Parameter 2'); zlabel('Cost')
view(2)
drawnow
pause(1)
stop = 0;
end
