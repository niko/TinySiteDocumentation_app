require 'tiny_site'

use Rack::CommonLogger
use Rack::ContentLength
use Rack::Static, :urls => ['/stylesheets','/javascript'], :root => 'public'

run TinySite.new :file_path => 'http://dl.dropbox.com/u/1343338/tiny-site-files'

