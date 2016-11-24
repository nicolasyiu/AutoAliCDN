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

    def self.bucket=(val)
      @@bucket = val
    end

    def self.bucket
      @@bucket
    end

    def self.site_resource_path=(val)
      @@site_resource_path = val
    end

    def self.site_resource_path
      @@site_resource_path
    end

    def self.domain_name=(val)
      @@domain_name= val
    end

    def self.domain_name
      @@domain_name
    end

  end
end