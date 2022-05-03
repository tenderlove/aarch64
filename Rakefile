ENV["MT_NO_PLUGINS"] = "1"

require "rake/testtask"
require "rake/clean"

XML_FILE  = "tmp/onebigfile.xml"
ISA_FILE  = "tmp/ISA_A64_xml_v88A-2021-12.tar.gz"
ISA_URL   = "https://developer.arm.com/-/media/developer/products/architecture/armv8-a-architecture/2021-12/ISA_A64_xml_v88A-2021-12.tar.gz"
LIB_FILE  = "lib/aarch64/instructions.rb"
INSNS_DIR = "lib/aarch64/instructions"

SYSTEM_REGS_URL = "https://developer.arm.com/-/media/developer/products/architecture/armv8-a-architecture/2020-06/SysReg_xml_v86A-2020-06.tar.gz"
SYSTEM_REGS_FILE  = "tmp/SysReg_xml_v86A-2020-06.tar.gz"
SYSTEM_REGS_XML = "tmp/SysReg_xml_v86A-2020-06/enc_index.xml"
MRS_MSR_64 = "lib/aarch64/system_registers/mrs_msr_64.rb"

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

task :system_regs => MRS_MSR_64

task :compile => [XML_FILE, INSNS_DIR] do
  ruby "-I build/lib bin/build_instructions.rb #{XML_FILE}"
end

def download from, to
  Dir.mkdir 'tmp' unless File.directory?("tmp")

  require "net/http"
  require "net/https"

  url = URI.parse from
  client = Net::HTTP.new(url.host, url.port)
  client.use_ssl = true
  client.start do |http|
    http.request_get(url.path) do |res|
      File.open(to, "w") do |f|
        res.read_body do |segment|
          f.write segment
        end
      end
    end
  end
end

file SYSTEM_REGS_XML => SYSTEM_REGS_FILE do |t|
  require "rubygems/package"
  require "zlib"

  wanted_file = t.name.split("/").last

  tar = Gem::Package::TarReader.new(Zlib::GzipReader.open(SYSTEM_REGS_FILE))

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

TEMPLATE = <<-eorb
module AArch64
  module SystemRegisters
    <%= base_name %> = Struct.new(<%= fields.map { |x| ":\#{x}" }.join(", ") %>)
    <%- for name, values in registers -%>
    <%= name %> = <%= base_name %>.new(<%= values.join(", ") %>)
    <%- end -%>
  end
end
eorb

file MRS_MSR_64 => SYSTEM_REGS_XML do |t|
  require "nokogiri"
  require "erb"

  doc = Nokogiri::XML.parse(File.read(SYSTEM_REGS_XML)) do |config|
    config.noblanks
  end
  base_name = nil
  fields = nil
  registers = []

  doc.xpath("//sectiongroup").each do |group|
    group.children.each do |section|
      next unless section["anchor"] == "mrs_msr_64"

      base_name = "MRS_MSR_64"
      section.children.each do |child|
        if child.name == "heading"
          h1, h2 = *child.children
          fields = h2.children.map(&:text)
        else
          child.children.each do |row|
            info = [row.children[fields.length].text,
                    row.children.first(fields.length).map(&:text)]
            if info.last.all? { |bits| bits =~ /^[01b]*$/ }
              registers << info
            else
              if info.last.all? { |bits| bits =~ /^[01b]*$/ || bits =~ /^n/ }
                idx = info.last.index { |bits| bits !~ /^[01b]*$/ }
                field = info.last[idx]
                (1 << (field[/\d:\d/].split(":").first.to_i + 1)).times do |i|
                  bits = info.last.dup
                  bits[idx] = sprintf("%0#b", i)
                  registers << [
                    info[0].sub(/<n>/, i.to_s),
                    bits
                  ]
                end
              else
                # Skip
              end
            end
          end
        end
      end
    end
  end

  template = ERB.new(TEMPLATE, trim_mode: "-")
  File.binwrite(MRS_MSR_64, template.result(binding))
end

desc "Download the ISA file from ARM"
file ISA_FILE do |t|
  download ISA_URL, t.name
end

desc "Download the Registers file from ARM"
file SYSTEM_REGS_FILE do |t|
  download SYSTEM_REGS_URL, t.name
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test/lib" << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
  t.warning = true
end

task :default => :test
