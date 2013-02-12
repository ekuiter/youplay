module Reader
  module BroadcastReader

    def update_broadcasts # fetch latest broadcasts from MediathekView
      latest_server = servers.first[:download] # use the latest mirror
      database = movie_database latest_server # and fetch the movie database from it
                                               #info = database_info database
      info = database_info database
      CachedBroadcastsInfo.all.each {|cb_info| cb_info.destroy}
      CachedBroadcastsInfo.create key: 'broadcast_number', value: info[:broadcasts]
      CachedBroadcastsInfo.create key: 'database_datetime', value: info[:datetime]
      CachedBroadcastsInfo.create key: 'version', value: info[:version]
      logger.debug CachedBroadcastsInfo.all
      File.open("#{Constants::movie_database_path}db.xml", 'w') {|db| db.write database}
    end

    @previous = {}
    @counter = 0

    def reset_broadcast
      @previous = {}
      @counter = 0
    end

    def next_broadcast
      broadcast = current_database['X'][@counter]
      return nil unless broadcast
        @previous = {
            station: broadcast['b'].nil? ? previous[:station] : broadcast['b'][0],
            topic: broadcast['c'].nil? ? previous[:topic] : broadcast['c'][0],
            title: broadcast['d'].nil? ? previous[:title] : broadcast['d'][0],
            published_at: if broadcast['e'].nil? then
                            previous[:published_at]
                          else
                            broadcast['f'].nil? ? previous[:published_at] : "#{broadcast['e'][0]} #{broadcast['f'][0]}".to_time
                          end,
            url: broadcast['g'].nil? ? previous[:title] : broadcast['g'][0],
            topic_url: broadcast['k'].nil? ? previous[:title] : broadcast['k'][0],
            md5: Digest::MD5.hexdigest((broadcast['d'].nil? ? previous[:title] : broadcast['d'][0]) +
                                           (broadcast['g'].nil? ? previous[:title] : broadcast['g'][0]))
        }
      @counter += 1
      @previous
    end

    def current_database
      file = File.open "#{Constants::movie_database_path}db.xml", 'r' # open the unzipped file
      require 'xmlsimple'
      xml = XmlSimple.xml_in file # and slurp it into a hash
      file.close
      xml
    end

    private

    def servers # mirror list
      update_xml = http_request(url: Constants::broadcast_update).body # fetch update xml ...
      require 'rexml/document'
      doc = REXML::Document.new update_xml
      servers = []
      doc.elements.each('Mediathek/Server') do |server| # ... and parse it
        servers << {
            download: server.elements['Download_Filme_1'].text,
            datetime: "#{server.elements['Datum'].text} #{server.elements['Zeit'].text}".to_time
        }
      end
      servers.sort! { |a, b| b[:datetime] <=> a[:datetime] } # sort the mirror list by date
      servers
    end

    def movie_database(server)
      #compressed = http_request(url: server).body # fetch the compressed data from server
      compressed = open server # fetch the compressed data from server
      if server.index('.zip', -4) # two choices: zip ...
        logger.debug 'using zip with temp file'
        xml = xml_by_zip compressed
      elsif server.index('.bz2', -4) # ... or bzip2
        logger.debug 'using bzip2 on-the-fly'
        xml = xml_by_bzip2 compressed
      else
        raise 'unknown compression format'
      end
      compressed.close unless compressed.closed?
      compressed.unlink
      xml
    end

    def xml_by_zip(compressed)
      Unzipper::ZIP::decompress compressed, Constants::movie_database_path # use rubyzip wrapper to unzip the zipped file
      directory = Dir.open(Constants::movie_database_path)
      xml = nil
      directory.each do |filename| # get the name of the unzipped file
        filename = File.join Constants::movie_database_path, filename
        if File.file? filename
          file = File.open filename, 'r' # open the unzipped file
          require 'xmlsimple'
          xml = XmlSimple.xml_in file # and slurp it into a hash
          file.close
          File.delete file
          break
        end
      end
      xml
    end

    def xml_by_bzip2(compressed)
      data = Unzipper::BZ2::decompress compressed # use bzip2-ruby wrapper to decompress the bzipped file
      require 'xmlsimple'
      XmlSimple.xml_in data # and slurp it into a hash
    end

    def database_info(database)
      {
          broadcasts: database['Filmliste'][0]['Filmliste-Anzahl'][0].to_i,
          datetime: "#{database['Filmliste'][0]['Filmliste-Nur-Datum'][0]} #{database['Filmliste'][0]['Filmliste-Nur-Zeit'][0]}".to_time,
          version: database['Filmliste'][0]['Filmliste-Version'][0]
      }
    end

  end
end