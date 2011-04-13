# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110217141329) do

  create_table "bigrams_01", :id => false, :force => true do |t|
    t.integer "distance",  :limit => 1, :null => false
    t.integer "token1_id", :limit => 3, :null => false
    t.integer "token2_id", :limit => 3, :null => false
    t.integer "frequency", :limit => 3, :null => false
  end

  add_index "bigrams_01", ["distance", "token1_id", "token2_id"], :name => "bigrams_tokens12"
  add_index "bigrams_01", ["distance", "token2_id", "token1_id"], :name => "bigrams_tokens21"

  create_table "bigrams_02", :id => false, :force => true do |t|
    t.integer "distance",  :limit => 1, :null => false
    t.integer "token1_id", :limit => 3, :null => false
    t.integer "token2_id", :limit => 3, :null => false
    t.integer "frequency", :limit => 3, :null => false
  end

  add_index "bigrams_02", ["distance", "token1_id", "token2_id"], :name => "bigrams_tokens12"
  add_index "bigrams_02", ["distance", "token2_id", "token1_id"], :name => "bigrams_tokens21"

  create_table "bigrams_03", :id => false, :force => true do |t|
    t.integer "distance",  :limit => 1, :null => false
    t.integer "token1_id", :limit => 3, :null => false
    t.integer "token2_id", :limit => 3, :null => false
    t.integer "frequency", :limit => 3, :null => false
  end

  add_index "bigrams_03", ["distance", "token1_id", "token2_id"], :name => "bigrams_tokens12"
  add_index "bigrams_03", ["distance", "token2_id", "token1_id"], :name => "bigrams_tokens21"

  create_table "bigrams_04", :id => false, :force => true do |t|
    t.integer "distance",  :limit => 1, :null => false
    t.integer "token1_id", :limit => 3, :null => false
    t.integer "token2_id", :limit => 3, :null => false
    t.integer "frequency", :limit => 3, :null => false
  end

  add_index "bigrams_04", ["distance", "token1_id", "token2_id"], :name => "bigrams_tokens12"
  add_index "bigrams_04", ["distance", "token2_id", "token1_id"], :name => "bigrams_tokens21"

  create_table "bigrams_05", :id => false, :force => true do |t|
    t.integer "distance",  :limit => 1, :null => false
    t.integer "token1_id", :limit => 3, :null => false
    t.integer "token2_id", :limit => 3, :null => false
    t.integer "frequency", :limit => 3, :null => false
  end

  add_index "bigrams_05", ["distance", "token1_id", "token2_id"], :name => "bigrams_tokens12"
  add_index "bigrams_05", ["distance", "token2_id", "token1_id"], :name => "bigrams_tokens21"

  create_table "bigrams_06", :id => false, :force => true do |t|
    t.integer "distance",  :limit => 1, :null => false
    t.integer "token1_id", :limit => 3, :null => false
    t.integer "token2_id", :limit => 3, :null => false
    t.integer "frequency", :limit => 3, :null => false
  end

  add_index "bigrams_06", ["distance", "token1_id", "token2_id"], :name => "bigrams_tokens12"
  add_index "bigrams_06", ["distance", "token2_id", "token1_id"], :name => "bigrams_tokens21"

  create_table "fanfiction_chapters", :force => true do |t|
    t.integer "story"
    t.integer "chapter"
    t.string  "githash"
  end

  add_index "fanfiction_chapters", ["story"], :name => "index_fanfiction_chapters_on_story"

  create_table "fanfiction_stories", :id => false, :force => true do |t|
    t.integer "id"
    t.string  "language",     :limit => 2
    t.string  "medium"
    t.string  "work"
    t.string  "title"
    t.integer "author_id"
    t.string  "author_name"
    t.date    "publish_date"
    t.date    "update_date"
    t.string  "rating",       :limit => 2
    t.string  "genre"
    t.string  "character_a"
    t.string  "character_b"
    t.boolean "completed"
    t.integer "words",        :limit => 3
    t.integer "chapters",     :limit => 2
    t.integer "reviews",      :limit => 3
  end

  add_index "fanfiction_stories", ["id"], :name => "index_fanfiction_stories_on_id"
  add_index "fanfiction_stories", ["language"], :name => "index_fanfiction_stories_on_language"
  add_index "fanfiction_stories", ["reviews"], :name => "index_fanfiction_stories_on_reviews"
  add_index "fanfiction_stories", ["words"], :name => "index_fanfiction_stories_on_words"

  create_table "occurrences_01", :id => false, :force => true do |t|
    t.integer "token_id", :limit => 3, :null => false
    t.integer "sequence", :limit => 3, :null => false
    t.integer "position", :limit => 1, :null => false
    t.integer "data",     :limit => 8, :null => false
  end

  add_index "occurrences_01", ["token_id"], :name => "index_occurrences_01_on_token_id"

  create_table "occurrences_02", :id => false, :force => true do |t|
    t.integer "token_id", :limit => 3, :null => false
    t.integer "sequence", :limit => 3, :null => false
    t.integer "position", :limit => 1, :null => false
    t.integer "data",     :limit => 8, :null => false
  end

  add_index "occurrences_02", ["token_id"], :name => "index_occurrences_02_on_token_id"

  create_table "occurrences_03", :id => false, :force => true do |t|
    t.integer "token_id", :limit => 3, :null => false
    t.integer "sequence", :limit => 3, :null => false
    t.integer "position", :limit => 1, :null => false
    t.integer "data",     :limit => 8, :null => false
  end

  add_index "occurrences_03", ["token_id"], :name => "index_occurrences_03_on_token_id"

  create_table "occurrences_04", :id => false, :force => true do |t|
    t.integer "token_id", :limit => 3, :null => false
    t.integer "sequence", :limit => 3, :null => false
    t.integer "position", :limit => 1, :null => false
    t.integer "data",     :limit => 8, :null => false
  end

  add_index "occurrences_04", ["token_id"], :name => "index_occurrences_04_on_token_id"

  create_table "occurrences_05", :id => false, :force => true do |t|
    t.integer "token_id", :limit => 3, :null => false
    t.integer "sequence", :limit => 3, :null => false
    t.integer "position", :limit => 1, :null => false
    t.integer "data",     :limit => 8, :null => false
  end

  add_index "occurrences_05", ["token_id"], :name => "index_occurrences_05_on_token_id"

  create_table "occurrences_06", :id => false, :force => true do |t|
    t.integer "token_id", :limit => 3, :null => false
    t.integer "sequence", :limit => 3, :null => false
    t.integer "position", :limit => 1, :null => false
    t.integer "data",     :limit => 8, :null => false
  end

  add_index "occurrences_06", ["token_id"], :name => "index_occurrences_06_on_token_id"

  create_table "seq_01", :force => true do |t|
    t.string "source",               :null => false
    t.binary "compressed_sentences", :null => false
  end

  add_index "seq_01", ["id"], :name => "index_seq_01_on_id", :unique => true

  create_table "seq_02", :force => true do |t|
    t.string "source",               :null => false
    t.binary "compressed_sentences", :null => false
  end

  add_index "seq_02", ["id"], :name => "index_seq_02_on_id", :unique => true

  create_table "seq_03", :force => true do |t|
    t.string "source",               :null => false
    t.binary "compressed_sentences", :null => false
  end

  add_index "seq_03", ["id"], :name => "index_seq_03_on_id", :unique => true

  create_table "seq_04", :force => true do |t|
    t.string "source",               :null => false
    t.binary "compressed_sentences", :null => false
  end

  add_index "seq_04", ["id"], :name => "index_seq_04_on_id", :unique => true

  create_table "seq_05", :force => true do |t|
    t.string "source",               :null => false
    t.binary "compressed_sentences", :null => false
  end

  add_index "seq_05", ["id"], :name => "index_seq_05_on_id", :unique => true

  create_table "seq_06", :force => true do |t|
    t.string "source",               :null => false
    t.binary "compressed_sentences", :null => false
  end

  add_index "seq_06", ["id"], :name => "index_seq_06_on_id", :unique => true

  create_table "sources", :force => true do |t|
    t.string "lang",   :null => false
    t.string "corpus", :null => false
  end

  create_table "tokens_01", :id => false, :force => true do |t|
    t.integer "id",                    :limit => 3, :null => false
    t.string  "word",                               :null => false
    t.integer "frequency",                          :null => false
    t.binary  "occurrence_statistics",              :null => false
  end

  add_index "tokens_01", ["frequency"], :name => "index_tokens_01_on_frequency"
  add_index "tokens_01", ["word"], :name => "index_tokens_01_on_word"

  create_table "tokens_02", :id => false, :force => true do |t|
    t.integer "id",                    :limit => 3, :null => false
    t.string  "word",                               :null => false
    t.integer "frequency",                          :null => false
    t.binary  "occurrence_statistics",              :null => false
  end

  add_index "tokens_02", ["frequency"], :name => "index_tokens_02_on_frequency"
  add_index "tokens_02", ["word"], :name => "index_tokens_02_on_word"

  create_table "tokens_03", :id => false, :force => true do |t|
    t.integer "id",                    :limit => 3, :null => false
    t.string  "word",                               :null => false
    t.integer "frequency",                          :null => false
    t.binary  "occurrence_statistics",              :null => false
  end

  add_index "tokens_03", ["frequency"], :name => "index_tokens_03_on_frequency"
  add_index "tokens_03", ["word"], :name => "index_tokens_03_on_word"

  create_table "tokens_04", :id => false, :force => true do |t|
    t.integer "id",                    :limit => 3, :null => false
    t.string  "word",                               :null => false
    t.integer "frequency",                          :null => false
    t.binary  "occurrence_statistics",              :null => false
  end

  add_index "tokens_04", ["frequency"], :name => "index_tokens_04_on_frequency"
  add_index "tokens_04", ["word"], :name => "index_tokens_04_on_word"

  create_table "tokens_05", :id => false, :force => true do |t|
    t.integer "id",                    :limit => 3, :null => false
    t.string  "word",                               :null => false
    t.integer "frequency",                          :null => false
    t.binary  "occurrence_statistics",              :null => false
  end

  add_index "tokens_05", ["frequency"], :name => "index_tokens_05_on_frequency"
  add_index "tokens_05", ["word"], :name => "index_tokens_05_on_word"

  create_table "tokens_06", :id => false, :force => true do |t|
    t.integer "id",                    :limit => 3, :null => false
    t.string  "word",                               :null => false
    t.integer "frequency",                          :null => false
    t.binary  "occurrence_statistics",              :null => false
  end

  add_index "tokens_06", ["frequency"], :name => "index_tokens_06_on_frequency"
  add_index "tokens_06", ["word"], :name => "index_tokens_06_on_word"

  create_table "trigrams_01", :id => false, :force => true do |t|
    t.integer "token1_id", :limit => 3, :null => false
    t.integer "token2_id", :limit => 3, :null => false
    t.integer "token3_id", :limit => 3, :null => false
    t.integer "frequency", :limit => 3, :null => false
  end

  add_index "trigrams_01", ["token1_id", "token2_id", "token3_id"], :name => "trigrams_tokens123"
  add_index "trigrams_01", ["token1_id", "token3_id"], :name => "trigrams_tokens13"
  add_index "trigrams_01", ["token2_id", "token3_id"], :name => "trigrams_tokens23"
  add_index "trigrams_01", ["token3_id"], :name => "trigrams_tokens3"

  create_table "trigrams_02", :id => false, :force => true do |t|
    t.integer "token1_id", :limit => 3, :null => false
    t.integer "token2_id", :limit => 3, :null => false
    t.integer "token3_id", :limit => 3, :null => false
    t.integer "frequency", :limit => 3, :null => false
  end

  add_index "trigrams_02", ["token1_id", "token2_id", "token3_id"], :name => "trigrams_tokens123"
  add_index "trigrams_02", ["token1_id", "token3_id"], :name => "trigrams_tokens13"
  add_index "trigrams_02", ["token2_id", "token3_id"], :name => "trigrams_tokens23"
  add_index "trigrams_02", ["token3_id"], :name => "trigrams_tokens3"

  create_table "trigrams_03", :id => false, :force => true do |t|
    t.integer "token1_id", :limit => 3, :null => false
    t.integer "token2_id", :limit => 3, :null => false
    t.integer "token3_id", :limit => 3, :null => false
    t.integer "frequency", :limit => 3, :null => false
  end

  add_index "trigrams_03", ["token1_id", "token2_id", "token3_id"], :name => "trigrams_tokens123"
  add_index "trigrams_03", ["token1_id", "token3_id"], :name => "trigrams_tokens13"
  add_index "trigrams_03", ["token2_id", "token3_id"], :name => "trigrams_tokens23"
  add_index "trigrams_03", ["token3_id"], :name => "trigrams_tokens3"

  create_table "trigrams_04", :id => false, :force => true do |t|
    t.integer "token1_id", :limit => 3, :null => false
    t.integer "token2_id", :limit => 3, :null => false
    t.integer "token3_id", :limit => 3, :null => false
    t.integer "frequency", :limit => 3, :null => false
  end

  add_index "trigrams_04", ["token1_id", "token2_id", "token3_id"], :name => "trigrams_tokens123"
  add_index "trigrams_04", ["token1_id", "token3_id"], :name => "trigrams_tokens13"
  add_index "trigrams_04", ["token2_id", "token3_id"], :name => "trigrams_tokens23"
  add_index "trigrams_04", ["token3_id"], :name => "trigrams_tokens3"

  create_table "trigrams_05", :id => false, :force => true do |t|
    t.integer "token1_id", :limit => 3, :null => false
    t.integer "token2_id", :limit => 3, :null => false
    t.integer "token3_id", :limit => 3, :null => false
    t.integer "frequency", :limit => 3, :null => false
  end

  add_index "trigrams_05", ["token1_id", "token2_id", "token3_id"], :name => "trigrams_tokens123"
  add_index "trigrams_05", ["token1_id", "token3_id"], :name => "trigrams_tokens13"
  add_index "trigrams_05", ["token2_id", "token3_id"], :name => "trigrams_tokens23"
  add_index "trigrams_05", ["token3_id"], :name => "trigrams_tokens3"

  create_table "trigrams_06", :id => false, :force => true do |t|
    t.integer "token1_id", :limit => 3, :null => false
    t.integer "token2_id", :limit => 3, :null => false
    t.integer "token3_id", :limit => 3, :null => false
    t.integer "frequency", :limit => 3, :null => false
  end

  add_index "trigrams_06", ["token1_id", "token2_id", "token3_id"], :name => "trigrams_tokens123"
  add_index "trigrams_06", ["token1_id", "token3_id"], :name => "trigrams_tokens13"
  add_index "trigrams_06", ["token2_id", "token3_id"], :name => "trigrams_tokens23"
  add_index "trigrams_06", ["token3_id"], :name => "trigrams_tokens3"

  create_table "wikipedia_articles", :force => true do |t|
    t.string "title"
    t.string "language"
    t.string "githash"
  end

  add_index "wikipedia_articles", ["title"], :name => "index_wikipedia_articles_on_title"

end
