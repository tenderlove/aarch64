module AArch64
  module Instructions
    # SMADDL -- A64
    # Signed Multiply-Add Long
    # SMADDL  <Xd>, <Wn>, <Wm>, <Xa>
    class SMADDL
      def encode
        raise NotImplementedError
      end

      private

      def SMADDL rm, ra, rn, rd
        insn = 0b1_00_11011_0_01_00000_0_00000_00000_00000
        insn |= ((rm & 0x1f) << 16)
        insn |= ((ra & 0x1f) << 10)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
