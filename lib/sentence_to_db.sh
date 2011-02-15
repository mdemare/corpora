LANG=$1
LONGLANG=$2
CORPUS=$3
echo 'Using language '$LONGLANG'('$LANG'), corpus: '$CORPUS
< $LONGLANG/ff-sentences tr '.?¿!¡;,()"&$%' ' ' | sed 's:^-::g;s:-$::g;s: -::g;s:- ::g' | ruby ../corpora/lib/process.rb

echo 'Creating sentences file'
< $LONGLANG/ff-sentences ruby -ne '$count = $count.to_i + 1;($lines ||= []) << $_.chomp;if $count % 100 == 0;puts("#{-1+$count/100};"+$lines.join("/"));$lines = [];end' > process/sentences
echo 'insert into sources (lang,corpus) values ("'$LANG'","'$CORPUS'")' | mysql -u root corpora_development
SOURCE=`echo 'select max(id) from sources group by id' |  mysql -u root corpora_development | tail -1`
SOURCE='01'
echo 'New source with id '$SOURCE

echo 'LOAD DATA INFILE "/Users/mdemare/proj/datacorp/process/sentences" INTO TABLE seq_'$SOURCE' FIELDS TERMINATED BY ";" (id,@txt) set compressed_sentences = compress(@txt)'
echo 'LOAD DATA INFILE "/Users/mdemare/proj/datacorp/process/sentences" INTO TABLE seq_'$SOURCE' FIELDS TERMINATED BY ";" (id,@txt) set compressed_sentences = compress(@txt)' | mysql -u root corpora_development
echo 'LOAD DATA INFILE "/Users/mdemare/proj/datacorp/process/tokens" INTO TABLE tokens_'$SOURCE' FIELDS TERMINATED BY "," (id,word,wtoken1_id,wtoken2_id,frequency,frequency_special)'
echo 'LOAD DATA INFILE "/Users/mdemare/proj/datacorp/process/tokens" INTO TABLE tokens_'$SOURCE' FIELDS TERMINATED BY "," (id,word,wtoken1_id,wtoken2_id,frequency,frequency_special)' | mysql -u root corpora_development
echo 'LOAD DATA INFILE "/Users/mdemare/proj/datacorp/process/3-grams" INTO TABLE g3_'$SOURCE' FIELDS TERMINATED BY ";" (id,wtoken1_id,wtoken2_id,wtoken3_id)'
echo 'LOAD DATA INFILE "/Users/mdemare/proj/datacorp/process/3-grams" INTO TABLE g3_'$SOURCE' FIELDS TERMINATED BY ";" (id,wtoken1_id,wtoken2_id,wtoken3_id)' | mysql -u root corpora_development
echo 'LOAD DATA INFILE "/Users/mdemare/proj/datacorp/process/3-grams-sequences" INTO TABLE s3g_'$SOURCE' FIELDS TERMINATED BY ";" (sequence,three_gram_id)'
echo 'LOAD DATA INFILE "/Users/mdemare/proj/datacorp/process/3-grams-sequences" INTO TABLE s3g_'$SOURCE' FIELDS TERMINATED BY ";" (sequence,three_gram_id)' | mysql -u root corpora_development

echo 'update g3_'$SOURCE' g set frequency = (select count(*) from s3g_'$SOURCE' s where s.three_gram_id = g.id)' | mysql -u root corpora_developmentecho 'LOAD DATA INFILE "/Users/mdemare/proj/datacorp/process/sentences" INTO TABLE seq_'$SOURCE' FIELDS TERMINATED BY ";" (id,@txt) set compressed_sentences = compress(@txt)'

echo 'LOAD DATA INFILE "/home/inglua/process/sentences" INTO TABLE seq_'$SOURCE' FIELDS TERMINATED BY ";" (id,@txt) set compressed_sentences = compress(@txt)' | mysql -u root corpora
echo 'LOAD DATA INFILE "/home/inglua/process/tokens" INTO TABLE tokens_'$SOURCE' FIELDS TERMINATED BY "," (id,word,wtoken1_id,wtoken2_id,frequency,frequency_special)'
echo 'LOAD DATA INFILE "/home/inglua/process/tokens" INTO TABLE tokens_'$SOURCE' FIELDS TERMINATED BY "," (id,word,wtoken1_id,wtoken2_id,frequency,frequency_special)' | mysql -u root corpora
echo 'LOAD DATA INFILE "/home/inglua/process/3-grams" INTO TABLE g3_'$SOURCE' FIELDS TERMINATED BY ";" (id,wtoken1_id,wtoken2_id,wtoken3_id)'
echo 'LOAD DATA INFILE "/home/inglua/process/3-grams" INTO TABLE g3_'$SOURCE' FIELDS TERMINATED BY ";" (id,wtoken1_id,wtoken2_id,wtoken3_id)' | mysql -u root corpora
echo 'LOAD DATA INFILE "/home/inglua/process/3-grams-sequences" INTO TABLE s3g_'$SOURCE' FIELDS TERMINATED BY ";" (sequence,three_gram_id)'
echo 'LOAD DATA INFILE "/home/inglua/process/3-grams-sequences" INTO TABLE s3g_'$SOURCE' FIELDS TERMINATED BY ";" (sequence,three_gram_id)' | mysql -u root corpora
echo 'update g3_'$SOURCE' g set frequency = (select count(*) from s3g_'$SOURCE' s where s.three_gram_id = g.id)' | mysql -u root corpora
