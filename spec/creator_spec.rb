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

  end
end
