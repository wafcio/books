require "yaml"

task :move_book do
  book = YAML.load_file("tmp/template.yml")
  FileUtils.cp("tmp/template.yml", "data/books/#{book["book"]["isbn"]}.yml")

  images = []
  images << book["book"]["image"] if book["book"]
  images << book["ebook"]["image"] if book["ebook"]
  images << book["audiobook"]["image"] if book["audiobook"]
  images.uniq!

  images.each do |image|
    FileUtils.cp("tmp/#{image}", "source/images/#{image}")
  end
end
