module Xcodeproj::Project::Object
  class AbstractTarget

    include CocoapodsCatalystSupport::TargetUtils
  
    ###### STEP 2 ######
    # In all targets (aggregates + native), filter dependencies
    def add_platform_filter_to_dependencies platform
      loggs "\t\t- Filtering dependencies"
      dependencies.each do |dependency|
        dependency.platform_filter = platform.name.to_s
      end
    end
  
    ###### STEP 3 ######
    # If any unsupported library, then flag as platform-dependant for every build configuration
    def flag_libraries dependencies, platform
      loggs "\tTarget: #{name}"

      build_configurations.filter do |config| 
        !config.base_configuration_reference.nil? 
      end.each do |config|
        loggs "\t\tScheme: #{config.name}"
        xcconfig_path = config.base_configuration_reference.real_path
        xcconfig = File.read(xcconfig_path)

        other_ldflags = xcconfig.filter_lines do |line| line.include? 'OTHER_LDFLAGS = ' end.first || ''
        header_search_paths = xcconfig.filter_lines do |line| line.include? 'HEADER_SEARCH_PATHS = ' end.first  || ''
        framework_search_paths = xcconfig.filter_lines do |line| line.include? 'FRAMEWORK_SEARCH_PATHS = ' end.first  || ''
        other_swift_flags = xcconfig.filter_lines do |line| line.include? 'OTHER_SWIFT_FLAGS = ' end.first || ''
        
        new_other_ldflags = "OTHER_LDFLAGS[sdk=#{platform.sdk}] = $(inherited) -ObjC"
        new_header_search_paths = "HEADER_SEARCH_PATHS[sdk=#{platform.sdk}] = $(inherited)"
        new_framework_search_paths = "FRAMEWORK_SEARCH_PATHS[sdk=#{platform.sdk}] = $(inherited)"
        new_other_swift_flags = "OTHER_SWIFT_FLAGS[sdk=#{platform.sdk}] = $(inherited) -D COCOAPODS"
        new_xcconfig = xcconfig.gsub!(other_ldflags, '').gsub!(header_search_paths, '').gsub!(other_swift_flags, '').gsub!(framework_search_paths, '')

        changed = false
        dependencies.each do |dependency|
          if other_ldflags.include? dependency.link
            other_ldflags.gsub! dependency.link, ''
            changed = true
            new_other_ldflags += " #{dependency.link}"
          end
          
          regex = /(?<=[\s])([\"]*[\S]*#{Regexp.escape(dependency.name)}[\S]*[\"]*)(?=[\s]?)/
          if header_search_paths.match? regex
            to_replace = header_search_paths.scan(regex).flat_map do |m| m end.filter do |m| !m.nil? && !m.empty? end.each do |to_replace|
              header_search_paths.gsub! to_replace, ''
              new_header_search_paths += " #{to_replace}"
            end
            changed = true
          end

          regex = /(?<=[\s])([\"][\S]*#{Regexp.escape(dependency.name)}[\S]*\")(?=[\s]?)/
          if framework_search_paths.match? regex
            to_replace = framework_search_paths.scan(regex).flat_map do |m| m end.filter do |m| !m.nil? && !m.empty? end.each do |to_replace|
              framework_search_paths.gsub! to_replace, ''
              new_framework_search_paths += " #{to_replace}"
            end
            changed = true
          end

          regex = /(?<=[\s])(-Xcc -[\S]*#{Regexp.escape(dependency.name)}[\S]*\")(?=[\s]?)/
          if other_swift_flags.match? regex
            to_replace = other_swift_flags.scan(regex).flat_map do |m| m end.filter do |m| !m.nil? && !m.empty? end.each do |to_replace|
              other_swift_flags.gsub! to_replace, ''
              new_other_swift_flags += " #{to_replace}"
            end
            changed = true
          end
        end
  
        if changed
          new_xcconfig += "\n#{other_ldflags}\n#{framework_search_paths}\n#{header_search_paths}"
          new_xcconfig += "\n#{new_other_ldflags}\n#{new_framework_search_paths}\n#{new_header_search_paths}"
          if !other_swift_flags.empty?
            new_xcconfig += "\n#{other_swift_flags}\n#{new_other_swift_flags}"
          end
          new_xcconfig.gsub! /\n+/, "\n"
          new_xcconfig.gsub! /[ ]+/, " "
          File.open(xcconfig_path, "w") { |file| file << new_xcconfig }
        end
        loggs "\t\t\t#{changed ? "Succeded" : "Nothing to flag"}"
      end
    end
  
    def to_dependency
      # We return both as we don't know if build as library or framework
      return [PodDependency.newFramework(module_name), PodDependency.newLibrary(name)]
    end
  
    # Dependencies contained in Other Linker Flags
    def other_linker_flags_dependencies
      config = build_configurations.filter do |config| not config.base_configuration_reference.nil? end.first
      return [] if config.nil?
      other_ldflags = config.resolve_build_setting 'OTHER_LDFLAGS'
      return [] if other_ldflags.nil? 
  
      if other_ldflags.class == String
        other_ldflags = other_ldflags.split ' '
      end
  
      libraries = other_ldflags.filter do |flag| flag.start_with? '-l' end.map do |flag| flag.gsub! /(["|\-l]*)/, '' end.map do |name| PodDependency.newLibrary name end
      mixed_frameworks = other_ldflags.filter do |flag| !flag.start_with? '-l' end
      
      weak_frameworks = mixed_frameworks.length.times.filter do |i| mixed_frameworks[i].include? 'weak_framework' end.map do |i| PodDependency.newWeakFramework(mixed_frameworks[i+1].gsub! '"', '') end
      frameworks = mixed_frameworks.length.times.select do |i| mixed_frameworks[i].match /^([^{weak_}]*)framework$/ end.map do |i| PodDependency.newFramework(mixed_frameworks[i+1].gsub! '"', '') end
  
      return libraries + frameworks + weak_frameworks
    end
  end
end