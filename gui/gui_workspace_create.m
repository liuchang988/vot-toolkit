function gui_workspace_create(tracker, language)
% workspace_create Initialize a new VOT workspace
%
% This function serves as a guided initialization of a workspace. It generates
% all the basic scripts to run your tracker on an experiment stack based on a
% series of questions.
%
% Input:
% - varargin[Tracker] (boolean, string): Generate a new tracker, if boolean, the
%   identifier of a tracker will be obtained interactively.
% - varargin[Stack] (string): Select a stack as an input.
%

script_directory = fileparts(mfilename('fullpath'));

addpath(fileparts(script_directory));
toolkit_path; % Setup the full toolkit path just in case

set_global_variable('toolkit_path', fileparts(script_directory));
set_global_variable('indent', 0);
set_global_variable('directory', pwd());

directory = get_global_variable('directory');

if ~isascii(get_global_variable('toolkit_path'))
    warndlg('Toolkit path contains non-ASCII characters. This may cause problems.')
end

if ~isascii(directory)
    warndlg('Workspace path contains non-ASCII characters. This may cause problems.')
end

% Check if the directory is already a valid VOT workspace ...
configuration_file = fullfile(directory, 'configuration.m');

if exist(configuration_file, 'file')
    errordlg('Directory is probably already a VOT workspace.');
    return;
end

% Copy configuration templates ...

templates_directory = fullfile(script_directory, 'templates');

version = toolkit_version();

tracker_identifier = tracker;
tracker = true;

if ~valid_identifier(tracker_identifier)
    errordlg('Not a valid tracker identifier!');
    return;
end

if tracker
    gui_tracker_create(tracker_identifier, directory, language);
end

variables = {'version', num2str(version.major), ...
    'tracker', tracker_identifier, ...
    'toolkit', get_global_variable('toolkit_path')};

generate_from_template(fullfile(directory, 'configuration.m'), ...
    fullfile(templates_directory, 'configuration.tpl'), variables{:});

generate_from_template(fullfile(directory, 'run_experiments.m'), ...
    fullfile(templates_directory, 'run_experiments.tpl'), variables{:});

generate_from_template(fullfile(directory, 'run_test.m'), ...
    fullfile(templates_directory, 'run_test.tpl'), variables{:});

generate_from_template(fullfile(directory, 'run_pack.m'), ...
    fullfile(templates_directory, 'run_pack.tpl'), variables{:});

generate_from_template(fullfile(directory, 'run_browse.m'), ...
    fullfile(templates_directory, 'run_browse.tpl'), variables{:});

generate_from_template(fullfile(directory, 'run_analysis.m'), ...
    fullfile(templates_directory, 'run_analysis.tpl'), variables{:});

set_global_variable('native_path', fullfile(get_global_variable('toolkit_path'), 'native'));
mkpath(get_global_variable('native_path'));
rmpath(get_global_variable('native_path')); rehash; % Try to avoid locked files on Windows
initialize_native();
addpath(get_global_variable('native_path'));
