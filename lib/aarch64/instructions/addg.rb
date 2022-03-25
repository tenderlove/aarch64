module AArch64
  module Instructions
    # ADDG -- A64
    # Add with Tag
    # ADDG  <Xd|SP>, <Xn|SP>, #<uimm6>, #<uimm4>
    class ADDG
      def initialize xd, xn, imm6, imm4
        @xd   = xd
        @xn   = xn
        @imm6 = imm6
        @imm4 = imm4
      end

      def encode
        ADDG(@imm6, @imm4, @xn.to_i, @xd.to_i)
      end

      private

      def ADDG uimm6, uimm4, xn, xd
        insn = 0b1_0_0_100011_0_000000_00_0000_00000_00000
        insn |= ((uimm6 & 0x3f) << 16)
        insn |= ((uimm4 & 0xf) << 10)
        insn |= ((xn & 0x1f) << 5)
        insn |= (xd & 0x1f)
        insn
      end
    end
  end
end
