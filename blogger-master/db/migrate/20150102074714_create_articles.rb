class CreateArticles < ActiveRecord::Migration
  create_table :articles do |t|
    t.string :title
    t.text :body

    t.timestamps
  end
end
