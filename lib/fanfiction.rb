# encoding: utf-8
require 'curb'
require 'fileutils'

$http = Curl::Easy.new
def get_html(url)
  $http.url = url
  $http.perform
  $http.body_str
rescue Exception
  STDERR.puts "Network error"
  sleep 30
  retry
end

if ARGV.size != 2
  STDERR.puts "usage: ruby fanfiction.rb story-id-file language"
  exit
end

GITREPOS="/home/mdemare/corpora/raw-data"
$outputfile = File.open("/home/mdemare/corpora/stories/fanfiction-chapters-#{ARGV[1]}.txt",'w')

def save(html, story, chapter)
  html =~ /storytext>/
  html = $'
  html =~ /Review this/
  st = story.to_s.rjust(7,'0')
  dir = "/home/mdemare/corpora/ingredients/fanfiction/#{ARGV[1]}/#{st[0,3]}"
  FileUtils.mkdir("/home/mdemare/corpora/ingredients/fanfiction/#{ARGV[1]}/#{st[0,3]}")
  File.open(File.join(dir, "#{story.to_s.rjust(7,'0')}-#{chapter}"), "w") do |f|
    git_cmd = "git --git-dir #{GITREPOS} hash-object -w #{f.path}"
    IO.popen(git_cmd) do |output|
      $outputfile.puts [story,chapter,output.gets.chomp].join(?;)
    end
  end
end

stories = File.read(ARGV[0]).split("\n")

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
  
  chapter = 1
  
  loop do
    h = get_html("http://www.fanfiction.net/s/#{story}/#{chapter}")
    if h.empty?
      break
    elsif h =~ /Story Not Found/
      # illegal id
      break
    elsif h =~ /chapter navigation/
      # has chapters, save chapter, go to next
      save(h,story,chapter)
      chapter += 1
      next
    elsif chapter > 1
      # last chapter
      break
    elsif h =~ /Message Type 1/
      # illegal id
      break
    else
      # single chapter, save chapter, next story
      save(h,story,chapter)
      break
    end
  end
end

$outputfile.close

%x@ echo 'LOAD DATA INFILE "#{$outputfile.path}" INTO TABLE fanfiction_chapters FIELDS TERMINATED BY ";" (story,chapter,githash)' | mysql -u root corpora_development @
