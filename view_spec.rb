require 'rspec'
require 'rack'

$LOAD_PATH << File.dirname(File.expand_path __FILE__)

class TinySite; end

#noops
def run(*a); end
def use(*a); end

load 'config.ru'

describe TinySite::View do
  before(:each) do
    @app = stub(:app)
    @view = TinySite::View.new(@app)
  end
  describe "#link_to" do
    describe "with just one argument" do
      it "uses this for href and text" do
        link = '<a href="http://foo">http://foo</a>'
        @view.link_to('http://foo').should == link
      end
      it "renders opts" do
        link = '<a href="http://foo" class="class" id="id">http://foo</a>'
        @view.link_to('http://foo', :class => 'class', :id => 'id').should == link
      end
    end
    describe "with two arguments" do
      it "uses these for href and text" do
        link = '<a href="http://foo">bar</a>'
        @view.link_to('http://foo', 'bar').should == link
      end
      it "renders opts, too" do
        link = '<a href="http://foo" class="class" id="id">bar</a>'
        @view.link_to('http://foo', 'bar', :class => 'class', :id => 'id').should == link
      end
    end
  end
  describe "#navigation" do
    before(:each) do
      nav = {
        '/' => 'Home',
        '/page_one' => 'one',
        '/page_two' => 'two',
      }
      @view.stub! :global => {:navigation => nav}, :request_path => '/page_one'
    end
    it "returns a ul for the given navigation" do
      @view.navigation.should == <<-EON
<ul>
  <li><a href="/">Home</a></li>
  <li><a href="/page_one" class="active">one</a></li>
  <li><a href="/page_two">two</a></li>
</ul>
EON
    end
  end
end
