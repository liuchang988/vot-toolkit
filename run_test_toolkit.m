% configuration to be set in GUI

toolkit_dir = '/Users/SuperLC/Desktop/VOT_workspace/vot-toolkit';
workspace_dir = '/Users/SuperLC/Desktop/VOT_workspace/workspaces/vot-struck';
stack_name = 'test';

addpath(toolkit_dir);
addpath(workspace_dir);
cd(workspace_dir);

set_global_variable('check_updates', false);
set_global_variable('toolkit_dir', toolkit_dir);
set_global_variable('workspace_dir', workspace_dir);
set_global_variable('stack', stack_name);
set_global_variable('sequences_path',... 
    fullfile(get_global_variable('toolkit_dir', toolkit_dir),...
    'sequences', stack_name));

run_test();

cd(toolkit_dir);
