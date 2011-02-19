class CreateFanfictionStories < ActiveRecord::Migration
  def self.up
    create_table :fanfiction_stories do |t|
      t.string :language
      t.string :medium
      t.string :work
      t.integer :story_id
      t.string :title
      t.integer :author_id
      t.string :author_name
      t.datetime :publish_date
      t.datetime :update_date
      t.string :rating
      t.string :genre
      t.string :character_a
      t.string :character_b
      t.boolean :completed
      t.integer :words
      t.integer :chapters
      t.integer :reviews
    end
    add_index :fanfiction_stories, :story_id
    add_index :fanfiction_stories, :language
    add_index :fanfiction_stories, :reviews
    add_index :fanfiction_stories, :words
  end

  def self.down
    remove_index :fanfiction_stories, :story_id
    add_index :fanfiction_stories, :language
    add_index :fanfiction_stories, :reviews
    add_index :fanfiction_stories, :words
    drop_table :fanfiction_stories
  end
end