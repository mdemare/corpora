require 'date'
require 'tempfile'

DATABASE = "corpora_development"

def to_unix_time(s)
  y,d,m = s.delete("^0-9-").split(?-).reverse.map(&:to_i)
  if y && m && d
    y = y < 50 ? y+2000 : y < 100 ? y + 1900 : y
    Date.new(y,m,d).to_time.to_i
  else
    ""
  end
rescue
  raise s
end

tf = Tempfile.new("index")
tf.open
tf.chmod(0644)

while line=gets
  medium,work,url,rest = line.chomp.gsub("&amp;","&").gsub("&gt;",">").gsub("&lt;","<").split(?;,4)
  if not rest
    STDERR.puts line
    next
  end
  pos = rest =~ %r{;[;/]}
  title = $`.gsub(?;, ?,)
  rest =~ /;([^;]*);/
  url2 = $1
  fields = $'.split(" - ")
  
  if fields[-1] != "Complete"
    fields << "N"
  else 
    fields[-1] = "Y"
  end
  head = fields[0,5]
  if head[2] =~ /Chapters: /
    head = [*head[0,2],"",*head[2,2]]
  end
  if fields[-2] =~ /Published/
    tail = [fields[-2],"",fields[-1]]
  else
    tail = fields[-3,3]
  end
  reviews = fields[4,2].grep(/Reviews/)[0]
  updated = fields[5,2].grep(/Updated/)[0] || ""
  fields = [*head,reviews,updated,*tail]
  if fields.size != 10
    STDERR.puts fields.to_s
  else
    rating,lang,genre,chapters,words,reviews,updated,published,characters,status = fields
    if chapters !~ /Chapters: /
      STDERR.puts line
    elsif words !~ /Words: /
      STDERR.puts line
    elsif published !~ /Published: /
      STDERR.puts fields.join ?;
      STDERR.puts line
      
    else
      chapters = chapters.delete "^0-9"
      words = words.delete "^0-9"
      reviews = reviews ? reviews.delete("^0-9") : "0"

      updated = to_unix_time(updated)
      published = to_unix_time(published)
      if url2 =~ %r{s/}
        url2,author = "",""
      elsif url2 =~ %r{u/.}
        url2,author = url2[2..-1].split(?/)
      else
        STDERR.puts url2
        url2,author = "",""
      end
      url = url[3..-1].split(?/)[0]
      char_a,char_b = characters.split(" & ")
      if line =~ /Reviews/ and reviews.to_i == 0
        STDERR.puts line
      else
        tf.print medium,?;,work,?;,url,?;,title,?;,url2,?;,author,?;,rating,?;,lang,?;,genre,?;,chapters,?;,words,?;,reviews,?;,updated,?;,published,?;,char_a,?;,char_b,?;,status,"\n"
      end
    end
  end
end
tf.close
puts "load into db"


%x@ echo 'LOAD DATA INFILE "#{tf.path}" INTO TABLE fanfiction_stories FIELDS TERMINATED BY ";" (medium,work,story_id,title,author_id,author_name,rating,language,genre,chapters,words,reviews,update_date,publish_date,character_a,character_b,completed)' | mysql -u root #{DATABASE} @
tf.unlink
