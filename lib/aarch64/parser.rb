# frozen_string_literal: true

require "strscan"
require "aarch64/system_registers/mrs_msr_64"
require "aarch64"
require "aarch64/rec"
require "aarch64/tokenizer"

module AArch64
  class Parser
    def parse str
      str += "\n" unless str.end_with?("\n")
      rec = Rec.new Tokenizer.new(str), AArch64::Assembler.new
      rec.instructions
    end
  end
end
