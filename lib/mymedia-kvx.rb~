#!/usr/bin/env ruby

# file: mymedia-kvx.rb

require 'mymedia'


class MyMediaKvx < MyMedia::Base

  attr_reader :kvx
  
  def initialize(opt={}, public_type: 'kvx', media_type: public_type, 
                                                      config: nil, ext: '.txt')
    
    @public_type = public_type
    super(media_type: media_type, public_type: public_type, config: config)
    
    @media_src = "%s/media/%s" % [@home, public_type]
    @prefix = 'k'
    @target_ext = '.html'

    @media_type = media_type
    @ext = ext
    
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
        copy_edit(src_path, raw_dest_xml)

      else

        kvx = Kvx.new(src_path)
        title = kvx.summary[:title] || ''

        kvx.summary[:original_source] = File.basename(src_path)
        
        File.write dest_xml, kvx.to_s

      end
      
      # transform the XML to an HTML file     
      
      File.write raw_destination, xsltproc("#{@home}/r/xsl/#{@public_type}.xsl", raw_dest_xml)
      File.write destination, xsltproc("#{@home}/#{@www}/xsl/#{@public_type}.xsl", dest_xml)      

      if not File.basename(src_path)[/#{@prefix}\d{6}T\d{4}\.txt/] then
        
        xml_filename = File.basename(src_path).sub(/txt$/,'xml')
        FileUtils.cp destination, @home + "/#{@public_type}/" + xml_filename
        
        if File.extname(src_path) == '.txt' then
          FileUtils.cp src_path, @home + "/#{public_type}/" + File.basename(src_path)
        end

        #publish the static links feed
        kvx_filepath = @home + "/#{@public_type}/static.xml"

        target_url = "%s/%s/%s" % [@website, @public_type, xml_filename]

        publish_dynarex(kvx_filepath, {title: xml_filename, url: target_url })
        
      end
      
      [raw_msg,target_url]
    end    

  end
  
  def copy_edit(src_path, destination, raw='')

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
    kvx.summary[:source] = File.basename(txt_destination)

    kvx.summary[:xslt] = @xsl unless kvx.item[:xslt]
    File.write destination, kvx.to_xml    

    [kvx, raw_msg]
  end
  
  def xsltproc(xslpath, xmlpath)
    
    Nokogiri::XSLT(File.open(xslpath))\
              .transform(Nokogiri::XML(File.open(xmlpath))).to_xhtml(indent: 0)
  end  
  
end