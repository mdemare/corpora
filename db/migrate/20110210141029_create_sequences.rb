class CreateSequences < ActiveRecord::Migration
  def self.up
    create_table :sources, :options => "ENGINE=MyISAM" do |t|
      t.string :lang, :null => false
      t.string :corpus, :null => false
    end
  end

  def self.down
    drop_table :sequences
  end
end
