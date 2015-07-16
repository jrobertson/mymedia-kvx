#!/usr/bin/env ruby

# file: mymedia-kvx.rb

require 'mymedia'
require 'martile'


class MyMediaKvx < MyMedia::Base

  attr_reader :kvx
  
  def initialize(public_type: 'kvx', media_type: public_type, 
                                         config: nil, ext: '.txt', xsl: nil)
    
    @public_type = public_type
    
    super(media_type: media_type, public_type: public_type, config: config)
    
    
    @media_src = "%s/media/%s" % [@home, public_type]
    @prefix = 'k'
    @target_ext = '.html'

    @media_type = media_type
    @ext = ext
    @xsl = xsl
    
  end


  private
  
  def copy_publish(filename, raw_msg='')

    src_path = File.join(@media_src, filename)
    raise "file not found : " + src_path unless File.exists? src_path

    file_publish(src_path, raw_msg) do |destination, raw_destination|
      
      raw_dest_xml = raw_destination.sub(/html$/,'xml')
      dest_xml = destination.sub(/html$/,'xml')            

      if not raw_msg or raw_msg.empty? then        
        raw_msg = File.basename(src_path) + " updated: " + Time.now.to_s
      end
      
      if File.extname(src_path) == '.txt' then

        kvx, raw_msg = copy_edit(src_path, dest_xml)
        copy_edit(src_path, raw_dest_xml, xsldir: 'r/xsl')

      else

        kvx = Kvx.new(src_path)
        title = kvx.summary[:title] || ''

        kvx.summary[:original_source] = File.basename(src_path)
        
        File.write dest_xml, kvx.to_s
        File.write raw_dest_xml, kvx.to_s

      end

      
      # transform the XML to an HTML file     
      
      File.write raw_destination, \
                  xsltproc("#{@home}/r/xsl/#{@public_type}.xsl", raw_dest_xml)
      File.write destination, \
                xsltproc("#{@home}/#{@www}/xsl/#{@public_type}.xsl", dest_xml)

      if not File.basename(src_path)[/#{@prefix}\d{6}T\d{4}\.txt/] then
        
        html_filename = File.basename(src_path).sub(/\.txt$/, @target_ext)
        FileUtils.cp destination, @home + "/#{@public_type}/" + html_filename
        
        if File.extname(src_path) == '.txt' then
          FileUtils.cp src_path, @home + "/#{@public_type}/" \
                                              + File.basename(src_path)
        end

        #publish the static links feed
        kvx_filepath = @home + "/#{@public_type}/static.xml"

        target_url = "%s/%s/%s" % [@website, @public_type, html_filename]

        publish_dynarex(kvx_filepath, {title: html_filename, url: target_url })
        
      end
      
      [raw_msg, target_url]
    end    

  end
  
  def copy_edit(src_path, destination, raw='', xsldir: 'xsl')

    txt_destination = destination.sub(/xml$/,'txt')
    FileUtils.cp src_path, txt_destination        

    buffer = File.read(src_path)
    buffer2 = buffer.gsub(/\[[xX]\]/,'✓').gsub(/\[\s*\]/,'.')

    @kvx = Kvx.new(buffer2.strip)

    title = kvx.summary[:title]

    tags = if kvx.summary[:tags] then
      '#' + kvx.summary[:tags].split.join(' #') 
    else
      ''
    end
    
    raw_msg = ("%s %s" % [title, tags]).strip
        
    kvx.summary[:original_source] = File.basename(src_path)
    
    source = txt_destination[/\/#{@public_type}.*/]
    relative_path = '/r' + source

    kvx.summary[:source_url] = relative_path
    kvx.summary[:source_file] = File.basename(txt_destination)
    kvx.summary[:published] = Time.now.strftime("%d-%m-%Y %H:%M")
    kvx.summary[:xslt] = @xsl unless kvx.summary[:xslt]
    
    doc = kvx.to_doc
    doc.instructions.push \
        %w(xml-stylesheet title='XSL_formatting' type='text/xsl') \
                  + ["href='#{@website}/#{xsldir}/#{@public_type}.xsl'"]
    
    summary = doc.root.element('summary')
    a = summary.xpath('title|tags|original_source|' + \
                      'source_url|source_file|published|xslt')
    a.each {|x| x.attributes[:class] = 'meta'}
    
    body = doc.root.element 'body'
    desc = body.element 'desc'
    
    if desc then
      
      html= RDiscount.new(Martile.new(desc.element('//text()')).to_s).to_html      
      desc.delete      
      body.add Rexle.new("<desc>%s</desc>" % html).root
      
    end

    File.write destination, doc.xml(pretty: true)

    [kvx, raw_msg]
  end
  
  def xsltproc(xslpath, xmlpath)
    
    Nokogiri::XSLT(File.open(xslpath))\
              .transform(Nokogiri::XML(File.open(xmlpath))).to_xhtml(indent: 0)
  end  
  
end