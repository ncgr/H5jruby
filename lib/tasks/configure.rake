namespace :H5jruby do
  namespace :hdf_java do
    desc "Configure HDF-Java binaries. " <<
    "(options: WITH_JAR_FILE=/path/to/jhdf5.jar)"
    task :configure do
      APP  = File.expand_path("../../../", __FILE__)
      CONF = File.expand_path(File.join(APP, "lib", "H5jruby_conf.rb"))
      EXT  = File.expand_path("../../ext", __FILE__)

      jar_file = ENV['WITH_JAR_FILE']
      
      unless jar_file
        # Supported Architectures
        supported = {
          'os'  => ['linux', 'darwin', 'solaris', 'win32'],
          'cpu' => ['x86_64', 'i386']
        }

        # Thanks to FFI for these tips!
        # https://raw.github.com/ffi/ffi/master/Rakefile
        cpu = case RbConfig::CONFIG['host_cpu'].downcase
              when /i[3456]86/
                # Darwin 64 bit check...
                if RbConfig::CONFIG['host_os'] =~ /darwin/ && 0xffffdeadbeef.is_a?(Fixnum)
                  "x86_64"
                else
                  "i386"
                end
              when /amd64|x86_64/
                "x86_64"
              else
                RbConfig::CONFIG['host_cpu']
              end

        os = case RbConfig::CONFIG['host_os'].downcase
             when /linux/
               "linux"
             when /darwin/
               "darwin"
             when /solaris|sunos/
               "solaris"
             when /mswin|mingw/
               "win"
             else
               RbConfig::CONFIG['host_os'].downcase
             end

        if supported['cpu'].include?(cpu) && supported['os'].include?(os)
          puts "Your system is supported!"
          puts "CPU: #{cpu} OS: #{os}"
        else
          raise "\nYour system architecture is not supported.\n" <<
            "Please visit http://www.hdfgroup.org/ftp/HDF5/hdf-java/bin/ " <<
            "for more information.\n" <<
            "CPU: #{cpu} OS: #{os}"
        end

        Dir.mkdir(EXT, 0755) unless Dir.exists?(EXT)
        Dir.chdir(EXT)

        curl_cmd = "http://www.hdfgroup.org/ftp/HDF5/hdf-java/bin/"
        
        if cpu =~ /64/
          cpu = "64"
        else
          cpu = "32"
        end

        os = "macintel" if os =~ /darwin/

        puts "Downloading HDF-Java binaries..."

        curl_cmd << "#{os}#{cpu}/hdf-java-2.8-bin.tar"
        system("curl -O #{curl_cmd}") 

        puts "Extracting HDF-Java binaries..."
        system("tar -xf *.tar")

        jar_file = "#{EXT}/hdf-java/lib/jhdf5.jar"
      end

      File.open(CONF, "w+") do |file|
        file << "module H5jruby "
        file << %Q(JAR_FILE="#{jar_file}")
        file << "; end"
      end
    
      puts "Finished configuring H5jruby."
    end
  end
end
