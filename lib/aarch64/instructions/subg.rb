module AArch64
  module Instructions
    # SUBG -- A64
    # Subtract with Tag
    # SUBG  <Xd|SP>, <Xn|SP>, #<uimm6>, #<uimm4>
    class SUBG < Instruction
      def initialize xd, xn, uimm6, uimm4
        @xd    = check_mask(xd, 0x1f)
        @xn    = check_mask(xn, 0x1f)
        @uimm6 = check_mask(uimm6, 0x3f)
        @uimm4 = check_mask(uimm4, 0x0f)
      end

      def encode
        SUBG(@uimm6, @uimm4, @xn, @xd)
      end

      private

      def SUBG uimm6, uimm4, xn, xd
        insn = 0b1_1_0_100011_0_000000_00_0000_00000_00000
        insn |= ((uimm6) << 16)
        insn |= ((uimm4) << 10)
        insn |= ((xn) << 5)
        insn |= (xd)
        insn
      end
    end
  end
end
