#encoding: utf-8
prefix = ARGV[0] || ""
count = 0
lines = []
while x=STDIN.gets
  y = x.chomp.strip
  lines << y if y.size > 2
end

# shouldn't match:
# (bv. Holland
# o.a. Holland
lines.join.gsub(/([a-zäëïöüáéíóúàèìòùâêîôûñçßœ0-9\)'" ][\.\!\?]) (['"[:upper:]])/,"\\1\n\\2").split("\n").each do |line|
  line.strip!
  if line.size > 0 and line.count(" ") >= 2 # and line =~ /^[-'A-ZÁÉÍÓÚÀÈÌÒÙÄËÏÖÜÂÊÎÔÛÇ0-9]/
    print prefix, line, "\n"
  end
end
