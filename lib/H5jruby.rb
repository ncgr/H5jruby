require "java"

begin
  require "H5jruby_conf"
rescue LoadError
load_error = <<-LOAD
  H5jruby_conf not found
  execute rake H5jruby:hdf_java:configure to continue
LOAD
  puts load_error
  exit
end

require H5jruby::JAR_FILE
require "H5jruby/version"

module H5jruby
  include_package "ncsa.hdf.hdf5lib" 

  def self.print_lib_version
    version = Java::int[3].new
    H5.H5get_libversion(version)
    puts "HDF5 Version: " << version.join(".")
  end
  print_lib_version
end
