module AArch64
  module Instructions
    # BC.cond -- A64
    # Branch Consistent conditionally
    # BC.<cond>  <label>
    class BC_cond < Instruction
      def initialize cond, label
        @cond  = cond
        @label = label
      end

      def encode
        BC_cond(unwrap_label(@label), Utils.cond2bin(@cond))
      end

      private

      def BC_cond imm19, cond
        insn = 0b0101010_0_0000000000000000000_1_0000
        insn |= ((apply_mask(imm19, 0x7ffff)) << 5)
        insn |= (apply_mask(cond, 0xf))
        insn
      end
    end
  end
end
