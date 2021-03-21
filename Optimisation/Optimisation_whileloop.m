%% Optimisation settings
Point = [-0.8 -0.8];                        % Start point
LearnRate = 0.1;                            % Optimisation learn rate
tol = 0.001; maxiter = 200; dxmin = 0.001;  % Optimisation termination tolerences
gnorm = inf; niter = 0; dx = inf; MSE = 0;  % Initialize termination tolerences

%% Problem

[x,y] = meshgrid(-1:0.1:1);
z = ProblemFunction(x,y);
figure(1)
surf(x,y,z,'FaceAlpha',0.5)
xlabel('Parameter 1'); ylabel('Parameter 2'); zlabel('Cost')

%% Optimiser loop
while and(gnorm>=tol, and(niter<=maxiter, dx>=dxmin))

    grad = ProblemGradient(Point);           % Get current gradient 
    OptimisedPoint = Point + LearnRate*grad; % Grad descent algorithm

    niter = niter + 1;                       % Termination tolerances update
    gnorm = norm(grad);                      % Termination tolerances update
    dx = norm(OptimisedPoint-Point);         % Termination tolerances update
    
    Point = OptimisedPoint;                  % Solution update
    
    zp = ProblemFunction(Point(1),Point(2)); % Latest output/cost
    plot(Point,zp)                           % For plotting

end

%% Function objectives
function zp = ProblemFunction(x,y)
    zp = -1 * exp(-(x-0.5).^2/(2*1^2)-(y-0.5).^2/(2*0.5^2)); % Function objective
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

function plot(w,zp)

persistent matrix
matrix = [matrix ;w zp];

% Get surface mesh and plot
[x,y] = meshgrid(-1:0.1:1);
z = ProblemFunction(x,y);
figure(1)
surf(x,y,z,'FaceAlpha',0.5)

% Plot results
hold on;
scatter3(matrix(:,1),matrix(:,2),matrix(:,3),'ok')
plot3(w(1),w(2),zp,'rx','MarkerSize',20,'LineWidth',3)
hold off;
xlabel('Parameter 1'); ylabel('Parameter 2'); zlabel('Cost')
view(2)
drawnow

end

