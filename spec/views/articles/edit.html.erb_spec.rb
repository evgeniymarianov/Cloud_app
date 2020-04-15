require 'rails_helper'

RSpec.describe "articles/edit", type: :view do
  before(:each) do
    @article = assign(:article, Article.create!(
      :name => "MyString",
      :preview => "MyString",
      :text => "MyString",
      :author => "MyString"
    ))
  end

  it "renders the edit article form" do
    render

    assert_select "form[action=?][method=?]", article_path(@article), "post" do

      assert_select "input[name=?]", "article[name]"

      assert_select "input[name=?]", "article[preview]"

      assert_select "input[name=?]", "article[text]"

      assert_select "input[name=?]", "article[author]"
    end
  end
end
