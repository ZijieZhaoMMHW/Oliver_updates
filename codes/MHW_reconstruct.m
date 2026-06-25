%% proxy fixed-hadi-new percentile
clims=NaN(360,180,12);
thres=NaN(360,180,12);

[x,y]=find(~isnan(nanmean(sst,3)));

for i=1:12
    idx_here=t(:,2)==i & t(:,1)<=2011 & t(:,1)>=1982;
    clims(:,:,i)=nanmean(sst(:,:,idx_here),3);
    thres(:,:,i)=quantile(sst(:,:,idx_here),0.9,3);
end

% for i=1:12
%     idx_here=t(:,2)==i & t(:,1)<=2011 & t(:,1)>=1982;
%     clims(:,:,i)=nanmean(sst(:,:,idx_here),3);
%     for j=1:length(x)
%         thres(x(j),y(j),i)=percentile(squeeze(sst(x(j),y(j),idx_here)),0.9);
%     end
% end

anoms=sst-clims(:,:,t(:,2));
anoms(anoms<=0)=nan;
a90s=sst-thres(:,:,t(:,2));
a90s(a90s<=0)=nan;

TMM=NaN(360,180,126);%annual mean SST
TMX=NaN(360,180,126);%annual max SST
TAM=NaN(360,180,126);%annual mean anom
TAX=NaN(360,180,126);%annuam max anom
TTM=NaN(360,180,126);%annuam mean a90;
TTX=NaN(360,180,126);%annual max a90;
NA=NaN(360,180,126);%number of month anom
NT=NaN(360,180,126);%number of month a90

for i=1900:2025
    idx_here=t(:,1)==i;
    TMM(:,:,i-1900+1)=nanmean(sst(:,:,idx_here),3);
    TMX(:,:,i-1900+1)=nanmax(sst(:,:,idx_here),[],3);
    TAM(:,:,i-1900+1)=nanmean(anoms(:,:,idx_here),3);
    TAX(:,:,i-1900+1)=nanmax(anoms(:,:,idx_here),[],3);
    TTM(:,:,i-1900+1)=nanmean(a90s(:,:,idx_here),3);
    TTX(:,:,i-1900+1)=nanmax(a90s(:,:,idx_here),[],3);
    NA(:,:,i-1900+1)=nansum(anoms(:,:,idx_here)>0,3);
    NT(:,:,i-1900+1)=nansum(a90s(:,:,idx_here)>0,3);
end
save proxy TMM TMX TAM TAX TTM TTX NA NT -v7.3

%% GLM-Frequency
name_used={'TMM','TMX','TAM','TAX','TTM','TTX','NA','NT'};
cs=NaN(360,180,8,3);
for i=3:3
    tic
    if i==1
        load(['proxy_fixedd_hadi_2025_p']);
    elseif i==2
        load(['proxy_fixedd_ersst_2025_p']);
    else
        load(['proxy_fixedd_cobe_2025_p']);
    end
    c_full=NaN(360,180,8);
    TAX(NA==0)=nan;
    TTX(NT==0)=nan;
    for j=1:8
        proxy_here=eval(name_used{j});
        
        for k=1:length(x)
            freq_here=squeeze(freqts(x(k),y(k),:));
            if i==3
            p_here=[squeeze(proxy_here(x(k),y(k),(end-42):end));nan];
            else
                p_here=[squeeze(proxy_here(x(k),y(k),(end-43):end))];
            end
            if j<7
            b = glmfit(p_here,freq_here,'poisson','Link','log');
            yfit = glmval(b,p_here,'log');
            else
                b = glmfit(p_here,freq_here,'poisson','Link','identity');
                yfit = glmval(b,p_here,'identity');
            end
            if any(~isnan(freq_here) & ~isnan(yfit))
            c_full(x(k),y(k),j)=corr(yfit(~isnan(freq_here) & ~isnan(yfit)),freq_here(~isnan(freq_here) & ~isnan(yfit)));
            end
            
        end
        
    end
    cs(:,:,:,i)=c_full;
    toc
end



