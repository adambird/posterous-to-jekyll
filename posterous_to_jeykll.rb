require 'nokogiri'

class PosterousToJekyll

  def initialize(options={})
    @options = options
    @options[:author] = "Adam" unless options[:author]
    @options[:comments] = true if options[:comments].nil?
    @options[:layout] = "post" unless options[:layout]
  end

  # Public - takes a File object and writes a jekyll compliant copy 
  # 
  # source_file     - File open on a Posterous backup XML file
  # output_file     - File open to accept 
  def convert(source_file, output_file)
    doc = Nokogiri::XML(source_file)
    write_headers doc, output_file
  end

  # writes headers, eg
  #   ---
  # layout: post
  # title: "What Are Your Cycling Training Tips?"
  # date: 2013-01-25 14:31
  # comments: true
  # author: Adam
  # categories: ['Cycling Training Tips']
  # ---

  def write_headers(source_doc, output_file)
    items = ["---"]
    items << "layout: #{@options[:layout]}"
    items << "title: \"#{source_doc.at_css("title").inner_text}\""
    items << "comments: #{@options[:comments]}"
    items << "author: #{@options[:author]}"
    items << "---"
    output_file.write(items.join("\r\n"))    
  end
end
