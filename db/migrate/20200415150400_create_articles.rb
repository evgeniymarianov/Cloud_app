class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.string :name
      t.string :preview
      t.string :text
      t.string :author

      t.timestamps
    end
  end
end
