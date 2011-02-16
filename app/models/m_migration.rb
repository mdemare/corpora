module MMigration
  def MMigration.migration_for_source(source)
    lambda do |klass|
      create_table("tokens_#{source}".to_sym, :options => "ENGINE=MyISAM", :id => false) do |t|
        t.column :id, "mediumint unsigned", :null => false
        t.string :word
        t.column :wtoken1_id, "integer unsigned", :null => false
        t.column :wtoken2_id, "integer unsigned", :null => false
        t.column :frequency, "integer unsigned", :null => false
        t.column :frequency_special, "tinyint unsigned", :null => false
      end
      add_index "tokens_#{source}".to_sym, [:id], :unique => true
      add_index "tokens_#{source}".to_sym, [:word]
      add_index "tokens_#{source}".to_sym, [:wtoken1_id]
      add_index "tokens_#{source}".to_sym, [:wtoken2_id]
      add_index "tokens_#{source}".to_sym, [:wtoken1_id, :wtoken2_id]
      add_index "tokens_#{source}".to_sym, [:frequency]

      create_table "g3_#{source}".to_sym, :options => "ENGINE=MyISAM", :id => false do |t|
        t.column :id, "integer unsigned", :null => false
        t.column :wtoken1_id, "mediumint unsigned", :null => false
        t.column :wtoken2_id, "mediumint unsigned", :null => false
        t.column :wtoken3_id, "mediumint unsigned", :null => false
        t.column :frequency, "smallint unsigned", :null => false
      end
      add_index "g3_#{source}".to_sym, [:id], :unique => true
      add_index "g3_#{source}".to_sym, [:wtoken1_id, :wtoken2_id, :wtoken3_id], :name => :g3_tokens123
      add_index "g3_#{source}".to_sym, [:wtoken1_id, :wtoken3_id, :wtoken2_id], :name => :g3_tokens132
      add_index "g3_#{source}".to_sym, [:wtoken2_id, :wtoken1_id, :wtoken3_id], :name => :g3_tokens213
      add_index "g3_#{source}".to_sym, [:wtoken2_id, :wtoken3_id, :wtoken1_id], :name => :g3_tokens231
      add_index "g3_#{source}".to_sym, [:wtoken3_id, :wtoken1_id, :wtoken2_id], :name => :g3_tokens312
      add_index "g3_#{source}".to_sym, [:wtoken3_id, :wtoken2_id, :wtoken1_id], :name => :g3_tokens321

      create_table "s3g_#{source}".to_sym, :options => "ENGINE=MyISAM", :id => false do |t|
        t.integer :three_gram_id, :null => false
        t.integer :sequence, :null => false
      end
      add_index "s3g_#{source}".to_sym, :three_gram_id

      create_table "seq_#{source}".to_sym, :options => "ENGINE=MyISAM", :id => false do |t|
        t.column :id, "integer unsigned", :null => false
        t.binary :compressed_sentences, :null => false
      end
      add_index "seq_#{source}".to_sym, [:id], :unique => true
    end
  end
end