function showdecwave( WLL,WLH,WHL,WHH,map )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

figure
WLL=abs(WLL);
WLL=(255/max(max(WLL)))*WLL;
subplot(2,2,1);
image(WLL); colormap(map);
title('WLL')

WLH=abs(WLH);
WLH=(255/max(max(WLH)))*WLH;
subplot(2,2,2);
image(WLH); colormap(map);
title('WLH')

WHL=abs(WHL);
WHL=(255/max(max(WHL)))*WHL;
subplot(2,2,3);
image(WHL); colormap(map);
title('WHL')

WHH=abs(WHH);
WHH=(255/max(max(WHH)))*WHH;
subplot(2,2,4);
image(WHH); colormap(map);
title('WHH')
end

