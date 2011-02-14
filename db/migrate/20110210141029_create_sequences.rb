class CreateSequences < ActiveRecord::Migration
  def self.up
    create_table :seq_01, :options => "ENGINE=MyISAM" do |t|
      t.column :id, "integer unsigned", :null => false
      t.binary :compressed_sentences, :null => false
    end
    add_index :seq_01, [:id], :unique => true

    create_table :sources, :options => "ENGINE=MyISAM" do |t|
      t.string :lang, :null => false
      t.string :corpus, :null => false
    end
  end

  def self.down
    drop_table :sequences
  end
end
