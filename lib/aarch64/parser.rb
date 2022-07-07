# frozen_string_literal: true

require "strscan"
require "aarch64/system_registers/mrs_msr_64"
require "aarch64/parser.tab"
require "aarch64"

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

    class RegRegShift
      attr_reader :d, :m, :shift, :amount

      def initialize d, m, shift: :lsl, amount: 0
        @d      = d
        @m      = m
        @shift  = shift
        @amount = amount
      end

      def apply asm, name
        asm.public_send(name, d, m, shift: shift, amount: amount)
      end
    end

    class TwoWithExtend
      attr_reader :n, :m, :extend, :amount

      def initialize n, m, extend:, amount:
        @n      = n
        @m      = m
        @extend = extend
        @amount = amount
      end

      def apply asm, name
        asm.public_send(name, n, m, extend: extend, amount: amount)
      end
    end

    class TwoWithShift
      attr_reader :n, :m, :shift, :amount

      def initialize n, m, shift:, amount:
        @n      = n
        @m      = m
        @shift  = shift
        @amount = amount
      end

      def apply asm, name
        asm.public_send(name, n, m, shift: shift, amount: amount)
      end
    end

    class TwoWithLsl
      attr_reader :n, :m, :lsl

      def initialize n, m, lsl:
        @n   = n
        @m   = m
        @lsl = lsl
      end

      def apply asm, name
        asm.public_send(name, n, m, lsl: lsl)
      end
    end

    class ThreeWithLsl
      attr_reader :d, :n, :m, :lsl

      def initialize d, n, m, lsl:
        @d   = d
        @n   = n
        @m   = m
        @lsl = lsl
      end

      def apply asm, name
        asm.public_send(name, d, n, m, lsl: lsl)
      end
    end

    class TwoArg
      attr_reader :n, :m

      def initialize n, m
        @n = n
        @m = m
      end

      def apply asm, name
        asm.public_send(name, n, m)
      end

      def to_a; [n, m]; end
    end

    class ThreeArg
      attr_reader :d, :n, :m

      def initialize d, n, m
        @d = d
        @n = n
        @m = m
      end

      def apply asm, name
        asm.public_send(name, d, n, m)
      end

      def to_a; [d, n, m]; end
    end

    class ThreeWithExtend
      attr_reader :d, :n, :m, :extend, :amount

      def initialize d, n, m, extend:, amount:
        @d      = d
        @n      = n
        @m      = m
        @extend = extend
        @amount = amount
      end

      def apply asm, name
        asm.public_send(name, d, n, m, extend: extend, amount: amount)
      end
    end

    class FourArg < Struct.new(:a, :b, :c, :d)
      def apply asm, name
        asm.public_send(name, a, b, c, d)
      end
    end

    def parse str
      str += "\n" unless str.end_with?("\n")
      @scan = StringScanner.new str
      @asm  = AArch64::Assembler.new
      do_parse
      @asm
    end

    def next_token
      _next_token
    end

    SYS_REG_SCAN = Regexp.new(AArch64::SystemRegisters.constants.join("|"), true)
    SYS_REG_MAP = Hash[AArch64::SystemRegisters.constants.map { |k|
      [k.to_s.downcase, AArch64::SystemRegisters.const_get(k)]
    }]

    def _next_token
      return _next_token if @scan.scan(/[\t ]+/) # skip whitespace

      if str = @scan.scan(/\n/)
        return [:EOL, :EOL]
      elsif str = @scan.scan(/x\d+/i)
        [:Xd, AArch64::Registers.const_get(str.upcase)]
      elsif str = @scan.scan(/w\d+/i)
        [:Wd, AArch64::Registers.const_get(str.upcase)]
      elsif str = @scan.scan(/c\d+/i)
        [:Cd, AArch64::Names.const_get(str.upcase)]
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
      elsif @scan.scan(/\[/)
        [:LSQ, "["]
      elsif @scan.scan(/\]/)
        [:RSQ, "]"]
      elsif @scan.scan(/!/)
        [:BANG, "!"]
      elsif str = @scan.scan(/(?:pld|pli|pst)(?:l1|l2|l3)(?:keep|strm)/)
        [:PRFOP, str]
      elsif str = @scan.scan(/-?0x[0-9A-F]+/i)
        [:NUMBER, Integer(str)]
      elsif str = @scan.scan(/-?(?:0|[1-9][0-9]*)/i)
        [:NUMBER, Integer(str)]
      elsif str = @scan.scan(/LSL/i)
        [:LSL, str]
      elsif str = @scan.scan(/#/)
        ["#", "#"]
      elsif str = @scan.scan(/s\d_\d_c\d+_c\d+_\d/i)
        if str =~ /s(\d)_(\d)_(c\d+)_(c\d+)_(\d)/i
          [:SYSTEMREG, SystemRegisters::MRS_MSR_64.new($1.to_i,
                                                       $2.to_i,
                                                       Names.const_get($3.upcase),
                                                       Names.const_get($4.upcase),
                                                       $5.to_i)]
        else
          raise
        end
      elsif str = @scan.scan(SYS_REG_SCAN)
        [:SYSTEMREG, SYS_REG_MAP[str.downcase]]
      elsif str = @scan.scan(/\w+/)
        [str.upcase.to_sym, str]
      else
      end
    end
  end
end
