module AutoAliCDN
  class Oss
    def self.setup(config_path)
      config = YAML.load_file(config_path)
      AutoAliCDN::Config.access_key_id = config['access_key_id']
      AutoAliCDN::Config.access_key_secret = config['access_key_secret']
      AutoAliCDN::Config.endpoint = config['endpoint']
      client = Aliyun::OSS::Client.new(
          :endpoint => AutoAliCDN::Config.endpoint,
          :access_key_id => AutoAliCDN::Config.access_key_id,
          :access_key_secret => AutoAliCDN::Config.access_key_secret,
          :cname => true)

      buckets = client.list_buckets
      buckets.each{ |b| puts b.name }
    end
  end
end