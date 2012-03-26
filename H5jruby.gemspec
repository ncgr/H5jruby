# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "H5jruby/version"

Gem::Specification.new do |s|
  s.name        = "H5jruby"
  s.version     = H5jruby::VERSION
  s.platform    = "java"
  s.authors     = ["Ken Seal"]
  s.email       = ["kas@ncgr.org"]
  s.homepage    = ""
  s.summary     = %q{HDF5 for JRuby}
  s.description = %q{HDF5 for JRuby using NCSA's Java HDF5 interface.}

  s.rubyforge_project = "H5jruby"

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
end
