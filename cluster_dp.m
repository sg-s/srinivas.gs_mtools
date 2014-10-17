% cluster_dp
% "Density peaks" based clustering
% See: Rodriguez, A., & Laio, A. (2014). Clustering by fast search and find of density peaks. Science, 344(6191), 1492–1496. doi:10.1126/science.1242072
% based off their script, with some modifications (general input type, automatic detection of cluster centres, etc.)
% usage:
% [cl,halo] = cluster_dp(xx)
% where xx is a n X 3 matrix, the first two columns containing pairs of points, and the third the distance b/w them (see the reference above for full details)
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [cl,halo] = cluster_dp(xx)
switch nargin 
    case 0
      help cluster_dp
end


ND=max(xx(:,2));
NL=max(xx(:,1));
if (NL>ND)
  ND=NL;
end
N=size(xx,1);
for i=1:ND
  for j=1:ND
    dist(i,j)=0;
  end
end
for i=1:N
  ii=xx(i,1);
  jj=xx(i,2);
  dist(ii,jj)=xx(i,3);
  dist(jj,ii)=xx(i,3);
end
percent=2.0;
position=round(N*percent/100);
sda=sort(xx(:,3));
dc=sda(position);

for i=1:ND
  rho(i)=0.;
end
%
% Gaussian kernel
%
for i=1:ND-1
  for j=i+1:ND
     rho(i)=rho(i)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));
     rho(j)=rho(j)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));
  end
end
%
% "Cut off" kernel
%
%for i=1:ND-1
%  for j=i+1:ND
%    if (dist(i,j)<dc)
%       rho(i)=rho(i)+1.;
%       rho(j)=rho(j)+1.;
%    end
%  end
%end

maxd=max(max(dist));

[rho_sorted,ordrho]=sort(rho,'descend');
delta(ordrho(1))=-1.;
nneigh(ordrho(1))=0;

for ii=2:ND
   delta(ordrho(ii))=maxd;
   for jj=1:ii-1
     if(dist(ordrho(ii),ordrho(jj))<delta(ordrho(ii)))
        delta(ordrho(ii))=dist(ordrho(ii),ordrho(jj));
        nneigh(ordrho(ii))=ordrho(jj);
     end
   end
end
delta(ordrho(1))=max(delta(:));


keyboard

% automatically find the outliers
r = rho(:); d = delta(:);
r  =r-min(r)/2; r = r./max(r);
d = d-min(d)/2; d = d./max(d);
%scatter(r,d,'k.'), hold on
ft = fittype('a/x^n');
rdfit = fit(r(:),d(:),ft);
%scatter(r,rdfit(r),'r.')

% find the distance of each point from the line
rr = 0:.001:1; dd = rdfit(rr);
distances_from_line = NaN*r;
for i = 1:length(r)
  distances_from_line(i) = min((r(i) - rr).^2 + (d(i) - dd').^2);
end

distances_from_line(r<.1) = 0;
distances_from_line(d<.1) = 0;

% find the greatest 
cluster_centres = find(distances_from_line>mean(distances_from_line)+std(distances_from_line));
%scatter(r(cluster_centres),d(cluster_centres),'g')


% disp('Select a rectangle enclosing cluster centers')
% scrsz = get(0,'ScreenSize');
% ff=figure('Position',[6 72 scrsz(3)/4. scrsz(4)/1.3]);


% for i=1:ND
%   ind(i)=i;
%   gamma(i)=rho(i)*delta(i); % why are we finding gamma?
% end


% subplot(2,1,1)
% tt=plot(rho(:),delta(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
% set(gca,'XLim',[min(rho)/2 1.5*max(rho)],'YLim',[.5*min(delta) 2*max(delta)])
% title ('Decision Graph','FontSize',15.0)
% xlabel ('\rho')
% ylabel ('\delta')

rhomin = min(rho(cluster_centres))-1e-4;
deltamin = min(delta(cluster_centres)) - 1e-4;

% subplot(2,1,1)
% rect = getrect(1);
% rhomin=rect(1);
% deltamin=rect(2); % this was rect(4) in the original code
NCLUST=0;

cl = -1*ones(1,ND);
icl = -1*ones(1,ND);


for i=1:ND
  if ( (rho(i)>rhomin) && (delta(i)>deltamin))
     NCLUST=NCLUST+1;
     cl(i)=NCLUST;
     icl(NCLUST)=i;
  end
end
fprintf('NUMBER OF CLUSTERS: %i \n', NCLUST);
disp('Performing assignation')

%assignation
for i=1:ND
  if (cl(ordrho(i))==-1)
    cl(ordrho(i))=cl(nneigh(ordrho(i)));
  end
end
%halo
for i=1:ND
  halo(i)=cl(i);
end
if (NCLUST>1)
  for i=1:NCLUST
    bord_rho(i)=0.;
  end
  for i=1:ND-1
    for j=i+1:ND
      if ((cl(i)~=cl(j))&& (dist(i,j)<=dc))
        rho_aver=(rho(i)+rho(j))/2.;
        if (rho_aver>bord_rho(cl(i))) 
          bord_rho(cl(i))=rho_aver;
        end
        if (rho_aver>bord_rho(cl(j))) 
          bord_rho(cl(j))=rho_aver;
        end
      end
    end
  end
  for i=1:ND
    if (rho(i)<bord_rho(cl(i)))
      halo(i)=0;
    end
  end
end
for i=1:NCLUST
  nc=0;
  nh=0;
  for j=1:ND
    if (cl(j)==i) 
      nc=nc+1;
    end
    if (halo(j)==i) 
      nh=nh+1;
    end
  end
  fprintf('CLUSTER: %i CENTER: %i ELEMENTS: %i CORE: %i HALO: %i \n', i,icl(i),nc,nh,nc-nh);
end

% cmap=colormap;
% for i=1:NCLUST
%    ic=int8((i*64.)/(NCLUST*1.));
%    subplot(2,1,1)
%    hold on
%    plot(rho(icl(i)),delta(icl(i)),'o','MarkerSize',8,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
% end
% subplot(2,1,2)
% disp('Performing 2D nonclassical multidimensional scaling')
Y1 = mdscale(dist, 2, 'criterion','metricstress');
% plot(Y1(:,1),Y1(:,2),'o','MarkerSize',2,'MarkerFaceColor','k','MarkerEdgeColor','k');
% title ('2D Nonclassical multidimensional scaling','FontSize',15.0)
% xlabel ('X')
% ylabel ('Y')
for i=1:ND
 A(i,1)=0.;
 A(i,2)=0.;
end
for i=1:NCLUST
  nn=0;
  ic=int8((i*64.)/(NCLUST*1.));
  for j=1:ND
    if (halo(j)==i)
      nn=nn+1;
      A(nn,1)=Y1(j,1);
      A(nn,2)=Y1(j,2);
    end
  end

  %plot(A(1:nn,1),A(1:nn,2),'o','MarkerSize',2,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
end


