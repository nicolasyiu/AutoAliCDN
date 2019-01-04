module AutoAliCDN
  class Oss

    def self.oss_config(config_path)
      config = YAML.load_file(config_path)
      AutoAliCDN::Config.access_key_id = config['access_key_id']
      AutoAliCDN::Config.access_key_secret = config['access_key_secret']
      AutoAliCDN::Config.endpoint = config['endpoint']
      AutoAliCDN::Config.bucket = config['bucket']
      AutoAliCDN::Config.site_resource_path = config['site_resource_path']
      AutoAliCDN::Config.domain_name = config['domain_name']
      return AutoAliCDN::Config
    end

    def self.bucket(oss_config)
      client = Aliyun::OSS::Client.new(
          :endpoint => oss_config.endpoint,
          :access_key_id => oss_config.access_key_id,
          :access_key_secret => oss_config.access_key_secret)
      client.get_bucket(oss_config.bucket)
    end

    #setup dir on oss
    def self.oss_setup(config_path)
      config = oss_config(config_path)

      puts "config:#{config}"

      bucket = bucket(config)

      puts bucket.name
      bucket.put_object(config.site_resource_path+"/.start.txt") { |stream| stream << '2cdn setup ok' }
    end

    def self.oss_upload(config_path, app_path, local_file, remote_file, delete='false')
      config = oss_config(config_path)
      bucket = bucket(config)

      object_key = config.site_resource_path+"/#{remote_file}"
      if bucket.object_exists?(object_key)
        puts "#{name} --> #{object_key}".color(:dimgray)
      else
        begin
          bucket.put_object(object_key, :file => "#{app_path}/#{local_file}")
          puts "#{name} --> #{object_key}".color(:green)
          File.delete("#{app_path}/#{local_file}") if delete == 'true'
        rescue Aliyun::OSS::CallbackError => e
          puts "Callback failed: #{e.message}"
        end
      end
    end

    def self.oss_download(config_path, app_path, remote_file, local_file)
      config = oss_config(config_path)

      bucket = bucket(config)

      object_key = config.site_resource_path+"/#{remote_file}"
      if bucket.object_exists?(object_key)
        bucket.get_object(object_key, :file =>  "#{app_path}/#{local_file}")
        puts "#{object_key} --> #{app_path}/#{local_file}".color(:cyan)
      end

    end

  end
end
