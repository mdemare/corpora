require 'tempfile'
require 'rubygems'
require 'libxml'
include LibXML

class PostCallbacks
  GITREPOS="/Volumes/HFS+/corpora/raw-data"
  include XML::SaxParser::Callbacks

  def on_start_element(element, attributes)
    case element
    when 'title'
      $yes = true
    when 'text'
      $compress = :create
    end
  end
  
  def on_characters(chars)
    if $yes
      $current = chars
      $yes = false
    elsif $compress == :create
      STDERR.puts "#{$current}."
      $compress = :append
      $article = chars
    elsif $compress == :append
      $article << chars
    end
  end
  
  def on_end_element(element)
    case element
    when 'text'
      $file.close
      if $article.size > 500
        tf = Tempfile.new("ss")
        tf.open
        tf.chmod(0644)
        tf.write ...
        tf.close
        git_cmd = "git --git-dir #{GITREPOS} hash-object -w #{tf.path}"
        IO.popen(git_cmd) do |output|
          $data << [$current,output.gets.chomp].join(?;)
        end
      else
        STDERR.puts "skipping #{$current}"
      end
      $compress = nil
    end
  end
end
$data = []

parser = XML::SaxParser.file("/Volumes/HFS+/corpora/#{ARGV[0]}wiki-latest-pages-articles.xml")
parser.callbacks = PostCallbacks.new
parser.parse

tf = Tempfile.new("meta")
tf.open
tf.chmod(0644)
tf.puts data
puts data
tf.close
puts "load into db"
%x@ echo 'LOAD DATA INFILE "#{tf.path}" INTO TABLE wikipedia_articles FIELDS TERMINATED BY ";" (title,githash) set language = "#{ARGV[0]}"' | mysql -u root #{DATABASE} @
tf.unlink
