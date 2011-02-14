# encoding: utf-8
require 'set'
require 'tempfile'
require 'pp'
require "unicode_utils"

raise "1.9 required" unless RUBY_VERSION =~ /1.9/

# Make frequency list, 2-gram list, 3-gram list from clean sentences.

class Ngram
  attr_reader :ag2d,:h2gram12
  
  def initialize
    @hw_tokens = {}
    # index(token): data: [token, literal word or 2-gram id, occurrences]

    # table to lookup 2-grams
    # token => {token => g2}
    @h2gram21 = {}
    @h2gram12 = {}

    # index(g2); data:[g2,token1,token2,fq]
    @ag2d = []
  end
  
  def inspect
    "NGram object."
  end

  def most_frequent_2grams(top)
    ag2d.sort_by {|x| -x[3]}[0,top].map(&:first)
  end

  def frequent_2grams(freq)
    ag2d.reject{|x| x[3] < freq}.sort_by {|x| -x[3]}.map(&:first)
  end

  def token_seen(t)
    t and y = @atd2[t.to_i] and y[2] += 1 
    t
  end

  def frequent_2grams_for_token(token, min_freq)
    x = h2gram12[token]
    y = x ? x.values : []
    x = @h2gram21[token] 
    y += x.values if x
    y.reject{|g2| ag2d[g2][3] < min_freq}.sort_by {|g2| -ag2d[g2][3]}
  end

  def words_for_2gram(g2)
    ag2d[g2][1].map {|x| x && word_for_token(x)}
  end

  def string_for_2gram(g2)
    x,y = ag2d[g2][2],ag2d[g2][3]
    x &&= word_for_token(x)
    y &&= word_for_token(y)
    !x ? y.capitalize : !y ? "#{x}." : "#{x} #{y}"
  end

  def add_words_for_token(t, arr)
    w = word_for_token(t)
    x = String === w ? w : string_for_2gram(w)
    arr << x
  end

  def word_for_token(token)
    @atd2[token][1]
  end
  
  def freq_for_token(token)
    Numeric === token ? @atd2[token][2] : 1
  end
  
  ARR62 = []
  BASE62 = [*'0'..'9']+[*'a'..'z']+[*'A'..'Z']
  RBASE62 = Hash[*BASE62.zip(0..62).flatten]
  def to_62(k)
    k or return "#"
    k = k.to_i
    x = ARR62[k] and return x
    n = k
    s = ''
    loop do
      s = BASE62[n%62] + s
      if (n/=62) == 0
        ARR62[k] = s
        return s 
      end
    end
  end

  def from_62(n)
    n && !n.empty? && n != "#" or return nil
    (1..n.size).inject(0) do |acc,i|
      acc += RBASE62[n[-i]] * 62 ** (i-1)
    end
  end

  def process_file
    puts "process_file"
    count = 0
    @tf = Tempfile.new("ss")
    @tf.open
    atd1 = []
    
    while not STDIN.eof?
      x = STDIN.gets
      count += 1
      STDERR.puts(count / 1000_000) if count % 1000_000 == 0
  
      ws = x.split
      ws.map!.with_index do |w,i|
        
        canonical_word = UnicodeUtils.downcase(w)
        
        if t = @hw_tokens[canonical_word]
          atd1[t][1] += 1
        else
          t = atd1.size
          @hw_tokens[canonical_word] = t
          atd1 << [canonical_word,1] # token, word, occurrences
        end
        
        # if w.size > 1 and w == UnicodeUtils.upcase(w)
        #   found_occurrence(t, :uppercase)
        # elsif i > 0 and w == UnicodeUtils.titlecase(w)
        #   found_occurrence(t, :titlecase)
        # end
        
        canonical_word
        
      end
      @tf.print(",")
      ws.each {|x| @tf.print(x,",")}
      @tf.puts
    end
    @tf.close
    atd1.reject! {|x| x[1] == 1 }
    frequent_first = atd1.sort_by {|x| -x[1] }
    @two_percent_fq = frequent_first[atd1.size/50][1]
    puts "two_percent_fq: #{@two_percent_fq}"
    
    @atd2 = [nil]
    @hw_tokens = {}
    (1..frequent_first.size).each do |i|
      w = frequent_first[i-1][0]
      unless w =~ /[0-9]/
        @atd2 << [i, w, 0]
        @hw_tokens[w] = [i]
      end
    end
    self
  end
  
  def calc_2gram
    puts "calc_2gram"
    i = 0
    @tf.open
    @tf2 = Tempfile.new("ss2")
    @tf2.open
    count = 0

    while line = @tf.gets
      count += 1
      STDERR.puts(count / 1000_000) if count % 1000_000 == 0

      line.chomp!
      ws = line.split(",",-1)
      ws.map! do |x|
        if x.size > 0
          y = @hw_tokens[x]
          y ? y.first : %Q@"#{x}"@  # no words with digits, no words with one occurrance
        end
      end
      @tf2.puts(ws.join(","))
      
      ws.each_cons(2) do |t1,t2|
        if a = h2gram12[t1] and g2 = a[t2]
          ag2d[g2][3] += 1
        elsif not @seen_enough
          new_g2 = ag2d.size
          if new_g2 == 1_000_000
            STDERR.puts "2-gram limit reached"
            ag2d.reject do |g2,t1,t2,f|
              if f == 1
                h2gram12[t1].delete t2
                @h2gram21[t2].delete t1
                true
              end
            end
            @seen_enough = true
          else
            unless String === t1 or String === t2
              (h2gram12[t1] ||= {})[t2] = new_g2
              (@h2gram21[t2] ||= {})[t1] = new_g2
              ag2d << [new_g2,t1 && t1.to_i,t2 && t2.to_i,1]
            end
          end
        end
      end
    end
    @tf.close
    @tf2.close
    self
  end
  
  def replace_tokens_by_2grams
    puts "replace_tokens_by_2grams"
    
    f2g = @atd2[1,100].map(&:first).inject([]) do |memo,t|
      memo += frequent_2grams_for_token(t,@two_percent_fq)
    end.uniq
    STDERR.puts "#{@atd2.size} words found"
    STDERR.puts "#{f2g.size} 2-grams found"
    @h2gram12 = {}
    @h2gram21 = nil
    ag2d_new = []
    f2g.each_with_index do |g2,i|
      token1 = ag2d[g2][1]
      token2 = ag2d[g2][2]
      new_token = @atd2.size
      ag2d_new << [i, new_token, token1, token2, ag2d[g2][3]]
      token1 and @hw_tokens[word_for_token(token1)] << new_token
      token2 and @hw_tokens[word_for_token(token2)] << new_token
      (h2gram12[token1] ||= {})[token2] = i
      @atd2 << [new_token,i,0]
    end
    @ag2d = ag2d_new
    @hw_tokens = nil

    self
  end
  
  def handle_3grams
    @tf2.open
    count = 0
    puts "#{@atd2.size} tokens"
    g3s_seen = {}
    File.open("process/3-grams", "w") do |f3|
      File.open("process/3-grams-sequences", "w") do |f4|
        
        gid_for_key = -> key,g3 do
          x = g3s_seen[key] and return x
          f3.print(g3s_seen.size,";",g3[0],";",g3[1],";",g3[2],"\n")
          g3s_seen[key] = g3s_seen.size
        end
        
        seen3 = 0
        g3 = []

        handle_g3 = -> t do
          token_seen(t)
          g3 << t
          if seen3 == 2
            key = g3[0]*@atd2.size**2 + g3[1]*@atd2.size + g3[2]
            gid = gid_for_key[key,g3]
            f4.print(count-1,";",gid,"\n")
            g3.shift
          else
            seen3 += 1
          end
        end
        
        while line = @tf2.gets
          count += 1
          STDERR.puts(count / 1000_000) if count % 1000_000 == 0
          ts = line.chomp.split(",",-1)
          ts.map! {|x| x.empty? ? nil : x }
          g3.clear
          seen3 = 0
        
          j = -1
          while (j+=1) < ts.size
            w1,w2 = ts[j,2][0],ts[j,2][1]
            t1 = w1 && w1.to_i
            t2 = w2 && w2.to_i
            if x = h2gram12[t1] and g2 = x[t2]
              j += 1
              handle_g3[ag2d[g2][1]]
            elsif t1.to_i == 0
              seen3 = 0
              g3.clear
            else
              handle_g3[t1]
            end
          end
        end
        @tf2.close
      end
    end
    puts "seen #{g3s_seen.size} unique 3-grams"
    g3s_seen = nil
    File.open("process/tokens","w") do |f|
      start = Time.now
      jstart = 1
      (1...@atd2.size).each do |j| 
        _,w,fq = @atd2[j]
        if String === w
          f.puts("#{j},#{w},\\N,\\N,#{fq}")
        else
          wt1,wt2 = ag2d[w][2,2].map{|x|x || "\\N"}
          f.puts("#{j},\\N,#{wt1},#{wt2},#{fq}")
        end
        if Time.now-start > 60
          start = Time.now
          puts "speed: #{j-jstart} per minute"
          jstart = j
        end
      end
    end
  end
end

Ngram.new.process_file.calc_2gram.replace_tokens_by_2grams.handle_3grams
