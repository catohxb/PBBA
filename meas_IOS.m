function [dx, dy, data] = meas_IOS(Family, Dev, dKK)
%measured induced orbit shift for SPEAR3
%10/5/2021
%%modified for NSLS-II on 12/4/2023
%Note dKK is a column vector of length Nq
%

% x0 = getx;
% y0 = gety;

[x0,y0] = getOrbit(1);
bpmlist = getlist('BPMx');

hcm0 = getpv('HCM'); 
vcm0 = getpv('VCM'); 
dcct0 = getdcct;

Ival0 = getsp(Family, Dev);
Nq = length(Ival0);

% QF0 = getsp('QF');
% qf_list = getlist('QF');
% indx = 2:2:28;


% dI = ones(size(indx)).*(-1).^(1:14);
% dI = -dI(:).*QF0(indx)*0.01;

%dI = Ival0*dKK.*(-1).^(1:Nq)';
dI = Ival0.*dKK;

%Modify Here, turn off FOFB
%setpv('Fofb:ControlState',1); %turn of FOFB

pause(0.5);
for ii = 1:10
   %stepsp('QF', dI/10, qf_list(indx,:));
   stepsp(Family, dI/10, Dev);
   pause(0.2);   
end
pause(4);
Ival = getam(Family, Dev);

hcm = getpv('HCM'); 
vcm = getpv('VCM'); 
dcct = getdcct;

[x,y] = getOrbit(1);
% x = getx;
% y = gety;


for ii = 1:10
   stepsp(Family, -dI/10, Dev);
   pause(0.2);   
end
pause(0.5);

setsp(Family, Ival0, Dev);

dx = x-x0;
dy = y-y0;

data.dx = dx;
data.dy = dy;

data.x0 = x0;
data.y0 = y0;
data.hcm0 = hcm0;
data.vcm0 = vcm0;
data.dcct0 = dcct0;

data.x = x;
data.y = y;
data.hcm = hcm;
data.vcm = vcm;
data.dcct = dcct;

data.Quad.Famly = Family;
data.Quad.Device = Dev;
data.Quad.dKK = dKK;
data.Quad.Ival0 = Ival0;
data.Quad.Ival = Ival;
data.Quad.dI = dI;

%% 

if 0
    spos = getspos('BPMx');
figure; 
plot(spos, x-x0, spos, y-y0);
end



