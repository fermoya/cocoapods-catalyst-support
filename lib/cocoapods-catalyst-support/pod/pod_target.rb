module Pod
  class PodTarget

    #build_settings[:debug].other_ldflags
    include CocoapodsCatalystSupport::TargetUtils
  
    def resources 
      resources = file_accessors.flat_map do |accessor| accessor.resources end.map do |path| "#{path.basename}" end
      bundles = file_accessors.flat_map do |accessor| accessor.resource_bundles end.flat_map do |dic| dic.keys end.map do |s| s + ".bundle" end
      return resources + bundles
    end
    
    def vendor_products
      return file_accessors.flat_map do |accessor| 
        accessor.vendored_frameworks + accessor.vendored_libraries
      end.map do |s| s.basename 
      end.map do |s|
        name = "#{s}"
        if name.include? "framework"
          PodDependency.newFramework name.sub(".framework", "").sub(".xcframework", "")
        else
          PodDependency.newLibrary name.sub("lib", "").sub(".a", "")
        end
      end
    end
  
    def frameworks
      return file_accessors.flat_map do |accessor| 
        accessor.spec_consumer.frameworks.map do |name| PodDependency.newFramework name  end + accessor.spec_consumer.libraries.map do |name| PodDependency.newLibrary name end
      end
    end
  
  end
end