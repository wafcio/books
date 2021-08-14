# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

# Layouts
# https://middlemanapp.com/basics/layouts/

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

page "/books.html"
page "/course_groups.html"
# page "/courses.html"

# With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/

books = Dir.glob("data/books/*.yml").map { |path| YAML.load_file(path) }
categories = books.map { |book| book["categories"] }.flatten.uniq
authors = books.map { |book| book["authors"] }.flatten.uniq

categories.each do |category|
  slug = Blog::UriTemplates.safe_parameterize(category)

  proxy(
    "/categories/#{slug}.html",
    "/category.html",
    locals: {
      category: category
    }
  )
end

authors.each do |author|
  slug = Blog::UriTemplates.safe_parameterize(author)

  proxy(
    "/authors/#{slug}.html",
    "/author.html",
    locals: {
      author: author
    }
  )
end

data.course_groups.each do |group|
  proxy(
    "/courses/#{group.slug}.html",
    "/courses.html",
    locals: {
      group: group
    }
  )
end

# "Drukowane",
# "E-Booki",
# "Audiobooki"

proxy(
  "/formats/drukowane.html",
  "/format.html",
  locals: {
    format: "book"
  }
)

proxy(
  "/formats/e-booki.html",
  "/format.html",
  locals: {
    format: "ebook"
  }
)

proxy(
  "/formats/audiobooki.html",
  "/format.html",
  locals: {
    format: "audiobook"
  }
)

# proxy(
#   '/this-page-has-no-template.html',
#   '/template-file.html',
#   locals: {
#     which_fake_page: 'Rendering a fake page with a local variable'
#   },
# )

# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/

helpers do
  def book_categories
    categories = []

    data.books.values.each do |book|
      categories << book.categories
    end

    categories.flatten.uniq.sort
  end

  def book_formats
    [
      "Drukowane",
      "E-Booki",
      "Audiobooki"
    ]
  end

  def book_authors
    authors = []

    data.books.values.each do |book|
      authors << book.authors
    end

    authors.flatten.uniq.sort
  end

  def books
    books = []

    data.books.keys.sort.reverse.each do |isbn|
      books << data.books[isbn]
    end

    books
  end

  def books_by_author(author)
    books.select { |book| book["authors"].include?(author) }
  end

  def books_by_category(category)
    books.select { |book| book["categories"].include?(category) }
  end

  def books_by_format(format)
    books.select { |book| book["formats"].include?(format) }
  end

  def active_book?(book, format)
    formats = data.my_books[book.book.isbn.to_s]
    return false unless formats

    formats.include?(format)
  end

  def courses
    courses = []

    data.courses.keys.sort.reverse.each do |key|
      courses << data.courses[key]
    end

    courses
  end

  def courses_by_group(group)
    courses.select { |course| course.group == group.name }
  end

  def slug(name)
    Blog::UriTemplates.safe_parameterize(name)
  end
end

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

# configure :build do
#   activate :minify_css
#   activate :minify_javascript
# end
