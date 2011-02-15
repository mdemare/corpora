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

ActiveRecord::Schema.define(:version => 20110210143930) do

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

  create_table "s3g_01", :id => false, :force => true do |t|
    t.integer "three_gram_id", :null => false
    t.integer "sequence",      :null => false
  end

  add_index "s3g_01", ["three_gram_id"], :name => "index_s3g_01_on_three_gram_id"

  create_table "seq_01", :force => true do |t|
    t.binary "compressed_sentences", :null => false
  end

  add_index "seq_01", ["id"], :name => "index_seq_01_on_id", :unique => true

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

end
