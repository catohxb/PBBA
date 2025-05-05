function [dxa, dya, data] = meas_IOS_mult(Family, Dev, Modu_factor,dKK_list)
%measured induced orbit shift for 
%created on 10/5/2021 for SPEAR3
%modified for NSLS-II on 12/1/2023
%Modu_factor is a column vector of length Nq
%dKK_list is a vector with desired level of modulations
%

[x0,y0] = getOrbit(2);
bpmlist = getlist('BPMx');

%Modify Here, get corrector strengths
hcm0 = getpv('HCM'); 
vcm0 = getpv('VCM'); 


dcct0 = getdcct;

Ival0 = getsp(Family, Dev);
Nq = length(Ival0);

Nk = length(dKK_list);

[dKKmax,imaxdKK] = max(abs(dKK_list));
if dKKmax==0
   error('dK/K must be nonzero'); 
end
dKKmax = dKK_list(imaxdKK);
frac = dKK_list/dKK_list(imaxdKK);

% dI = ones(size(indx)).*(-1).^(1:14);
% dI = -dI(:).*QF0(indx)*0.01;

for step = 1:length(dKK_list)
    dKK = dKK_list(step);
    
     %dI = Ival0*dKK.*(-1).^(1:Nq)';
    %dI = Ival0*dKK; % for QFC
    dI = Ival0.*Modu_factor(:)*dKK; % for QFC
    
    newIval = Ival0+dI;
    tmpIval = getsp(Family, Dev);
    
    %Modify here, turn off fofb
%     setpv('Fofb:ControlState',1); %turn of FOFB

    pause(0.5);
    for ii = 1:10
       setsp(Family, tmpIval+(newIval-tmpIval)/10*ii, Dev);
       pause(0.3);   
    end
    setsp(Family, Ival0+dI, Dev);
    pause(3);
    Ivala(:,step) = getam(Family, Dev);

    hcm = getpv('HCM'); 
    vcm = getpv('VCM'); 
    dcct = getdcct;

    [x,y] = getOrbit(2);
    
    xa(:,step) = x;
    ya(:,step) = y;
    dIa(:,step) = dI(:);
    dccta(step) = dcct;

end

% x = getx;
% y = gety;

% setpv('Fofb:ControlState',2); %turn on FOFB
% setsp('QF',QF0);
tmpIval = getsp(Family, Dev);
for ii = 1:10
   setsp(Family, tmpIval+ii*(Ival0-tmpIval)/10, Dev);
   pause(0.2);   
end
setsp(Family, Ival0, Dev);
pause(2);


dxa = xa-x0;
dya = ya-y0;

data.dx = dxa;
data.dy = dya;

data.x0 = x0;
data.y0 = y0;
data.hcm0 = hcm0;
data.vcm0 = vcm0;
data.dcct0 = dcct0;

data.x = xa;
data.y = ya;
data.dcct = dccta;

data.Quad.Famly = Family;
data.Quad.Device = Dev;
data.Quad.Modu_factor = Modu_factor;
data.Quad.dKK = dKK_list;
data.Quad.Ival0 = Ival0;
data.Quad.dI = dIa;

%% 

if 0
    spos = getspos('BPMx');
figure; 
plot(spos, x-x0, spos, y-y0);
end



