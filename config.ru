# I use this for local testing. Hopefully I don't check this in.
$LOAD_PATH << File.join( File.expand_path(File.dirname(__FILE__)), '../tiny_site/lib')

require 'tiny_site'
require 'tiny_site/version'

module Rack
  class Runtime
    def initialize(app)
      @app = app
    end
    def call(env)
      started_at = Time.now
      status, headers, body = @app.call(env)
      duration = Time.now - started_at
      headers['X-Runtime'] = ("%0.6f" % duration)
      [status, headers, body]
    end
  end
end


use Rack::CommonLogger
use Rack::ContentLength
use Rack::Runtime
use Rack::Static, :urls => ['/stylesheets','/javascript'], :root => 'public'

class TinySite::View
  def link_to(url, name=url, opts={})
    opts, name = name, url if name.is_a? Hash
    
    o = opts.map{|k,v| %Q{ #{k}="#{v}"} }.join
    
    %Q{<a href="#{url}"#{o}>#{name}</a>}
  end
  
  def navigation
    lis = global[:navigation].map do |url,name|
      opts  = {}
      
      opts.update({:class => 'active'}) if request_path==url
      
      %Q{  <li>#{link_to url, name, opts}</li>\n}
    end
    
    %Q{<ul>\n#{lis.join}</ul>\n}
  end
end

run TinySite.new :file_path => 'https://dl.dropbox.com/s/d55gpsn2e4196uh', :file_path_postfix => '?dl=1'

