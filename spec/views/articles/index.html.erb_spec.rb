require 'rails_helper'

RSpec.describe "articles/index", type: :view do
  before(:each) do
    assign(:articles, [
      Article.create!(
        :name => "Name",
        :preview => "Preview",
        :text => "Text",
        :author => "Author"
      ),
      Article.create!(
        :name => "Name",
        :preview => "Preview",
        :text => "Text",
        :author => "Author"
      )
    ])
  end

  it "renders a list of articles" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Preview".to_s, :count => 2
    assert_select "tr>td", :text => "Text".to_s, :count => 2
    assert_select "tr>td", :text => "Author".to_s, :count => 2
  end
end
