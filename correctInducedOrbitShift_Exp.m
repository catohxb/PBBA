function [data] = correctInducedOrbitShift_Exp(Family,Dev,Modu_factor,dKK,Rixx, Riyy, str_label, index_qBPM)
%correct induced Orbit shift by quadrupole  
%
%created by X. Huang, 8/31/2021
%Modified for NSLS-II, 12/1/2023

% setpv('Fofb:ControlState',2); %turn on FOFB

if nargin<6
str_label=Family;
end

scalex=1;
scaley=1;
% if nargin<7 || isempty(scalex)
%     scalex=1;
% end
% if nargin<8
%     scaley=1;
% end



dcct0 = getdcct; 
[x0,y0] = getOrbit;
[dx0, dy0, data0] = meas_IOS(Family, Dev, dKK*Modu_factor(:));

target = zeros(size(x0));

[Nq,~] = size(Dev);



if 1 %x
    RespMat  = Rixx.RespMat*dKK/Rixx.dKK;
    plane    = Rixx.plane;
    
    Amat = RespMat'*RespMat;
    [uA,sA,vA] = svd(Amat); ssA = diag(sA);
    Rixx.sTol =  ssA(Nq)-eps*100;

%     [uA,sA,vA] = svd(Amat);
%     
%     if Nq<=min(size(sA))
%         sTol = sA(Nq,Nq)-eps;
%     else
%         sTol = sA(1,1)*1e-5;
%     end

    dtheta = pinv(Amat,Rixx.sTol)*RespMat'*(target(:)-dx0(:));

     %Modify here - convert kick angle to change of corrector PV value
    dIx = dtheta*scalex; %30 Amp for 1.5 mrad
end

if 1 %y
    RespMat  = Riyy.RespMat*dKK/Riyy.dKK;
    plane    = Riyy.plane;
    Amat = RespMat'*RespMat;
    [uA,sA,vA] = svd(Amat); ssA = diag(sA);
    Riyy.sTol =  ssA(Nq)-eps*100;


    dtheta = pinv(Amat,Riyy.sTol)*RespMat'*(target(:)-dy0(:));

     %Modify here - convert kick angle to change of corrector PV value
    dIy = dtheta*scaley; %0.8; %30 Amp for 0.75 mrad
end

%setpv('Fofb:ControlState',1); %turn of FOFB

pause(0.5);
for ii=1:5
stepsp('HCM',dIx/5);
stepsp('VCM',dIy/5);
pause(0.4);
end

dcct = getdcct; 
[x,y] = getOrbit;
[dx, dy, data1] = meas_IOS(Family, Dev, dKK*Modu_factor(:));



sbpm = getspos('BPMx');
if 1 %strcmp(options.plot,'Yes')
    plane = 'x';
    figure; %(2010);
    subplot(2,1,1);

    if strcmp(plane,'x') || strcmp(plane,'X')
        plot(sbpm, x0, sbpm,x);
    else
        plot(sbpm, y0, sbpm,y);
    end
    legend('before','after');
    ylabel([plane ' orbit']);
    title(str_label,'interpreter','none');
    
    subplot(2,1,2);
    if strcmp(plane,'x') || strcmp(plane,'X')
        plot(sbpm, dx0, sbpm,dx);
        title(num2str(dx'*dx0/(dx0'*dx0)));
    else
        plot(sbpm, dy0, sbpm,dy);
        title(num2str(dy'*dy0/(dy0'*dy0)));
    end
    title(str_label,'interpreter','none');
    xlabel('s (m)');
    ylabel(['d' plane ' (m)']);

    plane = 'y';
    figure; %(2010);
    subplot(2,1,1);

    if strcmp(plane,'x') || strcmp(plane,'X')
        plot(sbpm, x0, sbpm,x);
    else
        plot(sbpm, y0, sbpm,y);
    end
    ylabel([plane ' orbit']);
    title(str_label,'interpreter','none');
    
    subplot(2,1,2);
    if strcmp(plane,'x') || strcmp(plane,'X')
        plot(sbpm, dx0, sbpm,dx);
        title(num2str(dx'*dx0/(dx0'*dx0)));
    else
        plot(sbpm, dy0, sbpm,dy);
        title(num2str(dy'*dy0/(dy0'*dy0)));
    end
    
    xlabel('s (m)');
    ylabel(['d' plane ' (m)']);
    
    figure; %(2011);
    sx = getspos('HCM');
    sy = getspos('VCM');
    plot(sx, dIx,'-s', sy, dIy,'-o');
    xlabel('s (m)');
    ylabel('\Delta I (Amp)');
    
end

data.x0 = x0;
data.y0 = y0;
data.dx0 = dx0;
data.dy0 = dy0;
data.x = x;
data.y = y;
data.dx = dx;
data.dy = dy;
data.dtheta = dtheta;
data.dKK = dKK;

data.data_IOS0 = data0;
data.data_IOS1 = data1;

data.label = str_label;
data.Quad.Family = Family;
data.Quad.Dev = Dev;
data.Quad.index_BPM = index_qBPM;


data.Rixx = Rixx;
data.Riyy = Riyy;
data.dIy = dIy;
data.dIx = dIx;
data.dcct = dcct;
data.scalex = scalex;
data.scaley = scaley;

dfile = appendtimestamp(['PBBA_' str_label]);
save(dfile);

%data.QIndex = QIndex;
%data.index_BPM = index_BPM;
