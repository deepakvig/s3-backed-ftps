class FilesController < ApplicationController
  before_filter :get_ftps_connection
  after_filter :close_ftps_connection

  def index
    @dirs, @files = FtpManager.seg(@ftps.list)
    current_path = @ftps.pwd.reverse #.gsub!("/","")
    @prev_dir = current_path[current_path.index("/")+1..-1].reverse
    @current_dir = current_path.reverse
  end

  def download
    localfile = params[:file]
    @ftps.get(get_download_path(params[:dir],localfile),localfile)
    flash[:alert] = "Successfully downloaded file #{localfile} to root directory!"
    redirect_to chdir_files_path(:dir => params[:dir])
  end

  def chdir
    @ftps.chdir(get_directory_path(params[:prev_dir], params[:dir]))
    @dirs, @files = FtpManager.seg(@ftps.list)
    current_path = @ftps.pwd.reverse #.gsub!("/","")
    @prev_dir = current_path[current_path.index("/")+1..-1].reverse
    @current_dir = current_path.reverse
    render :index
  end

  def upload
    if params[:file]
      path = params[:current_dir] == "/" ? "" : params[:current_dir]
      @ftps.putbinaryfile(params[:file].path, remotefile = path+"/"+params[:file].original_filename)
      flash[:alert] = "File Uploaded Successfully"
    end
    redirect_to chdir_files_path(:dir => params[:current_dir]) 
  end

  private
  def get_ftps_connection
    @ftps = FtpManager.connect
  end

  def close_ftps_connection
    @ftps.close
  end

  def get_download_path(dir, file)
    file_path = dir+"/"+ file if dir != "/"
    file_path = dir+file if dir == "/"
    file_path
  end

  def get_directory_path(prev_dir, dir)
    dir_path = ""
    dir_path = params[:prev_dir] + "/" if params[:prev_dir] and !params[:prev_dir].blank?
    dir_path += params[:dir]
    dir_path
  end
end
