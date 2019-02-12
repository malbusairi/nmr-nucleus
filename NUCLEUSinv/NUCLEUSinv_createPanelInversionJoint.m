function [gui,myui] = NUCLEUSinv_createPanelInversionJoint(data,gui,myui)
%NUCLEUSinv_createPanelInversionJoint creates joint inversion panel
%
% Syntax:
%       [gui,myui] = NUCLEUSinv_createPanelInversionJoint(gui,myui)
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
%       [gui,myui] = NUCLEUSinv_createPanelInversionJoint(gui,myui)
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

%% create all boxes and panels
gui.panels.invjoint.Tabs = uix.TabPanel('Parent',gui.panels.invjoint.main);
gui.panels.invjoint.TabSettings = uix.VBox('Parent',gui.panels.invjoint.Tabs,...
    'Spacing',3,'Padding',3);
gui.panels.invjoint.TabCPS = uix.HBox('Parent',gui.panels.invjoint.Tabs,...
    'Spacing',3,'Padding',3);
gui.panels.invjoint.Tabs.TabTitles = {'settings','cps data'};
gui.panels.invjoint.Tabs.TabWidth = 75;

%% settings sub panel
% inversion method
gui.panels.invjoint.HBox1 = uix.HBox('Parent',gui.panels.invjoint.TabSettings,...
    'Spacing',3);
% PSD radii
gui.panels.invjoint.HBox2 = uix.HBox('Parent',gui.panels.invjoint.TabSettings,...
    'Spacing',3);
% regularization options
gui.panels.invjoint.HBox3 = uix.HBox('Parent',gui.panels.invjoint.TabSettings,...
    'Spacing',3);
% smoothness constraint / order of regularized solution
gui.panels.invjoint.HBox4 = uix.HBox('Parent',gui.panels.invjoint.TabSettings,....
    'Spacing',3);
% min and max values of the L-curve
gui.panels.invjoint.HBox5 = uix.HBox('Parent',gui.panels.invjoint.TabSettings,...
    'Spacing',3);
% geometry type and number of polygon sides
gui.panels.invjoint.HBox6 = uix.HBox('Parent',gui.panels.invjoint.TabSettings,...
    'Spacing',3);
% angles
gui.panels.invjoint.HBox7 = uix.HBox('Parent',gui.panels.invjoint.TabSettings,...
    'Spacing',3);
% start values
gui.panels.invjoint.HBox8 = uix.HBox('Parent',gui.panels.invjoint.TabSettings,...
    'Spacing',3);
% RUN button
gui.panels.invjoint.HBox9 = uix.HBox('Parent',gui.panels.invjoint.TabSettings,...
    'Spacing',3);

%% cps sub panel
% two parallel VBoxes
% one for settings
gui.panels.invjoint.VBox1 = uix.VBox('Parent',gui.panels.invjoint.TabCPS,...
    'Spacing',3);
% one for the CPS table
gui.panels.invjoint.VBox2 = uix.VBox('Parent',gui.panels.invjoint.TabCPS);
% adjust widths
set(gui.panels.invjoint.TabCPS,'Widths',[200 -1]);

% pressure units
gui.panels.invjoint.HBox10 = uix.HBox('Parent',gui.panels.invjoint.VBox1);
uix.Empty('Parent',gui.panels.invjoint.VBox1);
% + button
gui.panels.invjoint.HBox11 = uix.HBox('Parent',gui.panels.invjoint.VBox1);
% - button
gui.panels.invjoint.HBox12 = uix.HBox('Parent',gui.panels.invjoint.VBox1);
% LOAD button
gui.panels.invjoint.HBox13 = uix.HBox('Parent',gui.panels.invjoint.VBox1);
% adjust heights for the settings VBox
set(gui.panels.invjoint.VBox1,'Heights',[25 -1 25 25 25]);

%% inversion method
gui.text_handles.invjoint_InvType = uicontrol('Parent',gui.panels.invjoint.HBox1,...
    'Style','text','FontSize',myui.fontsize,'HorizontalAlignment','center',...
    'String','inversion method');
tstr = 'tba';

switch data.info.optim
    case 'on'
        gui.popup_handles.invjoint_InvType = uicontrol('Parent',gui.panels.invjoint.HBox1,...
            'Style','popup','FontSize',myui.fontsize,...
            'String',{'free inversion','fixed inversion','shape inversion'},...
            'UserData',struct('Tooltipstr',tstr),'Enable','off','Value',1,...
            'Callback',@onPopupInvjointType);
    case 'off'
        gui.popup_handles.invjoint_InvType = uicontrol('Parent',gui.panels.invjoint.HBox1,...
            'Style','popup','FontSize',myui.fontsize,...
            'String',{'free inversion','fixed inversion','shape inversion'},...
            'UserData',struct('Tooltipstr',tstr),'Enable','off','Value',2,...
            'Callback',@onPopupInvjointType);
end
set(gui.panels.invjoint.HBox1,'Widths',[200 -1]);

%% PSD radii
gui.text_handles.invjoint_radii = uicontrol('Parent',gui.panels.invjoint.HBox2,...
    'Style','text','FontSize',myui.fontsize,'String','PSD - min [m] | max [m] | # / dec');
tstr = 'Lower bound of pore size distribution.';
gui.edit_handles.invjoint_radii_min = uicontrol('Parent',gui.panels.invjoint.HBox2,...
    'Style','edit','String',num2str(data.invjoint.radii(1,1)),'FontSize',myui.fontsize,...
    'UserData',struct('Tooltipstr',tstr,'defaults',[data.invjoint.radii(1,1) 1 1]),...
    'Tag','invjoint_radii','Enable','off','Callback',@onEditValue);
tstr = 'Upper bound of pore size distribution.';
gui.edit_handles.invjoint_radii_max = uicontrol('Parent',gui.panels.invjoint.HBox2,...
    'Style','edit','String',num2str(data.invjoint.radii(1,2)),'FontSize',myui.fontsize,...
    'UserData',struct('Tooltipstr',tstr,'defaults',[data.invjoint.radii(1,2) 1 2]),...
    'Tag','invjoint_radii','Enable','off','Callback',@onEditValue);
tstr = 'Number of steps per decade.';
gui.edit_handles.invjoint_Nradii = uicontrol('Parent',gui.panels.invjoint.HBox2,...
    'Style','edit','String',num2str(data.invjoint.Nradii),'FontSize',myui.fontsize,...
    'UserData',struct('Tooltipstr',tstr,'defaults',[data.invjoint.Nradii 1 1]),...
    'Tag','invjoint_Nradii','Enable','off','Callback',@onEditValue);
set(gui.panels.invjoint.HBox2,'Widths',[200 -1 -1 -1]);

%% regularization options
gui.text_handles.invjoint_InvTypeOpt = uicontrol('Parent',gui.panels.invjoint.HBox3,...
    'Style','text','FontSize',myui.fontsize,'HorizontalAlignment','center',...
    'String','regularization options');
tstr = ['<HTML>Choose regularization options.<br><br>',...
    '<u>Available options:</u><br>',...
    '<font color="black"><b>Manual</b> Manual regularization.<br>',...
    '<font color="black"><b>L-curve</b> Perform the L-curve test to find optimal regularization parameter lambda.<br><br>',...
    '<u>Default value:</u><br>',...
    '<b>Manual</b><br>'];
gui.popup_handles.invjoint_InvTypeOpt = uicontrol('Parent',gui.panels.invjoint.HBox3,...
    'Style','popup','String',{'Manual','L-curve'},'FontSize',myui.fontsize,...
    'Enable','off','Value',1,'UserData',struct('Tooltipstr',tstr),...
    'Callback',@onPopupInvjointTypeOptional);
set(gui.panels.invjoint.HBox3,'Widths',[200 -1]);

%% smoothness constraint / order of regularized solution
gui.text_handles.invjoint_Lorder = uicontrol('Parent',gui.panels.invjoint.HBox4,...
    'Style','text','FontSize',myui.fontsize,...
    'HorizontalAlignment','center','String','smoothness constraint (L-order)');
tstr = ['<HTML>Choose the smoothness constraint for the multi-exponential fitting routines.<br><br>',...
    '<u>Available options:</u><br>',...
    '<b>0</b> Zeroth-order smoothness constraint.<br>',...
    '<b>1</b> First-order smoothness constraint.<br>',...
    '<b>2</b> Second-order smoothness constraint.<br><br>',...
    '<u>Default value:</u><br>',...
    '<b>1</b><br>'];
gui.radio_handles.invjoint_Lorder0 = uicontrol('Parent',gui.panels.invjoint.HBox4,...
    'Style','radiobutton','String','0','Tag','invjoint','FontSize',myui.fontsize,...
    'UserData',struct('Tooltipstr',tstr),'Enable','off','Callback',@onRadioLorder);
gui.radio_handles.invjoint_Lorder1 = uicontrol('Parent',gui.panels.invjoint.HBox4,...
    'Style','radiobutton','String','1','Tag','invjoint','FontSize',myui.fontsize,...
    'UserData',struct('Tooltipstr',tstr),'Enable','off','Callback',@onRadioLorder);
gui.radio_handles.invjoint_Lorder2 = uicontrol('Parent',gui.panels.invjoint.HBox4,...
    'Style','radiobutton','String','2','Tag','invjoint','FontSize',myui.fontsize,...
    'UserData',struct('Tooltipstr',tstr),'Enable','off','Callback',@onRadioLorder);
set(gui.panels.invjoint.HBox4,'Widths',[200 -1 -1 -1]);

%% min and max values of the L-curve
gui.text_handles.invjoint_lambda = uicontrol('Parent',gui.panels.invjoint.HBox5,...
    'Style','text','FontSize',myui.fontsize,...
    'String','lambda  -  min | max | #');
tstr = 'Lambda value / Smallest Lambda in range.';
gui.edit_handles.invjoint_lambda_min = uicontrol('Parent',gui.panels.invjoint.HBox5,...
    'Style','edit','String',num2str(data.invjoint.lambda),'FontSize',myui.fontsize,...
    'UserData',struct('Tooltipstr',tstr,'defaults',[data.invjoint.lambdaR(1,1) 1 1]),...
    'Tag','invjoint_lambdaR','Enable','off','Callback',@onEditValue);
tstr = 'Largest Lambda in range.';
gui.edit_handles.invjoint_lambda_max = uicontrol('Parent',gui.panels.invjoint.HBox5,...
    'Style','edit','String',num2str(data.invjoint.lambdaR(1,2)),...
    'UserData',struct('Tooltipstr',tstr,'defaults',[data.invjoint.lambdaR(1,2) 1 2]),...
    'Tag','invjoint_lambdaR','FontSize',myui.fontsize,...
    'Enable','off','Callback',@onEditValue);
tstr = 'Number of Lambdas in L-curve.';
gui.edit_handles.invjoint_NlambdaR = uicontrol('Parent',gui.panels.invjoint.HBox5,...
    'Style','edit','String',num2str(data.invjoint.NlambdaR),...
    'UserData',struct('Tooltipstr',tstr,'defaults',[data.invjoint.NlambdaR 1 1]),...
    'Tag','invjoint_NlambdaR','FontSize',myui.fontsize,...
    'Enable','off','Callback',@onEditValue);
set(gui.panels.invjoint.HBox5,'Widths',[200 -1 -1 -1]);

%% geometry type and number of polygon sides
gui.text_handles.invjoint_geometry_type = uicontrol('Parent',gui.panels.invjoint.HBox6,...
    'Style','text','FontSize',myui.fontsize,'HorizontalAlignment','center',...
    'String','pore geometry | # sides');
tstr = ['<HTML>Choose the geometry of the capillary bundle pore model.<br><br>',...
    '<u>Available options:</u><br>',...
    '<b>cylindrical</b> <br>',...
    '<b>rectangular</b> <br>',...
    '<b>polygon</b> <br><br>',...
    '<u>Default value:</u><br>',...
    '<b>cylindrical</b> <br>'];
gui.popup_handles.invjoint_geometry_type = uicontrol('Parent',gui.panels.invjoint.HBox6,...
    'Style','popup','String',{'cylindrical','rectangular','polygon'},'FontSize',myui.fontsize,...
    'Enable','off','Value',1,'UserData',struct('Tooltipstr',tstr),'Callback',@onPopupInvjointGeometryType);
tstr = ['<HTML>Number of polygon sides<br><br>',...
    '<u>Available options:</u><br>',...
    '<b>3</b> to <b>12</b> <br><br>',...
    '<u>Default value:</u><br>',...
    '<b>3</b> <br>'];
gui.popup_handles.invjoint_polyN = uicontrol('Parent',gui.panels.invjoint.HBox6,...
    'Style','popup','String',{'3','4','5','6','7','8','9','10','11','12'},...
    'Value',1,'FontSize',myui.fontsize,'UserData',struct('Tooltipstr',tstr),...
    'Enable','off','Callback',@onPopupInvjointPolyN);
set(gui.panels.invjoint.HBox6,'Widths',[200 -2 -1]);

%% angles
gui.text_handles.invjoint_angles = uicontrol('Parent',gui.panels.invjoint.HBox7,...
    'Style','text','FontSize',myui.fontsize,'HorizontalAlignment','center',...
    'String',['angles  -  ',char(hex2dec('03B1')),' [�] | ',...
    char(hex2dec('03B2')),' [�] | ',char(hex2dec('03B3')),' [�]']);
tstr = ['<HTML>For <b>rectangular</b> geometry:<br><br>',...
    'angle ',char(hex2dec('03B1')),' is always 90�<br>',...
    'angle ',char(hex2dec('03B2')),' is adjustable<br>',...
    'angle ',char(hex2dec('03B3')),' gets calculated from the other two.<br><br>',...
    '<u>Default value:</u><br>',...
    '<b>90 45 45</b><br><br>',...
    'For <b>polygon</b> geometry only one angle is needed:<br><br>',...
    'angle ',char(hex2dec('03B2')),' automatically changes by number of polygon sides<br>'];
gui.edit_handles.invjoint_alpha = uicontrol('Parent',gui.panels.invjoint.HBox7,...
    'Style','edit','String',num2str(data.invjoint.alpha),'FontSize',myui.fontsize,...
    'UserData',struct('Tooltipstr',tstr,'defaults',[data.invjoint.alpha 1 1]),...
    'Tag','invjoint_alpha','Enable','off','Callback',@onEditValue);
gui.edit_handles.invjoint_beta = uicontrol('Parent',gui.panels.invjoint.HBox7,...
    'Style','edit','String',num2str(data.invjoint.beta),'FontSize',myui.fontsize,...
    'UserData',struct('Tooltipstr',tstr,'defaults',[data.invjoint.beta 1 1]),...
    'Tag','invjoint_beta','Enable','off','Callback',@onEditValue);
gui.edit_handles.invjoint_gamma = uicontrol('Parent',gui.panels.invjoint.HBox7,...
    'Style','edit','String',num2str(data.invjoint.gamma),'FontSize',myui.fontsize,...
    'UserData',struct('Tooltipstr',tstr,'defaults',[data.invjoint.gamma 1 1]),...
    'Tag','invjoint_gamma','Enable','off','Callback',@onEditValue);
set(gui.panels.invjoint.HBox7,'Widths',[200 -1 -1 -1]);

%% start values for rho and angle
gui.text_handles.invjoint_startvalues = uicontrol('Parent',gui.panels.invjoint.HBox8,...
    'Style','text','FontSize',myui.fontsize,'HorizontalAlignment','center',...
    'String',['start values - ',char(hex2dec('03C1')),' [�m/s] | ',char(hex2dec('03B2')),' [�]']);
tstr = 'tba';
gui.edit_handles.invjoint_rhostart = uicontrol('Parent',gui.panels.invjoint.HBox8,...
    'Style','edit','String',num2str(data.invjoint.rhostart),'FontSize',myui.fontsize,...
    'UserData',struct('Tooltipstr',tstr,'defaults',[data.invjoint.rhostart 1 1]),...
    'Tag','invjoint_rhostart','Enable','off','Callback',@onEditValue);
tstr = 'tba';
gui.edit_handles.invjoint_anglestart = uicontrol('Parent',gui.panels.invjoint.HBox8,...
    'Style','edit','String',num2str(data.invjoint.anglestart),'FontSize',myui.fontsize,...
    'UserData',struct('Tooltipstr',tstr,'defaults',[data.invjoint.anglestart 1 1]),...
    'Tag','invjoint_anglestart','Enable','off','Callback',@onEditValue);
set(gui.panels.invjoint.HBox8,'Widths',[200 -1 -1]);

%% RUN button
gui.text_handles.invjoint_run = uicontrol('Parent',gui.panels.invjoint.HBox9,...
    'Style','text','FontSize',myui.fontsize,'HorizontalAlignment','center',...
    'String','run Inversion');
gui.push_handles.invjoint_run = uicontrol('Parent',gui.panels.invjoint.HBox9,'Enable','off',...
    'String','<HTML><u>R</u>UN','FontSize',myui.fontsize,'BackGroundColor','g',...
    'Tag','joint','UserData',1,'Callback',@onPushRun);
set(gui.panels.invjoint.HBox9,'Widths',[200 -1]);

%% pressure units
gui.text_handles.invjoint_pressure_units = uicontrol('Parent',gui.panels.invjoint.HBox10,...
    'Style','text','FontSize',myui.fontsize,'HorizontalAlignment','center',...
    'String','pressure unit');
tstr = ['<HTML>Set pressure unit<br><br>',...
    '<u>Available options:</u><br>',...
    '<b>Pa</b>, <b>kPa</b>, <b>MPa</b> and <b>bar</b> <br><br>',...
    '<u>Default value:</u><br>',...
    '<b>Pa</b><br>'];
gui.popup_handles.invjoint_pressure_units = uicontrol('Parent',gui.panels.invjoint.HBox10,...
    'Style','popup','String',{'Pa','kPa','MPa','bar'},...
    'Value',1,'FontSize',myui.fontsize,'UserData',struct('Tooltipstr',tstr),...
    'Enable','off','Callback',@onPopupPressureUnits);
set(gui.panels.invjoint.HBox10,'Widths',[100 -1]);

%% push buttons ADD DEL LOAD
uix.Empty('Parent',gui.panels.invjoint.HBox11);
gui.push_handles.invjoint_Add = uicontrol('Parent',gui.panels.invjoint.HBox11,...
    'Style','pushbutton','String','+','UserData',struct('Tooltipstr',tstr),...
    'FontSize',myui.fontsize,'HorizontalAlignment','center','Enable','off',...
    'Callback',@onPushCPSTable);
set(gui.panels.invjoint.HBox11,'Widths',[-1 50]);

uix.Empty('Parent',gui.panels.invjoint.HBox12);
gui.push_handles.invjoint_Delete = uicontrol('Parent',gui.panels.invjoint.HBox12,...
    'Style','pushbutton','String','-','UserData',struct('Tooltipstr',tstr),...
    'FontSize',myui.fontsize,'HorizontalAlignment','center','Enable','off',...
    'Callback',@onPushCPSTable);
set(gui.panels.invjoint.HBox12,'Widths',[-1 50]);

uix.Empty('Parent',gui.panels.invjoint.HBox13);
gui.push_handles.invjoint_Load = uicontrol('Parent',gui.panels.invjoint.HBox13,...
    'Style','pushbutton','String','LOAD','UserData',struct('Tooltipstr',tstr),...
    'FontSize',myui.fontsize,'HorizontalAlignment','center','Enable','off',...
    'Callback',@onPushCPSTable);
set(gui.panels.invjoint.HBox13,'Widths',[-1 50]);

%% the CPS table
gui.table_handles.invjoint_table = uitable('Parent',gui.panels.invjoint.VBox2,...
    'Data',data.pressure.table,'CellEditCallback',@onEditCPSTable,...
    'ColumnFormat',({'logical' 'numeric' 'numeric' {'D' 'I'}}),...
    'ColumnEditable',true,'FontSize',myui.fontsize,...
    'ColumnName',{'use','p [Pa]','S [-]','D / I'},...
    'RowName','','Enable','off');

%% Java Hack to adjust vertical alignment of text fields
jh = findjobj(gui.text_handles.invjoint_InvType);
jh.setVerticalAlignment(javax.swing.JLabel.CENTER);
jh = findjobj(gui.text_handles.invjoint_radii);
jh.setVerticalAlignment(javax.swing.JLabel.CENTER);
jh = findjobj(gui.text_handles.invjoint_InvTypeOpt);
jh.setVerticalAlignment(javax.swing.JLabel.CENTER);
jh = findjobj(gui.text_handles.invjoint_Lorder);
jh.setVerticalAlignment(javax.swing.JLabel.CENTER);
jh = findjobj(gui.text_handles.invjoint_lambda);
jh.setVerticalAlignment(javax.swing.JLabel.CENTER);
jh = findjobj(gui.text_handles.invjoint_geometry_type);
jh.setVerticalAlignment(javax.swing.JLabel.CENTER);
jh = findjobj(gui.text_handles.invjoint_angles);
jh.setVerticalAlignment(javax.swing.JLabel.CENTER);
jh = findjobj(gui.text_handles.invjoint_startvalues);
jh.setVerticalAlignment(javax.swing.JLabel.CENTER);
jh = findjobj(gui.text_handles.invjoint_run);
jh.setVerticalAlignment(javax.swing.JLabel.CENTER);

%% Java Hacks work only on "visible" objects
% set focus on CPS sub panel
set(gui.panels.invjoint.TabSettings,'Visible','off');
set(gui.panels.invjoint.TabCPS,'Visible','on');
% adjust the width of the CPS table
pos = get(gui.table_handles.invjoint_table,'Position');
w_total = pos(3);
w1 = floor(w_total/6)-1;
w2 = floor((w_total-(w1*2))/2)-1;
% w = floor(pos(3)/4)-1;
set(gui.table_handles.invjoint_table,'ColumnWidth',{w1 w2 w2 w1});
% Java Hack to adjust the text fields vertical alignment
jh = findjobj(gui.text_handles.invjoint_pressure_units);
jh.setVerticalAlignment(javax.swing.JLabel.CENTER);
% set focus back on settings sub panel
set(gui.panels.invjoint.TabCPS,'Visible','off');
set(gui.panels.invjoint.TabSettings,'Visible','on');

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