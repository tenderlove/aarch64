require "nokogiri"
require "erb"

TOP_LEVEL = ERB.new(<<-eoerb, trim_mode: "-")
module AArch64
  module Instructions
  <%- for fname, klass in files_and_classes do -%>
    autoload :<%= klass %>, "aarch64/instructions/<%= fname %>"
  <%- end -%>
  end
end
eoerb

TEMPLATE = ERB.new(<<-eoerb, trim_mode: "-")
module AArch64
  module Instructions
    # <%= title %>
    <%- for line in description.each_line -%>
    # <%= line %>
    <%- end -%>
    <%- for line in asm_template -%>
    # <%= line %>
    <%- end -%>
    class <%= func_name %>
      def encode
        raise NotImplementedError
      end

      private

      def <%= func_name %> <%= params.join(", ") %>
        insn = 0b<%= fields.map { |f| f.bits }.join("_") %>
        <%- for field in required -%>
        <%- if field.shift == 0 -%>
        insn |= (<%= field.name.downcase %> & <%= sprintf("%#02x", field.mask) %>)
        <%- else -%>
        insn |= ((<%= field.name.downcase %> & <%= sprintf("%#02x", field.mask) %>) << <%= field.shift %>)
        <%- end -%>
        <%- end -%>
        insn
      end
    end
  end
end
eoerb

class Field < Struct.new(:name, :shift, :bits, :width)
  def mask
    (1 << width) - 1
  end
end

def make_encode func_name, title, description, asm_template, regdiagram
  sum = 0
  required = []
  fields = []

  fields = regdiagram.children.reject(&:text?).map do |box|
    width = (box["width"] || 1).to_i
    name  = box["name"]
    hibit  = box["hibit"].to_i + 1
    shift = hibit - width
    bits = box.children.reject(&:text?).map { |x| x.text.empty? ? nil : x.text.gsub(/[()]*/, '') }.compact
    sum += width
    if bits.empty?
      x = [:param, name, width, "0" * width, shift]
      x = Field.new(name, shift, "0" * width, width)
      required << x
      x
    else
      [:lit, name, width, bits.join, shift]
      Field.new(name, shift, bits.join, width)
    end
  end
  params = required.map { |x| x.name }.map(&:downcase)

  TEMPLATE.result(binding)
end

doc = Nokogiri::XML.parse(File.read(ARGV[0]))
basic_insn_files = doc.css("iforms").find { |x|
  x["title"] =~ /Base Instructions/
}.css("iform").map { |x| x["iformfile"] }

files_by_name = doc.css("//file[@type=\"instructionsection\"]").group_by { |file| file["file"] }

files_and_classes = []

basic_insn_files.each do |filename|
  file_node = files_by_name[filename].first
  file_node.css("instructionsection").each do |section|
    asm = section.css("asmtemplate").map(&:text)
    desc = section.at_css("desc > brief").text.strip
    fname = section["id"].downcase
    files_and_classes << [fname, section["id"]]
    File.binwrite "lib/aarch64/instructions/#{fname}.rb", make_encode(section["id"], section["title"], desc, asm, section.at_css("regdiagram"))
  end
end

File.binwrite "lib/aarch64/instructions.rb", TOP_LEVEL.result(binding)
