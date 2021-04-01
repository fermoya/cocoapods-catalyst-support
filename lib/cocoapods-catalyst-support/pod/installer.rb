require 'colorize'

module Pod

  class Installer

    def configure_catalyst
      catalyst_pods_to_remove = $catalyst_configuration.ios_dependencies
      if !catalyst_pods_to_remove.empty? 
        remove_dependencies catalyst_pods_to_remove, OSPlatform.macos, OSPlatform.ios
      end

      ios_pods_to_remove = $catalyst_configuration.mac_dependencies
      if !ios_pods_to_remove.empty? 
        remove_dependencies ios_pods_to_remove, OSPlatform.ios, OSPlatform.macos
      end

      unless ios_pods_to_remove.empty? && catalyst_pods_to_remove.empty?
        puts "Catalyst => Done! Your Catalyst dependencies are ready to go".green
      else
        puts "Catalyst => Nothing to configure"
      end
    end

    private
    def remove_dependencies pod_names_to_remove, remove_platform, keep_platform

      loggs "\n#### Configuring #{remove_platform.name} dependencies ####\n"

      ###### Variable definition ###### 
      all_pods = podfile.dependencies #PodDependency
      pods_to_keep = all_pods.filter do |pod| !pod_names_to_remove.include? pod.name end
      pods_to_remove = all_pods.filter do |pod| !pods_to_keep.include? pod end

      # root_pods_to_keep = pods_to_keep.map do |pod| pod.to_root_dependency end
      # root_pods_to_remove = pods_to_remove.map do |pod| pod.to_root_dependency end.filter do |pod| !root_pods_to_keep.include? pod end
      # pods_to_remove += root_pods_to_remove

      pod_names_to_keep = pods_to_keep.flat_map do |d| d.target_names end.uniq
      pod_names_to_remove = pods_to_remove.flat_map do |d| d.target_names end.uniq.filter do |name| !pod_names_to_keep.include? name end
      
      pod_names_to_keep = pod_dependencies(pod_names_to_keep)
      pod_names_to_remove = pod_dependencies(pod_names_to_remove).filter do |name| !pod_names_to_keep.include? name end
      
      $verbose = (defined? podfile.debug) ? podfile.debug : $verbose

      pod_names_to_keep = recursive_dependencies(pod_names_to_keep)
      pod_targets_to_keep = pod_targets.filter do |pod| pod_names_to_keep.include? pod.module_name end       # PodTarget

      pod_names_to_remove = recursive_dependencies(pod_names_to_remove).filter do |name| !pod_names_to_keep.include? name end
      pod_targets_to_remove = pod_targets.filter do |pod| pod_names_to_remove.include? pod.module_name end   # PodTarget

      loggs "\n#### Unsupported Libraries ####\n#{pod_names_to_remove}\n"

      targets_to_remove = pods_project.targets.filter do |target| pod_names_to_remove.include?(target.module_name) end.filter do |target| target.platform_name == OSPlatform.ios.name end # AbstractTarget
      pods_targets = pods_project.targets.filter do |target| target.name.start_with? "Pods-" end.filter do |target| target.platform_name == OSPlatform.ios.name end   # AbstractTarget
      targets_to_keep = pods_project.targets.filter do |target| !targets_to_remove.include?(target) && !pods_targets.include?(target) end.filter do |target| target.platform_name == OSPlatform.ios.name end   # AbstractTarget

      ######  Determine which dependencies should be removed ###### 
      dependencies_to_keep = targets_to_keep.reduce([]) do |dependencies, target| dependencies + target.other_linker_flags_dependencies end    
      dependencies_to_keep = dependencies_to_keep + targets_to_keep.flat_map do |target| target.to_dependency end + pod_targets_to_keep.flat_map do |pod| pod.vendor_products + pod.frameworks end
      
      dependencies_to_remove = targets_to_remove.reduce([]) do |dependencies, target| dependencies + target.other_linker_flags_dependencies end
      dependencies_to_remove = dependencies_to_remove + targets_to_remove.flat_map do |target| target.to_dependency end + pod_targets_to_remove.flat_map do |pod| pod.vendor_products + pod.frameworks end
      dependencies_to_remove = dependencies_to_remove.filter do |d|  !dependencies_to_keep.include? d end

      ###### CATALYST NOT SUPPORTED LINKS ###### 
      unsupported_links = dependencies_to_remove.map do |d| d.link end.to_set.to_a
      
      loggs "\n#### Unsupported dependencies ####\n"
      loggs "#{dependencies_to_remove.map do |d| d.name end.to_set.to_a }\n\n"

      ###### CATALYST NOT SUPPORTED FRAMEWORKS AND RESOURCES
      frameworks_to_uninstall = dependencies_to_remove.filter do |d| d.type == :framework || d.type == :weak_framework end.map do |d| "#{d.name}.framework" end
      resources_to_uninstall = pod_targets_to_remove.flat_map do |pod| pod.resources end.to_set.to_a

      loggs "#### Frameworks not to be included in the Archive ####\n"
      loggs "#{frameworks_to_uninstall}\n\n" 

      loggs "#### Resources not to be included in the Archive ####\n"
      loggs "#{resources_to_uninstall}\n\n"

      ###### OTHER LINKER FLAGS -> to iphone* ###### 
      loggs "#### Flagging unsupported libraries ####"
      pods_project.targets.filter do |target| target.platform_name == OSPlatform.ios.name end.each do |target| target.flag_libraries unsupported_links, keep_platform end

      ###### BUILD_PHASES AND DEPENDENCIES -> PLATFORM_FILTER 'ios' ###### 
      loggs "\n#### Filtering build phases ####"
      targets_to_remove.filter do |target| 
        pods_project.native_targets.include? target
      end.each do |target| 
        loggs "\tTarget: #{target.name}"
        target.add_platform_filter_to_build_phases keep_platform
      end

      loggs "\n#### Filtering dependencies ####"
      targets_to_remove.each do |target| 
        loggs "\tTarget: #{target.name}"
        target.add_platform_filter_to_dependencies keep_platform
      end

      target_names_to_remove = targets_to_remove.map do |t| t.name end
      pods_project.targets.each do |target| 
        loggs "\tTarget: #{target.name}"
        target.add_platform_filter_to_dependencies keep_platform, target_names_to_remove
      end

      ###### FRAMEWORKS AND RESOURCES SCRIPT -> if [ "$SDKROOT" != "MacOS" ]; then #######   
      loggs "\n#### Changing frameworks and resources script ####"
      pods_targets.each do |target|
        loggs "\tTarget: #{target.name}"
        loggs "\t\t-Uninstalling frameworks"
        target.uninstall_frameworks frameworks_to_uninstall, remove_platform

        loggs "\t\t-Uninstalling resources"
        target.uninstall_resources resources_to_uninstall, remove_platform
      end
    end
	
    def pod_dependencies names
      pod_names = names
      return pod_names unless sandbox.manifest
      pods = sandbox.manifest.internal_data['PODS']
      pods.each do |pod|
        key = pod.keys.first unless pod.is_a?(String)
        key ||= pod
        pod_name = key.split(' ')[0]
        if names.include? pod_name
          dependencies = pod[key]
          unless dependencies.is_a?(String)
            dependencies = dependencies.map do |s| s.split(' ')[0] end
            dependencies += pod_dependencies(dependencies)
            pod_names += [pod_name] + dependencies
          end
        end
      end
      return pod_names.uniq
    end

    def recursive_dependencies to_filter_names
      targets = pods_project.targets
      targets_to_remove = pods_project.targets.filter do |target| to_filter_names.include? target.module_name end
      dependencies = targets_to_remove.flat_map do |target| target.dependencies end
      dependencies_names = dependencies.map do |d| d.module_name end
    
      if dependencies.empty?
        return to_filter_names + dependencies_names
      else
        return to_filter_names + recursive_dependencies(dependencies_names)
      end
    
    end

  end

end