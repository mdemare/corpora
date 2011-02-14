count = 0
while x=gets
  count += 1
  STDERR.puts(count / 1000000) if count % 1000000 == 0
  
  x.chomp!
  if x.size > 0
    # shouldn't match:
    # (bv. Holland
    # o.a. Holland
    x = x.strip.gsub(/([a-z0-9\)' ][\.\!\?]) (['[:upper:]])/,"\\1\n\\2")
    x.split("\n").each do |line|
      line.strip!
      if line.size > 0 and line.count(" ") >= 2 # and line =~ /^[-'A-ZÁÉÍÓÚÀÈÌÒÙÄËÏÖÜÂÊÎÔÛÇ0-9]/
        puts line
      end
    end
  end
end
