count = 0
filecount = 0
file = nil
status = :await_open_page
while line=STDIN.gets
  case status
  when :await_close_text
    status = :await_close_page if line =~ /<\/text>/
    file.puts line
  when :await_open_page
    if line =~ /<page>/
      status = :await_title
      if not file
        file = File.open("#{ARGV[0]}-wiki/article-#{filecount}.txt", "w")
        file.puts "<wiki>"
        filecount += 1
      end
      file.puts line
    end
  when :await_close_page
    if line =~ /<\/page>/
      status = :await_open_page
      file.puts line
      count += 1
      if count == 1000
        count = 0
        file.puts "</wiki>"
        file.close
        file = nil
      end
    end
  when :await_open_text
    if line =~ /<text/
      file.puts line
      status = :await_close_text
    end
  when :await_title
    status = :await_open_text if line =~ /<title>/
    file.puts line
  end
end
