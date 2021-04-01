module Pod
  class Dependency
    def target_names
      [name, name.sub('/', '')]
    end
  end
end