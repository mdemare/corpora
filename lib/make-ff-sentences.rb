#encoding: utf-8
#call with: chapters sentences-out
#select c.story,c.chapter,c.githash into outfile "/tmp/f" FIELDS TERMINATED BY ',' from fanfiction_chapters c,fanfiction_stories s where s.id=c.story and s.language='nl';
texts = File.read(ARGV[0]).split("\n").map {|x| x.split ?; }

GITREPOS="/home/mdemare/corpora/raw-data"

`echo '' > #{ARGV[1]}`
texts.each do |story,chapter,githash|
  %x@ git --git-dir #{GITREPOS} cat-file blob #{githash} | tr '`' \\' | sed -e 's:</[pP]>::g;s:<[pP][^>]*>:`:g;s:<[bB][rR]>:`:g;s:<[/]\{0,1\}[bBiIuU]\{0,1\}>::g' -e 's:<[^>]*>::g' | tr '`' '\\n'  | grep -P -v '^[[:blank:]]\{0,1\}<' | ~/proj/corpora/lib/cleanup | ~/proj/corpora/lib/groom '#{story},#{chapter},' >> #{ARGV[1]} @
end
