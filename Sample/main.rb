#!/usr/bin/env ruby
require 'cocoapods-catalyst-support'

include Pod

file = Pathname.new (File.join __dir__, 'Podfile')
podfile = Podfile.from_file file

file = Pathname.new (File.join __dir__, 'Podfile.lock')
lockfile = Lockfile.from_file file

sandbox = Sandbox.new 'Pods'

installer = Installer.new sandbox, podfile, lockfile
installer.install!
