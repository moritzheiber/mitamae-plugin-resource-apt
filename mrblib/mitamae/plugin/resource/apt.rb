module ::MItamae
  module Plugin
    module Resource
      class Apt < ::MItamae::Resource::Base
        define_attribute :action, default: :install
        define_attribute :package_name, type: String, default_name: true
        define_attribute :source_url, type: String, default: false
        define_attribute :options, type: String, default: ''
        define_attribute :version, type: String, default: false

        self.available_actions = [:install, :remove]
      end
    end
  end
end
