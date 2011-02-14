class CreateTokens < ActiveRecord::Migration
  def self.up
    create_table :tokens_01, :options => "ENGINE=MyISAM", :id => false do |t|
      t.column :id, "mediumint unsigned", :null => false
      t.string :word
      t.column :wtoken1_id, "integer unsigned", :null => false
      t.column :wtoken2_id, "integer unsigned", :null => false
      t.column :frequency, "integer unsigned", :null => false
      t.column :frequency_title, "integer unsigned", :null => false
      t.column :frequency_upper, "integer unsigned", :null => false
    end
    add_index :tokens_01, [:id], :unique => true
    add_index :tokens_01, [:word]
    add_index :tokens_01, [:wtoken1_id]
    add_index :tokens_01, [:wtoken2_id]
    add_index :tokens_01, [:wtoken1_id, :wtoken2_id]
    add_index :tokens_01, [:frequency]

    create_table :g3_01, :options => "ENGINE=MyISAM", :id => false do |t|
      t.column :id, "integer unsigned", :null => false
      t.column :wtoken1_id, "mediumint unsigned", :null => false
      t.column :wtoken2_id, "mediumint unsigned", :null => false
      t.column :wtoken3_id, "mediumint unsigned", :null => false
    end
    add_index :g3_01, [:id], :unique => true
    add_index :g3_01, [:wtoken1_id, :wtoken2_id, :wtoken3_id], :name => :g3_tokens123
    add_index :g3_01, [:wtoken1_id, :wtoken3_id, :wtoken2_id], :name => :g3_tokens132
    add_index :g3_01, [:wtoken2_id, :wtoken1_id, :wtoken3_id], :name => :g3_tokens213
    add_index :g3_01, [:wtoken2_id, :wtoken3_id, :wtoken1_id], :name => :g3_tokens231
    add_index :g3_01, [:wtoken3_id, :wtoken1_id, :wtoken2_id], :name => :g3_tokens312
    add_index :g3_01, [:wtoken3_id, :wtoken2_id, :wtoken1_id], :name => :g3_tokens321

    create_table :s3g_01, :options => "ENGINE=MyISAM", :id => false do |t|
      t.integer :three_gram_id, :null => false
      t.integer :sequence, :null => false
    end
    add_index :s3g_01, :three_gram_id
  end

  def self.down
    drop_table :tokens_01
    drop_table :g3_01
    drop_table :sg3_01
  end
end
