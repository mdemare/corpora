require 'tempfile'

GITREPOS="/home/mdemare/corpora/raw-data"

start = Time.now
jstart = 1
tf = Tempfile.new("ss")
tf.open
tf.chmod(0644)
glob = Dir.glob(ARGV[0])
puts glob.size
sleep 10

glob.each_with_index do |filename,j|
  git_cmd = "git --git-dir #{GITREPOS} hash-object -w #{filename}"
  IO.popen(git_cmd) do |output|
    tf.puts [*filename.split(?/)[-1].sub(".txt","").split(?-),output.gets.chomp].join(?;)
  end
  if Time.now-start > 60
    start = Time.now
    speed = j-jstart
    remaining = glob.size - j
    STDERR.puts "speed: #{speed} per minute, remaining time: #{remaining/speed} minutes"
    jstart = j
  end
end
tf.close
DATABASE = 'corpora_development'

puts "load into db"
%x@ echo 'LOAD DATA INFILE "#{tf.path}" INTO TABLE fanfiction_chapters FIELDS TERMINATED BY ";" (story,chapter,githash)' | mysql -u root #{DATABASE} @
tf.unlink
