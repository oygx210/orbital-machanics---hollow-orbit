function [Xbest, dbest, FinPt,DDS] = gridsearch_OC3(c1_int,n1,c2_int,n2,k1_int,n3,k2_int,n4,tf_int,n5)

% Program gridsearch_5D_adj.m: This program will utilize the shooting
% method defined for our full system in the file shootingF_OC.m. The
% program will attempt to find a value of X for which the error d is below a
% certain user-defined minimum defined in maxerr.

% Ngrid is the number of investigation intervals per parameter.

% ATTENTION ! Current code demands that the user declare PLOTON global and
% enter PLOTON=1, if output plots are desired.
% Also, don't start the time interval [t_begin,t_end] with t_begin=0. (this
% will cause an error in the ode solver)

% Sample input:
% Init_OCP;
% [Xbest, dbest] = gridsearch_OC([-.2,.2],3,[-.2,.2],3,[-.2,.2],5,[-.2,.2],5,.1:.1:2)



global PLOTON
plotons = PLOTON;
PLOTON = 0;

solutionsX=[];

%Initial Values
c1 = c1_int(1);
c2 = c2_int(1);
k1 = k1_int(1);
k2 = k2_int(1);
tf  = tf_int(end);

% Set Stepsizes

tc1 = (c1_int(2) - c1_int(1));  % Ranges of values. 
tc2 = (c2_int(2) - c2_int(1));
tk1 = (k1_int(2) - k1_int(1));
tk2 = (k2_int(2) - k2_int(1));

if tc1 <= 0
    n1 = 0;
else
    tc1 = tc1/n1;       % dividing up ranges of values into the 
end                         % appropriate number of intervals. 
if tc2 <= 0
    n2 = 0;
else
    tc2 = tc2/n2;
end
if tk1 <= 0
    n3 = 0;
else
    tk1 = tk1/n3;
end
if tk2 <= 0
    n4 = 0;
else
    tk2 = tk2/n4;
end

% Set up global times list

global TIMES_F

if length(tf_int) == 1 && n5 > 1
    TIMES_F = linspace(0,tf_int,n5);
else
    if tf_int(1) ~= 0
        TIMES_F = [0,tf_int];
    else
        TIMES_F = tf_int;
    end
end

n = length(TIMES_F);
d = zeros([5,n-1]);

% Prep plotting DDS vector
% NS = (n1+1)*(n2+1)*(n3+1)*(n4+1)*(n5+1);
% DDS = zeros([1,NS]);
% ls = 0;

dbest = 1.e10;
c1 = c1_int(1);
for k=1:n1+1    % if Ngrid1=0, then this loop component will only preform one cycle.
    c2 = c2_int(1);
    for j=1:n2+1
        k1 = k1_int(1);
        for l=1:n3+1
            k2 = k2_int(1);
            for m=1:n4+1
              
                X= [c1,c2,k1,k2,tf]';
                [d,TE,TS] = shootingF_OC3(X);% dd = norm(d);%, ls = ls +1;,DDS(ls) = dd;

                for k5 = 1:size(d,2)

                    dd = norm(d(:,k5));
                    if dd < dbest       % The program will output those values norm error which seem
                        dbest = dd;     % plausible in order to inform the user how close the selected
                        Xbest = [X(1:4);TS(k5+1)];      % intervals are actually coming to a target solution
                        disp([Xbest',dd]);
                        PLOTON = plotons;
                        if PLOTON ~= 0
                            d = shootingF_OC2(Xbest);
                        end
                        PLOTON = 0;
                    end
                    
                end
                k2 = k2 + tk2;
            end
            k1 = k1 + tk1;
        end
        c2 = c2 + tc2;
    end
    c1 = c1 + tc1;
end

% Recompute best Solution with plot
PLOTON = plotons;
dbest = shootingF_OC2(Xbest)'; 
global FINPT
FinPt = FINPT;