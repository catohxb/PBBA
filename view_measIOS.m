function data = view_measIOS(dfile)
%

if nargin<1
    DATA_DIR = '.';
default_file = [DATA_DIR filesep 'data_measIOS*.mat'];
[filename, pathname] = uigetfile('data_measIOS*.mat', 'Please select a measIOS file', default_file);
load([pathname filesep filename]);
dfile = filename;

else
    load([dfile]); %,'data','data0','data1');
end

data.filename = dfile;
data.raw_data = data_meas;
data.dxa = dxa;
data.dya = dya;
data.dKK_list = dKK_list;
data.Dev = Dev;
data.x0 = data_meas(1).x0;
data.y0 = data_meas(1).y0;

figure;
subplot(2,1,1);
plot(1:size(dxa,1), dxa);
xlabel('s (m)');
ylabel('dx (mm)');
title(dfile,'interpreter','none');

subplot(2,1,2);
plot(1:size(dxa,1), dya);
xlabel('s (m)');
ylabel('dy (mm)');
title(dfile,'interpreter','none');

%% 
quad_options = {'QH1_grp2'};
quad = '';
for ii=1:length(quad_options)
    if findstr(data.filename,quad_options{ii})
       quad = quad_options{ii}; 
    end
end
if isempty(quad)
    return
end

load(['Ri_NSLS2_' quad], 'ds_Q');
Rqxx = ds_Q.Rqxx;
Rqyy = ds_Q.Rqyy;
%dK = ds_Q.dK;
K = ds_Q.K;


for ii=1:size(dxa,2)
    dthetax(:,ii) = fitIOS(Rqxx, dxa(:,ii));
    dthetay(:,ii) = fitIOS(Rqyy, dya(:,ii));
end
Nq = size(Rqxx,2);
figure;subplot(2,1,1)
plot(1:Nq, dthetax*1000,'-o');
ylabel('\theta_x (urad)')
subplot(2,1,2);
plot(1:Nq, dthetay*1000,'-o')
xlabel('Quad')
ylabel('\theta_y (urad)')
title(data.filename,'interpreter','none')

data.orm.Rqxx = Rqxx;
data.orm.Rqyy = Rqyy;
%data.orm.dK = dK;
data.orm.K = K;
data.thetax = dthetax;
data.thetay = dthetay;


for ii=1:Nq
    [px,sx] = polyfit(dKK_list, dthetax(ii,:),1);
    [py,sy] = polyfit(dKK_list, dthetay(ii,:),1);
    dtheta_dKK_x(ii) = px(1);
    dtheta_dKK_y(ii) = py(1);
end

data.dthdKK_x = dtheta_dKK_x;
data.dthdKK_y = dtheta_dKK_y;

function dtheta=fitIOS(Rmat, dx)
%
dtheta = pinv(Rmat)*dx;



