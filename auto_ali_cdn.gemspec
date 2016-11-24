# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'auto-ali-cdn/version'

Gem::Specification.new do |spec|
  spec.name          = "2cdn"
  spec.version       = AutoAliCDN::VERSION
  spec.authors       = ["liuxi"]
  spec.email         = ["15201280641@qq.com"]

  spec.summary       = %q{自动部署网站到服务器}
  spec.description   = %q{自动将本地代码上传到阿里云服务器}
  spec.homepage      = "https://github.com/mumaoxi/AutoAliCDN"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = ["2cdn"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_runtime_dependency "aliyun-sdk", "~> 0.5"
  spec.add_runtime_dependency "rainbow", "~> 2.1"
end
