module UserMixins
  module Admin
    def admin
      role == 'admin'
    end

    def admin=(boolean)
      if boolean
        write_attribute :role, 'admin'
        true
      else
        preserve_last_admin!
        write_attribute :role, ''
        false
      end
    end

    def self.admins
      where role: 'admin'
    end

    def role=
    end
  
    def humanize_role
      admin ? I18n.t('conf.admin') : ''
    end
    
    private
    
    def preserve_last_admin!
      admins = self.class.admins
      raise 'You can\'t remove the last admin' if admins.count == 1 && admins.first == self
    end
  end
end