module AArch64
  module Instructions
    # SBC -- A64
    # Subtract with Carry
    # SBC  <Wd>, <Wn>, <Wm>
    # SBC  <Xd>, <Xn>, <Xm>
    class SBC
      def encode
        raise NotImplementedError
      end

      private

      def SBC sf, rm, rn, rd
        insn = 0b0_1_0_11010000_00000_000000_00000_00000
        insn |= ((sf & 0x1) << 31)
        insn |= ((rm & 0x1f) << 16)
        insn |= ((rn & 0x1f) << 5)
        insn |= (rd & 0x1f)
        insn
      end
    end
  end
end
