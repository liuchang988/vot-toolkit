function [sequences, experiments] = gui_test_init(varargin)
% workspace_load Initializes the current workspace
%
% This function initializes the current workspace by reading sequences and
% experiments as well as initializing global variables. It also checks if native
% resources have to be downloaded or compiled.
%
% To make loading faster when running the script multiple times, it checks if
% sequences and experiments variables exist in the workspace and if they are
% cell arrays and just reuses them. No further check is performed so this may
% lead to problems when switching workspaces. Clear the workspace or use 'Force'
% argument to avoid issues with cached data.
%
% Input:
% - varargin[Force] (boolean): Force reloading the sequences and experiments.
% - varargin[Directory] (string): Set the directory of the workspace (otherwise
%   current directory is used.
% - varargin[OnlyDefaults] (boolean): Only set default global variables and skip
%   workspace initialization.
%
% Output:
% - sequences (cell): Array of sequence structures.
% - experiments (cell): Array of experiment structures.
%

force = false;
directory = pwd();
only_defaults = false;

args = varargin;
for j=1:2:length(args)
    switch lower(varargin{j})
        case 'directory', directory = args{j+1};
        case 'force', force = args{j+1};
        case 'onlydefaults', only_defaults = args{j+1};
        otherwise, error(['unrecognized argument ' args{j}]);
    end
end

if ~force

    try

        % Attempts to load variables from the workspace namespace to save
        % some time
        sequences = evalin('base', 'sequences');

        % Are variables correts at a glance ...
        cached = iscell(sequences);

    catch

        cached = false;

    end

else

    cached = false;

end;

% Some defaults
set_global_variable('toolkit_path', fileparts(fileparts(mfilename('fullpath'))));
set_global_variable('indent', 0);
set_global_variable('directory', directory);
set_global_variable('debug', 0);
set_global_variable('cache', 1);
set_global_variable('bundle', []);
set_global_variable('cleanup', 1);
set_global_variable('trax_mex', []);
set_global_variable('trax_client', []);
set_global_variable('trax_timeout', 30);
set_global_variable('matlab_startup_model', [923.5042, -4.2525]);
set_global_variable('legacy_rasterization', false);
set_global_variable('native_path', fullfile(get_global_variable('toolkit_path'), 'native'));

if only_defaults
	sequences = {};
	experiments = {};
	return;
end;

print_text('Initializing workspace ...');

if ~strcmp(directory, pwd())
    addpath(directory);
end;

mkpath(get_global_variable('native_path'));
rmpath(get_global_variable('native_path')); rehash; % Try to avoid locked files on Windows
initialize_native();
addpath(get_global_variable('native_path'));

experiment_stack = get_global_variable('stack', 'vot2013');
stack_configuration = str2func(['stack_', experiment_stack]);
experiments = stack_configuration();

if cached
    print_debug('Skipping loading sequence data (using cached structures)');
else

    sequences_directory = get_global_variable('sequences_path',...
        fullfile(get_global_variable('workspace_path'), 'sequences'));

    print_text('Loading sequences ...');

    sequences = load_sequences(sequences_directory, ...
        'list', get_global_variable('sequences', 'list.txt'));

    if isempty(sequences)
        error('No sequences available. Stopping.');
    end;

end;

end