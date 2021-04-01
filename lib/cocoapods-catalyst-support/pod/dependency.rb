module Pod
  class Dependency
    def target_names
      [name, root_name, name.sub('/', '')]
    end
  end
end