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

ActiveRecord::Schema.define(:version => 20110210150653) do

  create_table "sequences", :force => true do |t|
    t.binary "compressed_sentences", :null => false
  end

  add_index "sequences", ["id"], :name => "index_sequences_on_id", :unique => true

  create_table "sequences_three_grams", :id => false, :force => true do |t|
    t.integer "three_gram_id", :limit => 8, :null => false
    t.integer "sequence",      :limit => 8, :null => false
  end

  add_index "sequences_three_grams", ["three_gram_id"], :name => "index_sequences_three_grams_on_three_gram_id"

  create_table "sources", :force => true do |t|
    t.string "lang",   :null => false
    t.string "corpus", :null => false
  end

  create_table "three_grams", :force => true do |t|
    t.integer "wtoken1_id", :limit => 8, :null => false
    t.integer "wtoken2_id", :limit => 8, :null => false
    t.integer "wtoken3_id", :limit => 8, :null => false
  end

  add_index "three_grams", ["id"], :name => "index_three_grams_on_id", :unique => true
  add_index "three_grams", ["wtoken1_id", "wtoken2_id", "wtoken3_id"], :name => "g3_tokens123"
  add_index "three_grams", ["wtoken1_id", "wtoken3_id", "wtoken2_id"], :name => "g3_tokens132"
  add_index "three_grams", ["wtoken2_id", "wtoken1_id", "wtoken3_id"], :name => "g3_tokens213"
  add_index "three_grams", ["wtoken2_id", "wtoken3_id", "wtoken1_id"], :name => "g3_tokens231"
  add_index "three_grams", ["wtoken3_id", "wtoken1_id", "wtoken2_id"], :name => "g3_tokens312"
  add_index "three_grams", ["wtoken3_id", "wtoken2_id", "wtoken1_id"], :name => "g3_tokens321"

  create_table "tokens", :force => true do |t|
    t.integer "source_id",               :null => false
    t.string  "word"
    t.integer "wtoken1_id", :limit => 8
    t.integer "wtoken2_id", :limit => 8
    t.integer "frequency",  :limit => 8, :null => false
  end

  add_index "tokens", ["frequency"], :name => "index_tokens_on_frequency"
  add_index "tokens", ["id"], :name => "index_tokens_on_id", :unique => true
  add_index "tokens", ["source_id", "word"], :name => "index_tokens_on_source_id_and_word"
  add_index "tokens", ["wtoken1_id", "wtoken2_id"], :name => "index_tokens_on_wtoken1_id_and_wtoken2_id"
  add_index "tokens", ["wtoken1_id"], :name => "index_tokens_on_wtoken1_id"
  add_index "tokens", ["wtoken2_id"], :name => "index_tokens_on_wtoken2_id"

end
