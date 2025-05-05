function [Rix,Riy,data] = calcInducedOrbitRespMat(RING,BPMIndex,CORIndex,plane,Quad,dKK)
%calculate the response matrix of the induced traejctory shift with respect
%to correctors
%
%created by X. Huang, 8/31/2021
%

NBPM = length(BPMIndex);
NCOR = length(CORIndex);
Nq = length(Quad.QuadPara);

Rix = zeros(NBPM, NCOR);
Riy = Rix;

delta = 1e-7;
RING0 = RING;
[dx0, dy0] = calcInducedOrbitShift(RING,BPMIndex,Quad, dKK);

for ii=1:NCOR
    RING = RING0;
    if strcmp(plane,'x')
        theta0 = getcellstruct(RING,'KickAngle',CORIndex(ii),1);
        RING = setcellstruct(RING,'KickAngle',CORIndex(ii),theta0+delta,1);
    else
        theta0 = getcellstruct(RING,'KickAngle',CORIndex(ii),2);
        RING = setcellstruct(RING,'KickAngle',CORIndex(ii),theta0+delta,2);
    end
    %[x,y] = getOrbit(RING,BPMIndex);
    [dx, dy] = calcInducedOrbitShift(RING,BPMIndex,Quad, dKK);
    Rix(:,ii) = (dx(:) - dx0(:))/delta;
    Riy(:,ii) = (dy(:) - dy0(:))/delta;
end

data.Rix = Rix;
data.Riy = Riy;
data.CORIndex = CORIndex;
data.dKK = dKK;
data.Quad = Quad;
data.BPMIndex = BPMIndex;
data.delta = delta;

