require 'tiny_site'

use Rack::CommonLogger
use Rack::ContentLength
use Rack::Static, :urls => ['/stylesheets','/javascript'], :root => 'public'

run TinySite.new :file_path => 'https://www.dropbox.com/s/d55gpsn2e4196uh'

