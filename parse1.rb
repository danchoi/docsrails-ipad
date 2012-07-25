
require 'nokogiri'
require 'sequel'
require 'sqlite3'
require 'yaml'

DB = Sequel.connect 'sqlite://rails.db'

class Page < Sequel::Model; end

# use find command to find all files
files = STDIN.readlines 
files.each do |file|
  html = File.read(file.chomp)
  d = Nokogiri::HTML(html)
  page_title = d.at("head title").inner_text

  # get parent module info
  title = d.at(".banner h1").inner_text.strip.gsub(/\s+/, ' ')

  params = {
    page_title: page_title,
    item_id: page_title,
    title: title,
    slug: page_title,
    description: (d.at('#bodyContent .description').inner_html rescue nil),
    source: nil
  }
  if (parent = Page[item_id: params[:item_id]]).nil?
    puts "Inserting #{page_title} -> #{params[:title]}"
    parent = Page.create params
  end

  d.search("div.method").each {|x|
    params = {
      page_title: page_title,
      item_id: x.at("div[@class=title]/@id").text,
      title: x.at("div[@class=title]").inner_text.strip,
      slug: x.at('div[@class=title]//b').inner_text,
      description: (x.at('.description').inner_html rescue nil),
      source: (x.at(".dyn-source").inner_html rescue nil),
      parent_item_id: parent[:item_id]
    }
    if Page[item_id: params[:item_id]].nil?
      puts "Inserting #{page_title} => #{params[:title]}"
      Page.create params
    end
  }
end

__END__

class=title 
  a name=M006066
class-description


