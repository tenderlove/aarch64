# frozen_string_literal: true

require "racc/parser.rb"
require "strscan"

module AArch64
  class Parser < Racc::Parser
    class RegsWithShift
      attr_reader :d, :n, :m, :shift, :amount

      def initialize d, n, m, shift: :lsl, amount: 0
        @d      = d
        @n      = n
        @m      = m
        @shift  = shift
        @amount = amount
      end

      def apply asm, name
        asm.public_send(name, d, n, m, shift: shift, amount: amount)
      end
    end

    class ThreeRegs
      attr_reader :d, :n, :m

      def initialize d, n, m
        @d = d
        @n = n
        @m = m
      end

      def apply asm, name
        asm.public_send(name, d, n, m)
      end
    end

    def parse str
      str += "\n" unless str.end_with?("\n")
      @scan = StringScanner.new str
      @asm  = Assembler.new
      do_parse
      @asm
    end

    def next_token
      _next_token
    end

    def _next_token
      return _next_token if @scan.scan(/[\t ]+/) # skip whitespace

      if str = @scan.scan(/\n/)
        return [:EOL, :EOL]
      elsif str = @scan.scan(/x\d+/i)
        [:Xd, AArch64::Registers.const_get(str.upcase)]
      elsif str = @scan.scan(/w\d+/i)
        [:Wd, AArch64::Registers.const_get(str.upcase)]
      elsif str = @scan.scan(/sp/i)
        [:SP, AArch64::Registers.const_get(str.upcase)]
      elsif str = @scan.scan(/xzr/i)
        [:Xd, AArch64::Registers.const_get(str.upcase)]
      elsif str = @scan.scan(/wzr/i)
        [:Wd, AArch64::Registers.const_get(str.upcase)]
      elsif str = @scan.scan(/wsp/i)
        [:WSP, AArch64::Registers.const_get(str.upcase)]
      elsif @scan.scan(/,/)
        [:COMMA, ","]
      elsif @scan.scan(/\./)
        [:DOT, "."]
      elsif str = @scan.scan(/0x[0-9A-F]+/i)
        [:NUMBER, Integer(str)]
      elsif str = @scan.scan(/-?(?:0|[1-9][0-9]*)/i)
        [:NUMBER, Integer(str)]
      elsif str = @scan.scan(/LSL/i)
        [:LSL, str]
      elsif str = @scan.scan(/#/)
        ["#", "#"]
      elsif str = @scan.scan(/\w+/)
        [str.upcase.to_sym, str]
      else
      end
    end
  end
end

require "aarch64/parser.tab"
