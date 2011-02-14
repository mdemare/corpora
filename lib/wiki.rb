require 'rubygems'
require 'htmlentities'
coder = HTMLEntities.new

count = 0
ignore = true
ignore_small = false
while x=gets
  count += 1
  STDERR.puts(count / 1000000) if count % 1000000 == 0
  if ignore or ignore_small
    y = x.gsub(/&quot;/, "")
    y.gsub!(/&lt;\/[^&]+[^\/]&gt;/, "}")
    unless y =~ /<text/ or y.index("}")
      #STDERR.puts "ignoring#{ignore_small ? " small" : ""} line: #{x}"
      next
    end
  end
  x.gsub!(/<text .*<\/text>/, "")             # remove one-line articles
  x = coder.decode(x)                         # unescape html
  # STDERR.puts "after decoding: #{x}"
  x.gsub!(/<[^&]*\/>/, "")                  # remove self-closed elements
  x.gsub!(/<br[^>]*>/, "")                  # remove br elements
  x.gsub!(/<!--[^>]+-->/, "")                  # remove comments
  x.gsub!(/<\/text.*>/, "ƒƒ")                # replace text closing elements with code
  if x =~ /<\/([^ ]+).*>/
    if $1 == "span" || $1 == "div"
      x.gsub!(/<\/([^ ]+).*>/, "")              # remove span element with closing brace
    else
      x.gsub!(/<\/([^ ]+).*>/, "}")             # replace closing elements with closing brace
    end
  end
  x.gsub!(/<text.*>/, "∑∑")                  # replace text opening elements with code
  if x =~ /<([^ ]+).*>/
    if $1 == "span" || $1 == "div"
      x.gsub!(/<([^ ]+).*>/, "")              # remove span element with opening brace
    else
      x.gsub!(/<([^ ]+).*>/, "{")             # replace opening elements with opening brace
    end
  end
  x.gsub!(/'''/, "")                         # replace blockquote with space
  x.gsub!(/''/, " ")                          # replace bold with space
  x.gsub!(/^\*/, "")                         # remove unordered lists
  x.gsub!(/^\d+\. /, "")                      # remove ordered lists
  x.gsub!(/\{\{.*\}\}/, "")                   # remove one-line {{ blocks
  x.gsub!(/\{[^\}]+\}/, "")                   # remove one-line { blocks
  if x.index("[")
    x.gsub!(/\[\[[^:\]]+\|([^:\]]+)\]\]/, "\\1")  # change [[Foo | Foobar]] blocks to Foobar
    x.gsub!(/\[\[([^:\]]+)\]\]/, "\\1")          # remove [[ from [[Foo]] blocks
    x.gsub!(/\[\[[^\]]+:[^\]]+\]\]/, "")        # remove one-line [[foo:bar]] blocks
    x.gsub!(/\[[^\]]+\]/, "")                   # remove [...] blocks
  end
  r = /==.+==/;x.gsub!(r, "")                 # remove headers
  if x =~ /∑∑/
    if x =~ /infobox county/                  # remove county articles
      ignore = true
      x = ""
    else
      ignore = false
      x = x[x.index('∑') + 6 .. -1]
      #STDERR.puts "found: #{x}"
    end
  elsif x =~ /ƒƒ/
    x = x[0,x.index('ƒ')]
    ignore = true
  elsif x[0] == ?| && !x.index("}")
    x = ""
    ignore_small = true
  elsif ignore_small
    if i = x.index("}}")
      x = x[i+2 .. -1]
      ignore_small = false
    elsif i = x.index("}")
      x = x[i+1 .. -1]
      ignore_small = false
    else
      x = ""
    end
  else
    x = ignore ? "" : x
  end
  
  if i = x.index("{")
    #STDERR.puts "START ignore_small: #{x}"
    x = x[0,i]
    ignore_small = true
  end
  

  x.chomp!
  if x.size > 0
    x = x.strip.squeeze(" ").gsub(/([a-z0-9\)"'][\.\!\?]) (['[:upper:]])/,"\\1\n\\2") 
    x.split("\n").each do |line|
      if line.size > 0 && (line[-1] == ?. || line[-1] == ??) && line =~ /^['[:digit:][:upper:]]/ && line.count(" ") > 2
        puts line 
      end
    end
  end
end
STDERR.puts "done"