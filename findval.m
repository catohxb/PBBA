function [k, t] = findval(xl, x)
%[k, t] = findval(xl, x)
%given a list of monotonic (ascending) numbers in xl
%find the index k which satisfies
%	xl(k) <= x < xl(k+1)
%   t = (x - xl(k))/(xl(k+1)-xl(k))
% k = 0 if x < xl(1)
% k = -1  if x > xl(end)
%the original version searches for 1 value in the list
%the change implemented on 5/2/2024 look for values in an array in
%the list. Note if the array is sorted, it can be faster, but this is not
%assumed

for ii=1:length(x)
[k(ii), t(ii)] = findval1(xl, x(ii));
end 



function [k, t] = findval1(xl, x)
%[k, t] = findval(xl, x)
%given a list of monotonic (ascending) numbers in xl
%find the index k which satisfies
%	xl(k) <= x < xl(k+1)
%   t = (x - xl(k))/(xl(k+1)-xl(k))
% k = 0 if x < xl(1)
% k = -1  if x > xl(end)
%
i1 = 1;
i2 = length(xl);
if xl(i1) > x
    k = 0;
    t = NaN;
    return
end
if xl(i2) < x
    k = -1;         
    t = NaN;
    return
end
if xl(i2) ==x
    k = i2;         
    t = 0;
    return
end


while i1 < i2-1
	im = floor( (i1+i2)/2 );
	if xl(im) <= x
		i1 = im;
	else 
		i2 = im;
	end
end

k = i1;
t = (x - xl(k))/(xl(k+1)-xl(k));
