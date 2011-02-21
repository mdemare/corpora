# encoding: utf-8
require 'set'
require 'tempfile'
require 'pp'
require "unicode_utils"

raise "1.9 required" unless RUBY_VERSION =~ /1.9/

# Make frequency list, 2-gram list, 3-gram list from clean sentences.

class Ngram
=begin
trim, replace dashes, downcase, reject numbers, split, sort | uniq -c, cat, sort | uniq -c, sum count, reject fq <= 1, sort fq desc  
tr -dc ' [:alnum:]\n'\'- | sed 's:^-::g;s:-$::g;s: -::g;s:- ::g' | tr '[:upper:]' '[:lower:]' | tr ' ' '\n' | grep -v '[0-9]' | grep -P . > tokenized
split -l 200000 tokenized tokens-
ls tokens-* | xargs -I xxx sort -o xxx xxx
ls tokens-* | xargs -I xxx uniq -c xxx uxxx
rm tokens-*
ls utokens-* | xargs cat | sort -k 2 | awk 'c && s!=$2{print c,s;c=0} {s=$2;c+=$1} END {print c,s}' | grep -v '^1 ' | sort -nr > fqlist
rm utokens-*
=end
  # - tokens: id, word, frequency already known, occurrence_statistics handled afterwards
  # TODO also split after l'église
  # TODO still contains single '
  
  # files to write:
  # - occurrences: token, sequence, position, data, one sequential file
  # - bigrams: stored in one file per distance, merged afterwards
  # - trigrams: stored in 100 files based on token1 % 100, merged afterwards
  # - sequences: stored in one file, new record after word count exceeds 200

  def initialize(token_file, sentence_file, language)
    @token_map = {}
    linenr = 0
    File.foreach(token_file) do |line| 
      fq,word = line.chomp.split
      @token_map[word] = [linenr,fq]
      linenr += 1
    end
    
    @sentence_file = sentence_file
    @fsentences = File.open("process/sentences","w")
    @fbloom = File.open("process/bloom","w")
  end
  
  def flush_block
    if @line_batch
      @fsentences.puts @line_batch.join(?/)
      @fbloom.write @bloom.to_s # TODO write bytes
      @words_in_batch,@line_batch,@bloom = nil
    end
  end
  
  def close_resources
    flush_block
    @fsentences.close
  end
  
  def seen_line(line, wordcount)
    @words_in_batch ||= 0
    @bloom ||= Bloom.new(2000)
    @line_batch ||= []
    
    @line_batch << line
    @words_in_batch += wordcount
    if @words_in_batch > 200
      flush_block
    end
  end
  
  def seen_occurrence(word, token, capitalization)
    # TODO
  end
  
  def add_bigrams(tokens, index, words)
    (0..7).each do |distance|
      p1 = index - 1 - distance
      if p1 >= 0
        if p1 == 0
          @bloom.add("#{distance}:#-#{words[index]}")
        else
          @bloom.add("#{distance}:#{words[p1]}-#{words[index]}")
        end
        # TODO write distance, tokens[p1], tokens[p2]
      end
    end
  end
  
  def add_trigrams(tokens, index, words)
    if index > 0
      if index == 0
        @bloom.add("#-#{words[index-1]}-#{words[index]}")
      else
        @bloom.add("#{distance}:#{words[p1]}-#{words[index]}")
      end
      # TODO write distance, tokens[p1], tokens[p2]
    end
  end
  
  def process
    File.readlines(@sentence_file) do |line|
      clean_line = line.delete("^ [:alnum:]'-")
      clean_line.gsub!(/^-/,'')
      clean_line.gsub!(/-$/,'')
      clean_line.gsub!(/ -/,'')
      clean_line.gsub!(/- /,'')
      
      # TODO split l'église into l' and église
      words = clean_line.split

      # split into 200-word batches, update bloom filter
      seen_line(line, words.size) 
      tokens = []
      [0,*words,1].each do |word,index|
        canonical_word = UnicodeUtils.downcase(word)
        if word == 0
          tokens << 0
        elsif word == 1
          tokens << 0
          add_bigrams(tokens, index) # backward looking, in memory, also add bloom filter
          add_trigrams(tokens, index) # backward looking, to file "trigrams-#{token1 % 100}", also add bloom filter
        else
          token = (x = @token_map[word]) && x[0]
          # some words aren't tokens (only 1 occurrence), will return nil
          # still add to token list
          tokens << token
          if token
            capitalization = if w == canonical_word
              :lowercase
            elsif w == UnicodeUtils.upcase(w)
              :uppercase
            else 
              :capitalized
            end
            @bloom.add(word)
            seen_occurrence(word, token, capitalization) # add details (capitalization) to occurrences file, unless stop word
            add_bigrams(tokens, index) # backward looking, in memory, also add bloom filter
            add_trigrams(tokens, index) # backward looking, to file "trigrams-#{token1 % 100}", also add bloom filter
          end
        end
      end
    end
    
    close_resources
  end

end

if ARGV.size != 3
  puts "format: ruby process.rb token_file sentence_file language_code"
  exit
end

# (token_file, sentence_file, language)
Ngram.new(ARGV[0], ARGV[1], ARGV[2]).process
