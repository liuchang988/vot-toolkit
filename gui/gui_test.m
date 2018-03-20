function [tracker, data] = gui_test(tracker, sequences, app)
% workspace_test Tests the integration of a tracker into the toolkit
%
% Tests the integration of a tracker into the toolkit in a manual or
% automatic mode, visualizes results and estimates time to complete
% an experiment.
%
% Input:
% - tracker (structure): A valid tracker structure.
% - sequences (cell or structure): Array of sequence structures.
%

debug_state = get_global_variable('trax_debug', false);
set_global_variable('trax_debug', true);
set_global_variable('trax_debug_console', true);

if is_octave()
use_gui = get_global_variable('gui', true);
else
use_gui = get_global_variable('gui', usejava('awt'));
end

try

    if ~isempty(sequences)

        data.figure = 1;
        data.sequence = sequences{1};
        data.index = 1;
        data.gui = use_gui;
        data.app = app;

        tracker_run(tracker, @callback, data);

    else
        % break;
    end

catch e
    % Restore debug flag
    set_global_variable('trax_debug', debug_state);
    set_global_variable('trax_debug_console', false);
    rethrow(e);
end

end


function [image, region, properties, data] = callback(state, data)

	region = [];
	image = [];
    properties = struct();

	if isempty(state.region)
		region = get_region(data.sequence, data.index);
		image = get_image(data.sequence, data.index);
		return;
	end
	if data.gui

        update_gui(state, data);
        
		try
		    [~, ~, c] = ginput(1);
		catch
		    c = -1;
		end
		try
		    if c == ' ' || c == 'f' || uint8(c) == 29

		    elseif c == 'q' || c == -1
		        print_text('Quitting.');
		        return;
		    end
		catch e
		    print_text('Error %s', e.message);
		end

	else

		c = input('(space/Q) ', 's');

		if c == 'q'
			print_text('Quitting.');
		    return;
		end
    end

	data.index = data.index + 1;

	% End of sequence
	if data.index > data.sequence.length
		return;
	end

    image = get_image(data.sequence, data.index);

end
