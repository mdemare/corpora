require 'net/http'
require 'fileutils'

story = ARGV[0].to_i

def save(html, story)
  h = html.split "\n"
  title = h.grep(/^<img src/)[0].gsub("</a>","").gsub(" &#187; ",";").gsub("<b>","").gsub("<a href=","").gsub('/">',' ').gsub('"',' ')
  writer = h.grep(/^<a href='\/u/)[0].gsub("'>",";")
  rating = h.grep(/^Rated: <a href/)[0]
  rating =~ /www.fictionratings.com/
  lang = $'[0,50].split('-')[1].strip.downcase
  rating = rating.gsub("</a>","").gsub("/'>",":")
  chapter = h.grep(/^ <SELECT/)[0]
  chapter = chapter ? chapter.split("value=")[-1][0,4] : ""
  puts "#{lang}|#{title[116...-4]}|#{writer[12...-4]}|#{rating[65..-33]}|#{chapter}"
end

http = Net::HTTP.start "www.fanfiction.net"
loop do
  u = "/s/#{story}/1"
  begin
    h = http.get(u).body[10000,16000]
  rescue Exception
    begin
      http.close
    rescue Exception
    end
    `say network error, resuming in 5 minutes`
    sleep 300
    http = Net::HTTP.start "www.fanfiction.net"
    retry
  end
  if !h or h.empty?
    puts "#{story} blank"
  elsif h =~ /Story Not Found/
    puts "#{story} illegal"
  elsif h =~ /chapter navigation/
    print "#{story} many chapters:"
    save(h,story)
  elsif h =~ /Message Type 1/
    puts "#{story} illegal"
  else
    print "#{story} 1 chapter:"
    save(h,story)
  end
  story += 1
end
