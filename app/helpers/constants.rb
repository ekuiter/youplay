module Constants

  def self.url_protocol
    'youplay://'
  end

  def self.broadcast_update
    'http://zdfmediathk.sourceforge.net/update.xml'
  end

  def self.movie_database_path
    'lib/movie_database/'
  end

  # player section
  def self.player_width
    '800'
  end

  def self.player_height
    '475'
  end


  # gdata and oauth2 section

  # see: http://code.google.com/apis/youtube/dashboard  --  youplay
  def self.developer_key
    '***REMOVED***'
  end

  # see: http://code.google.com/apis/console  --  youplay: API Access
  def self.client_id
    '***REMOVED***'
  end

  def self.client_secret
    '***REMOVED***'
  end

  def self.redirect_uri
    'http://localhost/youtube/auth'
  end

  def self.scope # space-delimited list of scopes that identify the resources to access
    'https://gdata.youtube.com'
  end


  # you don't want to edit this typically

  def self.jw_folder hash = {} # jw player folder
    # ***edit***
    folder = 'jwplayer'
    # ***edit***

    return "/#{folder}" if hash[:client]
    return "public/#{folder}"
  end

  def self.skin_folder hash = {} # jw skin folder
    jw = hash[:client] ? jw_folder(client: true) : jw_folder

    # ***edit***
    "#{jw}/skins"
    # ***edit***
  end

end
