function [identifier] = gui_tracker_create(identifier, directory, selected_interpreter)
% tracker_create Generate a new tracker configuration file
%
% This function helps with creation of a new tracker configuration file.
%
% Input:
% - varargin[Identifier] (string): Identifier of the new tracker. Must be a valid tracker name.
% - varargin[Directory] (string): Directory where the configuration file will be created.
%

if ~valid_identifier(identifier)
    errordlg('Not a valid tracker identifier!');
    return;
end

variables = {'tracker', identifier};

interpreter_names = {'Matlab', 'Python', 'C/C++', 'Octave', 'None of the above'};
interpreter_ids = {'matlab', 'python', '', 'octave', ''};

if isempty(selected_interpreter) || selected_interpreter < 1 || selected_interpreter > length(interpreter_ids)
    selected_interpreter = numel(interpreter_names);
end

if ~isempty(interpreter_ids{selected_interpreter})
    template_name = sprintf('tracker_%s.tpl', interpreter_ids{selected_interpreter});
else
    template_name = 'tracker.tpl';
end

generate_from_template(fullfile(directory, ['tracker_', identifier, '.m']), ...
    fullfile(fileparts(mfilename('fullpath')), 'templates', template_name), variables{:});

