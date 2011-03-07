#encoding: utf-8
#call with: lang sentences-out
#select c.story,c.chapter,c.githash into outfile "/home/mysql/#{ARGV[0]}-chapters" FIELDS TERMINATED BY ',' from fanfiction_chapters c,fanfiction_stories s where s.id=c.story and s.language='nl';
texts = File.read("/home/mysql/ff-chapters-#{ARGV[0]}").split("\n").map {|x| x.split ?; }

GITREPOS="/home/mdemare/corpora/raw-data"

File.open("/home/mdemare/corpora/#{ARGV[1]}-sentences", "w") do |f|
  texts.each do |story,chapter,githash|
    html = %x@ git --git-dir #{GITREPOS} cat-file blob #{githash} @
    html =~ /<div id=storytext class=storytext>/
    body = $'
    body =~ %r{</div><div style='height:10px'></div>}
    body = $`
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
