LANG = ARGV[0]
FFDIR = ARGV[1]
LANGUAGES = Hash[*%w(de german fr french nl dutch es spanish it italian)]
if LANG == 'en'
  langdir = "~/corpora/english/fanfiction.net"
  dir = "~/corpora/english/fanfiction.net/#{FFDIR}"
else
  langdir = "~/corpora/#{LANGUAGES[LANG]}"
  dir = "~/corpora/#{LANGUAGES[LANG]}/ff-3M"
end
# only changes specific for ff.net here - rest in cleanup
%x@ find #{dir} -name '*.txt' | xargs cat | tr '`' \\' | sed -e 's:</[pP]>::g' -e 's|<a class=.positive. onClick=.select_drop("review");. href=.#.>||' -e 's:<[pP][^>]*>:`:g' -e 's:<[bB][rR]>:`:g' -e 's:<[/]\{0,1\}[bBiIuU]\{0,1\}>::g' -e 's:<[^>]*>::g' | tr '`' '\\n'  | grep -P -v '^[[:blank:]]\{0,1\}<' | sh ~/corpora/lib/cleanup > #{dir}/../current@
dir = if LANG == 'en'
  `mv #{langdir}/current #{langdir}/c#{FFDIR}`
#  `rm -rf #{dir}`
else
  `mv #{langdir}/current #{langdir}/c3M`
  `rm -rf #{dir}`
end
