s = `head -5000 ~/corpora/dutch/frequency-ff.txt`
t = `head -5000 ~/corpora/dutch/wikipedia/frequency.txt`

freq = s.split("\n").inject({}) do |memo,line|
  f,w = line.split
  f = f.to_i
  memo[w] = f
  memo
end

t.split("\n").each do |line|
  f,w = line.split
  f = f.to_i
  puts "#{f*freq[w]} #{w}" if freq[w]
end
