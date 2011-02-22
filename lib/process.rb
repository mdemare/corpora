# encoding: utf-8
$: << File.expand_path(File.dirname(__FILE__))
STDERR.puts $:.last
require 'tempfile'
require 'bloom'
require 'bitset'
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

  def initialize(token_file, sentence_file, output, language)
    @token_map = {}
    linenr = 0
    File.foreach(token_file) do |line| 
      fq,word = line.chomp.split
      @token_map[word] = [linenr,fq]
      linenr += 1
    end
    STDERR.puts "loaded #{@token_map.size} words"
    
    @sentence_file = sentence_file
    @fbigram = (0..7).map {|d| File.open(File.join(output, "bigram-#{d}"),"w")}
    @ftrigram = File.open(File.join(output, "trigram"),"w")
    @fsentences = File.open(File.join(output, "sentences"),"w")
    @fbloom = File.open(File.join(output, "bloom"), "w")
    @bloom = Bloom.new(16000)
    @words_in_batch = 0
    @line_batch = []
  end
  
  def flush_block
    if @line_batch
      @fsentences.puts @line_batch.join(?/)
      puts @line_batch.join(?/)
      @fbloom.write @bloom.to_s # TODO write bytes
      puts @bloom.to_s # TODO write bytes
      exit
    end
  end
  
  def close_resources
    flush_block
    @fsentences.close
    @fbloom.close
    @fbigram.each {|f|f.close}
    @ftrigram.close
  end
  
  def seen_line(line, wordcount)
    if @words_in_batch > 200
      flush_block
      @words_in_batch = 0
      @bloom = Bloom.new(16000)
      @line_batch.clear
    end
    @line_batch << line
    @words_in_batch += wordcount
  end
  
  def seen_occurrence(word, token, capitalization)
    # TODO
  end
  
  def add_bigrams(index, words)
    index -= 1
    # <start> w0 w1 w2 <end>
    # words.size == 3
    bigram = -> d,w1,w2 do
      raise "#{index}, #{words.inspect}" if w2.to_s == ''
      bi = [w1,w2].join(?,)
      @fbigram[d].puts bi
      bloom("#{d}:#{bi}", 2)
    end
    (0..7).each do |distance|
      p1 = index - 1 - distance
      break if p1 < 0
      next if p1 == 0 && index == words.size
      next if (p1 == 0 and bigram[distance, "#", words[index]])
      raise unless words[p1]
      lw = words.size == index ? "#" : words[index]
      bigram[distance, words[p1], lw]
    end
  end
  
  def add_trigrams(index, words)
    index -= 1
    return if index < 1
    raise unless words[index-2,3].all?
    id = words[index-2,3]
    id[0] = '#' if index == 1
    id[2] = '#' if index == words.size
    raise index.to_s + words.inspect unless id.all? {|w| w.to_s.size > 0 }
    bloom(id.join(?,), 3)
    @ftrigram.puts id
  end

  def bloom(obj, kind)
    puts "adding #{obj}"
    @bloom.add(obj)
    raise unless @bloom.includes?(obj)
    unless Bloom.from_s(@bloom.to_s).instance_eval{@bitfield}.to_s == @bloom.instance_eval{@bitfield}.to_s
      STDERR.puts Bloom.from_s(@bloom.to_s).instance_eval{@bitfield}.to_s.size, @bloom.instance_eval{@bitfield}.to_s.size
      raise
    end
    raise unless Bloom.from_s(@bloom.to_s).includes?(obj)
  end
  
  def process
    File.foreach(@sentence_file) do |line|
      line.chomp!
      # all that's left in file after clean is this:
      # 0-9A-ZÁÉÍÓÚÀÈÌÒÙÄËÏÖÜÂÊÎÔÛÇa-zäëïöüáéíóúàèìòùâèìòùñçß\n .?¿!¡;,()"&$%'\'-
      clean_line = line.delete('.?¿!¡;,()"&$%')
      # now all that's left are :alnum, spaces, dashes and apostrophs.
      
      clean_line.gsub!(/^-/,'')
      clean_line.gsub!(/-$/,'')
      clean_line.gsub!(/ -/,'')
      clean_line.gsub!(/- /,'')
      
      # TODO split l'église into l' and église
      words = clean_line.split

      # split into 200-word batches, update bloom filter
      seen_line(line, words.size) 
      tokens = []
      [0,*words,1].each_with_index do |word,index|
        if word == 0
          tokens << 0
        elsif word == 1
          tokens << 0
          add_bigrams(index, words) # backward looking, in memory, also add bloom filter
          add_trigrams(index, words) # backward looking, to file "trigrams-#{token1 % 100}", also add bloom filter
        else
          canonical_word = UnicodeUtils.downcase(word)
          token = (x = @token_map[canonical_word]) && x[0]
          # some words aren't tokens (only 1 occurrence), will return nil
          # still add to token list
          tokens << token
          if token
            capitalization = if word == canonical_word
              :lowercase
            elsif word == UnicodeUtils.upcase(word)
              :uppercase
            else 
              :capitalized
            end
            if word
              bloom(word, 1)
              seen_occurrence(word, token, capitalization) # add details (capitalization) to occurrences file, unless stop word
              add_bigrams(index, words) # backward looking, in memory, also add bloom filter
              add_trigrams(index, words) # backward looking, to file "trigrams-#{token1 % 100}", also add bloom filter
            end
          end
        end
      end
    end
    
    flush_block
    close_resources
  end

end

if ARGV.size != 4
  puts "format: ruby process.rb token_file sentence_file output_dir language_code"
  exit
end

Ngram.new(*ARGV).process
