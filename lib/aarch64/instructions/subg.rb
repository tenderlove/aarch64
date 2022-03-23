module AArch64
  module Instructions
    # SUBG -- A64
    # Subtract with Tag
    # SUBG  <Xd|SP>, <Xn|SP>, #<uimm6>, #<uimm4>
    class SUBG
      def encode
        raise NotImplementedError
      end

      private

      def SUBG uimm6, uimm4, xn, xd
        insn = 0b1_1_0_100011_0_000000_00_0000_00000_00000
        insn |= ((uimm6 & 0x3f) << 16)
        insn |= ((uimm4 & 0xf) << 10)
        insn |= ((xn & 0x1f) << 5)
        insn |= (xd & 0x1f)
        insn
      end
    end
  end
end