function [x,y,spos] = getOrbit(RING,BPMIndex)
%

nX = findorbit6(RING,BPMIndex);
x=nX(1,:);  
y=nX(3,:);
spos = findspos(RING, BPMIndex);
