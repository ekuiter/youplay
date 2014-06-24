module UserMixins
  module Token
    def token
      "#{id}:#{authentication_token}"
    end

    private
 
    def ensure_authentication_token
      if authentication_token.blank?
        self.authentication_token = generate_authentication_token
      end
    end

    def generate_authentication_token
      loop do
        token = Devise.friendly_token
        break token unless User.where(authentication_token: token).first
      end
    end
  end
end