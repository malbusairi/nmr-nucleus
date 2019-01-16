function gui = NUCLEUSmod_createMenus(gui)
%NUCLEUSmod_createMenus creates all GUI menus
%
% Syntax:
%       gui = NUCLEUSmod_createMenus(gui)
%
% Inputs:
%       gui - figure gui elements structure
%
% Outputs:
%       gui
%
% Example:
%       gui = NUCLEUSmod_createMenus(gui)
%
% Other m-files required:
%       none
%
% Subfunctions:
%       none
%
% MAT-files required:
%       none
%
% See also: NUCLEUSmod
% Author: Thomas Hiller
% email: thomas.hiller[at]leibniz-liag.de
% License: MIT License (at end)

%------------- BEGIN CODE --------------

%% 1. File
gui.menu.file = uimenu(gui.figh,...
    'Label','File');

% 1.1 Import
gui.menu.file_import = uimenu(gui.menu.file,...
    'Label','Import','Callback',@onMenuImport);

% 1.2 Export
gui.menu.file_export = uimenu(gui.menu.file,...
    'Label','Export');
% 1.2.1 Data
gui.menu.file_export_data = uimenu(gui.menu.file_export,...
    'Label','Data');
% 1.2.1.1 NMRMOD mat-file
gui.menu.file_export_data_mat = uimenu(gui.menu.file_export_data,...
    'Label','NUCLEUSmod','Callback',@onMenuExportData);
% 1.2.1.2 excel-file
gui.menu.file_export_data_xls = uimenu(gui.menu.file_export_data,...
    'Label','XLS file','Callback',@onMenuExportData);
% 1.2.1.3 csv-file
gui.menu.file_export_data_csv = uimenu(gui.menu.file_export_data,...
    'Label','CSV file','Callback',@onMenuExportData);
% 1.2.1.4 dat-file
gui.menu.file_export_data_dat = uimenu(gui.menu.file_export_data,...
    'Label','DAT files','Callback',@onMenuExportData);

% 1.2.2 Graphics
gui.menu.file_export_graphics = uimenu(gui.menu.file_export,...
    'Label','Graphics');
% 1.2.2.1 Layout
gui.menu.file_export_graphics_layout = uimenu(gui.menu.file_export_graphics,...
    'Label','Layout');
% 1.2.2.1.1 Layout vertical
gui.menu.file_export_graphics_layout_vert = uimenu(gui.menu.file_export_graphics_layout,...
    'Label','vert','Checked','on','Callback',@onMenuExportGraphics);
% 1.2.2.1.2 Layout horizontal
gui.menu.file_export_graphics_layout_horz = uimenu(gui.menu.file_export_graphics_layout,...
    'Label','horz','Callback',@onMenuExportGraphics);
% 1.2.2.2 fig
gui.menu.file_export_graphics_fig = uimenu(gui.menu.file_export_graphics,...
    'Label','FIG','Callback',@onMenuExportGraphics);
% 1.2.2.3 png
gui.menu.file_export_graphics_png = uimenu(gui.menu.file_export_graphics,...
    'Label','PNG','Callback',@onMenuExportGraphics);
% 1.2.2.4 tiff
gui.menu.file_export_graphics_tiff = uimenu(gui.menu.file_export_graphics,...
    'Label','TIFF','Callback',@onMenuExportGraphics);
% 1.2.2.5 eps
gui.menu.file_export_graphics_eps = uimenu(gui.menu.file_export_graphics,...
    'Label','EPS','Callback',@onMenuExportGraphics);

% 1.3 Restart
gui.menu.file_restart = uimenu(gui.menu.file,...
    'Label','Restart','Separator','on','Callback',@onMenuRestartQuit);

% 1.4 Quit
gui.menu.file_quit = uimenu(gui.menu.file,...
    'Label','Quit','Separator','on','Callback',@onMenuRestartQuit);

%% 2. Extra
gui.menu.extra = uimenu(gui.figh,...
    'Label','Extra');

% 2.1 Show
gui.menu.extra_show = uimenu(gui.menu.extra,...
    'Label','Show');
% 2.1.1 tooltips (on/off)
gui.menu.extra_show_tooltips = uimenu(gui.menu.extra_show,...
    'Label','Tooltips');
gui.menu.extra_show_tooltips_on = uimenu(gui.menu.extra_show_tooltips,...
    'Label','On','Callback',@onMenuExtraShow);
gui.menu.extra_show_tooltips_off = uimenu(gui.menu.extra_show_tooltips,...
    'Label','Off','Checked','on','Callback',@onMenuExtraShow);

% 2.2 color theme
gui.menu.extra_theme = uimenu(gui.menu.extra,...
    'Label','Color Theme');
% 2.2.1 default color theme
gui.menu.extra_theme_standard = uimenu(gui.menu.extra_theme,...
    'Label','standard','Checked','on','Callback',@onMenuExtraColor);
% 2.2.2 basic color theme
gui.menu.extra_theme_basic = uimenu(gui.menu.extra_theme,...
    'Label','basic','Callback',@onMenuExtraColor);
% 2.2.3 dark color theme
gui.menu.extra_theme_dark = uimenu(gui.menu.extra_theme,...
    'Label','dark','Callback',@onMenuExtraColor);

%% 3. Help
gui.menu.help = uimenu(gui.figh,...
    'Label','Help');

% 3.1 About
gui.menu.help_about = uimenu(gui.menu.help,...
    'Label','About','Callback',@onMenuHelp);

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