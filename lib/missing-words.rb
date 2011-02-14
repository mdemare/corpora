# converts inglua to word list
# prints frequent words from wikipedia corpus not occurring in inglua to file.
require 'set'
a = (0..5).inject([]){|memo,l|memo + DICTIONARY.belt_keys(:nl,l)}.map(&:to_s)
a -= a.grep(/^nl/)
att = a.reverse.map {|m| (0..5).map { tough_attempt(+m,6,6) }.uniq }.flatten.uniq
inglua_vocab = Set.new(att.map {|x| collect_forms(x,:nl).inject([]){|memo,l|memo + l.downcase.delete("?.").split}}.flatten.sort.uniq)
File.open("missing-nl.txt","w") do |file|
  IO.foreach("/Users/mdemare/corpora/dutch/wikipedia/frequency.txt") do |line|
    freq,word = line.split
    unless inglua_vocab.include?(word)
      file.puts "#{word} #{freq}"
    end
    break if freq.to_i < 10000
  end
end
