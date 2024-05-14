# frozen_string_literal: true

require "strscan"
require "aarch64/system_registers/mrs_msr_64"
require "aarch64/parser.tab"
require "aarch64"
require "aarch64/rec"
require "aarch64/tokenizer"

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

    class FourArg < ClassGen.pos(:a, :b, :c, :d)
      def apply asm, name
        asm.public_send(name, a, b, c, d)
      end
    end

    def parse str
      str += "\n" unless str.end_with?("\n")
      parse_states = [
        # First pass: Label parsing
        :first_pass,
        # Second pass: Code generation
        :second_pass
      ]
      @labels = {}
      if @asm = instructions(str, AArch64::Assembler.new)
      else
        parse_states.each do |state|
          @scan = Tokenizer.new str
          @asm  = AArch64::Assembler.new
          @state = state
          do_parse
        end
      end

      @asm
    end

    def instructions str, asm
      rec = Rec.new Tokenizer.new(str), asm
      rec.instructions
      ## KEYWORDS.bsearch { tok <=> _1 } || raise(tok)
    end

    def next_token
      @scan.next_token
    end

    def register_label str
      return unless @state == :first_pass

      if @labels.include?(str)
        raise "symbol '#{str}' is already defined"
      end

      label = @asm.make_label(str)
      @asm.put_label(label)
      @labels[str] = label

      nil
    end

    def label_for str
      # In the first pass, all valid labels are not known yet i.e. forward references
      # Return a placeholder value instead.
      if @state == :first_pass
        @asm.make_label(str)
      else
        raise("Label #{str.inspect} not defined") unless @labels.key?(str)
        @labels[str]
      end
    end

    def on_error(token_id, val, vstack)
      token_str = token_to_str(token_id) || '?'
      string = @scan.string
      line_number = string.byteslice(0, @scan.pos).count("\n") + 1
      raise ParseError, "parse error on value #{val.inspect} (#{token_str}) on line #{line_number} at pos #{@scan.pos - 1}/#{string.bytesize}"
    end
  end
end
