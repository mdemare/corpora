class CreateFanfictionChapters < ActiveRecord::Migration
  def self.up
    create_table :fanfiction_chapters do |t|
      t.integer :story
      t.integer :chapter
      t.string :githash
    end
    add_index :fanfiction_chapters, :story
  end

  def self.down
    remove_index :fanfiction_chapters, :story
    drop_table :fanfiction_chapters
  end
end