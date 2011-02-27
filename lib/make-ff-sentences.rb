#encoding: utf-8
texts = File.read(ARGV[0]).split("\n").map {|x| x.split ?, }

GITREPOS="/home/mdemare/corpora/raw-data"

File.open(ARGV[1],"w") do |f|
  texts.each do |story,chapter,githash|
    %x@ git --git-dir #{GITREPOS} cat-file blob #{githash} | tr '`' \\' | sed -e 's:</[pP]>::g;s|<a class=.positive. onClick=.select_drop("review");. href=.#.>||;s:<[pP][^>]*>:`:g;s:<[bB][rR]>:`:g;s:<[/]\{0,1\}[bBiIuU]\{0,1\}>::g' -e 's:<[^>]*>::g' | tr '`' '\\n'  | grep -P -v '^[[:blank:]]\{0,1\}<' | ~/proj/corpora/lib/cleanup | ~/proj/corpora/lib/groom '#{story},#{chapter},' >> #{f.path} @
  end
end
