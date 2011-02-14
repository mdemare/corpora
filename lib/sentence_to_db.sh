LANG=$1
LONGLANG=$2
CORPUS=$3
echo 'Using language '$LONGLANG'('$LANG'), corpus: '$CORPUS
< $LONGLANG/ff-sentences tr '.?¿!¡;,()"&$%' ' ' | sed 's:^-::g;s:-$::g;s: -::g;s:- ::g' | ruby lib/process.rb

#< $LONGLANG/ff-sentences ruby -ne '$count = $count.to_i + 1;($lines ||= []) << $_.chomp;if $count % 100 == 0;puts("#{-1+$count/100};"+$lines.join("/"));$lines = [];end' > process/sentences
echo 'insert into sources (lang,corpus) values ("'$LANG'","'$CORPUS'")' | mysql -u root corpora_development
SOURCE=`echo 'select max(id) from sources group by id' |  mysql -u root corpora_development | tail -1`
echo 'New source with id '$SOURCE

echo 'LOAD DATA INFILE "/Users/mdemare/corpora/process/sentences" INTO TABLE sequences FIELDS TERMINATED BY ";" (@pos,@txt) set id = @pos+1000000000*'$SOURCE',compressed_sentences = compress(@txt)'
echo 'LOAD DATA INFILE "/Users/mdemare/corpora/process/sentences" INTO TABLE sequences FIELDS TERMINATED BY ";" (@pos,@txt) set id = @pos+1000000000*'$SOURCE',compressed_sentences = compress(@txt)' | mysql -u root corpora_development
echo 'LOAD DATA INFILE "/Users/mdemare/corpora/process/tokens" INTO TABLE tokens FIELDS TERMINATED BY "," (@id,word,@w1,@w2,frequency) set source_id='$SOURCE' ,id = @id+1000000000*'$SOURCE' , wtoken1_id = @wt1+1000000000*'$SOURCE' ,wtoken2_id = @wt2+1000000000*'$SOURCE
echo 'LOAD DATA INFILE "/Users/mdemare/corpora/process/tokens" INTO TABLE tokens FIELDS TERMINATED BY "," (@id,word,@w1,@w2,frequency) set source_id='$SOURCE' ,id = @id+1000000000*'$SOURCE' , wtoken1_id = @wt1+1000000000*'$SOURCE' ,wtoken2_id = @wt2+1000000000*'$SOURCE | mysql -u root corpora_development
echo 'LOAD DATA INFILE "/Users/mdemare/corpora/process/3-grams" INTO TABLE three_grams FIELDS TERMINATED BY ";" (@id,@w1,@w2,@w3) set id = @id+1000000000*'$SOURCE',wtoken1_id = @w1+1000000000*'$SOURCE',wtoken2_id = @w2+1000000000*'$SOURCE',wtoken3_id = @w3+1000000000*'$SOURCE
echo 'LOAD DATA INFILE "/Users/mdemare/corpora/process/3-grams" INTO TABLE three_grams FIELDS TERMINATED BY ";" (@id,@w1,@w2,@w3) set id = @id+1000000000*'$SOURCE',wtoken1_id = @w1+1000000000*'$SOURCE',wtoken2_id = @w2+1000000000*'$SOURCE',wtoken3_id = @w3+1000000000*'$SOURCE | mysql -u root corpora_development
echo 'LOAD DATA INFILE "/Users/mdemare/corpora/process/3-grams-sequences" INTO TABLE sequences_three_grams FIELDS TERMINATED BY ";" (@seq,@g3) set sequence = @seq+1000000000*'$SOURCE',three_gram_id = @g3+1000000000*'$SOURCE
echo 'LOAD DATA INFILE "/Users/mdemare/corpora/process/3-grams-sequences" INTO TABLE sequences_three_grams FIELDS TERMINATED BY ";" (@seq,@g3) set sequence = @seq+1000000000*'$SOURCE',three_gram_id = @g3+1000000000*'$SOURCE | mysql -u root corpora_development
