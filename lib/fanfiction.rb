require 'tempfile'
require 'net/http'
require 'fileutils'

STDERR.puts ARGV[0]

if ARGV.size != 2
  STDERR.puts "usage: ruby fanfiction.rb story-id-file language"
  exit
end

GITREPOS="/home/mdemare/corpora/raw-data"

$tf = Tempfile.new("ff")
$tf.chmod(0644)

$outputfile = File.open("/home/mdemare/corpora/stories/fanfiction-chapters-#{ARGV[1]}.txt",'w')

stories = if ARGV[0] =~ /\d+\.\.\d+/
  s,e = ARGV[0].split("..")
  (s.to_i .. e.to_i).to_a
else
  File.read(ARGV[0]).split("\n")
end

chapter = 1

def save(html, story, chapter)
  html =~ /www.fictionratings.com/
  begin
    lang = $'[0,50].split('-')[1].strip.downcase
  rescue
    STDERR.puts html.inspect
    exit
  end
  html =~ /storytext>/
  html = $'
  html =~ /Review this/
  $tf.open
  $tf.write($`)
  $tf.close
  
  git_cmd = "git --git-dir #{GITREPOS} hash-object -w #{$tf.path}"
  IO.popen(git_cmd) do |output|
    line = [story,chapter,output.gets.chomp].join(?;)
    $outputfile.puts line
  end
  
end

start = Time.now
jstart = 0
http = Net::HTTP.start "www.fanfiction.net"
stories.each_with_index do |story,j|
  if Time.now-start > 60
    start = Time.now
    speed = j-jstart
    remaining = stories.size - j
    STDERR.puts "speed: #{speed} per minute, remaining time: #{remaining/speed} minutes"
    jstart = j
  end
  
  loop do
    u = "/s/#{story}/#{chapter}"
    begin
      h = http.get(u).body
      if h =~ /408 Request Timeout/
        sleep 60
        next
      end
    rescue Exception
      begin
        http.close
      rescue Exception
      end
      STDERR.puts "network error, resuming in 5 minutes"
      sleep 300
      http = Net::HTTP.start "www.fanfiction.net"
      next
    end
    if h.empty?
      # puts "story #{story} is blank, skipping"
      break
    elsif h =~ /Story Not Found/
      # illegal id
      # puts "story #{story} is illegal, skipping"
      break
    elsif h =~ /chapter navigation/
      # has chapters, save chapter, go to next
      save(h,story,chapter) and next
      chapter += 1
    elsif chapter > 1
      # last chapter
      # puts "last chapter found"
      chapter = 1
      break
    elsif h =~ /Message Type 1/
      # illegal id
      # puts "story #{story} is illegal, skipping"
      chapter = 1
      break
    else
      # single chapter, save chapter, next story
      # puts "single chapter story"
      save(h,story,chapter)
      break
    end
  end
end

$outputfile.close

%x@ echo 'LOAD DATA INFILE "#{$outputfile.path}" INTO TABLE fanfiction_chapters FIELDS TERMINATED BY ";" (story,chapter,githash)' | mysql -u root corpora_development @
