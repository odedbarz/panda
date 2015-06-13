%Spectra viewer
function y= Spectra_viewer_Imp(imp_l,imp_r,Snd_Azi_Ele)
if nargin <3 
    
    fprint('input the locations')
    return;
end

if size(imp_l)~=size(imp_r)
    fprint('left and right impulse need to be same size')
    return;
end

Fs=48828.125;
fig=figure;
subplot(3,1,1)
plot(Snd_Azi_Ele(:,1),Snd_Azi_Ele(:,2),'ro')
title('Select the location of the spectrum U want to see')
grid on

dcm_obj = datacursormode(fig);
set(dcm_obj,'UpdateFcn',@cursor_text_spec,'DisplayStyle','window',...
'SnapToDataVertex','on','Enable','on')

[trl,Nsmpl]             =size(imp_l);
ft_y_l=zeros(size(imp_l));
ft_y_r=zeros(size(imp_r));
for i=1:trl
    [y y_l]=rceps(imp_l(i,:));
    [y y_r]=rceps(imp_r(i,:));
    ft_y_l(i,:)=abs(fft(y_l));    
    ft_y_r(i,:)=abs(fft(y_r)); 
end

NFFT                    =ceil(Nsmpl/2);
h_sp                    =round(1000/(Fs/2)*NFFT):round(16000/(Fs/2)*NFFT);
as                      =[1:Fs/2/NFFT:Fs/2];
mag_s_l                 =zeros(size(ft_y_l));
mag_s_r                 =zeros(size(ft_y_r));
for i=1:trl
    mag_s_l(i,:)                =c_smooth(ft_y_l(i,:),128);
    mag_s_r(i,:)                =c_smooth(ft_y_r(i,:),128);
end
k=0;

while k==0
    w = waitforbuttonpress;
    if w == 0
        disp('Button click')
    else
        disp('Key press')
    end
    c_info = getCursorInfo(dcm_obj);
    trl_n=c_info.DataIndex;
    subplot(3,1,2)
    dBlog_plot_duo(ft_y_l(trl_n,h_sp),ft_y_r(trl_n,h_sp),0)
    legend('left','right')
    grid on
    subplot(3,1,3)
    dBlog_plot_duo(mag_s_l(trl_n,h_sp),mag_s_r(trl_n,h_sp),0)
    legend('left','right')
    grid on
end


% [x,y]=ginput(1);
% gtext({num2str(x),num2str(y)})