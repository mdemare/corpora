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
  # - tokens: id, word, frequency already known, occurrence_statistics handled afterwards
  
  # files to write:
  # - occurrences: token, sequence, position, data, one sequential file
  # - bigrams: stored in one file per distance, merged afterwards
  # - trigrams: stored in 100 files based on token1 % 100, merged afterwards
  # - sequences: stored in one file, new record after word count exceeds 200

  def initialize(token_file, sentence_file, language)
    @token_map = {}
    File.foreach(token_file) do |line| 
      id,fq,word = line.chomp.split
      @token_map[word] = [id.to_i,fq]
    end
    @token_map['#'] = [0,0]
    STDERR.puts "loaded #{@token_map.size} words"
    
    @sentence_file = sentence_file
    @fbigram = (0..7).map {|d| File.open("bigram-#{d}","w")}
    @ftrigram = File.open("trigram","w")
    @fsentences = File.open("sentences","w")
    @fbloom = File.open("bloom", "w")
    @bloom_added = 0
    @bloom = Bloom.new(20000)
    @words_in_batch = 0
    @line_batch = []
  end
  
  def flush_block
    if @line_batch
      @fsentences.puts @line_batch.join(?/)
      @fbloom.write @bloom.to_s
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
      @bloom_added = 0
      @bloom = Bloom.new(20000)
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
      bi = [w1,w2].map{|x| (t = @token_map[x]) && t[0]}
      if bi.all?
        bi = bi.join(?,)
        @fbigram[d].puts bi
        bloom("#{d}:#{bi}", 2)
      end
    end
    (0..7).each do |distance|
      p1 = index - 1 - distance
      break if p1 < 0
      next if p1 == 0 && index == words.size
      next if (p1 == 0 and bigram[distance, "#", words[index]])
      lw = words.size == index ? "#" : words[index]
      bigram[distance, words[p1], lw]
    end
  end
  
  def add_trigrams(index, words)
    index -= 1
    return if index < 1
    id = words[index-2,3]
    if index == 1
      id = ['#',*words[0,2]]
    end
    id[2] = '#' if index == words.size
    g3 = id.map{|x| (t = @token_map[x]) && t[0]}
    if g3.all?
      tri = g3.join(?,)
      bloom(tri, 3)
      @ftrigram.puts tri
    end
  end

  def bloom(obj, kind)
    @bloom_added += 1
    @bloom.add(obj)
  end
  
  def process
    start = Time.now
    jstart = 1
    j = 0
    total = File.stat(@sentence_file).size
    File.foreach(@sentence_file) do |line|
      j += line.size
      if Time.now-start > 60
        start = Time.now
        speed = j-jstart
        remaining = total - j
        STDERR.puts "speed: #{speed/1024} kb per minute, remaining time: #{remaining/speed} minutes"
        jstart = j
      end
      
      line.chomp!
      # all that's left in file after clean is this:
      # 0-9A-ZÁÉÍÓÚÀÈÌÒÙÄËÏÖÜÂÊÎÔÛÇa-zäëïöüáéíóúàèìòùâèìòùñçß\n .?¿!¡;,()"&$%'\'-
      clean_line = line.delete('.?¿!¡;,()"&$%')
      # now all that's left are :alnum:, spaces, dashes and apostrophs.
      
      clean_line.gsub!(/^-/,'')
      clean_line.gsub!(/-$/,'')
      clean_line.gsub!(/ -/,'')
      clean_line.gsub!(/- /,'')
      
      # TODO split l'église into l' and église
      words = clean_line.split
      
      next if words.size < 3

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
          words[index-1] = canonical_word if index > 0 && index <= words.size
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
            bloom(canonical_word, 1)
            seen_occurrence(word, token, capitalization) # add details (capitalization) to occurren
            add_bigrams(index, words) # backward looking, in memory, also add bloom filter
            add_trigrams(index, words) # backward looking, to file "trigrams-#{token1 % 100}", also
          end
        end
      end
    end
    
    flush_block
    close_resources
  end

end

if ARGV.size != 3
  puts "format: ruby process.rb token_file sentence_file language_code"
  exit
end

Ngram.new(*ARGV).process
