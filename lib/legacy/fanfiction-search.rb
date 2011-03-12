# encoding: utf-8
require 'curb'
require 'nokogiri'

$http = Curl::Easy.new
def get_html(url)
  $http.url = url
  $http.perform
  $http.body_str
rescue Exception
  STDERR.puts "Network error"
  sleep 30
  retry
end

#http://www.fanfiction.net/book/Forgotten_Realms/:rating/:genre/:language/:order/:length/:char_a/:char_b/:completed/:unused/:page/ # completed

def handle_work(medium,title,url_template)
  page = 1
  start = Time.now
  jstart = page
  loop do
    if Time.now-start > 60
      STDERR.puts "speed: #{page-jstart} per minute"
      start = Time.now
      jstart = page
    end
    h = get_html(sprintf(url_template,page))
    if h =~ /<center>No entries found with current settings/
      break
    end
    rs = Nokogiri::HTML(h).css(".z-list")
    if rs.empty?
      STDERR.puts "no .z-list found in "+sprintf(url_template,page)
      sleep 5
      next # page not updated
    end
    rs.each do |r|
      if r.css("div").size == 2
        links = r.css("a").map{|x| x.attributes["href"]}
        fields = r.css("div")[1].children.to_s[7..-1]
        puts "#{medium};#{title};#{links.join(' ')};#{r.children[1].children[0]};#{fields}"
      end
    end
    if h =~ /([\d,]+) found/
      nr_results = $1.delete(",").to_i
      if rs[-1].children[0].to_s[0...-2].to_i == nr_results
        STDERR.puts "Seen the last of popular work #{url_template}"
        break
      end
    else
      break
    end
    page += 1
  end
end

skipping = true
%w(anime book cartoon comic game misc movie play tv).map do |genre|
  get_html("http://www.fanfiction.net/#{genre}/").scan(/href="\/(#{genre})\/([^"]+)\/"/)
end.flatten(1).each do |medium,title|
  # if skipping
  #   if medium == "movie" && title == "Zoom"
  #     skipping = false
  #   end
  #   next
  # end
  STDERR.puts "#{medium} - #{title.inspect}"
  u = "http://www.fanfiction.net/#{medium}/#{title}/10/0/0/2/1/0/0/0/0/%d/"
  handle_work(medium,title,u)
end
