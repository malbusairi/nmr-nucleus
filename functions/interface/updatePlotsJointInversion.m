function updatePlotsJointInversion
%updatePlotsJointInversion plots the joint-inversion results in NUCLEUSinv
%
% Syntax:
%       updatePlotsJointInversion
%
% Inputs:
%       none
%
% Outputs:
%       none
%
% Example:
%       updatePlotsJointInversion
%
% Other m-files required:
%       beautifyAxes
%       clearSingleAxis
%       getColorIndex
%
% Subfunctions:
%       none
%
% MAT-files required:
%       none
%
% See also: NUCLEUSinv
% Author: Thomas Hiller
% email: thomas.hiller[at]leibniz-liag.de
% License: MIT License (at end)

%------------- BEGIN CODE --------------

%% get GUI handle and data
fig = findobj('Tag','INV');
gui = getappdata(fig,'gui');
data = getappdata(fig,'data');

% get colors
col = gui.myui.colors;

% proceed only if there is data
if isfield(data.results,'invjoint')
    % get al relevant data
    invjoint = data.results.invjoint;
    nmr = invjoint.idata.nmr;
    levels = invjoint.levels;
    iGEOM = invjoint.iGEOM;
    iSAT = invjoint.iSAT;
    pSAT = invjoint.pSAT;
    SatImbDrain = invjoint.iparam.SatImbDrain;
    
    %% NMR data plot
    ax = gui.axes_handles.all;
    clearSingleAxis(ax);
    hold(ax,'on');
    
    mycol = flipud(parula(128));
    % color for the individual NMR signals
    colindd = getColorIndex(invjoint.S0(levels),128);
    colindi = getColorIndex(invjoint.S0(levels),128);
    
    % NMR data
    xlims = [1 0];
    ylims = [0 1.05];
    lgdstr = cell(1,1);
    for i = 1:numel(levels)
        t = nmr{levels(i)}.t;
        g = nmr{levels(i)}.g;
        switch SatImbDrain(i)
            case 'D'
                plot(t,g,'s','Color',mycol(colindd(i),:),'Parent',ax);
                lgdstr{i} = ['drain ',sprintf('%3.2f',invjoint.S0(levels(i)))];
            case 'I'
                plot(t,g,'o','Color',mycol(colindi(i),:),'Parent',ax);
                lgdstr{i} = ['imb ',sprintf('%3.2f',invjoint.S0(levels(i)))];
        end
        if i == 1
            xlims(1) = min(t(t>0));
            xlims(2) = max(t);
            ylims(1) = min([ylims(1) min(g)]);
            ylims(2) = max([ylims(2) max(g)]);
        else
            xlims(1) = min([xlims(1) min(t(t>0))]);
            xlims(2) = max([xlims(2) max(t)]);
            ylims(1) = min([ylims(1) min(g)]);
            ylims(2) = max([ylims(2) max(g)]);
        end
    end
    % NMR fits
    for i = 1:numel(levels)
        t = nmr{levels(i)}.t;
        g = nmr{levels(i)}.fit_g;
        if i == 1
            plot(t,g,'-','Color',col.FIT,'LineWidth',2,'Parent',ax);
        else
            plot(t,g,'-','Color',col.FIT,'LineWidth',2,'Parent',ax,...
                'Tag','fits','HandleVisibility','off');
        end
        
        xlims(1) = min([xlims(1) min(t(t>0))]);
        xlims(2) = max([xlims(2) max(t)]);
        ylims(1) = min([ylims(1) min(g)]);
        ylims(2) = max([ylims(2) max(g)]);
    end
    lgdstr{end+1} = 'fits';
    
    % limits & ticks
    loglinx = get(gui.cm_handles.axes_all_xaxis,'Label');
    switch loglinx
        case 'x-axis -> lin' % log axes
            if xlims(1) == 0
                xlims(1) = 1e-4;
            end
            ticks = floor(log10(xlims(1))) :1: ceil(log10(xlims(2)));
            set(ax,'XScale','log','XLim',[10^(ticks(1)) xlims(2)],'XTick',10.^ticks);
        case 'x-axis -> log' % lin axes
            set(ax,'XScale','lin','XLim',xlims,'XTickMode','auto');
    end
    logliny = get(gui.cm_handles.axes_all_yaxis,'Label');
    switch invjoint.T1T2
        case 'T1'
            switch logliny
                case 'y-axis -> lin' % log axes
                    if ylims(1) <= 0
                        ylims(1) = 1e-4;
                    end
                    ticks = floor(log10(ylims(1)))-1 :1: ceil(log10(ylims(2)));
                    set(ax,'YScale','log','YLim',[10^(ticks(1)) 10^(ticks(end))],...
                        'YTick',10.^ticks);
                case 'y-axis -> log' % lin axes
                    set(ax,'YScale','lin','YLim',ylims,'YTickMode','auto');
            end
        case 'T2'
            switch logliny
                case 'y-axis -> lin' % log axes
                    if ylims(1) <= 0
                        ylims(1) = 1e-4;
                    end
                    ticks = floor(log10(ylims(1)))-1 :1: ceil(log10(ylims(2)));
                    set(ax,'YScale','log','YLim',[10^(ticks(1)) ylims(2)],...
                        'YTick',10.^ticks);
                case 'y-axis -> log' % lin axes
                    set(ax,'YScale','lin','YLim',ylims,'YTickMode','auto');
            end
    end
    
    % labels
    if strcmp(data.process.timescale,'s')
        set(get(ax,'XLabel'),'String','time [s]');
    else
        set(get(ax,'XLabel'),'String','time [ms]');
    end
    set(get(ax,'YLabel'),'String','amplitude [a.u.]');
    
    % legend
    legend(ax,lgdstr,'Location','NorthEast','Tag','alllegend','FontSize',10);
    % grid
    grid(ax,'on');
    
    %% PSD data plot
    ax = gui.axes_handles.psdj;
    clearSingleAxis(ax);
    hold(ax,'on');
    
    % x-axis label
    switch data.process.timescale
        case 's'
            xlstring = 'equiv. pore size [m]';
        case 'ms'
            xlstring = 'equiv. pore size [mm]';
    end
    
    switch data.info.PSDJflag        
        case 'freq'            
            % data
            iF = invjoint.iF./trapz(iGEOM.radius,invjoint.iF);
            plot(iGEOM.radius,iF,'o-','Color',col.FIT,'LineWidth',2,'Parent',ax);
            ylim = max(iF);
            
            if isfield(data.import,'NMRMOD')
                modr = data.import.NMRMOD.psddata.r;
                modf = data.import.NMRMOD.psddata.psd;
                modf = modf./trapz(modr,modf);
                plot(modr,modf,'k--','LineWidth',1,'Parent',ax);
                ylim = max([ylim max(modf)]);
                lgdstr = {'fit','model'};
            else
                lgdstr = {'fit'};
            end

            % y-limits
            set(ax,'YScale','lin','YLim',[0 ylim*1.05]);
            % y-label
            set(get(ax,'YLabel'),'String','frequency [-]');

            
        case 'cum'            
            % data
            iF = invjoint.iF;%./trapz(iGEOM.radius,invjoint.iF);
            plot(iGEOM.radius,cumsum(iF),'o-','Color',col.FIT,'LineWidth',2,'Parent',ax);
            ylim = sum(iF);
            
            if isfield(data.import,'NMRMOD')
                modr = data.import.NMRMOD.psddata.r;
                modf = data.import.NMRMOD.psddata.psd;
%                 modf = modf./trapz(modr,modf);
                plot(modr,cumsum(modf),'k--','LineWidth',1,'Parent',ax);
                ylim = max([ylim sum(modf)]);
                lgdstr = {'fit','model'};
            else
                lgdstr = {'fit'};
            end

            % y-limits
            set(ax,'YScale','lin','YLim',[0 ylim*1.05]);
            % y-label
            set(get(ax,'YLabel'),'String','cumulative [-]'); 
    end
    
    % x-limits
    ticks = round(log10(min(iGEOM.radius)) :1: log10(max(iGEOM.radius)));
    set(ax,'XScale','log','XLim',[10^(ticks(1)) 10^(ticks(end))],'XTick',10.^ticks);
    % x-label
    set(get(ax,'XLabel'),'String',xlstring);
    
    % legend
    legend(ax,lgdstr,'Location','NorthEast','Tag','psdjlegend','FontSize',10);
    % grid
    grid(ax,'on');
    
    %% CPS data plot
    ax = gui.axes_handles.cps;
    ph = findall(ax,'Tag','SatPoints');
    if ~isempty(ph)
        set(ph,'HandleVisibility','on')
        delete(ph);
    end
    clearSingleAxis(ax);
    hold(ax,'on');
    
    plotpress = pSAT.pressure .* data.pressure.unitfac;
    xlstring = ['pressure [',data.pressure.unit,']'];
    
    if data.invstd.porosity < 1
        WRCfac = data.invstd.porosity;
    else
        WRCfac = 1;
    end
    
    plot(plotpress,WRCfac.*pSAT.Sdfull,'-','Color',col.FIT,'LineWidth',2,'Parent',ax);
    plot(plotpress,WRCfac.*pSAT.Sifull,'--','Color',col.FIT,'LineWidth',2,'Parent',ax);
    
    % special treatment if there is NUCLEUSmod data
    if isfield(data.import,'NMRMOD')
        modp = data.import.NMRMOD.p .* data.pressure.unitfac;
        modSd = data.import.NMRMOD.Sd;
        modSi = data.import.NMRMOD.Si;
        plot(modp,WRCfac.*modSd,'k-','LineWidth',1,'Parent',ax);
        plot(modp,WRCfac.*modSi,'k--','LineWidth',1,'Parent',ax);
        lgdstr = {'fit_{drain}','fit_{imb}','model_{drain}','model_{imb}'};
    else
        lgdstr = {'fit_{drain}','fit_{imb}'};
    end
    
    % plot the individual levels
    for i = 1:numel(levels)
        p = invjoint.p0(levels(i)).*data.pressure.unitfac;
        S = WRCfac.*invjoint.S0(levels(i));
        switch SatImbDrain(i)
            case 'D'
                plot(p,S,'s','Color',mycol(colindd(i),:),'MarkerSize',8,'Parent',ax,...
                    'HandleVisibility','off','Tag','SatPoints');
            case 'I'
                plot(p,S,'o','Color',mycol(colindi(i),:),'MarkerSize',8,'Parent',ax,...
                    'HandleVisibility','off','Tag','SatPoints');
        end
    end
    
    % x-limits
    set(ax,'XScale','log');
    xticks = log10(plotpress(1)):1:log10(plotpress(end));
    set(ax,'XLim',[plotpress(1) plotpress(end)],'XTick',10.^xticks);
    % y-limits
    if data.invstd.porosity < 1
        set(ax,'YLim',[-0.1 data.invstd.porosity.*1.1],'YTickMode','auto');
    else
        set(ax,'YLim',[-0.1 1.1],'YTick',linspace(0,1,5));
    end
    % labels
    set(get(ax,'XLabel'),'String',xlstring);
    if data.invstd.porosity < 1
        set(get(ax,'YLabel'),'String','water content [-]');
    else
        set(get(ax,'YLabel'),'String','saturation [-]');
    end
    % legend
    legend(ax,lgdstr,'Location','NorthEast','Tag','cpslegend','FontSize',10);
    % grid
    grid(ax,'on');
    
    %% finalize
    beautifyAxes(fig);
    % update GUI data
    setappdata(fig,'data',data);
    setappdata(fig,'gui',gui);
end

end

%------------- END OF CODE --------------

%% License:
% MIT License
%
% Copyright (c) 2018 Thomas Hiller
%
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.