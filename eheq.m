 function [ fo ] = eheq( img )

i=im2double(img); 
si=(sig(i,0.32,6));

s=uint8(si*255);

hi = rgb2hsv(s); hv = hi(:,:, 3);  hs = hi(:,:, 2); hs=hs.^.87; hi(:,:, 2)=hs;

g=uint8(hv*255);

x=double(cont(g))/255;
 hi(:,:, 3)=x; 
 fo=noc(hsv2rgb(hi));
 end
 
 
 
 function [ o ] = cont( img )
 
%% Histogram Calculation
L=256;
x=[0:1:L-1];
[w,l]=size(img); 
len=w*l;
y=reshape(img,len,1);   
xpdf=hist(y,[0:L-1]); 

%% Bin Clip
Tc=mean(xpdf);  % mean pixels for gray levels
Tc=round(Tc);
Ihist=zeros(1,256);   % intermediate histogram for clipping
 for i=1:256
     if xpdf(i)>Tc
     Ihist(i)=Tc;
     elseif xpdf(i)==0
          Ihist(i)=xpdf(i);
     else
         Ihist(i)=xpdf(i);
     end     
 end
%% E Thresh
exposure=sum(xpdf.*x)/sum(xpdf)/(L);
aNorm=(1-exposure);
Xm=round(L*aNorm);
%% HE
o=zeros(size(img));          
C_L=zeros(1,Xm+1);
C_U=zeros(1,(256-(Xm+1)));
n_L=sum(Ihist(1:Xm+1));
n_U=sum(Ihist(Xm+2:256));
P_L=Ihist(1:Xm+1)/n_L;
P_U=Ihist(Xm+2:256)/n_U;
C_L(1)=P_L(1);
for r=2:length(P_L)
    C_L(r)=P_L(r)+C_L(r-1);
end
C_U(1)=P_U(1);
for r=2:(length(P_U))
    C_U(r)=P_U(r)+C_U(r-1);
end
for r=1:w                       
    for s=1:l
        if img(r,s)<(Xm+1)
            f=Xm*C_L(img(r,s)+1);
            o(r,s)=round(f);
        else
            f=(Xm+1)+(255-Xm)*C_U((img(r,s)-(Xm+1))+1);
            o(r,s)=round(f);
        end
    end
end

end