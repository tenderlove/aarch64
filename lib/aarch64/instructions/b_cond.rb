module AArch64
  module Instructions
    # B.cond -- A64
    # Branch conditionally
    # B.<cond>  <label>
    class B_cond
      COND_TABLE = {
        "EQ"  => 0b0000,
        "NE"  => 0b0001,
        "CS"  => 0b0010,
        "CC"  => 0b0011,
        "MI"  => 0b0100,
        "PL"  => 0b0101,
        "VS"  => 0b0110,
        "VC"  => 0b0111,
        "HI"  => 0b1000,
        "LS"  => 0b1001,
        "GE"  => 0b1010,
        "LT"  => 0b1011,
        "GT"  => 0b1100,
        "LE"  => 0b1101,
        "AL"  => 0b1110,
        "NVb" => 0b1111,
      }

      def initialize cond, label
        @cond  = cond
        @label = label
      end

      def encode
        B_cond(@label.to_i / 4, COND_TABLE.fetch(@cond.to_s.upcase))
      end

      private

      def B_cond imm19, cond
        insn = 0b0101010_0_0000000000000000000_0_0000
        insn |= ((imm19 & 0x7ffff) << 5)
        insn |= (cond & 0xf)
        insn
      end
    end
  end
end
