require 'colored2'
require_relative 'utils'

module CocoapodsCatalystSupport

  class ValidationError < StandardError
  end

  Podfile = String

  class Podfile
    def pods
      lookup 'pod'
    end

    def ios_pods
      lookup 'ios'
    end

    def mac_pods
      lookup 'macos'
    end

    def validate
      errors = []
      ios_failures = ios_pods.filter do |pod| !pods.include? pod end
      unless ios_failures.empty?
        errors << "- Unrecognized dependencies for iOS:\n#{ios_failures.map do |pod| "  + #{pod}" end.join("\n") }".red
      end
      
      mac_failures = mac_pods.filter do |pod| !pods.include? pod end
      unless mac_failures.empty?
        errors << "- Unrecognized dependencies for macOS:\n#{mac_failures.map do |pod| "  + #{pod}" end.join("\n") }".red
      end
      
      return errors
    end

    @private
    def lookup key
      results = scan(/^[\s]*#{key}\s+[('|")][\S]*[('|")]/).map do |match|
        match.gsub!('/\s+/', ' ' )
        pod_name = match.split(' ')[1]
        pod_name.gsub! /[('|")]/, ''
        pod_name
      end
      return results
    end
  end

  def configure_podfile
    podfile = File.read('Podfile')

    unless podfile.include? "require 'cocoapods-catalyst-support'" 
      podfile = "require 'cocoapods-catalyst-support'\n\n" + podfile
    end

    config = ''
    unless podfile.match(/catalyst_configuration\s+do/)
      config += "\n# Configure your macCatalyst dependencies\n"
      config += "catalyst_configuration do\n"
      config += "\t# Uncomment the next line for a verbose output\n\t# verbose!\n\n"
      config += "\t# ios '<pod_name>' # This dependency will only be available for iOS\n"
      config += "\t# macos '<pod_name>' # This dependency will only be available for macOS\nend\n"
    end

    is_catalyst_configured = podfile.match(/post_install[\S\s]+installer[\S\s]configure_catalyst/)
    changed = !(is_catalyst_configured && config.empty?)
    unless podfile.match /post_install\s+do/
      podfile += config
      podfile += "\n# Configure your macCatalyst App\npost_install do |installer|\n\tinstaller.configure_catalyst\nend\n"
    else 
      configure_line = (podfile.include? 'configure_catalyst') ? "" : "\n\tinstaller.configure_catalyst\n"
      post_install_line = podfile.filter_lines do |line| line.include? 'post_install' end.first
      
      if config.empty? 
        new_post_install_line = post_install_line + configure_line
      else
        new_post_install_line = "#{config}\n\n" + post_install_line + configure_line
      end

      podfile.gsub! post_install_line, new_post_install_line
    end

    unless podfile.nil? 
      File.open('Podfile', "w") { |file| file << podfile }
    end

    if changed 
      puts 'Done! Checkout your Podfile to start configuring your macCatalyst dependencies'
    else
      puts 'It seems your Podfile is ready. Go ahead and start configuring your macCatalyst dependencies'
    end
  end

  def validate_podfile
    podfile = File.read('Podfile')
    errors = []

    unless podfile.match(/require\s+[('|")]cocoapods-catalyst-support[('|")]/)
      errors << "- Are you missing `require cocoapods-catalyst-support` in your Podfile".red
    end

    unless podfile.match(/catalyst_configuration\s+do/)
      errors << "- Are you missing `require cocoapods-catalyst-support` in your Podfile".red
    end

    unless podfile.match(/post_install[\S\s]+installer[\S\s]configure_catalyst/)
      errors << "- Are you calling `configure_catalyst` from `post_install` phase?".red
    end

    pod_errors = podfile.validate
    unless pod_errors.empty?
      errors << "#{pod_errors.reduce('') do |acc, s| "#{acc}\n#{s}" end }"
    end

    unless errors.empty?
      raise ValidationError.new "Your catalyst configuration seems to have some errors:\n#{errors.join}"
    end

  end

end