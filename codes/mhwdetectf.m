d = depth_s;

durs=cell(2,720,1);
ints=cell(2,720,1);
years=cell(2,720,1);

freqsy=NaN(2,720,44,1);
intsy=NaN(2,720,44,1);
dursy=NaN(2,720,44,1);
numsy=NaN(2,720,44,1);
cintsy=NaN(2,720,44,1);

accm=NaN(2,720,5);
tic
for m=1:1
    if m==1
    load(['/g/data/v45/zz6006/mhwlf/mhw_ts_fixed2025_f_cmatlab' num2str(d)]);
    %mhw_ts=mhw_ts(1:2,:,:);
    elseif m==2
        load(['/g/data/v45/zz6006/mhwlf/mhw_ts_detrended' num2str(d)]);
    else
        load(['/g/data/v45/zz6006/mhwlf/mhw_ts_shifting' num2str(d)]);
    end
    numsm(:,:,m)=nansum(~isnan(mhw_ts),3);
    [x,y]=find(~isnan(nanmean(mhw_ts,3)));
    date_used=datevec(datenum(1982,1,1):datenum(2025,12,31));
    for i=1:length(x)
        %tic
        ts_here=squeeze(mhw_ts(x(i),y(i),:));
        bw=bwconncomp(~isnan(ts_here));
        int_here=NaN(bw.NumObjects,1);
        dur_here=NaN(bw.NumObjects,1);
        year_here=cell(bw.NumObjects,1);
        for b=1:bw.NumObjects
            int_here(b)=nanmax(ts_here(bw.PixelIdxList{b}));
            dur_here(b)=length(bw.PixelIdxList{b});
            year_here{b}=unique(date_used(bw.PixelIdxList{b},1));
        end
        ints{x(i),y(i),m}=int_here;
        durs{x(i),y(i),m}=dur_here;
        years{x(i),y(i),m}=year_here;
        
        int_y=NaN(44,1);
        dur_y=NaN(44,1);
        freq_y=NaN(44,1);
        nums_y=NaN(44,1);
        cint_y=NaN(44,1);
        
        for yr=1982:2025
            idxy=cellfun(@(x)any(ismember(x,yr)),year_here);
            int_y(yr-1982+1)=nanmean(int_here(idxy));
            dur_y(yr-1982+1)=nanmean(dur_here(idxy));
            freq_y(yr-1982+1)=nansum(idxy);
            nums_y(yr-1982+1)=nansum(~isnan(ts_here(date_used(:,1)==yr)));
            cint_y(yr-1982+1)=nansum(ts_here(date_used(:,1)==yr));
        end
        
        freqsy(x(i),y(i),:,m)=freq_y;
        intsy(x(i),y(i),:,m)=int_y;
        dursy(x(i),y(i),:,m)=dur_y;
        numsy(x(i),y(i),:,m)=nums_y;
        cintsy(x(i),y(i),:,m)=cint_y;
        
        name_used={'freq_y','int_y','dur_y','nums_y','cint_y'};
        
        x_here=(1:44)';
        for n=1:length(name_used)
            % slope
            ts_here=eval(name_used{n});
            [slope, intercept, slope_CI, intercept_CI] = ...
                theilSenRegression(x_here(~isnan(ts_here)),ts_here(~isnan(ts_here)), 0.05, 2000);
            if prod(slope_CI)>=0
                % slope1
                x1=x_here(1:22);
                y1=ts_here(1:22);
                if nansum(~isnan(y1))>=2
                    [slope1, intercept1, slope_CI1, intercept_CI1] = ...
                        theilSenRegression(x1(~isnan(y1)),y1(~isnan(y1)), 0.05, 2000);
                else
                    slope1=nan;
                    slope_CI1=[nan nan];
                end
                
                % slope2
                x1=x_here(23:end);
                y1=ts_here(23:end);
                if nansum(~isnan(y1))>=2
                    [slope2, intercept2, slope_CI2, intercept_CI2] = ...
                        theilSenRegression(x1(~isnan(y1)),y1(~isnan(y1)), 0.05, 2000);
                else
                    slope2=nan;
                    slope_CI2=[nan nan];
                end
            end
            
            if prod(slope_CI)<0 | slope==0
                accm(x(i),y(i),n)=1; % insig
            elseif prod(slope_CI)>=0 && slope<0
                accm(x(i),y(i),n)=2; % Decline
            elseif prod(slope_CI)>=0 && slope>0 ...
                    && (slope_CI2(2)<slope_CI1(1) || any(isnan(slope_CI2))) % Decelerating 
                accm(x(i),y(i),n)=3;
            elseif prod(slope_CI)>=0 && slope>0 ...
                    && (slope_CI1(2)<slope_CI2(1) || any(isnan(slope_CI1))) % Accelerating
                accm(x(i),y(i),n)=5;
            elseif prod(slope_CI)>=0 && slope>0 ...
                    && nanmax([slope_CI1(1) slope_CI2(1)])<=nanmin([slope_CI1(2) slope_CI2(2)])
                accm(x(i),y(i),n)=4;
            end
        end
        %toc
    end
    
end
freqm=cellfun(@length,durs);
intm=cellfun(@nanmean,ints);
durm=cellfun(@nanmean,durs);
toc
save(['/g/data/v45/zz6006/mhwlf/mhw_metric_2025_f_cmatlab_all' num2str(d)],'*sy','numsm','freqm','intm','durm',...
    'accm','-v7.3');
