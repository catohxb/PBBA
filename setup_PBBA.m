clear

load('NSLS2operlat.mat','THERING')
updateatindex;
ati = atindex(THERING);

if 0
tag = 'QH1_grp2';
QH1_list = getlist('QH1');
sel = 2:2:size(QH1_list,1);
Dev_Quad = QH1_list(sel,:);
%QIndex = ati.QH1(sel); 
QIndex = family2atindex('QH1', Dev_Quad); 
Quad.Famliy = 'QH1';

elseif 0 
    tag = 'QH1_grp1';
    QH1_list = getlist('QH1');
    sel = 1:2:size(QH1_list,1);
    Dev_Quad = QH1_list(sel,:);
    QIndex = family2atindex('QH1', Dev_Quad); 
    Quad.Famliy = 'QH1';

elseif 0
    tag = 'QH2_grp1';
    QH2_list = getlist('QH2');
    sel = 1:2:size(QH2_list,1);
    Dev_Quad = QH2_list(sel,:);
    QIndex = family2atindex('QH2', Dev_Quad); 
    Quad.Famliy = 'QH2';
elseif 0
    tag = 'QH2_grp2';
    QH2_list = getlist('QH2');
    sel = 2:2:size(QH2_list,1);
    Dev_Quad = QH2_list(sel,:);
    QIndex = family2atindex('QH2', Dev_Quad); 
    Quad.Famliy = 'QH2';

elseif 0
    tag = 'QL1_grp1';
    QL1_list = getlist('QL1');
    sel = 1:2:size(QL1_list,1);
    Dev_Quad = QL1_list(sel,:);
    QIndex = family2atindex('QL1', Dev_Quad); 
    Quad.Famliy = 'QL1';

elseif 0
    tag = 'QL1_grp2';
    QL1_list = getlist('QL1');
    sel = 2:2:size(QL1_list,1);
    Dev_Quad = QL1_list(sel,:);
    QIndex = family2atindex('QL1', Dev_Quad); 
    Quad.Famliy = 'QL1';

elseif 0
    tag = 'QL2_grp1';
    QL2_list = getlist('QL2');
    sel = 1:2:size(QL2_list,1);
    Dev_Quad = QL2_list(sel,:);
    QIndex = family2atindex('QL2', Dev_Quad); 
    Quad.Famliy = 'QL2';

elseif 0
    tag = 'QL2_grp2';
    QL2_list = getlist('QL2');
    sel = 2:2:size(QL2_list,1);
    Dev_Quad = QL2_list(sel,:);
    QIndex = family2atindex('QL2', Dev_Quad); 
    Quad.Famliy = 'QL2';

elseif 0
    tag = 'QM2_grp1';
    QM2_list = getlist('QM2');
    sel = 1:4:size(QM2_list,1);
    Dev_Quad = QM2_list(sel,:);
    QIndex = family2atindex('QM2', Dev_Quad); 
    Quad.Famliy = 'QM2';

elseif 0
    tag = 'QM2_grp2';
    QM2_list = getlist('QM2');
    sel = 3:4:size(QM2_list,1);
    Dev_Quad = QM2_list(sel,:);
    QIndex = family2atindex('QM2', Dev_Quad); 
    Quad.Famliy = 'QM2';

elseif 0
    tag = 'QM1_grp2';
    QM1_list = getlist('QM1');
    sel = 4:4:size(QM1_list,1);
    Dev_Quad = QM1_list(sel,:);
    QIndex = family2atindex('QM1', Dev_Quad); 
    Quad.Famliy = 'QM1';

elseif 1
    tag = 'QM1_grp1';
    QM1_list = getlist('QM1');
    sel = 2:4:size(QM1_list,1);
    Dev_Quad = QM1_list(sel,:);
    QIndex = family2atindex('QM1', Dev_Quad); 
    Quad.Famliy = 'QM1';

end


Quad.QIndex = QIndex;  %in AT model
Quad.Dev = Dev_Quad;
Nq = length(QIndex);
Quad.Modu_factor = (-1).^(1:Nq);
Quad.tag = tag;


Kv0 = getcellstruct(THERING,'PolynomB',QIndex,2);
sq = findspos(THERING,QIndex);
for ii=1:length(sq)
   QuadPara{ii} = mkparamgroup(THERING,QIndex(ii),'K'); 
end
Quad.QuadPara = QuadPara;
Quad.spos = sq;


BPMIndex = family2atindex('BPMx',getlist('BPMx'));
sbpm = findspos(THERING,BPMIndex);

%find nearest BPM for each quad
% QIndex = [];
% for ii=1:length(QuadPara)
%     QIndex(ii) = QuadPara{ii}(end).ElemIndex;
% end
sq = findspos(THERING,QIndex);
for ii=1:length(sq)
    [ki,ti] = findval(sbpm,sq(ii));
    index_qBPM(ii) = ki;
    if ti>0.5
        index_qBPM(ii) = ki+1;
        ti = ti-1.0;
    end
%     disp([ii ti])
end
Quad.index_BPM = index_qBPM;


HCORIndex = family2atindex('HCM',getlist('HCM'));
VCORIndex = family2atindex('VCM',getlist('VCM'));

%THERING0 = THERING;

Nq = length(QIndex);



%% 
ds_Q = calcOrmQuad(THERING,Quad,BPMIndex);

dKK = 0.02;
plane = 'x';
[Rixx,Riyx,dataHCorr] = calcInducedOrbitRespMat(THERING,BPMIndex,HCORIndex,plane,Quad,dKK);
RiH.RespMat = Rixx;
RiH.BPMIndex = BPMIndex;
RiH.CORIndex = HCORIndex;
RiH.plane = plane;
RiH.Quad  = Quad;
RiH.dKK = dKK;
RiH.tag = tag;


plane = 'y';
[Rixy,Riyy,dataVCorr] = calcInducedOrbitRespMat(THERING,BPMIndex,VCORIndex,plane,Quad,dKK);
RiV.RespMat = Riyy;
RiV.BPMIndex = BPMIndex;
RiV.CORIndex = VCORIndex;
RiV.plane = plane;
RiV.Quad = Quad;
RiV.dKK = dKK;
RiV.tag = tag;

save(['Ri_NSLS2_' tag '.mat']);
 
%
sq = findspos(THERING,Quad.QIndex);
sb = findspos(THERING,BPMIndex(Quad.index_BPM));
sq-sb

%% singular values
[u,s,v] = svd(Rixx);
ss=diag(s);

[uy,sy,vy] = svd(Riyy);
ssy=diag(sy);
figpaper; 
semilogy(1:length(ss), ss,'s',1:length(ssy), ssy,'o')
xlabel('Index');
ylabel('Singular Values');
legend('X','Y');
text(5,1,['NSLS2 ' tag],'interpreter','none')

return

