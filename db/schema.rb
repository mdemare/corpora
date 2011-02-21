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

  create_table "g3_01", :force => true do |t|
    t.integer "wtoken1_id", :limit => 3, :null => false
    t.integer "wtoken2_id", :limit => 3, :null => false
    t.integer "wtoken3_id", :limit => 3, :null => false
    t.integer "frequency",  :limit => 2, :null => false
  end

  add_index "g3_01", ["id"], :name => "index_g3_01_on_id", :unique => true
  add_index "g3_01", ["wtoken1_id", "wtoken2_id", "wtoken3_id"], :name => "g3_tokens123"
  add_index "g3_01", ["wtoken1_id", "wtoken3_id", "wtoken2_id"], :name => "g3_tokens132"
  add_index "g3_01", ["wtoken2_id", "wtoken1_id", "wtoken3_id"], :name => "g3_tokens213"
  add_index "g3_01", ["wtoken2_id", "wtoken3_id", "wtoken1_id"], :name => "g3_tokens231"
  add_index "g3_01", ["wtoken3_id", "wtoken1_id", "wtoken2_id"], :name => "g3_tokens312"
  add_index "g3_01", ["wtoken3_id", "wtoken2_id", "wtoken1_id"], :name => "g3_tokens321"

  create_table "g3_02", :force => true do |t|
    t.integer "wtoken1_id", :limit => 3, :null => false
    t.integer "wtoken2_id", :limit => 3, :null => false
    t.integer "wtoken3_id", :limit => 3, :null => false
    t.integer "frequency",  :limit => 2, :null => false
  end

  add_index "g3_02", ["id"], :name => "index_g3_02_on_id", :unique => true
  add_index "g3_02", ["wtoken1_id", "wtoken2_id", "wtoken3_id"], :name => "g3_tokens123"
  add_index "g3_02", ["wtoken1_id", "wtoken3_id", "wtoken2_id"], :name => "g3_tokens132"
  add_index "g3_02", ["wtoken2_id", "wtoken1_id", "wtoken3_id"], :name => "g3_tokens213"
  add_index "g3_02", ["wtoken2_id", "wtoken3_id", "wtoken1_id"], :name => "g3_tokens231"
  add_index "g3_02", ["wtoken3_id", "wtoken1_id", "wtoken2_id"], :name => "g3_tokens312"
  add_index "g3_02", ["wtoken3_id", "wtoken2_id", "wtoken1_id"], :name => "g3_tokens321"

  create_table "g3_03", :force => true do |t|
    t.integer "wtoken1_id", :limit => 3, :null => false
    t.integer "wtoken2_id", :limit => 3, :null => false
    t.integer "wtoken3_id", :limit => 3, :null => false
    t.integer "frequency",  :limit => 2, :null => false
  end

  add_index "g3_03", ["id"], :name => "index_g3_03_on_id", :unique => true
  add_index "g3_03", ["wtoken1_id", "wtoken2_id", "wtoken3_id"], :name => "g3_tokens123"
  add_index "g3_03", ["wtoken1_id", "wtoken3_id", "wtoken2_id"], :name => "g3_tokens132"
  add_index "g3_03", ["wtoken2_id", "wtoken1_id", "wtoken3_id"], :name => "g3_tokens213"
  add_index "g3_03", ["wtoken2_id", "wtoken3_id", "wtoken1_id"], :name => "g3_tokens231"
  add_index "g3_03", ["wtoken3_id", "wtoken1_id", "wtoken2_id"], :name => "g3_tokens312"
  add_index "g3_03", ["wtoken3_id", "wtoken2_id", "wtoken1_id"], :name => "g3_tokens321"

  create_table "g3_04", :force => true do |t|
    t.integer "wtoken1_id", :limit => 3, :null => false
    t.integer "wtoken2_id", :limit => 3, :null => false
    t.integer "wtoken3_id", :limit => 3, :null => false
    t.integer "frequency",  :limit => 2, :null => false
  end

  add_index "g3_04", ["id"], :name => "index_g3_04_on_id", :unique => true
  add_index "g3_04", ["wtoken1_id", "wtoken2_id", "wtoken3_id"], :name => "g3_tokens123"
  add_index "g3_04", ["wtoken1_id", "wtoken3_id", "wtoken2_id"], :name => "g3_tokens132"
  add_index "g3_04", ["wtoken2_id", "wtoken1_id", "wtoken3_id"], :name => "g3_tokens213"
  add_index "g3_04", ["wtoken2_id", "wtoken3_id", "wtoken1_id"], :name => "g3_tokens231"
  add_index "g3_04", ["wtoken3_id", "wtoken1_id", "wtoken2_id"], :name => "g3_tokens312"
  add_index "g3_04", ["wtoken3_id", "wtoken2_id", "wtoken1_id"], :name => "g3_tokens321"

  create_table "g3_05", :force => true do |t|
    t.integer "wtoken1_id", :limit => 3, :null => false
    t.integer "wtoken2_id", :limit => 3, :null => false
    t.integer "wtoken3_id", :limit => 3, :null => false
    t.integer "frequency",  :limit => 2, :null => false
  end

  add_index "g3_05", ["id"], :name => "index_g3_05_on_id", :unique => true
  add_index "g3_05", ["wtoken1_id", "wtoken2_id", "wtoken3_id"], :name => "g3_tokens123"
  add_index "g3_05", ["wtoken1_id", "wtoken3_id", "wtoken2_id"], :name => "g3_tokens132"
  add_index "g3_05", ["wtoken2_id", "wtoken1_id", "wtoken3_id"], :name => "g3_tokens213"
  add_index "g3_05", ["wtoken2_id", "wtoken3_id", "wtoken1_id"], :name => "g3_tokens231"
  add_index "g3_05", ["wtoken3_id", "wtoken1_id", "wtoken2_id"], :name => "g3_tokens312"
  add_index "g3_05", ["wtoken3_id", "wtoken2_id", "wtoken1_id"], :name => "g3_tokens321"

  create_table "g3_06", :force => true do |t|
    t.integer "wtoken1_id", :limit => 3, :null => false
    t.integer "wtoken2_id", :limit => 3, :null => false
    t.integer "wtoken3_id", :limit => 3, :null => false
    t.integer "frequency",  :limit => 2, :null => false
  end

  add_index "g3_06", ["id"], :name => "index_g3_06_on_id", :unique => true
  add_index "g3_06", ["wtoken1_id", "wtoken2_id", "wtoken3_id"], :name => "g3_tokens123"
  add_index "g3_06", ["wtoken1_id", "wtoken3_id", "wtoken2_id"], :name => "g3_tokens132"
  add_index "g3_06", ["wtoken2_id", "wtoken1_id", "wtoken3_id"], :name => "g3_tokens213"
  add_index "g3_06", ["wtoken2_id", "wtoken3_id", "wtoken1_id"], :name => "g3_tokens231"
  add_index "g3_06", ["wtoken3_id", "wtoken1_id", "wtoken2_id"], :name => "g3_tokens312"
  add_index "g3_06", ["wtoken3_id", "wtoken2_id", "wtoken1_id"], :name => "g3_tokens321"

  create_table "s3g_01", :id => false, :force => true do |t|
    t.integer "three_gram_id", :null => false
    t.integer "sequence",      :null => false
  end

  add_index "s3g_01", ["three_gram_id"], :name => "index_s3g_01_on_three_gram_id"

  create_table "s3g_02", :id => false, :force => true do |t|
    t.integer "three_gram_id", :null => false
    t.integer "sequence",      :null => false
  end

  add_index "s3g_02", ["three_gram_id"], :name => "index_s3g_02_on_three_gram_id"

  create_table "s3g_03", :id => false, :force => true do |t|
    t.integer "three_gram_id", :null => false
    t.integer "sequence",      :null => false
  end

  add_index "s3g_03", ["three_gram_id"], :name => "index_s3g_03_on_three_gram_id"

  create_table "s3g_04", :id => false, :force => true do |t|
    t.integer "three_gram_id", :null => false
    t.integer "sequence",      :null => false
  end

  add_index "s3g_04", ["three_gram_id"], :name => "index_s3g_04_on_three_gram_id"

  create_table "s3g_05", :id => false, :force => true do |t|
    t.integer "three_gram_id", :null => false
    t.integer "sequence",      :null => false
  end

  add_index "s3g_05", ["three_gram_id"], :name => "index_s3g_05_on_three_gram_id"

  create_table "s3g_06", :id => false, :force => true do |t|
    t.integer "three_gram_id", :null => false
    t.integer "sequence",      :null => false
  end

  add_index "s3g_06", ["three_gram_id"], :name => "index_s3g_06_on_three_gram_id"

  create_table "seq_01", :force => true do |t|
    t.binary "compressed_sentences", :null => false
  end

  add_index "seq_01", ["id"], :name => "index_seq_01_on_id", :unique => true

  create_table "seq_02", :force => true do |t|
    t.binary "compressed_sentences", :null => false
  end

  add_index "seq_02", ["id"], :name => "index_seq_02_on_id", :unique => true

  create_table "seq_03", :force => true do |t|
    t.binary "compressed_sentences", :null => false
  end

  add_index "seq_03", ["id"], :name => "index_seq_03_on_id", :unique => true

  create_table "seq_04", :force => true do |t|
    t.binary "compressed_sentences", :null => false
  end

  add_index "seq_04", ["id"], :name => "index_seq_04_on_id", :unique => true

  create_table "seq_05", :force => true do |t|
    t.binary "compressed_sentences", :null => false
  end

  add_index "seq_05", ["id"], :name => "index_seq_05_on_id", :unique => true

  create_table "seq_06", :force => true do |t|
    t.binary "compressed_sentences", :null => false
  end

  add_index "seq_06", ["id"], :name => "index_seq_06_on_id", :unique => true

  create_table "sources", :force => true do |t|
    t.string "lang",   :null => false
    t.string "corpus", :null => false
  end

  create_table "tokens_01", :force => true do |t|
    t.string  "word"
    t.integer "wtoken1_id",                     :null => false
    t.integer "wtoken2_id",                     :null => false
    t.integer "frequency",                      :null => false
    t.integer "frequency_special", :limit => 1, :null => false
  end

  add_index "tokens_01", ["frequency"], :name => "index_tokens_01_on_frequency"
  add_index "tokens_01", ["id"], :name => "index_tokens_01_on_id", :unique => true
  add_index "tokens_01", ["word"], :name => "index_tokens_01_on_word"
  add_index "tokens_01", ["wtoken1_id", "wtoken2_id"], :name => "index_tokens_01_on_wtoken1_id_and_wtoken2_id"
  add_index "tokens_01", ["wtoken1_id"], :name => "index_tokens_01_on_wtoken1_id"
  add_index "tokens_01", ["wtoken2_id"], :name => "index_tokens_01_on_wtoken2_id"

  create_table "tokens_02", :force => true do |t|
    t.string  "word"
    t.integer "wtoken1_id",                     :null => false
    t.integer "wtoken2_id",                     :null => false
    t.integer "frequency",                      :null => false
    t.integer "frequency_special", :limit => 1, :null => false
  end

  add_index "tokens_02", ["frequency"], :name => "index_tokens_02_on_frequency"
  add_index "tokens_02", ["id"], :name => "index_tokens_02_on_id", :unique => true
  add_index "tokens_02", ["word"], :name => "index_tokens_02_on_word"
  add_index "tokens_02", ["wtoken1_id", "wtoken2_id"], :name => "index_tokens_02_on_wtoken1_id_and_wtoken2_id"
  add_index "tokens_02", ["wtoken1_id"], :name => "index_tokens_02_on_wtoken1_id"
  add_index "tokens_02", ["wtoken2_id"], :name => "index_tokens_02_on_wtoken2_id"

  create_table "tokens_03", :force => true do |t|
    t.string  "word"
    t.integer "wtoken1_id",                     :null => false
    t.integer "wtoken2_id",                     :null => false
    t.integer "frequency",                      :null => false
    t.integer "frequency_special", :limit => 1, :null => false
  end

  add_index "tokens_03", ["frequency"], :name => "index_tokens_03_on_frequency"
  add_index "tokens_03", ["id"], :name => "index_tokens_03_on_id", :unique => true
  add_index "tokens_03", ["word"], :name => "index_tokens_03_on_word"
  add_index "tokens_03", ["wtoken1_id", "wtoken2_id"], :name => "index_tokens_03_on_wtoken1_id_and_wtoken2_id"
  add_index "tokens_03", ["wtoken1_id"], :name => "index_tokens_03_on_wtoken1_id"
  add_index "tokens_03", ["wtoken2_id"], :name => "index_tokens_03_on_wtoken2_id"

  create_table "tokens_04", :force => true do |t|
    t.string  "word"
    t.integer "wtoken1_id",                     :null => false
    t.integer "wtoken2_id",                     :null => false
    t.integer "frequency",                      :null => false
    t.integer "frequency_special", :limit => 1, :null => false
  end

  add_index "tokens_04", ["frequency"], :name => "index_tokens_04_on_frequency"
  add_index "tokens_04", ["id"], :name => "index_tokens_04_on_id", :unique => true
  add_index "tokens_04", ["word"], :name => "index_tokens_04_on_word"
  add_index "tokens_04", ["wtoken1_id", "wtoken2_id"], :name => "index_tokens_04_on_wtoken1_id_and_wtoken2_id"
  add_index "tokens_04", ["wtoken1_id"], :name => "index_tokens_04_on_wtoken1_id"
  add_index "tokens_04", ["wtoken2_id"], :name => "index_tokens_04_on_wtoken2_id"

  create_table "tokens_05", :force => true do |t|
    t.string  "word"
    t.integer "wtoken1_id",                     :null => false
    t.integer "wtoken2_id",                     :null => false
    t.integer "frequency",                      :null => false
    t.integer "frequency_special", :limit => 1, :null => false
  end

  add_index "tokens_05", ["frequency"], :name => "index_tokens_05_on_frequency"
  add_index "tokens_05", ["id"], :name => "index_tokens_05_on_id", :unique => true
  add_index "tokens_05", ["word"], :name => "index_tokens_05_on_word"
  add_index "tokens_05", ["wtoken1_id", "wtoken2_id"], :name => "index_tokens_05_on_wtoken1_id_and_wtoken2_id"
  add_index "tokens_05", ["wtoken1_id"], :name => "index_tokens_05_on_wtoken1_id"
  add_index "tokens_05", ["wtoken2_id"], :name => "index_tokens_05_on_wtoken2_id"

  create_table "tokens_06", :force => true do |t|
    t.string  "word"
    t.integer "wtoken1_id",                     :null => false
    t.integer "wtoken2_id",                     :null => false
    t.integer "frequency",                      :null => false
    t.integer "frequency_special", :limit => 1, :null => false
  end

  add_index "tokens_06", ["frequency"], :name => "index_tokens_06_on_frequency"
  add_index "tokens_06", ["id"], :name => "index_tokens_06_on_id", :unique => true
  add_index "tokens_06", ["word"], :name => "index_tokens_06_on_word"
  add_index "tokens_06", ["wtoken1_id", "wtoken2_id"], :name => "index_tokens_06_on_wtoken1_id_and_wtoken2_id"
  add_index "tokens_06", ["wtoken1_id"], :name => "index_tokens_06_on_wtoken1_id"
  add_index "tokens_06", ["wtoken2_id"], :name => "index_tokens_06_on_wtoken2_id"

  create_table "wikipedia_articles", :force => true do |t|
    t.string "title"
    t.string "language"
    t.string "githash"
  end

  add_index "wikipedia_articles", ["title"], :name => "index_wikipedia_articles_on_title"

end
