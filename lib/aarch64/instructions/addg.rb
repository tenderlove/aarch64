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
        insn |= ((apply_mask(uimm6, 0x3f)) << 16)
        insn |= ((apply_mask(uimm4, 0xf)) << 10)
        insn |= ((apply_mask(xn, 0x1f)) << 5)
        insn |= (apply_mask(xd, 0x1f))
        insn
      end
    end
  end
end
