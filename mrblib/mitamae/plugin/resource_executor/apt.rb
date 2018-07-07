module ::MItamae
  module Plugin
    module ResourceExecutor
      class Apt < ::MItamae::ResourceExecutor::Base
        TWO_HOURS = 60*60*2
        APT_LAST_UPDATED_DIRECTORY = '/var/lib/apt/lists'

        def apply
          update_cache if cache_outdated

          if desired.installed && !current.installed
            install!
          else
            remove! unless desired.installed
          end
        end

        private

        def set_current_attributes(current, action)
          current.installed = run_specinfra(:check_package_is_installed, attributes.package_name, attributes.version)
        end

        def set_desired_attributes(desired, action)
          case action
          when :install
            desired.installed = true
          when :remove
            desired.installed = false
          end
        end

        def cache_outdated(hours_ago=TWO_HOURS)
          # We are dealing with mruby here
          (Time.now - File::Stat.new(APT_LAST_UPDATED_DIRECTORY).mtime) > hours_ago
        end

        def update_cache
          run_command('apt update -qq')
        end

        def valid_url(source_url)
          source_url =~ ::URI::regexp
        end

        def install!
          url = attributes.source_url
          tmp = "/tmp/mitamae_apt_#{::Random.srand.to_s}.deb"

          unless valid_url(url)
            run_specinfra(:install_package, attributes.package_name, attributes.version, attributes.options)
          else
            begin
              run_specinfra(:download_file, url, tmp)
              run_command("dpkg -i #{attributes.options} #{tmp}")
            ensure
              ::File.unlink(tmp)
            end
          end
        end

        def remove!
          run_specinfra(:remove_package, attributes.package_name, attributes.options)
        end
      end
    end
  end
end
