module MMigration
  def MMigration.migration_for_source(source)
    lambda do |klass|
      # Token - representation of word
      # word in lowercase
      # occurrence_statistics: sum of related entries in occurrences table.
      # has_many occurrences, therefore, needs (short) id.
      create_table("tokens_#{source}".to_sym, :options => "ENGINE=MyISAM", :id => false) do |t|
        t.column :id, "mediumint unsigned", :null => false
        t.string :word, :null => false
        t.column :frequency, "integer unsigned", :null => false
        t.binary :occurrence_statistics, :null => false
      end
      add_index "tokens_#{source}".to_sym, [:word]
      add_index "tokens_#{source}".to_sym, [:frequency]
      
      # TODO lemma
      # one lemma has many tokens
      # one token may belong to more than one lemma
      
      # bigrams, with distance 0..7 (0..7 words in between)
      # tokens: 0 means <start/end> of sentence.
      # solely used to cache frequencies.
      create_table "bigrams_#{source}".to_sym, :options => "ENGINE=MyISAM", :id => false do |t|
        t.column :distance, "tinyint unsigned", :null => false
        t.column :token1_id, "mediumint unsigned", :null => false
        t.column :token2_id, "mediumint unsigned", :null => false
        t.column :frequency, "mediumint unsigned", :null => false
      end
      add_index "bigrams_#{source}".to_sym, [:distance, :token1_id, :token2_id], :name => :bigrams_tokens12
      add_index "bigrams_#{source}".to_sym, [:distance, :token2_id, :token1_id], :name => :bigrams_tokens21

      # sequential trigrams.
      # solely used to cache frequencies.
      create_table "trigrams_#{source}".to_sym, :options => "ENGINE=MyISAM", :id => false do |t|
        t.column :token1_id, "mediumint unsigned", :null => false
        t.column :token2_id, "mediumint unsigned", :null => false
        t.column :token3_id, "mediumint unsigned", :null => false
        t.column :frequency, "mediumint unsigned", :null => false
      end
      add_index "trigrams_#{source}".to_sym, [:token1_id, :token2_id, :token3_id], :name => :trigrams_tokens123
      add_index "trigrams_#{source}".to_sym, [:token1_id, :token3_id], :name => :trigrams_tokens13
      add_index "trigrams_#{source}".to_sym, [:token2_id, :token3_id], :name => :trigrams_tokens23
      add_index "trigrams_#{source}".to_sym, [:token3_id], :name => :trigrams_tokens3
      
      # block200:
      # not in mysql:
      # record: bloom filter, constant size
      # record nr is id of sequences.
      # 9.6 bits per element: 19200 bits/2400 bytes for 2000 elements.
      
      # max 16M rows with 200 words each.
      create_table "seq_#{source}".to_sym, :options => "ENGINE=MyISAM", :id => false do |t|
        t.column :id, "mediumint unsigned", :null => false
        t.string :source, :null => false
        t.binary :compressed_sentences, :null => false
      end
      add_index "seq_#{source}".to_sym, [:id], :unique => true


      # Not stored for # most frequent tokens.
      # belongs_to token
      # belongs_to sequence
      # more details on each occurrence of a token
      # followed/preceded by common token %w(<start> <end> the a an of by I you he she it and ...)?
      # capitalized?
      # upper case?
      # between quotation marks?
      # between parentheses?
      # preceded/followed by comma?
      # preceded/followed by capitalized word?
      # preceded/followed by number?
      create_table("occurrences_#{source}".to_sym, :options => "ENGINE=MyISAM", :id => false) do |t|
        t.column :token_id, "mediumint unsigned", :null => false
        t.column :sequence, "mediumint unsigned", :null => false
        t.column :position, "tinyint", :null => false
        t.column :data, "bigint unsigned", :null => false
      end
      add_index "occurrences_#{source}".to_sym, [:token_id]
    end
  end
end