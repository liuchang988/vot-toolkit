function folders = get_folders(path)

folders = {};

files = dir(path);
for i = 1:length(files)
    file = files(i);
    if file.isdir == 1 && file.name(1) ~= '.' && file.name(1) ~= '_'
        folders = [folders file.name];
    end
end