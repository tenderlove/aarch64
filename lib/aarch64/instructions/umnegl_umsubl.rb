module AArch64
  module Instructions
    # UMNEGL -- A64
    # Unsigned Multiply-Negate Long
    # UMNEGL  <Xd>, <Wn>, <Wm>
    # UMSUBL <Xd>, <Wn>, <Wm>, XZR
    class UMNEGL_UMSUBL
      def encode
        raise NotImplementedError
      end

      private

      def UMNEGL_UMSUBL rm, rn, rd
        insn = 0b1_00_11011_1_01_00000_1_11111_00000_00000
        insn |= ((rm & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
