# LOAD DATA INFILE "/home/mdemare/corpora/ingredients/chapters.txt" INTO TABLE fanfiction_chapters FIELDS TERMINATED BY "," (story,chapter,githash);
class CreateFanfictionChapters < ActiveRecord::Migration
  def self.up
    create_table :fanfiction_chapters, :options => "ENGINE=MyISAM" do |t|
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

