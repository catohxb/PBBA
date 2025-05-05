setpathnsls2('Storage Ring');

%%

clear
global THERING
load('lat_RING_wDxDy_error_wCorr.mat','THERING')
updateatindex;

%tag = 'QH1_grp2';
tag = 'QM1_grp1';

load(['Ri_NSLS2_' tag '.mat'],'Quad')

fam = Quad.Famliy;
Dev = Quad.Dev;
Modu_factor = Quad.Modu_factor(:);
dKK = 0.02;

iter = 0;


%% correct

group=tag;
load(['Ri_NSLS2_' group '.mat'],'RiH','RiV','Quad');
Nq = length(Quad.QIndex);

dcct0 = getdcct;


% dKK = 0.04;
iter = iter + 1;

str_label=[Quad.tag '_iter_' num2str(iter)];

%Modify Here, correct orbit and then turn off FOFB
% if iter==0
% setpv('Fofb:ControlState',2);  
% pause(1);
% setpv('Fofb:ControlState',1);  
% pause(0.5)
% end

if 1

    fam = Quad.Famliy;
    Dev = Quad.Dev;
    Modu_factor = Quad.Modu_factor(:);
    dKK = 0.02;
    [data1] = correctInducedOrbitShift_Exp(fam,Dev,Modu_factor,dKK,RiH, RiV,str_label, Quad.index_BPM);
    dcct = getdcct;
    
    
%     dfname = appendtimestamp(['data_PBBA_' str_label])
%     save(dfname)
end


return

%% measure IOS w/ multiple modulations

dcct0 = getdcct;

% save init_QF QF0
iter = 0;

if iter==0
    %Modify Here, turn on FOFB
% setpv('Fofb:ControlState',2);  
% pause(2);

%Modify here, turn off FOFB
% setpv('Fofb:ControlState',1);  
end

dKK_list=[-1:0.5:1]*dKK;
if 0
    for ii=1:length(dKK_list)
        dKK = dKK_list(ii);
        [dxa(:,ii), dya(:,ii), data_meas(ii)] = meas_IOS(fam, Dev, dKK*Modu_factor);
   
        pause(1);
        str_lg{ii} = ['\DeltaK/K=' num2str(dKK)];
    end

else
    for ii=1:length(dKK_list)
        dKK = dKK_list(ii);
        str_lg{ii} = ['\DeltaK/K=' num2str(dKK)];
    end
    [dxa, dya, data_meas] = meas_IOS_mult(fam, Dev,Modu_factor, dKK_list);
    
end

option = Quad.tag;
dfile=appendtimestamp(['data_measIOS_' option '_iter_' num2str(iter)]);
save(dfile,'Dev','dxa','dya','data_meas','dKK_list');

NBPM = size(dxa,1);
figure; subplot(2,1,1); plot(1:NBPM, dxa)
subplot(2,1,2); plot(1:NBPM, dya)
title(option,'Interpreter','none')
legend(str_lg)

figure; plot(dKK_list, dxa(20,:),'o',dKK_list, dya(20,:),'o')
xlabel('\DeltaK/K'); ylabel('IOS (mm)');
legend('X','Y');
title([option, ', BPM 20']);


return

%% view measured IOS

data = view_measIOS;


