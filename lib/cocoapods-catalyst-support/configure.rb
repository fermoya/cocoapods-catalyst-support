require_relative 'utils'

module CocoapodsCatalystSupport

  def configure_podfile
    podfile = File.read('Podfile')

    unless podfile.include? "require 'cocoapods-catalyst-support'" 
      podfile = "require 'cocoapods-catalyst-support'\n\n" + podfile
    end

    tail = ''
    unless podfile.include? "def debug"
      tail += "\n#Use false for silent mode\ndef debug\n\ttrue\nend\n"
    end

    unless podfile.include? "catalyst_unsupported_pods"
      tail += "\n#Add pods to be excluded from macCatalyst \ndef catalyst_unsupported_pods\n\t[\n\n\t]\nend\n"
    end

    unless podfile.include? "catalyst_only_pods"
      tail += "\n#Add pods to be only used in macCatalyst \ndef catalyst_only_pods\n\t[\n\n\t]\nend\n"
    end

    changed = !(tails.empty? && podfile.include? 'configure_support_catalyst')
    unless podfile.include? "post_install do"
      podfile += tail
      podfile += "\n#Configure your macCatalyst App\npost_install do |installer|\n\tinstaller.configure_support_catalyst\nend\n"
    else 
      configure_line = (podfile.include? 'configure_support_catalyst') ? "" : "\n\tinstaller.configure_support_catalyst\n"
      post_install_line = podfile.filter_lines do |line| line.include? 'post_install' end.first
      
      if tail.empty? 
        new_post_install_line = post_install_line + configure_line
      else
        new_post_install_line = "#{tail}\n\n" + post_install_line + configure_line
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