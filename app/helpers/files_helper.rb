module FilesHelper

  def format_name(file)
    file.split(/\s+/).last
  end

  def folder_path(dir, current_dir)
    folder_path = format_name(dir)
    folder_path = current_dir + "/" + folder_path if current_dir != "/"
    folder_path
  end

end
