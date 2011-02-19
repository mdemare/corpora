count = 0
filecount = 0
file = nil
status = :await_open_page
while line=STDIN.gets
  case status
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
  end
  when :await_open_page
    if line =~ /<page>/
      status = :await_close_page
      if not file
        file = File.open("#{ARGV[0]}-wiki/article-#{filecount}.txt", "w")
        file.puts "<wiki>"
        filecount += 1
      end
      file.puts line
    end
end
