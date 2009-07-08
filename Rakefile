task :upload_rubyforge_site do
  content = "<pre>#{File.read('README')}</pre>"
  File.open("index.html", "w+") {|f| f << content }
  `scp index.html leethal@rubyforge.org:/var/www/gforge-projects/prowl`
  File.delete("index.html")
end