# coding: utf-8

lang = ARGV[0]
if lang == "ff"
  src = "corpora/english/fanfiction.net/#{ARGV[1]}"
  dest = "corpora/english/fanfiction.net/#{ARGV[1]}-frequency.txt"
else
  LANGUAGE = {"en" => "english", "de" => "german", "es" => "spanish", "fr" => "french", "nl" => "dutch", "it" => "italian"}
  src = "corpora/#{LANGUAGE[lang]}/wikipedia/sentences.txt"
  dest = "corpora/#{LANGUAGE[lang]}/wikipedia/frequency.txt"
end

punct = %w(‘ “ ” „ ’ – …).map{|x|"-e 's:#{x}::g' "}.join
`< #{src} \
   tr '[:punct:][:blank:]'  '  ' | \
   tr ' ' '\\n' | \
   grep -P '..' | \
   sed #{punct} > whole.txt`

ENV["LC_ALL"] = "C"
`sort -o whole.txt whole.txt`
`uniq -c whole.txt | grep -v '   1 ' > whole-freq.txt`

`grep -nm1 ' aa$' whole-freq.txt | awk -F: '{ print $1 }' | xargs -I '{}' head -'{}' whole-freq.txt > upper.txt`
`grep -nm1 ' aa$' whole-freq.txt | awk -F: '{ print $1 }' | xargs -I '{}' tail +'{}' whole-freq.txt > lower-0.txt`
`grep -nm1 ' Á$' lower-0.txt | awk -F: '{ print $1 }' | xargs -I '{}' head -'{}' lower-0.txt > lower.txt`
`rm lower-0.txt whole.txt whole-freq.txt`

lower={}
File.readlines("lower.txt").each do |line|
  v,k = line.split
  k =~ /[a-z]/ and k !~ /[0-9]/ and lower[k.downcase] = v.to_i
end

freq = {}
File.readlines("upper.txt").each do |line|
  upper,upper_key = line.split
  upper = upper.to_i
  if upper_key
    key = upper_key.downcase
    if upper_key =~ /[a-z]/ and upper_key !~ /[0-9]/  # not all caps, contains no digits
      next unless lower[key] # must occur in lowercase
      if upper / lower[key] > 3
        # suspicious ratio
        next if lower[key] < 40
      end
      freq[key] = upper.to_i + lower[key]
    end
  end
end

File.open("merged.txt", "w") do |file|
  freq.to_a.each {|w,f| file.puts "#{f} #{w}" if f > 1 }
end

`< merged.txt sort -rn > #{dest}`
`rm lower.txt upper.txt merged.txt`
