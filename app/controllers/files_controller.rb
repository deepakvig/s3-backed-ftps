class FilesController < ApplicationController
  before_filter :get_ftps_connection
  after_filter :close_ftps_connection

  def index
    @dirs, @files = FtpManager.seg(@ftps.list)
    @current_dir = @ftps.pwd.gsub!("/","")
  end

  def download
    localfile = params[:file]
    @ftps.get(params[:dir],localfile)
    flash[:notice] = "Successfully downloaded file #{localfile} to root directory!"
    redirect_to files_path
  end

  def chdir
    dir_path = ""
    dir_path = params[:prev_dir] + "/" if params[:prev_dir] and !params[:prev_dir].blank?
    dir_path += params[:dir]
    puts dir_path
    @ftps.chdir(dir_path)
    @dirs, @files = FtpManager.seg(@ftps.list)
    current_path = @ftps.pwd.reverse #.gsub!("/","")
    @prev_dir = current_path[current_path.index("/")+1..-1].reverse
    @current_dir = current_path.reverse
    render :index
  end

  private
  def get_ftps_connection
    @ftps = FtpManager.connect
  end

  def close_ftps_connection
    @ftps.close
  end
end
