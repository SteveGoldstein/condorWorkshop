%
%  run.m	Using next reaction method for
%
%                   0 -> M, M -> 0, M -> M + P, P -> 0, 2P -> D 
%
%               with rates c1 = 25, c2 = .1, c3 = 1000, c4 = 1, c5 = .001  
%
%  usage:	nrm_dimer(tend,initial)
%
%               tend = max time for the program to run
%
%               initial = initial condition, usually [0 0]
%
%  example:	nrm_dimer(1,[0 0 0])
%

function [y,N,val] = nrm_dimer(tend,initial)


%bt = clock;

%c = [25 .1 100 1 10^(-2) 0];
c = [25 .1 1000 1 10^(-3) 0];

R = size(c);
R = R(2);

maxi = 10^8;

zeta = [1 -1 0 0 0 0; 
        0 0 1 -1 -2 2; 
        0 0 0 0 1 -1];

%ct = clock;

%initialize.
T = 0;
x = initial';

a = zeros([R,1]);

%Set Poisson times and next Poisson Jumps.  Also set t_ks.
Tk = zeros([R,1]);
Pk = zeros([R,1]);
t = zeros([R,1]);

r = rand(R,1);

%{
tic
Pk = -log(r);
toc
%}

%tic
for j = 1:R
    Pk(j) = log(1/r(j));
end
%toc


N = R;

for i=1:maxi-1,

    if i == 10^8-2
        44
        break
    end
  a(1) = c(1);
  a(2) = c(2)*x(1);
  a(3) = c(3)*x(1);
  a(4) = c(4)*x(2);
  a(5) = c(5)*x(2)*(x(2)-1);
  a(6) = c(6)*x(3);
  
  for j = 1:R
      if a(j) ~= 0
          t(j) = (Pk(j)-Tk(j))/a(j);
      else
          t(j) = inf;
      end
  end
  
  
  loc = 1;
  for k = 2:R
      if t(loc)>t(k)
          loc = k;
      end      
  end
  

  T = T + t(loc);
  
  if T > tend
      break
  end
  
  x = x + zeta(:,loc);
  r = rand;
  Pk(loc) = Pk(loc) + log(1/r);
  Tk = Tk + a*t(loc);
  

  N = N + 1;
  
end 

y=zeros([3,1]);
y(1) = x(1);
y(2) = x(2);
y(3) = x(3);

  %val = x(3);
val = i;
%CPUTime = etime(clock,bt)


end %The program

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%