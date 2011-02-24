# run in ~/corpora
LANG=$1
SOURCE=$2
SENTENCES=$3
DATABASE="corpora_development"

# CREATE SOURCES MANUALLY
# echo 'insert into sources (lang,corpus) values ("'$LANG'","'$CORPUS'")' | mysql -u root $DATABASE
# CMD='echo '\''select lpad(max(id),2,"0") from sources group by id'\'' |  mysql -u root '$DATABASE' | tail -1'
# SOURCE=$(eval $CMD)

echo "Run with arguments: language-code source input-sentences-filename"
echo 'Using language '$LANG'('$LANG'), source '$SOURCE
sleep 5

# trim, replace dashes, downcase, reject numbers, split, sort | uniq -c, cat, sort | uniq -c, sum count, reject fq <= 1, sort fq desc  
< $SENTENCES tr -dc ' [:alnum:]\n'\'- | sed 's:^-::g;s:-$::g;s: -::g;s:- ::g' | tr '[:upper:]' '[:lower:]' | tr ' ' '\n' | grep -v '[0-9]' | grep -P . | split -l 200000 process/$LANG/tokens-

cd process/$LANG

ls tokens-* | xargs -I xxx sort -o xxx xxx
ls tokens-* | xargs -I xxx uniq -c xxx uxxx
rm tokens-*
ls utokens-* | xargs cat | sort -k 2 | awk 'c && s!=$2{print c,s;c=0} {s=$2;c+=$1} END {print c,s}' | grep -v '^[1-4] ' | sort -nr | nl -s, -nrz > fq-tokens
rm utokens-*

ruby ~/proj/corpora/lib/process.rb fq-tokens $SENTENCES . $LANG

for i in {0..7}
do
  split -l 200000 bigram-$i bigram-$i-chunks-
  ls bigram-$i-chunks-* | xargs -I xxx sort -o xxx xxx
  ls bigram-$i-chunks-* | xargs -I xxx uniq -c xxx uxxx
  rm bigram-$i-chunks-*
  ls ubigram-$i-chunks-* | xargs cat | sort -k 2 | awk 'c && s!=$2{print c,s;c=0} {s=$2;c+=$1} END {print c,s}' | grep -v '^[1-2] ' | sort -nr > fq-bigram-$i
  rm ubigram-$i-chunks-*
done

split -l 200000 trigram trigram-chunks-
ls trigram-chunks-* | xargs -I xxx sort -o xxx xxx
ls trigram-chunks-* | xargs -I xxx uniq -c xxx uxxx
rm trigram-chunks-*
ls utrigram-chunks-* | xargs cat | sort -k 2 | awk 'c && s!=$2{print c,s;c=0} {s=$2;c+=$1} END {print c,s}' | grep -v '^[1-2] ' | sort -nr > fq-trigram
rm utrigram-chunks-*

exit

echo 'LOAD DATA INFILE "'`pwd`'/sentences" INTO TABLE seq_'$SOURCE' FIELDS TERMINATED BY "," (id,@txt) set compressed_sentences = compress(@txt)'
echo 'LOAD DATA INFILE "'`pwd`'/sentences" INTO TABLE seq_'$SOURCE' FIELDS TERMINATED BY "," (id,@txt) set compressed_sentences = compress(@txt)' | mysql -u root $DATABASE
echo 'LOAD DATA INFILE "'`pwd`'/tokens" INTO TABLE tokens_'$SOURCE' FIELDS TERMINATED BY "," (id,word,frequency)'
echo 'LOAD DATA INFILE "'`pwd`'/tokens" INTO TABLE tokens_'$SOURCE' FIELDS TERMINATED BY "," (id,word,frequency)' | mysql -u root $DATABASE
for i in {0..7}
do
  echo 'LOAD DATA INFILE "'`pwd`'/fq-bigrams-'$i'" INTO TABLE bigrams_'$SOURCE' FIELDS TERMINATED BY "," (token1_id,token2_id,frequency) set distance='$i
  echo 'LOAD DATA INFILE "'`pwd`'/fq-bigrams-'$i'" INTO TABLE bigrams_'$SOURCE' FIELDS TERMINATED BY "," (token1_id,token2_id,frequency) set distance='$i | mysql -u root $DATABASE
done
echo 'LOAD DATA INFILE "'`pwd`'/fq-trigrams" INTO TABLE trimgrams_'$SOURCE' FIELDS TERMINATED BY "," (token1_id,token2_id,token3_id,frequency)'
echo 'LOAD DATA INFILE "'`pwd`'/fq-trigrams" INTO TABLE trimgrams_'$SOURCE' FIELDS TERMINATED BY "," (token1_id,token2_id,token3_id,frequency)' | mysql -u root $DATABASE

