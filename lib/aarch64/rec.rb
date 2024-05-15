module AArch64
  class Rec
    include Instructions

    class Insn
      def initialize nm
        @name = nm
      end
    end

    class ThreeArg < Insn
      def initialize nm, a, b, c
        @nm = nm
        @a = a
        @b = b
        @c = c
      end

      def apply asm
        asm.public_send @nm, @a, @b, @c
      end
    end

    class ThreeWithLsl < ThreeArg
      def initialize nm, a, b, c, lsl
        super(nm, a, b, c)
        @lsl = lsl
      end

      def apply asm
        asm.public_send @nm, @a, @b, @c, lsl: @lsl
      end
    end

    class ThreeWithExtend < ThreeArg
      def initialize nm, a, b, c, extend
        super(nm, a, b, c)
        @extend = extend
      end

      def apply asm
        asm.public_send @nm, @a, @b, @c, extend: @extend.to_sym
      end
    end

    class ThreeWithExtendAmount < ThreeWithExtend
      def initialize nm, a, b, c, extend, amt
        super(nm, a, b, c, extend)
        @amt = amt
      end

      def apply asm
        asm.public_send @nm, @a, @b, @c, extend: @extend, amount: @amt
      end
    end

    class ThreeWithShift < ThreeArg
      def initialize nm, a, b, c, shift
        super(nm, a, b, c)
        @shift = shift
      end

      def apply asm
        asm.public_send @nm, @a, @b, @c, shift: @shift.to_sym
      end
    end

    class ThreeWithShiftAmount < ThreeWithShift
      def initialize nm, a, b, c, shift, amt
        super(nm, a, b, c, shift)
        @amt = amt
      end

      def apply asm
        asm.public_send @nm, @a, @b, @c, shift: @shift, amount: @amt
      end
    end

    def initialize scan, asm
      @scan = scan
      @asm = asm
    end

    def instructions
      tok = @scan.peek
      tok = tok.first.to_s

      while !@scan.eof?
        if respond_to?("parse_#{tok}")
          @asm << send("parse_#{tok}")
        else
          return false
        end
      end

      @asm
    rescue NotImplementedError
      return false
    end

    def parse_ADC
      @scan.next_token
      if @scan.peek.last.x?
        xd_xd_xd Instructions::ADC
      else
        wd_wd_wd Instructions::ADC
      end
    end

    def parse_ADCS
      @scan.next_token
      if @scan.peek.last.x?
        xd_xd_xd ADCS
      else
        wd_wd_wd ADCS
      end
    end

    def parse_ADD
      expect { |tok| tok.first == :ADD }
      add_body ADD
    end

    def parse_ADDG
      expect { |tok| tok.first == :ADDG }
      d = @scan.next_token.last
      expect { |tok| tok.first == :COMMA }
      n = @scan.next_token.last
      expect { |tok| tok.first == :COMMA }
      expect { |tok| tok.first == '#' }
      imm6 = @scan.next_token.last
      expect { |tok| tok.first == :COMMA }
      expect { |tok| tok.first == '#' }
      imm4 = @scan.next_token.last
      ADDG.new(d, n, imm6 / 16, imm4)
    end

    def parse_ADDS
      expect { |tok| tok.first == :ADDS }
      add_body ADDS
    end

    def add_body nm
      d = @scan.next_token.last
      expect { |tok| tok.first == :COMMA }
      n = @scan.next_token.last
      expect { |tok| tok.first == :COMMA }
      if @scan.peek.first == '#'
        @scan.next_token
        m = @scan.next_token.last
        if @scan.peek.first == :COMMA
          expect { |tok| tok.first == :COMMA }
          expect { |tok| tok.first == :LSL }
          expect { |tok| tok.first == '#' }
          lsl = @scan.next_token.last
          nm::ADDSUB_imm.new(d, n, m, lsl / 12, d.sf)
        else
          nm::ADDSUB_imm.new(d, n, m, 0, d.sf)
        end
      else
        m = @scan.next_token.last
        if @scan.peek.first == :COMMA
          expect { |tok| tok.first == :COMMA }
          amount = 0

          if n.sp? || m.sp?
            modifier = @scan.next_token.last.to_sym
            amoubt = 0
            if @scan.peek.first == '#'
              expect { |tok| tok.first == '#' }
              amount = @scan.next_token.last
            end
            extend = Utils.sub_decode_extend32(modifier)
            nm::ADDSUB_ext.new(d, n, m, extend, amount, d.sf)
          else
            modifier = @scan.next_token.last.to_sym

            case modifier
            when :uxtb, :uxth, :uxtw, :uxtx, :sxtb, :sxth, :sxtw, :sxtx
              # extend
              if @scan.peek.first == '#'
                expect { |tok| tok.first == '#' }
                amount = @scan.next_token.last
              end
              extend = Utils.sub_decode_extend32(modifier)
              nm::ADDSUB_ext.new(d, n, m, extend, amount, d.sf)
            when :lsl, :lsr, :asr
              shift = [:lsl, :lsr, :asr].index(modifier)

              amount = 0
              # shift
              if @scan.peek.first == '#'
                expect { |tok| tok.first == '#' }
                amount = @scan.next_token.last
              end
              nm::ADDSUB_shift.new(d, n, m, shift, amount, d.sf)
            end
          end
        else
          nm::ADDSUB_shift.new(d, n, m, 0, 0, d.sf)
        end
      end
    end

    def wd_wd_wd nm
      w1 = expect { |tok| !tok.last.x? }.last
      expect { |tok| tok.first == :COMMA }
      w2 = expect { |tok| !tok.last.x? }.last
      expect { |tok| tok.first == :COMMA }
      w3 = expect { |tok| !tok.last.x? }.last
      nm.new(w1, w2, w3, w1.sf)
    end

    def xd_xd_xd nm
      x1 = expect { |tok| tok.last.x? }.last
      expect { |tok| tok.first == :COMMA }
      x2 = expect { |tok| tok.last.x? }.last
      expect { |tok| tok.first == :COMMA }
      x3 = expect { |tok| tok.last.x? }.last
      nm.new(x1, x2, x3, x1.sf)
    end

    def expect
      unless yield @scan.peek
        p @scan.peek
        raise
      end
      @scan.next_token
    end
  end
end
