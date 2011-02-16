LANG=$1
LONGLANG=$2
CORPUS=$3
DATABASE="corpora_development"
mkdir -p $LONGLANG/process
echo 'Using language '$LONGLANG'('$LANG'), corpus: '$CORPUS
#< $LONGLANG/ff-sentences tr '.?¿!¡;,()"&$%' ' ' | sed 's:^-::g;s:-$::g;s: -::g;s:- ::g' | ruby ../corpora/lib/process.rb $LONGLANG

echo 'Creating sentences file'
 < $LONGLANG/ff-sentences ruby -ne '$count = $count.to_i + 1;($lines ||= []) << $_.chomp;if $count % 100 == 0;puts("#{-1+$count/100};"+$lines.join("/"));$lines = [];end' > $LONGLANG/process/sentences
# echo 'insert into sources (lang,corpus) values ("'$LANG'","'$CORPUS'")' | mysql -u root $DATABASE
CMD='echo '\''select lpad(max(id),2,"0") from sources group by id'\'' |  mysql -u root '$DATABASE' | tail -1'
SOURCE=$(eval $CMD)
SOURCE='02'
echo 'New source with id '$SOURCE

echo 'LOAD DATA INFILE "'`pwd`'/'$LONGLANG'/process/sentences" INTO TABLE seq_'$SOURCE' FIELDS TERMINATED BY ";" (id,@txt) set compressed_sentences = compress(@txt)'
echo 'LOAD DATA INFILE "'`pwd`'/'$LONGLANG'/process/sentences" INTO TABLE seq_'$SOURCE' FIELDS TERMINATED BY ";" (id,@txt) set compressed_sentences = compress(@txt)' | mysql -u root $DATABASE
echo 'LOAD DATA INFILE "'`pwd`'/'$LONGLANG'/process/tokens" INTO TABLE tokens_'$SOURCE' FIELDS TERMINATED BY "," (id,word,wtoken1_id,wtoken2_id,frequency,frequency_special)'
echo 'LOAD DATA INFILE "'`pwd`'/'$LONGLANG'/process/tokens" INTO TABLE tokens_'$SOURCE' FIELDS TERMINATED BY "," (id,word,wtoken1_id,wtoken2_id,frequency,frequency_special)' | mysql -u root $DATABASE
echo 'LOAD DATA INFILE "'`pwd`'/'$LONGLANG'/process/3-grams" INTO TABLE g3_'$SOURCE' FIELDS TERMINATED BY ";" (id,wtoken1_id,wtoken2_id,wtoken3_id)'
echo 'LOAD DATA INFILE "'`pwd`'/'$LONGLANG'/process/3-grams" INTO TABLE g3_'$SOURCE' FIELDS TERMINATED BY ";" (id,wtoken1_id,wtoken2_id,wtoken3_id)' | mysql -u root $DATABASE
echo 'LOAD DATA INFILE "'`pwd`'/'$LONGLANG'/process/3-grams-sequences" INTO TABLE s3g_'$SOURCE' FIELDS TERMINATED BY ";" (sequence,three_gram_id)'
echo 'LOAD DATA INFILE "'`pwd`'/'$LONGLANG'/process/3-grams-sequences" INTO TABLE s3g_'$SOURCE' FIELDS TERMINATED BY ";" (sequence,three_gram_id)' | mysql -u root $DATABASE
echo 'update g3_'$SOURCE' g set frequency = (select count(*) from s3g_'$SOURCE' s where s.three_gram_id = g.id)'
echo 'update g3_'$SOURCE' g set frequency = (select count(*) from s3g_'$SOURCE' s where s.three_gram_id = g.id)' | mysql -u root $DATABASE
tar cjf 'tdata-'$LANG'.tar.bz2' /Users/mdemare/proj/datacorp/$LONGLANG/process/*