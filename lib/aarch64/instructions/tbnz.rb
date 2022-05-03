module AArch64
  module Instructions
    # TBNZ -- A64
    # Test bit and Branch if Nonzero
    # TBNZ  <R><t>, #<imm>, <label>
    class TBNZ
      def initialize rt, imm, label, sf
        @rt    = rt
        @imm   = imm
        @label = label
        @sf    = sf
      end

      def encode
        TBNZ(@sf, @imm, @label.to_i / 4, @rt.to_i)
      end

      private

      def TBNZ b5, b40, imm14, rt
        insn = 0b0_011011_1_00000_00000000000000_00000
        insn |= ((b5 & 0x1) << 31)
        insn |= ((b40 & 0x1f) << 19)
        insn |= ((imm14 & 0x3fff) << 5)
        insn |= (rt & 0x1f)
        insn
      end
    end
  end
end
