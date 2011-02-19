class CreateFanfictionStories < ActiveRecord::Migration
  def self.up
    create_table :fanfiction_stories, :options => "ENGINE=MyISAM", :id => false do |t|
      t.integer :id
      t.column :language, "char(2)"
      t.string :medium
      t.string :work
      t.string :title
      t.integer :author_id
      t.string :author_name
      t.date :publish_date
      t.date :update_date
      t.column :rating, "char(2)"
      t.string :genre
      t.string :character_a
      t.string :character_b
      t.boolean :completed
      t.column :words, "mediumint unsigned"
      t.column :chapters, "smallint unsigned"
      t.column :reviews, "mediumint unsigned"
    end
    add_index :fanfiction_stories, :id
    add_index :fanfiction_stories, :language
    add_index :fanfiction_stories, :reviews
    add_index :fanfiction_stories, :words
  end

  def self.down
    drop_table :fanfiction_stories
  end
end