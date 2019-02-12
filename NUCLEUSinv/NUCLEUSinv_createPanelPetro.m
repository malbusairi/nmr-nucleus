function [gui,myui] = NUCLEUSinv_createPanelPetro(data,gui,myui)
%NUCLEUSinv_createPanelPetro creates Petrophysics panel
%
% Syntax:
%       [gui,myui] = NUCLEUSinv_createPanelPetro(data,gui,myui)
%
% Inputs:
%       data - figure data structure
%       gui - figure gui elements structure
%       myui - individual GUI settings structure
%
% Outputs:
%       gui
%       myui
%
% Example:
%       [gui,myui] = NUCLEUSinv_createPanelPetro(data,gui,myui)
%
% Other m-files required:
%       findjobj.m
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

%% create all boxes
gui.panels.petro.VBox = uix.VBox('Parent',gui.panels.petro.main,...
    'Spacing',3,'Padding',3);

% Tbulk, surface relaxivity rho and geometry factor a
gui.panels.petro.HBox1 = uix.HBox('Parent',gui.panels.petro.VBox,...
    'Spacing',3);
% CBW and BVI
gui.panels.petro.HBox2 = uix.HBox('Parent',gui.panels.petro.VBox,...
    'Spacing',3);
% calibration switch calib volume
gui.panels.petro.HBox3 = uix.HBox('Parent',gui.panels.petro.VBox,...
    'Spacing',3);
% sample volume, sample porosity
gui.panels.petro.HBox4 = uix.HBox('Parent',gui.panels.petro.VBox,...
    'Spacing',3);

%% Tbulk, surface relaxivity rho and geometry factor a
gui.text_handles.petro_Tbulk = uicontrol('Parent',gui.panels.petro.HBox1,...
    'Style','text','FontSize',myui.fontsize,'HorizontalAlignment','center',...
    'String',['Tbulk [s]   |   ',char(hex2dec('03C1')),' [�m/s]   |   geom']);
tstr = '<HTML>Set the T bulk [s] value.<br>';
gui.edit_handles.invstd_Tbulk = uicontrol('Parent',gui.panels.petro.HBox1,...
    'Style','edit','String',num2str(data.invstd.Tbulk),'FontSize',myui.fontsize,...
    'UserData',struct('Tooltipstr',tstr,'defaults',[data.invstd.Tbulk 1 1]),...
    'Tag','invstd_Tbulk','Enable','off','Callback',@onEditValue);
tstr = ['<HTML>Surface relaxivity rho in [m/s].<br><br>',...
    '1/T = rho*S/V = rho*a/R.<br><br>',...
    '<u>Default value:</u><br>',...
    '<b>2.5e-5</b><br>'];
gui.edit_handles.param_rho = uicontrol('Parent',gui.panels.petro.HBox1,...
    'Style','edit','String',num2str(data.param.rho),'FontSize',myui.fontsize,...
    'UserData',struct('Tooltipstr',tstr,'defaults',[data.param.rho 1 1]),...
    'Tag','param_rho','Enable','off','Callback',@onEditValue);
tstr = ['<HTML>Give the geometry factor "a" to convert relaxation times to pore radii<br><br>',...
    '1/T = rho*S/V = rho*a/R.<br><br>',...
    '<u>Possible options:</u><br>',...
    '<b>2</b> capillaries with circular cross section<br>',...
    '<b>3</b> spheres<br><br>',...
    'For <b>rectangular</b> and <b>polygonal</b> cross-sections "a" converts to the area-equivalent cylinder radius e.g.:<br>',...
    '<b>2.57</b> capillaries with 60�-60�-60� equilateral cross section<br>',...
    '<b>2.72-12.18</b> capillaries with 90�-a�-(90-a)� rectangular cross section<br>',...
    'e.g. <b>2.72</b> is 90�-45�-45� | <b>2.87</b> is 90�-60�-30� | <b>5.64</b> is 90�-85�-5�<br><br>',...
    '<u>Default value:</u><br>',...
    '<b>2</b><br>'];
gui.edit_handles.param_geom = uicontrol('Parent',gui.panels.petro.HBox1,...
    'Style','edit','String',num2str(data.param.a),'FontSize',myui.fontsize,...
    'UserData',struct('Tooltipstr',tstr,'defaults',[data.param.a 1 1]),...
    'Tag','param_a','Enable','off','Callback',@onEditValue);
set(gui.panels.petro.HBox1,'Widths',[200 -1 -1 -1]);

%% CBW and BVI
gui.text_handles.petro_CBW = uicontrol('Parent',gui.panels.petro.HBox2,...
    'Style','text','FontSize',myui.fontsize,'HorizontalAlignment','center',...
    'String','CBW [ms]    |    BVI [ms]');
tstr = ['<HTML>Give cut-off time between CBW and BVI in [ms].',...
    ' This value depends on lithology.<br><br>',...
    '<u>Abbreviations:</u><br>',...
    '<b>CBW</b> clay bound water<br>',...
    '<b>BVI</b> bulk volume irreducible (irreducible water)<br>',...
    '<b>BVM</b> bulk volume movable (free water)<br><br>',...
    'The value is usually <b>3 [ms]</b><br><br>',...
    '<u>Default value:</u><br>',...
    '<b>3</b><br>'];
gui.edit_handles.param_CBW = uicontrol('Parent',gui.panels.petro.HBox2,...
    'Style','edit','String',num2str(data.param.CBWcutoff),'FontSize',myui.fontsize,...
    'UserData',struct('Tooltipstr',tstr,'defaults',[data.param.CBWcutoff 1 1]),...
    'Tag','param_CBWcutoff','Enable','off','Callback',@onEditValue);
tstr = ['<HTML>Give cut off time between BVI and BVM in [ms].',...
    ' This value depends on lithology.<br><br>',...
    '<u>Abbreviations:</u><br>',...
    '<b>CBW</b> clay bound water<br>',...
    '<b>BVI</b> bulk volume irreducible (irreducible water)<br>',...
    '<b>BVM</b> bulk volume movable (free water)<br><br>',...
    'For Sandstones the value is usually <b>33 [ms]</b><br>',...
    'For Carbonates the value is usually <b>92 [ms]</b><br><br>',...
    '<u>Default value:</u><br>',...
    '<b>33</b><br>'];
gui.edit_handles.param_BVI = uicontrol('Parent',gui.panels.petro.HBox2,...
    'Style','edit','String',num2str(data.param.BVIcutoff),'FontSize',myui.fontsize,...
    'UserData',struct('Tooltipstr',tstr,'defaults',[data.param.BVIcutoff 1 1]),...
    'Tag','param_BVIcutoff','Enable','off','Callback',@onEditValue);
set(gui.panels.petro.HBox2,'Widths',[200 -1 -1]);

%% calibration switch, calibration volume
gui.text_handles.petro_calibVol = uicontrol('Parent',gui.panels.petro.HBox3,...
    'Style','text','FontSize',myui.fontsize,'HorizontalAlignment','center',...
    'String','calib. Vol.  |  calib. Amp.');
tstr = '';
gui.edit_handles.param_calibVol = uicontrol('Parent',gui.panels.petro.HBox3,...
    'Style','edit','String',num2str(data.param.calibVol),'FontSize',myui.fontsize,...
    'UserData',struct('Tooltipstr',tstr,'defaults',[data.param.calibVol 1 1]),...
    'Tag','param_calibVol','Enable','off','Callback',@onEditValue);
tstr = '';
gui.edit_handles.param_calibAmp = uicontrol('Parent',gui.panels.petro.HBox3,...
    'Style','edit','String',num2str(data.param.calibAmp),'FontSize',myui.fontsize,...
    'UserData',struct('Tooltipstr',tstr,'defaults',[data.param.calibAmp 1 1]),...
    'Tag','param_calibAmp','Enable','off','Callback',@onEditValue);
set(gui.panels.petro.HBox3,'Widths',[200 -1 -1]);

%% sample volume, porosity
gui.text_handles.petro_sampVol = uicontrol('Parent',gui.panels.petro.HBox4,...
    'Style','text','FontSize',myui.fontsize,'HorizontalAlignment','center',...
    'String','sample Vol.   |   porosity');
tstr = ' ';
gui.edit_handles.param_sampVol = uicontrol('Parent',gui.panels.petro.HBox4,...
    'Style','edit','String',num2str(data.param.sampVol),'FontSize',myui.fontsize,...
    'UserData',struct('Tooltipstr',tstr,'defaults',[data.param.sampVol 1 1]),...
    'Tag','param_sampVol','Enable','off','Callback',@onEditValue);
tstr = ['<HTML>Set porosity (between 0 and 1)<br><br>',...
    '<u>Default value:</u><br>',...
    '<b>1</b><br><br>'];
gui.edit_handles.invstd_porosity = uicontrol('Parent',gui.panels.petro.HBox4,...
    'Style','edit','String',num2str(data.invstd.porosity),'FontSize',myui.fontsize,...
    'UserData',struct('Tooltipstr',tstr,'defaults',[data.invstd.porosity 1 1]),...
    'Tag','invstd_porosity','Enable','off','Callback',@onEditValue);
set(gui.panels.petro.HBox4,'Widths',[200 -1 -1]);

%% Java Hack to adjust vertical alignment of text fields
jh = findjobj(gui.text_handles.petro_Tbulk);
jh.setVerticalAlignment(javax.swing.JLabel.CENTER);
jh = findjobj(gui.text_handles.petro_CBW);
jh.setVerticalAlignment(javax.swing.JLabel.CENTER);
jh = findjobj(gui.text_handles.petro_calibVol);
jh.setVerticalAlignment(javax.swing.JLabel.CENTER);
jh = findjobj(gui.text_handles.petro_sampVol);
jh.setVerticalAlignment(javax.swing.JLabel.CENTER);

return

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
