require 'net/ftp'
require 'double_bag_ftps'

class FtpManager


  def self.connect

    ftp = Net::FTP.new
    ftp.connect("0.0.0.0","2100")
    ftp.login("admin", "test123")
    return ftp
 
    #ftps = DoubleBagFTPS.new
    #ftps.ssl_context = DoubleBagFTPS.create_ssl_context(:verify_mode => OpenSSL::SSL::VERIFY_NONE)
    #ftps.connect('0.0.0.0', '2100')
    #ftps.login('usr', 'passwd')
    #ftps = DoubleBagFTPS.new
    #ftps.connect('0.0.0.0', '2100')
    #ftps.login('user', 'test123', nil,DoubleBagFTPS::IMPLICIT) 
    #ftps = DoubleBagFTPS.open('0.0.0.0:2100', 'user', 'test123', nil, DoubleBagFTPS::IMPLICIT)
  end

  def self.seg(frams)
    puts frams
    dirs = []
    files = []
    frams.each do |f|
      if f[0] == "d"
        dirs << f if f.split(/\s+/).last != ".."
      else
        files << f if f.split(/\s+/).last != "passwd"
      end
    end
    return dirs, files
  end

end
