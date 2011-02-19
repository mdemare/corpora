class CreateWikipediaArticles < ActiveRecord::Migration
  def self.up
    create_table :wikipedia_articles, :options => "ENGINE=MyISAM" do |t|
      t.string :title
      t.string :language
      t.string :githash
    end
    add_index :wikipedia_articles, :title
  end

  def self.down
    remove_index :wikipedia_articles, :title
    drop_table :wikipedia_articles
  end
end