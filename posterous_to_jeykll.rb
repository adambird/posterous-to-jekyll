require 'nokogiri'

class PosterousToJekyll

  def namespaces
    {
      'content' => 'http://purl.org/rss/1.0/modules/content/',
      'excerpt' => 'http://wordpress.org/export/1.0/excerpt/'
    }
  end 

  def initialize(options={})
    @options = options
    @options[:author] = "Adam" unless options[:author]
    @options[:comments] = true if options[:comments].nil?
    @options[:layout] = "post" unless options[:layout]
  end

  # Public - takes a File object and writes a jekyll compliant copy 
  # 
  # source          - String containing posterous backup xml
  # output_file     - File open to accept 
  def convert(source, output_file)
    doc = Nokogiri::XML::Document.new
    parsing_node = Nokogiri::XML::Node.new "posterous_to_jekyll", doc
    namespaces.each_pair do |k, v| parsing_node.add_namespace(k, v) end

    item = parsing_node.parse(source)

    write_headers item, output_file
    write_content item, output_file
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
    items << "title: \"#{source_doc.at_css("title").text}\""
    items << "description: \"#{source_doc.at_css("excerpt|encoded", namespaces).text}\""
    items << "date: #{source_doc.at_css("pubDate").text}"
    items << "comments: #{@options[:comments]}"
    items << "author: #{@options[:author]}"
    items << "categories: [#{source_doc.css("category[domain='tag']").collect { |n| n.text }.join(",")}]"
    items << "---"
    output_file.write("#{items.join("\r\n")}\r\n\r\n")    
  end

  def write_content(source_doc, output_file)
    # if node = source_doc.at_css("content|encoded")
    output_file.write(source_doc.at_css("content|encoded", namespaces).text)
  end

end
