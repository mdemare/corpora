require 'tempfile'
require 'rubygems'
require 'libxml'
include LibXML

class PostCallbacks
  GITREPOS="/home/mdemare/corpora/raw-data"
  include XML::SaxParser::Callbacks

  def on_start_element(element, attributes)
    case element
    when 'title'
      $title = true
      $current = ''
    when 'text'
      $compress = :create
    end
  end
  
  def on_characters(chars)
    if $title
      $current << chars.force_encoding("utf-8")
    elsif $compress == :create
      $compress = :append
      $article = chars
    elsif $compress == :append
      $article << chars
    end
  end
  
  def on_end_element(element)
    case element
    when 'title'
      $title = false
    when 'text'
      if $article.size > 500
        tf = Tempfile.new("ss")
        tf.open
        tf.chmod(0644)
        tf.write $article
        tf.close
        git_cmd = "git --git-dir #{GITREPOS} hash-object -w #{tf.path}"
        IO.popen(git_cmd) do |output|
          $data << [$current,output.gets.chomp].join(?;)
        end
      end
      $compress = nil
    end
  end
end

DATABASE = 'corpora_development'
start = Time.now
jstart = 1
glob = Dir.glob(ARGV[1])
glob.each_with_index do |filename,j|
  $data = []
    
  parser = XML::SaxParser.file(filename)
  parser.callbacks = PostCallbacks.new
  parser.parse
  tf = Tempfile.new("meta")
  tf.open
  tf.chmod(0644)
  tf.puts $data
  tf.close
  %x@ echo 'LOAD DATA INFILE "#{tf.path}" INTO TABLE wikipedia_articles FIELDS TERMINATED BY ";" (title,githash) set language = "#{ARGV[0]}"' | mysql -u root #{DATABASE} @
  tf.unlink

  if Time.now-start > 60
    start = Time.now
    speed = j-jstart
    remaining = glob.size - j
    STDERR.puts "speed: #{speed} per minute, remaining time: #{remaining/speed} minutes"
    jstart = j
  end
end
