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
$outputfile = File.open("/home/mdemare/corpora/ff-chapters-#{ARGV[1]}",'w')

$j = 0

def save(html, story, chapter)
  $j += 1
  st = story.to_s.rjust(7,'0')
  dir = "/home/mdemare/corpora/ingredients/fanfiction/#{ARGV[1]}/#{st[0,3]}"
  FileUtils.mkdir_p(dir)
  fname = File.join(dir, "#{st}-#{chapter}")
  File.open(fname, "w") {|f| f.write(html) }
  git_cmd = "git --git-dir #{GITREPOS} hash-object -w #{fname}"
  IO.popen(git_cmd) do |io|
    $outputfile.puts [story,chapter,io.gets.chomp].join(?,)
  end
end

stories = File.read(ARGV[0]).split("\n")

start = Time.now
jstart = 0
stories.each_with_index do |story,i|
  if Time.now-start > 60
    start = Time.now
    speed = $j-jstart
    remaining = stories.size - i
    STDERR.puts "speed: #{speed} chapters per minute, remaining stories #{remaining}"
    jstart = $j
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

%x@ echo 'LOAD DATA INFILE "#{$outputfile.path}" INTO TABLE fanfiction_chapters FIELDS TERMINATED BY "," (story,chapter,githash)' | mysql -u root corpora_development @
