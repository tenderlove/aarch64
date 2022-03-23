ENV["MT_NO_PLUGINS"] = "1"

require "rake/testtask"
require "rake/clean"

XML_FILE  = "tmp/onebigfile.xml"
ISA_FILE  = "tmp/ISA_A64_xml_v88A-2021-12.tar.gz"
ISA_URL   = "https://developer.arm.com/-/media/developer/products/architecture/armv8-a-architecture/2021-12/ISA_A64_xml_v88A-2021-12.tar.gz"
LIB_FILE  = "lib/aarch64/instructions.rb"
INSNS_DIR = "lib/aarch64/instructions"

CLEAN.include [XML_FILE, ISA_FILE, LIB_FILE, INSNS_DIR]

file INSNS_DIR do |t|
  FileUtils.mkdir_p t.name
end

desc "Extract the instruction XML file from the tar file"
file XML_FILE => ISA_FILE do |t|
  require "rubygems/package"
  require "zlib"

  wanted_file = t.name.split("/").last

  tar = Gem::Package::TarReader.new(Zlib::GzipReader.open(ISA_FILE))

  tar.rewind

  tar.each do |entry|
    if entry.full_name.end_with?(wanted_file)
      File.open(t.name, "w") do |f|
        f.write entry.read
      end
      break
    end
  end
end

task :compile => [XML_FILE, INSNS_DIR] do
  ruby "-I build/lib bin/build_instructions.rb #{XML_FILE}"
end


desc "Download the ISA file from ARM"
file ISA_FILE do |t|
  Dir.mkdir 'tmp' unless File.directory?("tmp")

  require "net/http"
  require "net/https"

  url = URI.parse ISA_URL
  client = Net::HTTP.new(url.host, url.port)
  client.use_ssl = true
  client.start do |http|
    http.request_get(url.path) do |res|
      File.open(t.name, "w") do |f|
        res.read_body do |segment|
          f.write segment
        end
      end
    end
  end
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test/lib" << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
  t.warning = true
end
