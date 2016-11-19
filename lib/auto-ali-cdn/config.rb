module AutoAliCDN
  module Config


    def self.access_key_id=(val)
      @@access_key_id = val
    end

    def self.access_key_id
      @@access_key_id
    end

    def self.access_key_secret=(val)
      @@access_key_secret = val
    end

    def self.access_key_secret
      @@access_key_secret
    end

    def self.endpoint=(val)
      @@endpoint = val
    end

    def self.endpoint
      @@endpoint
    end
  end
end