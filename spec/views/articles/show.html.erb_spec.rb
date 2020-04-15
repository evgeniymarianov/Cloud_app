require 'rails_helper'

RSpec.describe "articles/show", type: :view do
  before(:each) do
    @article = assign(:article, Article.create!(
      :name => "Name",
      :preview => "Preview",
      :text => "Text",
      :author => "Author"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Preview/)
    expect(rendered).to match(/Text/)
    expect(rendered).to match(/Author/)
  end
end
