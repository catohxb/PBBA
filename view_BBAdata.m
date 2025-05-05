function data = view_BBAdata(dfile)
%

if nargin<1
    DATA_DIR = '.';
default_file = [DATA_DIR filesep 'PBBA*.mat'];
[filename, pathname] = uigetfile('PBBA*.mat', 'Please select a PBBA Data file', default_file);
load([pathname filesep filename],'data','sbpm');
dfile = filename;

else
    load([dfile],'data','sbpm');
end

data.filename = dfile;

if 1

    plane = 'x';
    figure; %(2010);
    subplot(2,1,1);

    if strcmp(plane,'x') || strcmp(plane,'X')
        plot(sbpm, data.x0, sbpm,data.x);
    else
        plot(sbpm, data.y0, sbpm,data.y);
    end
    ylabel([plane ' orbit']);
    title(plane);
    
    subplot(2,1,2);
    if strcmp(plane,'x') || strcmp(plane,'X')
        plot(sbpm, data.dx0, sbpm,data.dx);
    else
        plot(sbpm, data.dy0, sbpm,data.dy);
    end
    xlabel('s (m)');
    ylabel(['d' plane ' (m)']);
    title(dfile,'interpreter','none');

    plane = 'y';
    figure; %(2010);
    subplot(2,1,1);

    if strcmp(plane,'x') || strcmp(plane,'X')
        plot(sbpm, data.x0, sbpm,data.x);
    else
        plot(sbpm, data.y0, sbpm,data.y);
    end
    ylabel([plane ' orbit']);
    title(plane);
    
    subplot(2,1,2);
    if strcmp(plane,'x') || strcmp(plane,'X')
        plot(sbpm, data.dx0, sbpm,data.dx);
    else
        plot(sbpm, data.dy0, sbpm,data.dy);
    end
    xlabel('s (m)');
    ylabel(['d' plane ' (m)']);
    title(dfile,'interpreter','none');
    
%     figure; %(2011);
%     sx = getspos('HCM');
%     sy = getspos('VCM');
%     plot(sx, data.dIx,'-s', sy, data.dIy,'-o');
%     xlabel('s (m)');
%     ylabel('\Delta I (Amp)');
%     title(dfile,'interpreter','none');
    
end

%% 

figure;
plot(sbpm, data.x-data.x0, sbpm,data.y-data.y0);
xlabel('s (m)');
ylabel('x-x0, y-y0 (mm)');

figure;
subplot(2,1,1);
plot(sbpm, data.dx0, sbpm, data.dx,'--'); 
xlabel('s (m)');
ylabel('dx (mm)');

subplot(2,1,2);
plot(sbpm, data.dy0, sbpm, data.dy,'--');
xlabel('s (m)');
ylabel('dy (mm)');
title(dfile,'interpreter','none');


