module Xcodeproj::Project::Object
  class AbstractTarget

    include CocoapodsCatalystSupport::TargetUtils
  
    ###### STEP 2 ######
    # In all targets (aggregates + native), filter dependencies
    def add_platform_filter_to_dependencies platform, whitelist = nil
      loggs "\t\t- Filtering dependencies"
      whitelist ||= dependencies.map do |d| d.name end 
      dependencies.filter do |d|
        whitelist.include? d.name
      end.each do |dependency|
        dependency.platform_filter = platform.name.to_s
      end
    end
  
    ###### STEP 3 ######
    # If any unsupported library, then flag as platform-dependant for every build configuration
    def flag_libraries libraries, platform
      loggs "\tTarget: #{name}"
      build_configurations.filter do |config| !config.base_configuration_reference.nil? 
      end.each do |config|
        loggs "\t\tScheme: #{config.name}"
        xcconfig_path = config.base_configuration_reference.real_path
        xcconfig = File.read(xcconfig_path)
  
        changed = false
        libraries.each do |framework|
          if xcconfig.include? framework
            xcconfig.gsub!(framework, '')
            unless xcconfig.include? "OTHER_LDFLAGS[sdk=#{platform.sdk}]"
              changed = true
              xcconfig += "\nOTHER_LDFLAGS[sdk=#{platform.sdk}] = $(inherited) -ObjC "
            end
            xcconfig += framework + ' '
          end
        end
  
        File.open(xcconfig_path, "w") { |file| file << xcconfig }
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
      other_ldflags = config.resolve_build_setting 'OTHER_LDFLAGS'
      
      if other_ldflags.nil? 
        return [] 
      end
  
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