require 'date'

DATABASE = "corpora_development"
LANGUAGE_CODES = Hash[*%w(english en french fr dutch nl german de spanish es italian it swedish sv czech cs russian ru danish da norwegian no 
                          polish pl finnish fi japanese ja portuguese pt chinese zh esperanto eo greek el indonesian id latin la albanian sq 
                          arabic ar bulgarian bg croatian hr catalan ca hebrew he hindi hi hungarian hu korean ko punjabi pa romanian ro scandinavian sv 
                          serbian sr thai th turkish tr vietnamese vi farsi fa filipino tl)]

def to_unix_time(s)
  y,d,m = s.delete("^0-9-").split(?-).reverse.map(&:to_i)
  if y && m && d
    [y,m,d].join(?-)
    Date.new(y,m,d).to_time.to_i
  else
    ""
  end
rescue
  raise s
end
to_unix_time("2-16-10")
tf = File.open("/home/mdemare/corpora/search-results.sql","w")
tf.chmod(0644)

while line=gets
  # medium: anime
  # work: Return_to_Labyrinth
  # urls: /s/6950236/1/lo_prohibido_es_lo_mas_deseado /u/2666094/Dianithaxsasusaku
  # title: lo prohibido es lo mas deseado:::
  # fields: M - Spanish - Romance/Drama - Chapters: 1 - Words: 2,874 - Published: 4-29-11  
  
  medium,work,url,rest = line.chomp.gsub("&amp;","&").gsub("&gt;",">").gsub("&lt;","<").split(?;,4)
  
  if not rest
    STDERR.puts line
    next
  end
  
  fields = rest.split(?;).last
  title = rest.split(?;)[0...-1].join(?:)
  
  if url.nil?
    STDERR.puts line
    next
  end
  
  url2 = url.split.first
  
  title.gsub!(?;, ?,)
    
  fields = fields.split(" - ")
  
  if fields[-1] != "Complete"
    fields << "N"
  else 
    fields[-1] = "Y"
  end
  head = fields[0,5]
  if head[2] =~ /Chapters: /
    head = [*head[0,2],"",*head[2,2]]
  end

  unless head.size == 5
    STDERR.puts line
    next 
  end
  /home/mdemare/proj/corpora/lib/legacy/search-results.rb:61:in `<main>': cartoon;X-Men_Evolution;/s/2415613/1/Losing_her_grip5966693313316186ntDisposition_formdata_namecensorid3 /u/370708/RogueFan23 /r (RuntimeError)g her grip
  
  if fields[-2] =~ /Published/
    tail = [fields[-2],"",fields[-1]]
  else
    tail = fields[-3,3]
  end
raise unless tail.size == 3
  reviews = fields[4,2].grep(/Reviews/)[0]
  updated = fields[4,3].grep(/Updated/)[0] || ""
  fields = [*head,reviews,updated,*tail]
  if fields.size != 10
    STDERR.puts line
    STDERR.puts fields.inspect
  else
    rating,language,genre,chapters,words,reviews,updated,published,characters,status = fields
    lang = LANGUAGE_CODES[language.downcase]
    next unless lang
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
      if url2 =~ %r{/s/}
        url2,author = "",""
      elsif url2 =~ %r{/u/.}
        url2,author = url2[3..-1].split(?/)
      else
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
%x! echo 'LOAD DATA INFILE "/home/mdemare/corpora/search-results.sql" INTO TABLE fanfiction_stories FIELDS TERMINATED BY ";" (medium,work,id,title,author_id,author_name,rating,language,genre,chapters,words,reviews,@up,@pd,character_a,character_b,completed) set update_date = date(@ud),publish_date = date(@pd)' | mysql -u root #{DATABASE} !
