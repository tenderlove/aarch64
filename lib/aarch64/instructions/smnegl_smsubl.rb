module AArch64
  module Instructions
    # SMNEGL -- A64
    # Signed Multiply-Negate Long
    # SMNEGL  <Xd>, <Wn>, <Wm>
    # SMSUBL <Xd>, <Wn>, <Wm>, XZR
    class SMNEGL_SMSUBL
      def encode
        raise NotImplementedError
      end

      private

      def SMNEGL_SMSUBL rm, rn, rd
        insn = 0b1_00_11011_0_01_00000_1_11111_00000_00000
        insn |= ((rm & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
