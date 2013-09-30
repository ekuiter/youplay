module YoutubeConnector # provides a youtube client authenticated through OAuth2 with access and refresh tokens

  require 'youtube_it'
  
  def youtube_client(state = nil)
    @client = youtube_connect current_user: current_user, state: state, access_token: current_user.access_token,
                              refresh_token: current_user.refresh_token, expires_in: current_user.expires_in
  end

  def youtube_connect(options = {}) # returns an OAuth2 authenticated youtube client
    begin
      client = YouTubeIt::OAuth2Client.new(# create a youtube client
          client_access_token: options[:access_token], client_refresh_token: options[:refresh_token],
          client_token_expires_at: options[:expires_in], client_id: Constants::client_id,
          client_secret: Constants::client_secret, dev_key: Constants::developer_key)
      client.current_user # try a feature which needs authentication
    rescue OAuth2::Error, RuntimeError # if authentication failed
      begin
        tokens = refresh_access_token options[:refresh_token] # try to obtain a new access token
        options[:current_user].tokens = tokens
        options[:current_user].save
        client = YouTubeIt::OAuth2Client.new(# refresh the client
            client_access_token: tokens[:access_token], client_refresh_token: options[:refresh_token],
            client_token_expires_at: options[:expires_in], client_id: Constants::client_id,
            client_secret: Constants::client_secret, dev_key: Constants::developer_key)
        client.current_user # try again
      rescue OAuth2::Error, RuntimeError # if there's neither an access token nor a refresh token
        if options[:raise_error]
          if options[:state]
            raise youtube_connect_path(options[:state]) # let the user grant access and redirect him here back later
          else
            raise youtube_connect_path # let the user grant access
          end
        else
          if options[:state]
            redirect_to youtube_connect_path(options[:state]) # let the user grant access and redirect him here back later
          else
            redirect_to youtube_connect_path # let the user grant access
          end
          @redirecting = true
        end
      end
    end
    client
  end

  def receive_tokens(code) # exchanges temp code against an access and refresh token
    google_auth_url = 'https://accounts.google.com/o/oauth2/token'
    response = http_request url: google_auth_url,
                            post: {'client_id' => Constants::client_id, 'client_secret' => Constants::client_secret,
                                   'redirect_uri' => Constants::redirect_uri, 'grant_type' => 'authorization_code',
                                   'code' => code}
    json = ActiveSupport::JSON::decode response.body
    raise json['error'] if json['error']
    {access_token: json['access_token'], refresh_token: json['refresh_token'], expires_in: json['expires_in']}
  end

  def refresh_access_token(refresh_token) # refreshes the access token if expired
    google_auth_url = 'https://accounts.google.com/o/oauth2/token'
    response = http_request url: google_auth_url,
                            post: {'client_id' => Constants::client_id, 'client_secret' => Constants::client_secret,
                                   'grant_type' => 'refresh_token', 'refresh_token' => refresh_token}
    json = ActiveSupport::JSON::decode response.body
    raise json['error'] if json['error']
    {access_token: json['access_token'], expires_in: json['expires_in']}
  end

  def grant_access_url(state = '') # puts together the temp code obtain url
    google_auth_url = 'https://accounts.google.com/o/oauth2/auth'
    "#{google_auth_url}?client_id=#{Constants::client_id}&redirect_uri=#{Constants::redirect_uri}" +
        "&response_type=code&access_type=offline&approval_prompt=force&scope=#{Constants::scope}&state=#{state}"
  end  

end