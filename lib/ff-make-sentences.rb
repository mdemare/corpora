#encoding: utf-8
#call with: lang
#select c.story,c.chapter,c.githash into outfile "/home/mysql/ff-chapters-#{ARGV[0]}" FIELDS TERMINATED BY ',' from fanfiction_chapters c,fanfiction_stories s where s.id=c.story and s.language='#{ARGV[0]}';
texts = File.read("/home/mysql/ff-chapters-#{ARGV[0]}").split("\n").map {|x| x.split ?, }

GITREPOS="/home/mdemare/corpora/raw-data"

File.open("/home/mdemare/corpora/#{ARGV[0]}-sentences", "w") do |f|
  texts.each do |story,chapter,githash|
    html = %x@ git --git-dir #{GITREPOS} cat-file blob #{githash} @
    html =~ /<div id=storytext class=storytext>/
    body = $'
    body =~ %r{</div><div style='height:10px'></div>}
    body = $`
    unless body
      STDERR.puts "no match found for #{githash}"
      next
    end
    body.tr! "`" , "'"
    body.gsub! %r:</[pP]>: , ''
    body.gsub! %r:<[pP][^>]*>: , ' '
    body.gsub! %r:<[bB][rR]>: , ' '
    body.gsub! %r:<[/]?[bBiIuU]?>: , ''
    body.gsub! %r:<[^>]*>: , ''
    IO.popen("~/proj/corpora/lib/cleanup | ~/proj/corpora/lib/groom '#{story},#{chapter},'", "r+") do |io|
      io.write(body)
      io.close_write
      
      input = io.read
      f.write(input)
    end
  end
end
