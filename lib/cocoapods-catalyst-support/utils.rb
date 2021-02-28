class String
  def filter_lines
    lines = []
    each_line do |line| 
      if yield line
        lines = lines + [line]
      end
    end
    return lines
  end
end

module CocoapodsCatalystSupport

  $verbose = false

  def loggs string
    if $verbose
      puts string
    end
    return
  end

  module TargetUtils
   def module_name
     string = name.clone.gsub! /(-(iOS([0-9]+(\.[0-9])?)*|library|framework))*$/, ''
     return string.nil? ? name : string
   end
  end

 end