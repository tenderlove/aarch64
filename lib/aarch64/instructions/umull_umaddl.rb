module AArch64
  module Instructions
    # UMULL -- A64
    # Unsigned Multiply Long
    # UMULL  <Xd>, <Wn>, <Wm>
    # UMADDL <Xd>, <Wn>, <Wm>, XZR
    class UMULL_UMADDL
      def encode
        raise NotImplementedError
      end

      private

      def UMULL_UMADDL rm, rn, rd
        insn = 0b1_00_11011_1_01_00000_0_11111_00000_00000
        insn |= ((rm & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
