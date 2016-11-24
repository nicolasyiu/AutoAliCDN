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
      bucket.put_object(config.site_resource_path+"/images/.start.png") { |stream| stream << '2cdn setup ok' }
      bucket.put_object(config.site_resource_path+"/javascripts/.start.js") { |stream| stream << "console.log('start from here')" }
      bucket.put_object(config.site_resource_path+"/css/.start.css") { |stream| stream << "body{padding:0;}" }
    end

    #upload local files to server
    def self.oss_upload(config_path, app_path)
      config = oss_config(config_path)

      images_path = app_path+'/images'
      javascripts_path = app_path+'/javascripts'
      css_path = app_path+'/css'

      bucket = bucket(config)

      replace_res_path = ->(local_path, remote_path) do
        Dir.foreach(app_path) do |f|
          if f =~ /\.(html)|(htm)$/
            remote_prefix = remote_path.gsub(/-\w{32}\.(gif|png|jpg|jpeg|css|js)$/, '')

            file_content = File.read("#{app_path}/#{f}").gsub(local_path, remote_path)

            file_content = file_content.gsub(Regexp.new(remote_prefix+'-\w{32}\.(gif|png|jpg|jpeg|css|js)'), remote_path)

            File.open("#{app_path}/#{f}", "w") do |f2|
              f2.puts file_content
            end
          end
        end
      end

      #upload image javascripts css etc.
      upload_c = ->(res_path) do
        Dir.foreach(res_path) do |name|
          next if name =~ /^(\.)|(\.\.)$/
          file_path = res_path+"/#{name}"
          file_md5 = Digest::MD5.hexdigest(File.read(file_path))
          res_type = res_path.gsub(/^.*\//, '')
          object_key = config.site_resource_path+"/#{res_type}/#{name.gsub(/\./, "-#{file_md5}.")}"
          if bucket.object_exists?(object_key)
            puts "#{name} --> #{object_key}".color(:dimgray)
            replace_res_path.call(res_type+'/'+name, config.domain_name+'/'+object_key)
          else
            bucket.put_object(object_key, :file => file_path)
            puts "#{name} --> #{object_key}".color(:green)
            replace_res_path.call(res_type+'/'+name, config.domain_name+'/'+object_key)
          end
        end
      end

      upload_c.call(images_path)
      upload_c.call(javascripts_path)
      upload_c.call(css_path)
    end

    def self.oss_debug(config_path, app_path)
      config = oss_config(config_path)

      images_path = app_path+'/images'
      javascripts_path = app_path+'/javascripts'
      css_path = app_path+'/css'

      bucket = bucket(config)

      replace_res_path = ->(remote_path, local_path) do
        Dir.foreach(app_path) do |f|
          if f =~ /\.(html)|(htm)$/

            file_content = File.read("#{app_path}/#{f}").gsub(remote_path, local_path)

            File.open("#{app_path}/#{f}", "w") do |f2|
              f2.puts file_content
            end
          end
        end
      end

      debug_c = ->(res_path) do
        Dir.foreach(res_path) do |name|
          next if name =~ /^(\.)|(\.\.)$/
          file_path = res_path+"/#{name}"
          file_md5 = Digest::MD5.hexdigest(File.read(file_path))
          res_type = res_path.gsub(/^.*\//, '')
          object_key = config.site_resource_path+"/#{res_type}/#{name.gsub(/\./, "-#{file_md5}.")}"
          if bucket.object_exists?(object_key)
            replace_res_path.call(config.domain_name+'/'+object_key, res_type+'/'+name)
            puts "#{object_key.color(:red)} --> #{"#{res_type}/#{name}".color(:cyan)}"
          end
        end
      end

      debug_c.call(images_path)
      debug_c.call(javascripts_path)
      debug_c.call(css_path)
    end

  end
end