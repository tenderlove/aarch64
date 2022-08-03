module AArch64
  module Instructions
    # TBNZ -- A64
    # Test bit and Branch if Nonzero
    # TBNZ  <R><t>, #<imm>, <label>
    class TBNZ < Instruction
      def initialize rt, imm, label, sf
        @rt    = rt
        @imm   = imm
        @label = label
        @sf    = sf
      end

      def encode
        TBNZ(@sf, @imm, unwrap_label(@label), @rt)
      end

      private

      def TBNZ b5, b40, imm14, rt
        insn = 0b0_011011_1_00000_00000000000000_00000
        insn |= ((apply_mask(b5, 0x1)) << 31)
        insn |= ((apply_mask(b40, 0x1f)) << 19)
        insn |= ((apply_mask(imm14, 0x3fff)) << 5)
        insn |= (apply_mask(rt, 0x1f))
        insn
      end
    end
  end
end
