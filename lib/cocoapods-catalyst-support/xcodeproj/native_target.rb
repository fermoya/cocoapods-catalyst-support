module Xcodeproj::Project::Object

  class PBXNativeTarget

    ###### STEP 4 ######
    # In "Pods-" targets, modify "*frameworks.sh" to not install unsupported frameworks for SDK
    def uninstall_frameworks frameworks, platform
      uninstall frameworks, "#{name}-frameworks.sh", platform.sdk_root
    end

    ###### STEP 5 ######
    # In "Pods-" targets, modify "*resources.sh" to not install unsupported resources for SDK
    def uninstall_resources resources, platform
      uninstall resources, "#{name}-resources.sh", platform.sdk_root
    end

    def support_files_folder
      build_configurations.filter do |config| not config.base_configuration_reference.nil? end.first.base_configuration_reference.real_path.parent
    end

    @private
    def uninstall keys, file_name, sdk_root
      configurations = build_configurations.map do |b| b.name end
      keys = keys.to_set.to_a
      loggs "\t\t\tUninstalling for configurations: #{configurations}"
      if support_files_folder.nil?
        loggs "\t\t\tNothing to uninstall"
        return
      end

      script_path = support_files_folder.join file_name
      if !script_path.exist?
        loggs "\t\t\tNothing to uninstall"
        return
      end

      script = File.read(script_path)
      snippets = script.scan(/if \[\[ \"\$CONFIGURATION\" [\S\s]*?(?=fi\n)fi/)
      archs_condition = "[[ \"$SDKROOT\" != *\"#{sdk_root}\"* ]]"
      file_condition_format = 'if [ -d "%s" ]; then'
      changed = false
      
      snippets.each do |snippet|
        new_snippet = snippet.clone
        should_uninstall = configurations.map do |string| snippet.include? string end.reduce(false) do |total, condition| total = total || condition end
        keys.each do |key|
          lines_to_replace = snippet.filter_lines do |line| line.match "\/#{key}" end.to_set.to_a
          unless lines_to_replace.empty?
            changed = true
            lines_to_replace.each do |line|
              if should_uninstall
                new_snippet.gsub! line, "\tif #{archs_condition}; then \n\t#{line}\tfi\n"
              elsif file_name.include? 'resources'
                path = line.scan(/[^(install_resource| |")].*[^*("|\n)]/).first
                file_condition = file_condition_format % path
                new_snippet.gsub! line, "\t#{file_condition} \n\t#{line}\tfi\n"
              end
            end
          end
        end
        script.gsub! snippet, new_snippet
      end

      if changed
        File.open(script_path, "w") { |file| file << script }
      end
      loggs "\t\t\t#{changed ? "Succeded" : "Nothing to uninstall"}"
    end

    ###### STEP 1 ######
    # In native target's build phases, add platform filter to:
    # - Resources 
    # - Compile Sources
    # - Frameworks
    # - Headers
    def add_platform_filter_to_build_phases platform
      loggs "\t\t- Filtering resources"
      resources_build_phase.files.to_a.map do |build_file| build_file.platform_filter = platform.filter end
      
      loggs "\t\t- Filtering compile sources"
      source_build_phase.files.to_a.map do |build_file| build_file.platform_filter = platform.filter end
      
      loggs "\t\t- Filtering frameworks"
      frameworks_build_phase.files.to_a.map do |build_file| build_file.platform_filter = platform.filter end
      
      loggs "\t\t- Filtering headers"
      headers_build_phase.files.to_a.map do |build_file| build_file.platform_filter = platform.filter end
    end

  end

end