function [dx, dy, data] = calcInducedOrbitShift(RING,BPMIndex,Quad, dKK)
%calculate the induced trajectory shift
%
%created by X. Huang, 8/31/2021

RING0 = RING;
QuadPara = Quad.QuadPara;

[x0,y0] = getOrbit_model(RING0,BPMIndex);

RING=RING0;
for ii=1:length(QuadPara)
   Kv0(ii) =  getcellstruct(RING0,'K',QuadPara{ii}(1).ElemIndex);
end
dK = Kv0*dKK;  
dK = dK.*Quad.Modu_factor;

[RING, X0] = setQuadKPara(RING0,QuadPara,Kv0+dK,BPMIndex);
[x1,y1] = getOrbit_model(RING,BPMIndex);

% [RING, X0] = setQuadKPara(RING0,QuadPara,Kv0-dK,BPMIndex);
% [x2,y2] = getOrbit_model(RING,BPMIndex);

dx = x1(:) - x0(:);
dy = y1(:) - y0(:);

data.x0 = x0;
data.y0 = y0;
data.dx = dx;
data.dy = dy;
data.dKK = dKK;
data.Kv0 = Kv0;
data.QuadPara = QuadPara;

function [RING, X0] = setQuadKPara(RING0,QuadPara,Kv,BPMIndex)
%

RING=RING0;
for ii=1:length(QuadPara)
   RING = setparamgroup(RING,QuadPara{ii},Kv(ii));
end
X0 = findorbit6(RING,BPMIndex);

