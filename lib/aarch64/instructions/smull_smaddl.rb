module AArch64
  module Instructions
    # SMULL -- A64
    # Signed Multiply Long
    # SMULL  <Xd>, <Wn>, <Wm>
    # SMADDL <Xd>, <Wn>, <Wm>, XZR
    class SMULL_SMADDL
      def encode
        raise NotImplementedError
      end

      private

      def SMULL_SMADDL rm, rn, rd
        insn = 0b1_00_11011_0_01_00000_0_11111_00000_00000
        insn |= ((rm & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
