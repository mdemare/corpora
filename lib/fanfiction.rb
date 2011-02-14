require 'net/http'
require 'fileutils'

story = ARGV[0].to_i
INC = 1
chapter = 1

def save(html, story, chapter)
  html =~ /www.fictionratings.com/
  begin
    lang = $'[0,50].split('-')[1].strip.downcase
  rescue
    puts html.inspect
    exit
  end
  if %w(dutch english spanish french italian german).include?(lang)
    dir = if lang == 'english'
      FileUtils.mkdir_p("/Users/mdemare/corpora/#{lang}/fanfiction.net/#{1+story/100000}00k")
    else
      FileUtils.mkdir_p("/Users/mdemare/corpora/#{lang}/fanfiction.net")
    end
    html =~ /storytext>/
    html = $'
    html =~ /Review this/
    File.open(File.join(dir,"#{story}-#{chapter}.txt"), 'w') {|f| f.write($`) }
    puts "saving story(#{story}, chapter(#{chapter}) in #{lang})"
  else
    puts "skipping story in #{lang}"
    :skip
  end
end

http = Net::HTTP.start "www.fanfiction.net"
loop do
  u = "/s/#{story}/#{chapter}"
  begin
    h = http.get(u).body
  rescue
    http.close rescue nil
    sleep 30
    http = Net::HTTP.start "www.fanfiction.net"
    retry
  end
  if h.empty?
    puts "story #{story} is blank, skipping"
    story += INC
  elsif h =~ /Story Not Found/
    # illegal id
    puts "story #{story} is illegal, skipping"
    story += INC
  elsif h =~ /chapter navigation/
    # has chapters, save chapter, go to next
    save(h,story,chapter) and story += INC and next
    chapter += 1
  elsif chapter > 1
    # last chapter
    puts "last chapter found"
    story += INC
    chapter = 1
  elsif h =~ /Message Type 1/
    # illegal id
    puts "story #{story} is illegal, skipping"
    story += INC
    chapter = 1
  else
    # single chapter, save chapter, next story
    puts "single chapter story"
    save(h,story,chapter)
    story += INC
  end
  if story % 100_000 == 0 and chapter == 1
    s = "Reached story #{story}"
    puts s
    `say '#{s}'`
    exit
  end
end
