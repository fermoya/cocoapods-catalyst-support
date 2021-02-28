#!/usr/bin/env ruby

path = Pathname.new '/Users/fermoya/Documents/Projects/CatalystPodSupport/Sample/Podfile'
podfile = Podfile.from_file path

path = Pathname.new '/Users/fermoya/Documents/Projects/CatalystPodSupport/Sample/Podfile.lock'
lockfile = Lockfile.from_file path

sandbox = Sandbox.new 'Pods'

installer = Installer.new sandbox, podfile, lockfile
installer.install!
