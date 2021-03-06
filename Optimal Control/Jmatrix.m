function J=Jmatrix(x,y,u)
% A Matrix: Project, Lundberg, James, Cole


% General Parts
global U
u = U;
mus=(1-u);
r1s=((x+u).^2+y.^2);
r2s=((x-1+u).^2+y.^2);

% Some Partials
F_3x = 1 - mus*(y.^2 -2*(x + u).^2)./(r1s.^2.5)  -  u*(y.^2 -2*(x + u-1).^2)./(r2s.^2.5);

F_3y =    3*mus*((x + u).*y)./(r1s.^2.5)  +  3*u*((x + u-1).*y)./(r2s.^2.5);

F_4x =    3*mus*((x + u).*y)./(r1s.^2.5)  +  3*u*((x + u-1).*y)./(r2s.^2.5);

F_4y = 1 - mus*((x + u).^2 - 2*y.^2 )./(r1s.^2.5)  -  u*((x + u-1).^2-2*y.^2)./(r2s.^2.5);


% The Jacobian of F for the PCR3BP Xdot = F(X)
J=[0,0,1,0;0,0,0,1;F_3x,F_3y,0,2;F_4x,F_4y,-2,0];
