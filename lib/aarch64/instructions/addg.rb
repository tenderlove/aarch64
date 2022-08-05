module AArch64
  module Instructions
    # ADDG -- A64
    # Add with Tag
    # ADDG  <Xd|SP>, <Xn|SP>, #<uimm6>, #<uimm4>
    class ADDG < Instruction
      def initialize xd, xn, imm6, imm4
        @xd   = check_mask(xd, 0x1f)
        @xn   = check_mask(xn, 0x1f)
        @imm6 = check_mask(imm6, 0x3f)
        @imm4 = check_mask(imm4, 0x0f)
      end

      def encode
        ADDG(@imm6, @imm4, @xn, @xd)
      end

      private

      def ADDG uimm6, uimm4, xn, xd
        insn = 0b1_0_0_100011_0_000000_00_0000_00000_00000
        insn |= ((uimm6) << 16)
        insn |= ((uimm4) << 10)
        insn |= ((xn) << 5)
        insn |= (xd)
        insn
      end
    end
  end
end
