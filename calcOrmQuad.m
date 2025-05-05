function ds_Q = calcOrmQuad(THERING,Quad,BPMIndex)
%calculate orbit response matrix from kicks at quad location to BPM
%X. Huang, 8/2021
%modified 12/5/2023 to include response of position shift at quads
%

RING0 = THERING;

Nq = length(Quad.QIndex);
bpmindex = BPMIndex;
% bpmindex = family2atindex('BPMx',getlist('BPMx'));

% Nq = size(ds_Q.QuadDev_list,1);
% bpmindex = family2atindex('BPMx',getlist('BPMx'));


[x0,y0] = getOrbit_model(RING0,bpmindex);
dk=1e-5;
for ii=1:Nq
    %qindx(ii) = family2atindex(data.Quad.Famly{ii},data.Quad.Device(ii,:));
    %qindx = family2atindex(ds_Q.Family_list{ii},ds_Q.QuadDev_list(ii,:));
    qindx = Quad.QIndex(ii);

    qK(ii) = getcellstruct(THERING,'K',qindx);  
    len(ii) = getcellstruct(THERING,'Length',qindx);
   
    RING = setcellstruct(RING0,'T1',qindx,-dk/2.,2);
    RING = setcellstruct(RING,'T2',qindx,-dk/2.,2);
    [x,y] = getOrbit_model(RING,bpmindex);
    Rqxx(:,ii) = (x-x0)/dk;
    Rqyx(:,ii) = (y-y0)/dk;

   RING = setcellstruct(RING0,'T1',qindx,-dk/2.,4);
   RING = setcellstruct(RING,'T2',qindx,-dk/2.,4);
   [x,y] = getOrbit_model(RING,bpmindex);
   Rqxy(:,ii) = (x-x0)/dk;
   Rqyy(:,ii) = (y-y0)/dk;


   %response due to position shift at quadrupole
    RING = setcellstruct(RING0,'T1',qindx,-dk/2.,1);
    RING = setcellstruct(RING,'T2',qindx,-dk/2.,1);
    [x,y] = getOrbit_model(RING,bpmindex);
    Rqxx_pos(:,ii) = (x-x0)/dk;
    Rqyx_pos(:,ii) = (y-y0)/dk;

   RING = setcellstruct(RING0,'T1',qindx,-dk/2.,3);
   RING = setcellstruct(RING,'T2',qindx,-dk/2.,3);
   [x,y] = getOrbit_model(RING,bpmindex);
   Rqxy_pos(:,ii) = (x-x0)/dk;
   Rqyy_pos(:,ii) = (y-y0)/dk;

end

ds_Q.Rqxx = Rqxx;
ds_Q.Rqyy = Rqyy;
ds_Q.K = qK;
%ds_Q.dK = dk;
ds_Q.qKL = qK.*len;
ds_Q.Quad = Quad;
ds_Q.BPMIndex = bpmindex;
