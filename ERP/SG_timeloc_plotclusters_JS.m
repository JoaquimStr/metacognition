function [pos_elec, pos_time, neg_elec, neg_time, T0, T1, T2, T3, T4]=SG_timeloc_plotclusters_JS(stat,varargin)

dbstop if error

colorlist = {
    'monaural loc. std.'    [0         0    1.0000]
    'monaural loc. dev.'     [0    0.5000         0]
    'monaural glo. std.'   [1.0000    0         0]
    'monaural glo. dev.'    [0    0.7500    0.7500]
    'interaural dev.'  [0.7500    0    0.7500]
    'interaural ctrl.' [0.7500    0.7500    0]
    'attend tones'      [0    0.5000    0.5000]
    'attend sequences'  [0.5000    0    0.5000]
    'interference'      [0    0.2500    0.7500]
    'early glo. std.'   [0.5000    0.5000    0]
    'late glo. std.'    [0.2500    0.5000    0]
    };

param = finputcheck(varargin, {
    'legendstrings', 'cell', {}, stat.condlist; ...
    'legendposition', 'string', {}, 'SouthEast'; ...
    'ylim', 'real', [], [-10 10]; ...
    'title','string', {}, ' '; ...
    });


fontname = 'Helvetica';
fontsize = 42;
linewidth = 1;

%% plot significant clusters

posclustidx = [];
if isfield(stat,'posclusters') && ~isempty(stat.posclusters)
    for cidx = 1:length(stat.posclusters)
        if stat.posclusters(cidx).prob < stat.cfg.alpha && isempty(posclustidx) ...
                || (~isempty(posclustidx) && stat.posclusters(cidx).prob <  stat.cfg.alpha)
            posclustidx = cidx;
        end
    end
end

negclustidx = [];
if isfield(stat,'negclusters') && ~isempty(stat.negclusters)
    for cidx = 1:length(stat.negclusters)
        if stat.negclusters(cidx).prob < stat.cfg.alpha && isempty(negclustidx) ...
                || (~isempty(negclustidx) && stat.negclusters(cidx).prob < stat.cfg.alpha)
            negclustidx = cidx;
        end
    end
end


if stat.cfg.tail >= 0
    
    fprintf('Plotting positive clusters.\n');
    if strcmp(stat.statmode,'trial')
        figfile = sprintf('figures/%s_%s-%s-%s_pos',stat.condlist{1},stat.condlist{2},stat.latency(2));
    else
        figfile = sprintf('figures/%s_%s_%s-%s_pos',stat.statmode,num2str(stat.subjinfo),stat.condlist{1},stat.condlist{2});
    end

    clust_t = stat.diffcond.avg(:,find(min(abs(stat.diffcond.time-stat.cfg.latency(1))) == abs(stat.diffcond.time-stat.cfg.latency(1))):...
        find(min(abs(stat.diffcond.time-stat.cfg.latency(2))) == abs(stat.diffcond.time-stat.cfg.latency(2))));
    [maxval,maxidx] = max(clust_t);
    [pim_VN,maxmaxidx] = max(maxval);
    maxchan = maxidx(maxmaxidx);
    maxtime = find(stat.time(maxmaxidx) == stat.diffcond.time);    
    
    cond1_y = stat.diffcond.individual; %powspctrm
    cond2_y = stat.diffcond.individual; %???
    cond1_ySEM = nanstd(cond1_y,1)/sqrt(size(cond1_y,1)-1);
    cond2_ySEM = nanstd(cond2_y,1)/sqrt(size(cond2_y,1)-1);
    
    x=stat.diffcond.time-stat.timeshift;
    y_cond1=double(stat.diffcond.cond1avg(maxchan,:));
    z_cond1=double(squeeze(cond1_ySEM(1,maxchan,:)));
    y_cond2=double(stat.diffcond.cond2avg(maxchan,:));
    z_cond2=double(squeeze(cond2_ySEM(1,maxchan,:)));
    
    if isempty(posclustidx)
        
        fprintf('No significant positive clusters found.\n');
        
        figure('Name',sprintf('%s-%s: Positive Clusters # %s',stat.condlist{1},stat.condlist{2}, num2str(0)),'Color','white','FileName',[figfile '.fig']);
        curcolororder = get(gca,'ColorOrder');
        colororder = zeros(length(param.legendstrings),3);
        for str = 1:length(param.legendstrings)
            cids = strcmp(param.legendstrings{str},colorlist(:,1));
            if sum(cids) == 1
                colororder(str,:) = colorlist{cids,2};
            else
                colororder(str,:) = curcolororder(str,:);
            end
        end
        set(gca,'ColorOrder',cat(1,colororder,[0 0 0]));
        
        
        set(gcf,'Renderer','OpenGL'); % VN
        figpos = get(gcf,'Position');
        figpos(1:2) = 20;
        figpos(4) = figpos(3);
        set(gcf,'Position',figpos);
        
        subplot(2,1,1);
        plotvals = stat.diffcond.avg(:,maxtime);
        hold all
        topoplot(plotvals,stat.chanlocs, 'maplimits', 'absmax', 'electrodes','off', 'emarker2',{maxchan,'o','green',10,1},...
            'numcontour',0); %Ditto for maplimits
        pos_elec=0;
        colorbar('FontName',fontname,'FontSize',fontsize);
        title(param.title,'FontName',fontname,'FontSize',fontsize);
        
        subplot(2,1,2);
        %         set(gca,'ColorOrder',cat(1,colororder,[0 0 0]));
        hold all;
        
        [l,p] = boundedline(x, y_cond1, z_cond1, '-k', 'alpha', x, y_cond2, z_cond2, '-r', 'alpha', 'transparency', 0.3);
        
        ylim = param.ylim;
        set(gca,'XLim',ylim,'XLim',[stat.diffcond.time(1) stat.diffcond.time(end)]-stat.timeshift,'XTick',stat.diffcond.time(1)-stat.timeshift:.2:stat.diffcond.time(end)-stat.timeshift,...
            'FontName',fontname,'FontSize',fontsize);
        line([    0     0],ylim,'LineWidth',linewidth,'Color','black','LineStyle','-');
        line([stat.diffcond.time(maxtime) stat.diffcond.time(maxtime)]-stat.timeshift,ylim,'LineWidth',linewidth,'LineStyle','--','Color','red');
        xlabel('Time (sec) ','FontName',fontname,'FontSize',fontsize);
        ylabel('Amplitude (uV)','FontName',fontname,'FontSize',fontsize);
        box off
        title(sprintf('%.3f sec', stat.diffcond.time(maxtime)-stat.timeshift),'FontName',fontname,'FontSize',fontsize);
        pos_time=0;
        legend(param.legendstrings,'Location',param.legendposition, 'FontSize', 42, 'box', 'off');
        set(gcf,'Color','white');
        
    else
        
        for cidx = 1:posclustidx
            
            figure('Name',sprintf('%s-%s: Positive Clusters # %s',stat.condlist{1},stat.condlist{2}, num2str(cidx)),'Color','white','FileName',[figfile '.fig']);
            curcolororder = get(gca,'ColorOrder');
            colororder = zeros(length(param.legendstrings),3);
            for str = 1:length(param.legendstrings)
                cids = strcmp(param.legendstrings{str},colorlist(:,1));
                if sum(cids) == 1
                    colororder(str,:) = colorlist{cids,2};
                else
                    colororder(str,:) = curcolororder(str,:);
                end
            end
            set(gca,'ColorOrder',cat(1,colororder,[0 0 0]));
            
            
            set(gcf,'Renderer','OpenGL'); % VN
            figpos = get(gcf,'Position');
            figpos(1:2) = 20;
            figpos(4) = figpos(3);
            set(gcf,'Position',figpos);
            
            clust_t(~(stat.posclusterslabelmat == cidx)) = 0;
            [maxval,maxidx] = max(clust_t);
            [pim_VN,maxmaxidx] = max(maxval);
            maxchan = maxidx(maxmaxidx);
            maxtime = find(stat.time(maxmaxidx) == stat.diffcond.time);
            
            subplot(2,1,1);
            plotvals = stat.diffcond.avg(:,maxtime);
            pos_elec_t=stat.posclusterslabelmat(:,maxmaxidx);
            T0=pos_elec_t;
            pos_elec_t(pos_elec_t>0.5)=1;
            pos_elec=pos_elec_t;
            topoplot(plotvals,stat.chanlocs, 'maplimits', [-1 1], 'electrodes','off', 'emarker2',{maxchan,'o','green',10,1},...
                'pmask',pos_elec);
            T1=plotvals;
            T2=stat.chanlocs;
            T3=maxchan;
            T4=pos_elec_t;
            
            colorbar('FontName',fontname,'FontSize',fontsize);
            title(param.title,'FontName',fontname,'FontSize',fontsize);
            
            subplot(2,1,2);
            %             set(gca,'ColorOrder',cat(1,colororder,[0 0 0]));
            hold all;
            
            [l,p] = boundedline(x, y_cond1, z_cond1, '-k', 'alpha', x, y_cond2, z_cond2, '-r', 'alpha', 'transparency', 0.3);
            
            ylim = param.ylim;
            set(gca,'XLim',ylim,'XLim',[stat.diffcond.time(1) stat.diffcond.time(end)]-stat.timeshift,'XTick',stat.diffcond.time(1)-stat.timeshift:.2:stat.diffcond.time(end)-stat.timeshift,...
                'FontName',fontname,'FontSize',fontsize);
            line([    0     0],ylim,'LineWidth',linewidth,'Color','black','LineStyle','-');
            line([stat.diffcond.time(maxtime) stat.diffcond.time(maxtime)]-stat.timeshift,ylim,'LineWidth',linewidth,'LineStyle','--','Color','red');
            xlabel('Time (sec) ','FontName',fontname,'FontSize',fontsize);
            ylabel('Amplitude (uV)','FontName',fontname,'FontSize',fontsize);
            box off
            clustwinidx = find(maxval);
            line([stat.time(clustwinidx(1)) stat.time(clustwinidx(end))]-stat.timeshift,[-.1 -.1],'Color', [0 .45 .74],'LineWidth',8);
            pos_time=[stat.time(clustwinidx(1)) stat.time(clustwinidx(end))];
            title(sprintf('Cluster @ %.3f sec (t = %.2f, p = %.3f)', stat.diffcond.time(maxtime)-stat.timeshift,stat.posclusters(cidx).clusterstat,stat.posclusters(cidx).prob),...
                'FontName',fontname,'FontSize',fontsize);
            
            legend(param.legendstrings,'Location',param.legendposition, 'FontSize', 42, 'box', 'off');
            set(gcf,'Color','white');
        end
    end
end


if stat.cfg.tail <= 0
    fprintf('Plotting negative clusters.\n');
    
    if strcmp(stat.statmode,'trial')
        figfile = sprintf('figures/%s_%s-%s-%s_neg',stat.condlist{1},stat.condlist{2},stat.latency(1),stat.latency(2));
    else
        figfile = sprintf('figures/%s_%s_%s-%s_neg',stat.statmode,num2str(stat.subjinfo),stat.condlist{1},stat.condlist{2});
    end
    
    
    clust_t = stat.diffcond.avg(:,find(min(abs(stat.diffcond.time-stat.cfg.latency(1))) == abs(stat.diffcond.time-stat.cfg.latency(1))):...
        find(min(abs(stat.diffcond.time-stat.cfg.latency(2))) == abs(stat.diffcond.time-stat.cfg.latency(2)))); % This is from the frequency plto clusters script in case blue line problem is here clust_t = stat.diffcond.avg(:,find(min(abs(stat.diffcond.freq-stat.latency(1))) == abs(stat.diffcond.freq-stat.latency(1))):...
    [minval,minidx] = min(clust_t);
    [pim_VN,minminidx] = min(minval);
    minchan = minidx(minminidx);
    mintime = find(stat.time(minminidx) == stat.diffcond.time);
        
    cond1_y = stat.diffcond.individual; %powspctrm
    cond2_y = stat.diffcond.individual; %???
    cond1_ySEM = nanstd(cond1_y,1)/sqrt(size(cond1_y,1)-1);
    cond2_ySEM = nanstd(cond2_y,1)/sqrt(size(cond2_y,1)-1);

    x=stat.diffcond.time-stat.timeshift;    
    y_cond1=double(stat.diffcond.cond1avg(minchan,:));
    z_cond1=double(squeeze(cond1_ySEM(1,minchan,:)));
    y_cond2=double(stat.diffcond.cond2avg(minchan,:));
    z_cond2=double(squeeze(cond2_ySEM(1,minchan,:)));
    
    
    if isempty(negclustidx)
        fprintf('No significant negative clusters found.\n');
        
        figure('Name',sprintf('%s-%s: Negative Clusters # %s',stat.condlist{1},stat.condlist{2},num2str(0)),'Color','white','FileName',[figfile '.fig']);
        curcolororder = get(gca,'ColorOrder');
        colororder = zeros(length(param.legendstrings),3);
        for str = 1:length(param.legendstrings)
            cids = strcmp(param.legendstrings{str},colorlist(:,1));
            if sum(cids) == 1
                colororder(str,:) = colorlist{cids,2};
            else
                colororder(str,:) = curcolororder(str,:);
            end
        end
        set(gca,'ColorOrder',cat(1,colororder,[0 0 0]));
        
        set(gcf,'Renderer','OpenGL'); % VN
        figpos = get(gcf,'Position');
        figpos(1:2) = 20;
        figpos(4) = figpos(3);
        set(gcf,'Position',figpos);
        hold all
        
        
        subplot(2,1,1);
        plotvals = stat.diffcond.avg(:,mintime);
        hold all        
        topoplot(plotvals,stat.chanlocs, 'maplimits', 'absmax', 'electrodes','off', 'emarker2',{minchan,'o','green',14,1},...
            'numcontour',0);
        neg_elec=0;
        colorbar('FontName',fontname,'FontSize',fontsize);
        title(param.title,'FontName',fontname,'FontSize',fontsize);
        
        subplot(2,1,2);
        %         set(gca,'ColorOrder',cat(1,colororder,[0 0 0]));
        hold all;
        
        [l,p] = boundedline(x, y_cond1, z_cond1, '-k', 'alpha', x, y_cond2, z_cond2, '-r', 'alpha', 'transparency', 0.3);
        
        ylim = param.ylim;
        set(gca,'XLim',[stat.diffcond.time(1) stat.diffcond.time(end)]-stat.timeshift,'XTick',stat.diffcond.time(1)-stat.timeshift:0.2:stat.diffcond.time(end)-stat.timeshift,...
            'FontName',fontname,'FontSize',fontsize);        
        line([    0     0],ylim,'LineWidth',linewidth,'Color','black','LineStyle',':');
        line([stat.diffcond.time(mintime) stat.diffcond.time(mintime)]-stat.timeshift,ylim,'LineWidth',linewidth,'LineStyle','--','Color','red');
        xlabel('Time (sec) ','FontName',fontname,'FontSize',fontsize);
        ylabel('Amplitude (uV)','FontName',fontname,'FontSize',fontsize);
        box off
        title(sprintf('%.3f sec', stat.diffcond.time(mintime)-stat.timeshift),'FontName',fontname,'FontSize',fontsize);
        neg_time=0;
        
        legend(param.legendstrings,'Location',param.legendposition, 'FontSize', 42, 'box', 'off');
        set(gcf,'Color','white');
        
        
    else
        
        for cidx = 1:negclustidx
            
            figure('Name',sprintf('%s-%s: Negative Clusters # %s',stat.condlist{1},stat.condlist{2},num2str(cidx)),'Color','white','FileName',[figfile '.fig']);
            curcolororder = get(gca,'ColorOrder');
            colororder = zeros(length(param.legendstrings),3);
            for str = 1:length(param.legendstrings)
                cids = strcmp(param.legendstrings{str},colorlist(:,1));
                if sum(cids) == 1
                    colororder(str,:) = colorlist{cids,2};
                else
                    colororder(str,:) = curcolororder(str,:);
                end
            end
            set(gca,'ColorOrder',cat(1,colororder,[0 0 0]));
            
            set(gcf,'Renderer','OpenGL'); % VN
            figpos = get(gcf,'Position');
            figpos(1:2) = 20;
            figpos(4) = figpos(3);
            set(gcf,'Position',figpos);
            hold all;
            
            clust_t(~(stat.negclusterslabelmat == cidx)) = 0;
            [minval,minidx] = min(clust_t);
            [pim_VN,minminidx] = min(minval);
            minchan = minidx(minminidx);
            mintime = find(stat.time(minminidx) == stat.diffcond.time);
            
            subplot(2,1,1);
            plotvals = stat.diffcond.avg(:,mintime);
            topoplot(plotvals,stat.chanlocs,'maplimits', [-1 1], 'electrodes','off', 'emarker2',{minchan,'o','green',14,1},...
                'pmask',stat.negclusterslabelmat(:,minminidx)==cidx); % 'maplimits', 'absmax'
            neg_elec=stat.negclusterslabelmat(:,minminidx);
            
            colorbar('FontName',fontname,'FontSize',fontsize);
            title(param.title,'FontName',fontname,'FontSize',fontsize);
            
            subplot(2,1,2);
            %             set(gca,'ColorOrder',cat(1,colororder,[0 0 0]));
            hold all;
            
            [l,p] = boundedline(x, y_cond1, z_cond1, '-k', 'alpha', x, y_cond2, z_cond2, '-r', 'alpha', 'transparency', 0.3);
            
            ylim = param.ylim;
            set(gca,'XLim',[stat.diffcond.time(1) stat.diffcond.time(end)]-stat.timeshift,'XTick',stat.diffcond.time(1)-stat.timeshift:0.2:stat.diffcond.time(end)-stat.timeshift,...
                'FontName',fontname,'FontSize',fontsize);
            line([    0     0],ylim,'LineWidth',linewidth,'Color','black','LineStyle',':');
            line([stat.diffcond.time(mintime) stat.diffcond.time(mintime)]-stat.timeshift,ylim,'LineWidth',linewidth,'LineStyle','--','Color','red');
            xlabel('Time (sec) ','FontName',fontname,'FontSize',fontsize);
            ylabel('Amplitude (uV)','FontName',fontname,'FontSize',fontsize);
            box off
            clustwinidx = find(minval);
            line([stat.time(clustwinidx(1)) stat.time(clustwinidx(end))]-stat.timeshift,[-.1 -.1],'Color',[0 .45 .74],'LineWidth',8);
            neg_time=[stat.time(clustwinidx(1)) stat.time(clustwinidx(end))];
            title(sprintf('Cluster @ %.3f sec (t = %.2f, p = %.3f)', stat.diffcond.time(mintime)-stat.timeshift,stat.negclusters(cidx).clusterstat,stat.negclusters(cidx).prob),...
                'FontName',fontname,'FontSize',fontsize);
            
            legend(param.legendstrings,'Location',param.legendposition, 'FontSize', 42, 'box', 'off');
            set(gcf,'Color','white');
        end
    end
end

% export_fig High-Low_conf_in_alert_posclust.tif -native
%     ==================================