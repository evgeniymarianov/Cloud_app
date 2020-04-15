require 'rails_helper'

RSpec.describe "articles/new", type: :view do
  before(:each) do
    assign(:article, Article.new(
      :name => "MyString",
      :preview => "MyString",
      :text => "MyString",
      :author => "MyString"
    ))
  end

  it "renders new article form" do
    render

    assert_select "form[action=?][method=?]", articles_path, "post" do

      assert_select "input[name=?]", "article[name]"

      assert_select "input[name=?]", "article[preview]"

      assert_select "input[name=?]", "article[text]"

      assert_select "input[name=?]", "article[author]"
    end
  end
end
