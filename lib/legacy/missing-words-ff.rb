# converts inglua to word list
# prints frequent words from ff corpus not occurring in inglua to file.
require 'set'

a = (0..5).inject([]){|memo,l|memo + DICTIONARY.belt_keys(:en,l)}.map(&:to_s)
a -= a.grep(/^en/)
att = a.reverse.map {|m| (0...1).map { tough_attempt(+m,6,6) }.uniq }.flatten.uniq
inglua_vocab = Set.new(att.map {|x| collect_forms(x,:en).inject([]){|memo,l|memo + l.downcase.delete("?.").split}}.flatten.sort.uniq)
File.open("/Users/mdemare/missing-en.txt","w") do |file|
  IO.foreach("/Users/mdemare/corpora/english/fanfiction.net/1000k-frequency.txt") do |line|
    freq,word = line.split
    unless inglua_vocab.include?(word)
      file.puts "#{word} #{freq}"
    end
    break if freq.to_i < 10000
  end
end
