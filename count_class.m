function count = count_class(dir_name)
    all_files = dir(dir_name);
    all_dir = all_files([all_files(:).isdir]);
    count = numel(all_dir)-2;
end