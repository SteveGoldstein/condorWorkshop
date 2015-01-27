%
%  run.m	Run the next reaction method on the system
%
%                   0 -> M, M -> 0, M -> M + P, P -> 0, 2P -> D 
%
%               with rates c1 = 25, c2 = .1, c3 = 1000, c4 = 1, c5 = .001  
%
%  usage:	Independent(n,tol)
%
%               n = number of times to run to get stats.
%               tol = tolerance.  To match paper, use tol = 0.2603
%
%  example:	Independent(10^7,0.2603)
%

function [] = Independent(n,saveFile )

if ischar(n)
    n = str2num(n);
end
%rng(10)
rand('state',sum(100*clock));



initial = [0 0 0];
tend = 1;

data = zeros([3,n]);
GillCount = zeros([n,1]);


for j = 1:n
 [data(:,j),N,GillCount(j)] = nrm_dimer(tend,initial);
end  
save(saveFile, 'data','GillCount');



end %The program

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%