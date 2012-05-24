require File.dirname(__FILE__) + '/spec_helper.rb'

# Time to add your specs!
# http://rspec.info/
describe "Mdslide" do
  it 'has some themes' do
    Mdslide::Themes.should have_key(:white)
    Mdslide::Themes[:white][:css].should have_at_least(1).item
    Mdslide::Themes.should have_key(:black)
    Mdslide::Themes[:black][:css].should have_at_least(1).item
  end

  describe "Creator" do
    before do
      @creator = Mdslide::Creator.new
    end

    it "can be initialized" do
      @creator.should be_true
      @creator.should be_kind_of(Mdslide::Creator)
    end
    it "can be set theme" do
      @creator.set_theme('black').should be_true
      @creator.theme_stylesheets.should have_at_least(1).items
    end
    it "can convert markdown" do
      slide = @creator.convert_markdown("sample")
      slide.should be_true
      slide.should be_kind_of(String)
    end
    it "can make url-link automatically" do
      slide = @creator.convert_markdown("hogehoge\nhttp://example.com/test1\naaa https://example.com/test2/ bbb")
      slide.match(%r|<a[^>]+href="http://example.com/test1"[^>]*>http://example.com/test1</a>|).should be_true
      slide.match(%r|<a[^>]+href="https://example.com/test2/"[^>]*>https://example.com/test2/</a>|).should be_true
    end
    it "can make link to twitter accounts" do
      slide = @creator.convert_markdown("@ymrl")
      slide.match(%r|<a[^>]+href="https://twitter.com/ymrl"[^>]*>@ymrl</a>|).should be_true
    end
  end
end
