function [x,y,xa,ya] = getOrbit(N)
%
if nargin<1
    N=1;
end

for ii=1:N
xa(:,ii) = getx;
ya(:,ii) = gety; 
pause(0.1);
end

if N>1
    x = mean(xa')';
    y = mean(ya')';
elseif N==1
    x=xa;
    y=ya;
end


