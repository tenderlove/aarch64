module AArch64
  module Instructions
    # BC.cond -- A64
    # Branch Consistent conditionally
    # BC.<cond>  <label>
    class BC_cond
      def initialize cond, label
        @cond  = cond
        @label = label
      end

      def encode
        BC_cond(@label.to_i / 4, Utils.cond2bin(@cond))
      end

      private

      def BC_cond imm19, cond
        insn = 0b0101010_0_0000000000000000000_1_0000
        insn |= ((imm19 & 0x7ffff) << 5)
        insn |= (cond & 0xf)
        insn
      end
    end
  end
end
